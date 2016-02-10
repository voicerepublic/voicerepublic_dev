class Embed::BaseController < BaseController

  after_action :allow_iframe, only: :show

  layout 'embed'

  private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

end
