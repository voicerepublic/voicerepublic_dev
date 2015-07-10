class RemindersController < BaseController

  before_action :authenticate_user!

  # POST /talks/:talk_id/reminders
  # POST /talks/:venue_id/reminders
  def create
    rememberable ||= params[:talk_id]  && Talk.find(params[:talk_id])
    rememberable ||= params[:venue_id] && Venue.find(params[:venue_id])
    rememberable ||= params[:user_id]  && User.find(params[:user_id])
    raise "Cannot find Rememberable with #{params.inspect}" if rememberable.nil?

    attrs = {
      user_id: current_user.id,
      rememberable_id: rememberable.id,
      rememberable_type: rememberable.model_name
    }
    @reminder = Reminder.new(attrs)

    authorize! :create, @reminder
    if @reminder.save
      count = pin_deeply!(rememberable)
      message = I18n.t('.x_talks_pinned', count: count)
      Simon.says queue: 'user.notice', user_id: user.id, notice: message
      return redirect_to @reminder, notice: message
    end

    head 422
  end

  # DELETE /reminders/1
  def destroy
    @reminder = Reminder.find(params[:id])
    authorize! :destroy, @reminder
    @reminder.destroy
  end

  private

  def pin_deeply!(entity)
    list =
      case entity.model_name
      when 'User'  then entity.venues
      when 'Venue' then entity.talks
      when 'Talk'  then return 1 # nop
      else raise "Don't know how to pin #{entity.model_name} deeply?"
      end
    list.map do |e|
      Reminder.create(rememberable: e, user: current_user)
      pin_deeply!(e)
    end.sum
  end

end
