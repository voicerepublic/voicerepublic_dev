class Embed::TalksController < Embed::BaseController

  def show
    @talk = Talk.find(params[:id])
    @reminder = Reminder.find_by_user_and_talk(current_user, @talk) if current_user
  end

end
