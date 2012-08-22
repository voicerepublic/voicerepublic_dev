class Admin::UsersController < Admin::BaseController
  
  def index
    @users = User.paginate(:page => params[:page], :per_page => 15)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users}
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html 
      format.json { render json: @user }
    end
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
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: "User was successfully destroyed" }
      format.json { head :no_content }
    end
  end
  
  
  
end
