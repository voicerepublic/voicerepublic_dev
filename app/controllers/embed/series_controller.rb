class Embed::SeriesController < Embed::BaseController

  def show
    @series = Series.find(params[:id])
  end

end
