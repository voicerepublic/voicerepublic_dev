class Xhr::UsersController < Xhr::BaseController
  
  before_action :authenticate_user!, :only => [:edit,:update,:destroy]
  
  def index
    users = User.search(params[:q]).paginate(page: params[:page],
                                             per_page: params[:limit] || 10)

    render json: { users: users.map(&:for_select), total: users.count }
  end

end
