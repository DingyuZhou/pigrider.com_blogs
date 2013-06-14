module PaginationHelper
  def paginateURL(overwrite={})
    url_for :only_path => false, :params => params.merge(overwrite)
  end
end