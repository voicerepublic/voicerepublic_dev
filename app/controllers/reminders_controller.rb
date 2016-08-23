class RemindersController < BaseController

  before_action :authenticate_user!, except: [:index]
  before_action :set_reminder, only: [:show, :destroy]

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
    if @reminder.save
      return render json: { id: @reminder.id, reminder_id: @reminder.id }
    end

    head 409
  end

  # DELETE /reminders/1
  def destroy
    authorize! :destroy, @reminder
    return head(200) if @reminder.destroy

    head 404
  end

  private

  def set_reminder
    @reminder = Reminder.find(params[:id])
    @selector = [ '.pin',
                  @reminder.rememberable_type,
                  @reminder.rememberable_id ] * '-'
  end

end
