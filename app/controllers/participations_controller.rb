class ParticipationsController < ApplicationController

  before_filter :store_location
  before_filter :authenticate_user!

  # nested under venues
  before_filter :set_venue

  # This is somewhat f*ckd! Devise might redirect here if a currently
  # not signed in user clicks on a participate now button. For now
  # we'll simpy redirect to the venue.
  #
  # GET /participations
  # GET /participations.json
  def index
    redirect_to venue_path(:id => params[:participation][:venue_id])
  end

  # POST /participations
  # POST /participations.json
  def create
    @participation = Participation.new
    @participation.user = current_or_guest_user
    @participation.venue = @venue

    respond_to do |format|
      if @participation.save
        # make_avatar_appear_live if @venue.live? # CHECK still needed?
        format.html { redirect_to @venue } # after join redirect to venue page 
      else
        format.html { redirect_to @venue }
      end
    end
  end

  # DELETE /participations/1
  # DELETE /participations/1.json
  def destroy
    @participation = current_or_guest_user.
      participations.find_by_venue_id(params[:venue_id])
    @participation.destroy

    respond_to do |format|
      format.html { redirect_to @participation.venue }
    end
  end

  private

  def make_avatar_appear_live
    # TODO get rid of JS eval
    markup = render_to_string partial: 'venues/venue_show_avatar', locals: { user: current_or_guest_user }
    markup = markup.gsub('"', "'").gsub("\n", '')
    script = "$('.venue-participants').append(\"#{markup}\");Venue.initMote();Venue.sortParticipants();"
    PrivatePub.publish_to @venue.back_channel, script
  end

  def set_venue
    @venue = Venue.find(params[:venue_id])
  end

end
