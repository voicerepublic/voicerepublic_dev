class ParticipationsController < BaseController

  before_filter :store_location
  before_filter :authenticate_user!

  # nested under series
  before_filter :set_series

  # FIXME: This is somewhat f*ckd! Devise might redirect here if a currently
  # not signed in user clicks on a participate now button. For now we'll simpy
  # redirect to the series.
  #
  # GET /participations
  # GET /participations.json
  def index
    redirect_to series_path(:id => params[:series_id])
  end

  # POST /participations
  # POST /participations.json
  def create
    # TODO: Is this the correct way to go?
    # FIXME: There's no authorization in this controller
    @participation = @series.participations.build
    @participation.user = current_user

    target = @series

    # if participate button on talk was clicked we would like to
    # redirect to the same talk
    #
    # TODO check if we could alternatively use the stored_location
    #
    # FIXME urls do not look like this anymore!
    if request.referer =~ /\/series\/.+\/talks\/(.+)\z/
      target = [ @series, @series.talks.find($1) ]
    end

    authorize! :create, @participation
    respond_to do |format|
      if @participation.save
        format.html { redirect_to target } # after join redirect to series page
      else
        format.html { redirect_to target }
      end
    end
  end

  # DELETE /participations/1
  # DELETE /participations/1.json
  def destroy
    @participation = Participation.find(params[:id])

    authorize! :destroy, @participation
    @participation.destroy

    respond_to do |format|
      format.html { redirect_to @participation.series }
    end
  end

  private

  def set_series
    @series = Series.find(params[:series_id])
  end

end
