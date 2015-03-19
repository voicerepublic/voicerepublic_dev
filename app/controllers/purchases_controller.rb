class PurchasesController < ApplicationController

  def express
    @purchase = Purchase.new quantity: params[:quantity]
    options = {
      items: [
        { name: "#{@purchase.quantity} Talk Credits",
          quantity: 1,
          description: "Package",
          amount: @purchase.amount }
      ],
      allow_note: false,
      no_shipping: true,
      currency: Purchase::CURRENCY,
      ip: request.remote_ip,
      return_url: new_purchase_url(quantity: @purchase.quantity),
      cancel_return_url: purchases_url
    }
    response = EXPRESS_GATEWAY.setup_purchase( @purchase.amount, options)
    raise response.params['message'] unless response.success?
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def new
    @purchase = Purchase.new quantity: params[:quantity],
                             express_token: params[:token],
                             express_payer_id: params[:PayerID]
  end

  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.ip = request.remote_ip

    if @purchase.save
      if @purchase.process
        render action: 'success'
      else
        render action: 'failure'
      end
    else
      render action: 'new'
    end
  end

  private

  def purchase_params
    params.require(:purchase).permit(:quantity,
                                     :express_token,
                                     :express_payer_id)
  end

end
