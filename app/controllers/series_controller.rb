class SeriesController < BaseController

  before_filter :store_location
  before_filter :authenticate_user!, :except => [:show, :tags]
  before_filter :set_series, only: [:show, :edit, :update, :destroy]

  layout 'velvet'

  caches_action :show, if: -> { request.format.rss? }

  # GET /series/1
  # GET /series/1.json
  def show
    respond_to do |format|
      format.html do
        @upcoming_talks = @series.talks.prelive.ordered
        @archived_talks = @series.talks.archived.ordered
        @live_talks = @series.talks.live.ordered

        if current_user
          @participation =
            @series.participations.find_by(user_id: current_user.id)

          @show_join = @participation.nil? &&
                       current_user != @series.user
        end

        @total_plays = @series.talks.sum(:play_count)
      end
      format.json { render json: @series }
      format.rss do
        talks = @series.talks.archived.ordered
        @podcast = OpenStruct.new(talks: talks)
      end
      format.ics
    end
  end

  # GET /series/new
  # GET /series/new.json
  def new
    @series = Series.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @series }
    end
  end

  # GET /series/1/edit
  def edit
    authorize! :edit, @series
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # POST /series
  # POST /series.json
  def create
    @series = Series.new(series_params)
    @series.user = current_user

    authorize! :create, @series

    respond_to do |format|
      if @series.save
        format.html do
          logger.debug("Series#cretae  - redirecting to series")
          redirect_to @series, notice: 'Series was successfully created.'
         end
        format.json { render json: @series, status: :created, location: @series }
      else
        logger.error("Series#create - ERROR: #{@series.errors.inspect}")
        format.html { render action: "new" }
        format.json { render json: @series.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /series/1
  # PUT /series/1.json
  def update
    authorize! :update, @series

    respond_to do |format|
      if @series.update_attributes(series_params)
        format.html { redirect_to @series, notice: 'Series was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @series.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /series/1
  # DELETE /series/1.json
  def destroy
    authorize! :destroy, @series

    @series.destroy

    respond_to do |format|
      format.html { redirect_to user_path(current_user) }
      format.json { head :no_content }
    end
  end

  private

  def remember_location # TODO: check if needed
    logger.debug("Series#remember_location - storing location: " +
                 "#{series_url(:id => params[:series_id])}")
    session[:series_path] = series_url(:id => params[:series_id])
  end

  def set_series
    @series = Series.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def series_params
    params.require(:series).permit(:title, :teaser, :description,
                                  :image, :tag_list)
  end

end
