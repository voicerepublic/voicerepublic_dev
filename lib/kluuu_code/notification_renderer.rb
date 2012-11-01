module KluuuCode
  
  class NotificationRenderer < AbstractController::Base
    include AbstractController::Rendering
    include AbstractController::Helpers
    include AbstractController::Translation
    include AbstractController::AssetPaths
    include ActionView::Helpers::JavaScriptHelper
    include Rails.application.routes.url_helpers
    helper ApplicationHelper
    helper DashboardHelper
    
    self.view_paths = "app/views"

    helper_method :protect_against_forgery?
    def protect_against_forgery?
      false
    end

  end

end