class BlogsController < ApplicationController
  include BlogsHelper
  include SessionsHelper
  include ActionView::Helpers::SanitizeHelper
  
  
  $nNumberOfBlogsEachPage=10
  $nNumberOfPageTags=9
  
    
  # define a global array for blog categories
  $aoBlogCategories=[
    BlogCategory.new("HTML","html", "HtmlIndex", "html_indices", "sh_html"),
    BlogCategory.new("CSS", "css", "CssIndex", "css_indices", "sh_css"),
    BlogCategory.new("Javascript", "javascript", "JavascriptIndex", "javascript_indices", "sh_javascript_dom"),
    BlogCategory.new("Ruby on Rails", "ror", "RorIndex", "ror_indices", "sh_ruby"),
    BlogCategory.new("C++", "cpp", "CppIndex", "cpp_indices", "sh_cpp"),
    BlogCategory.new("Java", "java", "JavaIndex", "java_indices", "sh_java"),
    BlogCategory.new("Python", "python", "PythonIndex", "python_indices", "sh_python"),
    BlogCategory.new("SQL", "sql", "SqlIndex", "sql_indices", "sh_sql"),
    BlogCategory.new("Git", "git", "GitIndex", "git_indices"),
    BlogCategory.new("Linux", "linux", "LinuxIndex", "linux_indices"),
    BlogCategory.new("Others", "others", "OthersIndex", "others_indices")
  ]
  
  
  $hsiCategoryNameToArrayIndex={}
  $aoBlogCategories.each_with_index do |oBC,index|
    $hsiCategoryNameToArrayIndex[oBC.sCategoryName]=index
  end
   
  
  before_filter :notSignedIn, :only=>[:new,:create,:edit,:update,:destroy]
  

private
  def notSignedIn
    if !userSignedIn
      redirect_to userSignIn_path
    end
  end
   
  
  def sortFormInput(hFormInput)
    @oSortedBlogInput=hFormInput
    @oSortedBlogInput[:category]=""
    @oSortedBlogInput[:author]=usernameForSignedInUser
    @oSortedBlogInput[:abstract]=strip_tags(@oSortedBlogInput[:content]).gsub(/[\r\n]+/,"\n")[0..299].strip
    @oSortedBlogInput[:category]=""
    @bHasCategory=Array.new($aoBlogCategories.length,false)
    
    $aoBlogCategories.each_with_index do |oBC,index|
      if @oSortedBlogInput[oBC.sHashKeyName]=="1"
        @oSortedBlogInput[:category]+=oBC.sCategoryName+";"
        @bHasCategory[index]=true
      end
      @oSortedBlogInput.delete(oBC.sHashKeyName)
    end
  end
  
  
  def validateBlogInput(sAction)
    @dBlog=Blog.new(@oSortedBlogInput)
    
    # validate the uniqueness of the Blog title
    bValidTitle=true;
    dTmpBlog=Blog.find(:first, :select=>"id", :conditions=>{:title=>@dBlog.title,:author=>@dBlog.author})
    unless dTmpBlog.nil?
      if sAction=="create" || (sAction=="update" && dTmpBlog.id!=@dEditedBlog.id)
        bValidTitle=false;
      end
    end
    
    if @dBlog.valid? && bValidTitle
      return true
    else      # Fail the model validation.
      unless bValidTitle
        @dBlog.errors["titleHasBeenTaken"]='You already have a blog with the same title.'
      end
      return false
    end  
  end
  
  
  def insertIntoDatabase
    @dBlog.id=nil       
    @dBlog.save(:validate=>false)
    
    $aoBlogCategories.each_with_index do |oBC,index|
      if @bHasCategory[index]
        dTmp=Kernel.const_get(oBC.sModelClassName).create(:blogID=>@dBlog.id)
      end
    end
  end
  
  
  def deleteFromCategoryDatabases(sBlogCategory,iBlogID)    
    asCategory=parseCategory(sBlogCategory)
    asCategory.each do |sC|
      Kernel.const_get($aoBlogCategories[$hsiCategoryNameToArrayIndex[sC]].sModelClassName).where(:blogID=>iBlogID).delete_all
    end
  end


