class Admin::UsersController < Admin::BaseController
  
  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users}
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  
  # PUT /admin/users/1
  # PUT /admin/users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:bookmark])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
