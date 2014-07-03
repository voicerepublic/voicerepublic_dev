# TODO use i18n for flash messages
# TODO use cancan for authorization
class RemindersController < ApplicationController

  before_action :authenticate_user!

  # GET /reminders
  def index
    @reminders = current_user.reminders
  end

  # POST /reminders
  def create
    @reminder = Reminder.new
    @reminder.user = current_user

    rememberable ||= Talk.find(params[:talk_id])
    rememberable ||= Venue.find(params[:venue_id])
    raise "Cannot find Rememberable with #{params.inspect}" if rememberable.nil? 
    @reminder.rememberable = rememberable

    if @reminder.save
      redirect_to rememberable, notice: 'Reminder was successfully created.'
    else
      redirect_to rememberable, error: 'Reminder could not be created.'
    end
  end

  # DELETE /reminders/1
  def destroy
    @reminder = Reminder.find(params[:id])
    @reminder.destroy
    redirect_to current_user, anchor: 'reminders',
                notice: 'Reminder was successfully destroyed.'
  end

end
