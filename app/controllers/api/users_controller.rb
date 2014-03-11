class Api::UsersController < Api::BaseController
  
  before_filter :authenticate_user!, :only => [:edit,:update,:destroy]
  
  def index
    # TODO: introduce canonical field for better search on users
    scope = User.where(["lastname ILIKE ?", "%#{params[:q]}%"])
    users = scope.paginate(page: params[:page],
                           per_page: params[:limit] || 10)
    # TODO: limit users to require attributes, currently we leak email adresses
    render json: { users: users, total: scope.count }
  end

end
