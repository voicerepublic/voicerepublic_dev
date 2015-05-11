class RemindersController < BaseController

  before_action :authenticate_user!, except: [:index]

  # GET /users/:user_id/reminders
  def index
    @user = User.find(params[:user_id])
    talks = Talk.remembered_by(@user)
    @podcast = OpenStruct.new(talks: talks)
  end

  # POST /talks/:talk_id/reminders
  # POST /talks/:venue_id/reminders
  def create
    @reminder = Reminder.new
    @reminder.user = current_user

    rememberable ||= Talk.find(params[:talk_id])
    rememberable ||= Venue.find(params[:venue_id])
    raise "Cannot find Rememberable with #{params.inspect}" if rememberable.nil?
    @reminder.rememberable = rememberable

    authorize! :create, @reminder
    if @reminder.save
      redirect_to rememberable, notice: I18n.t('reminders.create.success')
    else
      redirect_to rememberable, error: I18n.t('reminders.create.failure')
    end
  end

  # DELETE /reminders/1
  def destroy
    @reminder = Reminder.find(params[:id])
    authorize! :destroy, @reminder
    @reminder.destroy
    redirect_to current_user, anchor: 'reminders',
                notice: I18n.t('reminders.destroy.success')
  end

end
