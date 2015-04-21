class BaseController < ApplicationController

  def redirect_if_low_on_credits
    return true unless Settings.payment_enabled

    return true if params[:talk] && params[:talk][:dryrun]
    return true if current_user.credits > 0

    redirect_to :purchases, notice: I18n.t('low_on_credits')
  end

end
