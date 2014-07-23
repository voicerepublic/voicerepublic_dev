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
      redirect_to rememberable, notice: I18n.t('reminders.create.success')
    else
      redirect_to rememberable, error: I18n.t('reminders.create.failure')
    end
  end

  # DELETE /reminders/1
  def destroy
    @reminder = Reminder.find(params[:id])
    @reminder.destroy
    redirect_to current_user, anchor: 'reminders',
                notice: I18n.t('reminders.destroy.success')
  end

end
