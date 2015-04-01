class PurchasesController < ApplicationController

  # step 1: setup purchase and redirect to paypal
  def express
    @purchase = Purchase.new product: params[:product],
                             ip: request.remote_ip
    redirect_to @purchase.setup.redirect_url
  end

  # step 2: display confirmation page
  def new
    @purchase = Purchase.new product: params[:product],
                             express_token: params[:token],
                             express_payer_id: params[:PayerID]
  end

  # step 3: process purchase
  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.ip = request.remote_ip
    @purchase.owner = current_user

    if @purchase.save
      if @purchase.process
        redirect_to @purchase
      else
        render action: 'failure'
      end
    else
      render action: 'new' # TODO
    end
  end

  def show
    @purchase = Purchase.find(params[:id])
    # TODO move this to cancan
    return redirect_to(:purchases) unless @purchase.owner == current_user
  end

  private

  def purchase_params
    params.require(:purchase).permit(:product,
                                     :express_token,
                                     :express_payer_id)
  end

end
