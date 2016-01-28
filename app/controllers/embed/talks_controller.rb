class Embed::TalksController < Embed::BaseController

  def show
    @talk = Talk.find(params[:id])
  end

end
