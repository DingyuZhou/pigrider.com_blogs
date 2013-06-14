module BlogsHelper
  def parseCategoryAndID(sBlogCategory)
    asCategory=sBlogCategory.split(';')
    hsiCategory={}
    
    asCategory.each do |sC|
      asTmp=sC.split(':')
      hsiCategory[asTmp[0]]=asTmp[1].to_i
    end
    
    return hsiCategory
  end
end
