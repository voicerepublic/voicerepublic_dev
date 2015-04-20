class BaseController < ApplicationController

  def redirect_if_low_on_credits
    unless current_user.credits > 0 or
           params[:talk] && params[:talk][:dryrun]
      redirect_to :purchases, notice: I18n.t('low_on_credits')
    end
  end

end
