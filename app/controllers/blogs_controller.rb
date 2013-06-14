class BlogsController < ApplicationController
  include BlogsHelper
  include SessionsHelper
  
  
  $sTagHTML="HTML"
  $sTagCSS="CSS"
  $sTagJavascript="Javascript"
  $sTagRoR="Ruby on Rails"
  $sTagPython="Python"
  $sTagJava="Java"
  $sTagCpp="C++"
  $sTagGit="Git"
  $sTagLinux="Linux"
  $sTagSql="SQL"
  $sTagOthers="Others"
  $nNumberOfBlogsEachPage=10
  $nNumberOfPageTags=9
  
  
  before_filter :notSignedIn, :only=>[:new,:create,:edit,:update]
  

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
    @oSortedBlogInput[:abstract]=@oSortedBlogInput[:content][0..500]
    @bHasJavascript=false
    @bHasHTML=false
    @bHasCSS=false
    @bHasRoR=false
    @bHasPython=false
    @bHasJava=false
    @bHasCpp=false
    @bHasGit=false
    @bHasLinux=false
    @bHasSql=false
    @bHasOthers=false
    bOthers=true
      
    if @oSortedBlogInput[:html]=="1"
      @bHasHTML=true
      bOthers=false
    end
    @oSortedBlogInput.delete(:html)
    
    if @oSortedBlogInput[:css]=="1"
      @bHasCSS=true
      bOthers=false
    end
    @oSortedBlogInput.delete(:css)
    
    if @oSortedBlogInput[:javascript]=="1"
      @bHasJavascript=true
      bOthers=false
    end
    @oSortedBlogInput.delete(:javascript)
    
    if @oSortedBlogInput[:ror]=="1"
      @bHasRoR=true
      bOthers=false
    end
    @oSortedBlogInput.delete(:ror)
    
    if @oSortedBlogInput[:python]=="1"
      @bHasPython=true
      bOthers=false
    end
    @oSortedBlogInput.delete(:python)
    
    if @oSortedBlogInput[:java]=="1"
      @bHasJava=true
      bOthers=false
    end
    @oSortedBlogInput.delete(:java)
    
    if @oSortedBlogInput[:cpp]=="1"
      @bHasCpp=true
      bOthers=false
    end
    @oSortedBlogInput.delete(:cpp)
    
    if @oSortedBlogInput[:git]=="1"
      @bHasGit=true
      bOthers=false
    end
    @oSortedBlogInput.delete(:git)
    
    if @oSortedBlogInput[:linux]=="1"
      @bHasLinux=true
      bOthers=false
    end
    @oSortedBlogInput.delete(:linux)
    
    if @oSortedBlogInput[:sql]=="1"
      @bHasSql=true
      bOthers=false
    end
    @oSortedBlogInput.delete(:sql)
    
    if @oSortedBlogInput[:others]=="1" || bOthers
      @bHasOthers=true
    end
    @oSortedBlogInput.delete(:others)
  end
  
  
  def insertIntoDatabase(sRedirectPathWhenInsertFailed,sRedirectPathWhenInsertSuccess=nil)
    dbInsertBlog=Blog.new(@oSortedBlogInput)
          
    respond_to do |format|
      if dbInsertBlog.save 
        if @bHasHTML
          dbHTML=HtmlIndex.create(:blogID=>dbInsertBlog.id)
          dbInsertBlog[:category]+=$sTagHTML+":"+dbHTML.id.to_s+";"
        end
          
        if @bHasCSS
          dbCSS=CssIndex.create(:blogID=>dbInsertBlog.id)
          dbInsertBlog[:category]+=$sTagCSS+":"+dbCSS.id.to_s+";"
        end
          
        if @bHasJavascript
          dbJavascript=JavascriptIndex.create(:blogID=>dbInsertBlog.id)
          dbInsertBlog[:category]+=$sTagJavascript+":"+dbJavascript.id.to_s+";"
        end
          
        if @bHasRoR
          dbRoR=RorIndex.create(:blogID=>dbInsertBlog.id)
          dbInsertBlog[:category]+=$sTagRoR+":"+dbRoR.id.to_s+";"
        end
        
        if @bHasPython
          dbPython=PythonIndex.create(:blogID=>dbInsertBlog.id)
          dbInsertBlog[:category]+=$sTagPython+":"+dbPython.id.to_s+";"
        end
        
        if @bHasJava
          dbJava=JavaIndex.create(:blogID=>dbInsertBlog.id)
          dbInsertBlog[:category]+=$sTagJava+":"+dbJava.id.to_s+";"
        end
        
        if @bHasCpp
          dbCpp=CppIndex.create(:blogID=>dbInsertBlog.id)
          dbInsertBlog[:category]+=$sTagCpp+":"+dbCpp.id.to_s+";"
        end
        
        if @bHasGit
          dbGit=GitIndex.create(:blogID=>dbInsertBlog.id)
          dbInsertBlog[:category]+=$sTagGit+":"+dbGit.id.to_s+";"
        end
        
        if @bHasLinux
          dbLinux=LinuxIndex.create(:blogID=>dbInsertBlog.id)
          dbInsertBlog[:category]+=$sTagLinux+":"+dbLinux.id.to_s+";"
        end
        
        if @bHasSql
          dbSql=SqlIndex.create(:blogID=>dbInsertBlog.id)
          dbInsertBlog[:category]+=$sTagSql+":"+dbSql.id.to_s+";"
        end
        
        if @bHasOthers
          dbOthers=OthersIndex.create(:blogID=>dbInsertBlog.id)
          dbInsertBlog[:category]+=$sTagOthers+":"+dbOthers.id.to_s+";"
        end
          
        if dbInsertBlog.save
          if sRedirectPathWhenInsertSuccess.nil?
            format.html {redirect_to blog_path(dbInsertBlog)}
          else
            format.html {redirect_to sRedirectPathWhenInsertSuccess}
          end
        else
          format.html {redirect_to sRedirectPathWhenInsertFailed}
        end
      else
        format.html {redirect_to sRedirectPathWhenInsertFailed}
      end
    end   
  end
  
  
  def deleteFromCategoryDatabase(sBlogCategory)
    hsiCategory=parseCategoryAndID(sBlogCategory)
    hsiCategory.each do |hK,hV|
      case hK
      when $sTagHTML
        HtmlIndex.delete(hV)
      when $sTagCSS
        CssIndex.delete(hV)
      when $sTagJavascript
        JavascriptIndex.delete(hV)
      when $sTagRoR
        RorIndex.delete(hV)
      when $sTagPython
        PythonIndex.delete(hV)
      when $sTagJava
        JavaIndex.delete(hV)
      when $sTagCpp
        CppIndex.delete(hV)
      when $sTagGit
        GitIndex.delete(hV)
      when $sTagLinux
        LinuxIndex.delete(hV)
      when $sTagSql
        SqlIndex.delete(hV)
      when $sTagOthers
        OthersIndex.delete(hV)
      end
      
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
      insertIntoDatabase(new_blog_path)
    end
  end


  def new
    @dbNewBlog=Blog.new   
  end


  def edit   
    @dbToEdit=Blog.find(params[:id])
  end


  def show
    # Use 'transaction' to improve sql operation speed, because this makes all sql operations in one transaction.
    ActiveRecord::Base.transaction do
      @dbShowBlog=Blog.find(params[:id],:select=>"author,category,content,id,title,updated_at,views")
      @dbShowBlog.views+=1
      Blog.record_timestamps=false      # Not update the 'updated_at' time.
      @dbShowBlog.save
      Blog.record_timestamps=true
    end
  end


  def update
    # Use 'transaction' to improve sql operation speed, because this makes all sql operations in one transaction.
    ActiveRecord::Base.transaction do
      dbUpdatedBlog=Blog.find(params[:id])
      sortFormInput(params[:blog])
      @oSortedBlogInput[:created_at]=dbUpdatedBlog[:created_at]
      @oSortedBlogInput[:views]=dbUpdatedBlog[:views]
      
      deleteFromCategoryDatabase(dbUpdatedBlog.category)
      dbUpdatedBlog.destroy
      
      insertIntoDatabase(new_blog_path)
    end
  end


  def destroy
    # Use 'transaction' to improve sql operation speed, because this makes all sql operations in one transaction.
    ActiveRecord::Base.transaction do
      dbToDelete=Blog.find(params[:id])
      deleteFromCategoryDatabase(dbToDelete.category)
      dbToDelete.destroy
    end

    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end
  
  
  def category
    # Use 'transaction' to improve sql operation speed, because this makes all sql operations in one transaction.
    ActiveRecord::Base.transaction do
      if params.has_key?(:currentPage)
        iLimitStart=(params[:currentPage].to_i-1)*$nNumberOfBlogsEachPage
      else
        iLimitStart=0
      end
      
      case params[:type]
      when $sTagHTML
        sIndexTableName="html_indices"
        nTotalRecords=HtmlIndex.count();
      when $sTagCSS
        sIndexTableName="css_indices"
        nTotalRecords=CssIndex.count();
      when $sTagJavascript
        sIndexTableName="javascript_indices"
        nTotalRecords=JavascriptIndex.count();
      when $sTagRoR
        sIndexTableName="ror_indices"
        nTotalRecords=RorIndex.count();
      when $sTagPython
        sIndexTableName="python_indices"
        nTotalRecords=PythonIndex.count();
      when $sTagJava
        sIndexTableName="java_indices"
        nTotalRecords=JavaIndex.count();
      when $sTagCpp
        sIndexTableName="cpp_indices"
        nTotalRecords=CppIndex.count();
      when $sTagGit
        sIndexTableName="git_indices"
        nTotalRecords=GitIndex.count();
      when $sTagLinux
        sIndexTableName="linux_indices"
        nTotalRecords=LinuxIndex.count();
      when $sTagSql
        sIndexTableName="sql_indices"
        nTotalRecords=SqlIndex.count();
      when $sTagOthers
        sIndexTableName="others_indices"
        nTotalRecords=OthersIndex.count();
      end
      
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
