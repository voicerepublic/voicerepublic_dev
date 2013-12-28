class Admin::UsersController < Admin::BaseController

  def index
    @users = User.paginate(:page => params[:page],
      :per_page => 15).
      where('not(firstname like ?)', '%guest%').
      order("created_at DESC")
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

    logger.debug("Admin::Users#update - params: \n#{params.inspect}\n")

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_role
    @user = User.find(params[:user_id])
    role = Role.find(params[:role_id])
    @user.roles << role
    respond_to do |format|
     if @user.save
        format.html { redirect_to admin_user_path(:id => @user), notice: "Role added successfully" }
      else
        format.html { render action: "edit" }
      end
    end

  end

  def remove_role
    @user = User.find(params[:user_id])
    ur = UserRole.find(params[:user_role_id])

    respond_to do |format|
      if ur.user == @user
        ur.destroy
        format.html { redirect_to admin_user_path(:id => @user), notice: "role removed" }
      else
        format.html { render action: "edit" }
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
