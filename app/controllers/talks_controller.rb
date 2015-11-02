class TalksController < BaseController

  before_action :set_talk, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show]
  before_action :redirect_if_low_on_credits, only: :new

  # GET /talks/1
  def show
    respond_to do |format|
      if current_user
        @reminder = Reminder.find_by_user_and_talk(current_user, @talk)
      end
      @related_talks = @talk.related_talks
      format.html do
        # write to session to make sure we have an id
        # see http://stackoverflow.com/questions/13673969
        session[:foo] = 'bar'
        session_id = session[:session_id]
        RegisterListenerMessage.call(@talk, session_id)
      end
      format.text do
        authorize! :manage, @talk
        render text: @talk.message_history
      end
      format.png { send_file @talk.flyer.path(true) }
      format.ics
      format.rss do
        @podcast = OpenStruct.new(talks: [@talk])
      end
    end
  end

  # GET /talks/new
  def new
    attrs = params[:talk] ? talk_params : {}
    attrs[:series_id] ||= current_user.default_series_id
    @talk = Talk.new(attrs)

    # set random default values for test talks
    if @talk.dryrun?
      @talk.title = Faker::Commerce.product_name
      @talk.tag_list = Faker::Commerce.department
      @talk.teaser = Faker::Company.catch_phrase
      @talk.starts_at_date= Date.today
      @talk.starts_at_time= 1.minute.from_now.strftime('%H:%M')
      @talk.description = Faker::Lorem.paragraph(3)
    end

    authorize! :new, @talk
  end

  # GET /talks/1/edit
  def edit
  end

  # POST /talks
  def create
    @talk = Talk.new(talk_params)

    # TODO explain, doesn't that mean i can steal someone's series by
    # creating a talk?
    @talk.series_user = current_user

    authorize! :create, @talk

    if @talk.save
      redirect_to @talk, notice: 'Talk was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /talks/1
  def update

    # TODO same concern here, see above
    # set series_user to be able to create series on the fly while
    # updating talks
    @talk.series_user = current_user

    authorize! :update, @talk
    if @talk.update(talk_params)
      redirect_to @talk, notice: 'Talk was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /talks/1
  def destroy
    authorize! :destroy, @talk

    @talk.destroy
    redirect_to current_user, notice: 'Talk was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_talk
    @talk = Talk.unscoped.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def talk_params
    params.require(:talk).permit(:title, :teaser, :starts_at_date,
                                 :starts_at_time, :duration, :speakers,
                                 :description, :collect, :image,
                                 :tag_list, :guest_list, :language,
                                 :format, :new_series_title, :series_id,
                                 :user_override_uuid, :dryrun, :slides_uuid)
  end

end
