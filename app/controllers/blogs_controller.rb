class BlogsController < ApplicationController
  include BlogsHelper
  include PigriderUser::SessionsHelper
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
      redirect_to pigrider_user.signInUser_path
    end
  end
   
  
  def sortFormInput(hFormInput)
    @oSortedBlogInput=hFormInput
    @oSortedBlogInput[:category]=""
    @oSortedBlogInput[:abstract]=strip_tags(@oSortedBlogInput[:content]).gsub(/[\r\n]+/,"\n")[0..299].strip
    @oSortedBlogInput[:category]=""
    
    $aoBlogCategories.each do |oBC|
      if @oSortedBlogInput[oBC.sHashKeyName]=="1"
        @oSortedBlogInput[:category]+=oBC.sCategoryName+";"
      end
      @oSortedBlogInput.delete(oBC.sHashKeyName)
    end
  end
  
  
  def validateBlogInput(dBlog,sAction)  
    # validate the uniqueness of the Blog title
    bValidTitle=true;
    dTmpBlog=Blog.find(:first, :select=>"id", :conditions=>{:title=>dBlog.title,:author=>dBlog.author})
    unless dTmpBlog.nil?
      if sAction=="create" || (sAction=="update" && dTmpBlog.id!=dBlog.id)
        bValidTitle=false;
      end
    end
    
    if bValidTitle && dBlog.valid?
      return true
    else      # Fail the model validation.
      unless bValidTitle
        dBlog.errors["titleHasBeenTaken"]='You already have a blog with the same title.'
      end
      return false
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
      
      @dbBlogs=Blog.find(:all,:select=>"abstract,author,category,id,title,updated_at,views",:order=>"updated_at desc",:limit=>"#{iLimitStart},#{$nNumberOfBlogsEachPage}")
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
      @oSortedBlogInput[:author]=usernameForSignedInUser
      @dBlog=Blog.new(@oSortedBlogInput)
      
      if validateBlogInput(@dBlog,"create")      
        @dBlog.save(:validate=>false)  
        asCategories=parseCategory(@dBlog.category)
        asCategories.each do |sC|
          Kernel.const_get($aoBlogCategories[$hsiCategoryNameToArrayIndex[sC]].sModelClassName).create(:blogID=>@dBlog.id)
        end
        
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
      sortFormInput(params[:blog])
      @dBlog=Blog.find(params[:id])
      ssBeforeCategories=parseCategory(@dBlog.category).to_set
      @dBlog.abstract=@oSortedBlogInput[:abstract]
      @dBlog.category=@oSortedBlogInput[:category]
      @dBlog.content=@oSortedBlogInput[:content]
      @dBlog.title=@oSortedBlogInput[:title]
      
      # Do nothing for categories that are the same before and after update
      asCurrentCategories=parseCategory(@dBlog.category)
      asNewCategories=Array.new
      asCurrentCategories.each do |sC|
        if ssBeforeCategories.delete?(sC).nil?
          asNewCategories.push(sC)
        end
      end
      
      if validateBlogInput(@dBlog,"update")
        @dBlog.save(:validate=>false)
        
        # Delete no longer chosen categories
        ssBeforeCategories.each do |sC|
          Kernel.const_get($aoBlogCategories[$hsiCategoryNameToArrayIndex[sC]].sModelClassName).find(@dBlog.id).delete
        end
        
        # Add new chosen categories
        asNewCategories.each do |sC|
          Kernel.const_get($aoBlogCategories[$hsiCategoryNameToArrayIndex[sC]].sModelClassName).create(:blogID=>@dBlog.id)
        end
        
        redirect_to @dBlog
      else
        render 'edit'
      end
    end
  end


  def destroy
    # Use 'transaction' to improve sql operation speed, because this makes all sql operations in one transaction.
    ActiveRecord::Base.transaction do
      dbToDelete=Blog.find(params[:id],:select=>"id,category")
      asCategory=parseCategory(dbToDelete.category)
      asCategory.each do |sC|
        Kernel.const_get($aoBlogCategories[$hsiCategoryNameToArrayIndex[sC]].sModelClassName).find(dbToDelete.id).delete
      end
      dbToDelete.delete
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
            
      @dbBlogs=Blog.find(:all,:select=>"abstract,author,blogs.id,category,title,blogs.updated_at,views",:joins=>"INNER JOIN #{sIndexTableName} it ON it.blogID=blogs.id",:order=>"updated_at desc",:limit=>"#{iLimitStart},#{$nNumberOfBlogsEachPage}")
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
    @dbBlogs=Blog.find(:all,:select=>"abstract,author,category,id,title,updated_at,views",:conditions=>{:author=>params[:byAuthor]},:order=>"updated_at desc",:limit=>"#{iLimitStart},#{$nNumberOfBlogsEachPage}")
  end
  
  
  def search
    if params.has_key?(:currentPage)
      iPage=params[:currentPage].to_i
    else
      iPage=1
    end
    
    @sSearchKeyword=params[:search][:keyword]
    
    oSearch = Blog.search do
      fulltext params[:search][:keyword] do
        boost_fields :title=>10.0
        boost_fields :author=>5.0
        boost_fields :content=>5.0
        highlight :title, :max_snippets=>1
        highlight :author, :max_snippets=>1, :fragment_size=>100
        highlight :content, :max_snippets=>3
        highlight :category, :max_snippets=>1,  :fragment_size=>400
      end

      paginate :page => iPage, :per_page => 10
    end
    
    oSearch.each_hit_with_result do |oHit,dbResult|     
      oHit.highlights(:title).each do |oHL|
        dbResult.title = oHL.format { |sW| "<span style='color:red'>#{sW}</span>" }
      end
      
      oHit.highlights(:author).each do |oHL|
        dbResult.author = oHL.format { |sW| "<span style='color:red'>#{sW}</span>" }
      end
      
      if oHit.highlights(:content).length>0
        dbResult.abstract=""
      end  
      oHit.highlights(:content).each do |oHL|
        dbResult.abstract += oHL.format { |sW| "<span style='color:red'>#{sW}</span>" }.gsub(/[\r\n]+/,"\n").strip
      end
      
      oHit.highlights(:category).each do |oHL|
        dbResult.category = oHL.format { |sW| "<span style='color:red'>#{sW.gsub(/;/,"<span style='color:red'>;</span>")}</span>" }
      end
    end
    
    @dbBlogs=oSearch.results
    nTotalRecords=oSearch.total
    $nTotalPages=nTotalRecords%$nNumberOfBlogsEachPage>0 ? nTotalRecords/$nNumberOfBlogsEachPage+1 : nTotalRecords/$nNumberOfBlogsEachPage
  end
end
