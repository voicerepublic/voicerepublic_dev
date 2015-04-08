class ParticipationsController < BaseController

  before_filter :store_location
  before_filter :authenticate_user!

  # nested under venues
  before_filter :set_venue

  # FIXME: This is somewhat f*ckd! Devise might redirect here if a currently
  # not signed in user clicks on a participate now button. For now we'll simpy
  # redirect to the venue.
  #
  # GET /participations
  # GET /participations.json
  def index
    redirect_to venue_path(:id => params[:venue_id])
  end

  # POST /participations
  # POST /participations.json
  def create
    # TODO: Is this the correct way to go?
    # FIXME: There's no authorization in this controller
    @participation = @venue.participations.build
    @participation.user = current_user

    target = @venue

    # if participate button on talk was clicked we would like to
    # redirect to the same talk
    #
    # TODO check if we could alternatively use the stored_location
    if request.referer =~ /\/venues\/.+\/talks\/(.+)\z/
      target = [ @venue, @venue.talks.find($1) ]
    end

    respond_to do |format|
      if @participation.save
        format.html { redirect_to target } # after join redirect to venue page
      else
        format.html { redirect_to target }
      end
    end
  end

  # DELETE /participations/1
  # DELETE /participations/1.json
  def destroy
    @participation = Participation.find(params[:id])
    @participation.destroy

    respond_to do |format|
      format.html { redirect_to @participation.venue }
    end
  end

  private

  def set_venue
    @venue = Venue.find(params[:venue_id])
  end

end
