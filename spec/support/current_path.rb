# module for helping request specs access the current_path
module CurrentPathHelper
  def current_path
    URI.parse(current_url).request_uri
  end
end
