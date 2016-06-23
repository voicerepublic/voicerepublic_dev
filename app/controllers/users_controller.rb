class UsersController < BaseController

  PERMITTED_ATTRS = %w( firstname
                        lastname
                        accept_terms_of_use
                        slug
                        email
                        avatar
                        header
                        timezone
                        facebook
                        twitter
                        website
                        summary
                        about
                        password
                        password_confirmation
                        referrer )


  before_filter :authenticate_user!, :only => [:edit,:update,:destroy]

  layout "velvet"

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # TODO rename @talks_total to @total_talks
  def show
    @user ||= User.find(params[:id])
    respond_to do |format|
      format.html do

        @remembered_talks  = Talk.remembered_by(@user).reordered

        @who = current_user==@user ? "you":"other"
        @role = @user.talks.empty? ? :listener : :publisher

        if @role == :publisher
          @tab_pinned_class = ""
          @tab_archived_class = "is-active"
        else
          @tab_pinned_class = "is-active"
          @tab_archived_class = ""
        end

        @talks_total       = @user.talks.where.not(state: 'postlive').count
        @total_plays       = @user.talks.sum(:play_count)

        # live         -> starts_at asc
        # upcoming     -> starts_at asc
        # archived     -> starts_at desc
        # listen later -> starts_at desc
        @live_talks        = @user.talks.live.ordered
        @upcoming_talks    = @user.talks.prelive.ordered
        @archived_talks    = @user.talks.archived_and_limbo.reordered

        @series            = @user.series_without_default

        @show_listen_later = @remembered_talks.present?
        @show_listen_later = true if @user == current_user

      end
      format.rss do
        talks = @user.talks.archived.order('updated_at DESC')
        @podcast = OpenStruct.new(talks: talks)
      end
      format.js do
        @talks =
          case params[:more]
          when 'live'      then @user.talks.live.ordered.offset(3)
          when 'upcoming'  then @user.talks.prelive.ordered.offset(3)
          when 'archived'  then @user.talks.archived.reordered.offset(3)
          when 'reminders' then Talk.remembered_by(@user).reordered.offset(3)
          end
      end
      format.ics
    end
  end

  def onboard
    @user = current_user
    show
    render :show
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    authorize! :edit, @user
    #render :layout => 'application'
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html do
          redirect_to @user, flash: { notice: I18n.t("flash.actions.create.notice") }
        end
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    authorize! :update, @user

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html do
          redirect_to @user, flash: { notice: I18n.t("flash.actions.update.notice") }
        end
        #format.json { head :no_content }
        #format.js
      else
        logger.error("Users#update - ERROR: #{@user.errors.inspect}")
        format.html do
          render :edit
         end
        #format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])

    authorize! :destroy, @user

    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private

  def user_params
    params.require(:user).permit(PERMITTED_ATTRS)
  end

end
