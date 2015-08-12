class RemindersController < BaseController

  before_action :authenticate_user!, except: [:index]

  # GET /users/:user_id/reminders
  def index
    @user = User.find(params[:user_id])
    talks = Talk.remembered_by(@user)
    @podcast = OpenStruct.new(talks: talks)
  end

  # POST /talks/:talk_id/reminders
  # POST /talks/:series_id/reminders
  def create
    rememberable ||= Talk.find(params[:talk_id])
    rememberable ||= Series.find(params[:series_id])
    rememberable ||= User.find(params[:user_id])
    raise "Cannot find Rememberable with #{params.inspect}" if rememberable.nil?

    attrs = {
      user_id: current_user.id,
      rememberable_id: rememberable.id,
      rememberable_type: rememberable.model_name
    }
    @reminder = Reminder.new(attrs)

    authorize! :create, @reminder
    return redirect_to @reminder if @reminder.save

    head 422
  end

  # DELETE /reminders/1
  def destroy
    @reminder = Reminder.find(params[:id])
    authorize! :destroy, @reminder
    @reminder.destroy
  end

end