public
  def index
    # Use 'transaction' to improve sql operation speed, because this makes all sql operations in one transaction.
    ActiveRecord::Base.transaction do
      if params.has_key?(:currentPage)
        iLimitStart=(params[:currentPage].to_i-1)*$nNumberOfBlogsEachPage
      else
        iLimitStart=0
      end
      nTotalRecords=Blog.count();
      $nTotalPages=nTotalRecords%$nNumberOfBlogsEachPage>0 ? nTotalRecords/$nNumberOfBlogsEachPage+1 : nTotalRecords/$nNumberOfBlogsEachPage
      
      @dbBlogs=Blog.find(:all,:select=>"abstract,author,category,id,title,updated_at,views",:order=>"id desc",:limit=>"#{iLimitStart},#{$nNumberOfBlogsEachPage}")
      respond_to do |format|
        format.html
      end
    end
  end


  def create
    # Use 'transaction' to improve sql operation speed, because this makes all sql operations in one transaction.
    ActiveRecord::Base.transaction do
      sortFormInput(params[:blog])
      @oSortedBlogInput[:views]=0
      if validateBlogInput("create")
        insertIntoDatabase
        redirect_to @dBlog
      else
        render 'new'
      end
    end
  end


  def new
    @dBlog=Blog.new
    @dBlog.category=""
  end


  def edit   
    @dBlog=Blog.find(params[:id])
  end


  def show
    # Use 'transaction' to improve sql operation speed, because this makes all sql operations in one transaction.
    ActiveRecord::Base.transaction do
      @dbShowBlog=Blog.find(params[:id],:select=>"author,category,content,id,title,updated_at,views")
      @dbShowBlog.update_column(:views,@dbShowBlog.views+1)
    end
  end


  def update
    # Use 'transaction' to improve sql operation speed, because this makes all sql operations in one transaction.
    ActiveRecord::Base.transaction do
      @dEditedBlog=Blog.find(params[:id],:select=>"id,category,created_at,views")
      sortFormInput(params[:blog])
      @oSortedBlogInput[:created_at]=@dEditedBlog[:created_at]
      @oSortedBlogInput[:views]=@dEditedBlog[:views]
      
      if validateBlogInput("update")
        deleteFromCategoryDatabases(@dEditedBlog.category,@dEditedBlog.id)
        @dEditedBlog.destroy     
        insertIntoDatabase
        redirect_to @dBlog
      else
        @dBlog.id=@dEditedBlog.id
        render 'edit'
      end
    end
  end


  def destroy
    # Use 'transaction' to improve sql operation speed, because this makes all sql operations in one transaction.
    ActiveRecord::Base.transaction do
      dbToDelete=Blog.find(params[:id],:select=>"id,category")
      deleteFromCategoryDatabases(dbToDelete.category,dbToDelete.id)
      dbToDelete.destroy
    end

    redirect_to root_path
  end
  
  
  def category
    # Use 'transaction' to improve sql operation speed, because this makes all sql operations in one transaction.
    ActiveRecord::Base.transaction do
      if params.has_key?(:currentPage)
        iLimitStart=(params[:currentPage].to_i-1)*$nNumberOfBlogsEachPage
      else
        iLimitStart=0
      end
      
      iCategory=$hsiCategoryNameToArrayIndex[params[:type]]
      nTotalRecords=Kernel.const_get($aoBlogCategories[iCategory].sModelClassName).count()
      sIndexTableName=$aoBlogCategories[iCategory].sDatabaseTableName
            
      @dbBlogs=Blog.find(:all,:select=>"abstract,author,blogs.id,category,title,blogs.updated_at,views",:joins=>"INNER JOIN #{sIndexTableName} it ON it.blogID=blogs.id",:order=>"id desc",:limit=>"#{iLimitStart},#{$nNumberOfBlogsEachPage}")
      $nTotalPages=nTotalRecords%$nNumberOfBlogsEachPage>0 ? nTotalRecords/$nNumberOfBlogsEachPage+1 : nTotalRecords/$nNumberOfBlogsEachPage
    end
  end
  
  
  def byAuthor
    if params.has_key?(:currentPage)
      iLimitStart=(params[:currentPage].to_i-1)*$nNumberOfBlogsEachPage
    else
      iLimitStart=0
    end
    nTotalRecords=Blog.count(:conditions=>{:author=>params[:byAuthor]})
    $nTotalPages=nTotalRecords%$nNumberOfBlogsEachPage>0 ? nTotalRecords/$nNumberOfBlogsEachPage+1 : nTotalRecords/$nNumberOfBlogsEachPage
    @dbBlogs=Blog.find(:all,:select=>"abstract,author,category,id,title,updated_at,views",:conditions=>{:author=>params[:byAuthor]},:order=>"id desc",:limit=>"#{iLimitStart},#{$nNumberOfBlogsEachPage}")
  end
  
end
