module BlogsHelper
  def parseCategory(sBlogCategory)
    asCategory=sBlogCategory.split(';')
    return asCategory
  end
  
  
  class BlogCategory
    attr_accessor :sCategoryName, :sHashKeyName, :sModelClassName, :sDatabaseTableName, :sSHJSCode
    def initialize(sCategoryName,sHashKeyName,sModelClassName,sDatabaseTableName,sSHJSCode=nil)
      @sCategoryName=sCategoryName
      @sHashKeyName=sHashKeyName
      @sModelClassName=sModelClassName
      @sDatabaseTableName=sDatabaseTableName
      @sSHJSCode=sSHJSCode
    end
  end
end
