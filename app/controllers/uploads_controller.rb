class UploadsController < BaseController

  before_action :authenticate_user!
  before_action :redirect_if_low_on_credits, only: :new
  before_action :set_presigned_post_url

  def new
    attrs = params[:talk] ? talk_params : {}
    attrs[:venue_id] ||= current_user.default_venue_id
    @talk = Talk.new(attrs)
  end

  # POST /uploads
  def create
    @talk = Talk.new(talk_params)
    @talk.venue_user = current_user

    authorize! :create, @talk

    if @talk.save
      redirect_to @talk, notice: 'Talk was successfully created.'
    else
      render action: 'new'
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def talk_params
    params.require(:talk).permit(:title, :teaser, :starts_at_date,
                                 :starts_at_time,
                                 :description, :image,
                                 :tag_list, :language,
                                 :new_venue_title, :venue_id,
                                 :user_override_uuid)
  end

  # this is a phony fake presigned url generator!
  # TODO make a less phony fake...
  # In S3, permissions are set for everyone to upload. It's better to create
  # a real presigned URL. Either use 'fog', or the 'aws-sdk' gem.
  def set_presigned_post_url
    @presigned_s3_post_url = "https://#{Settings.storage.uploads}.s3.amazonaws.com"

    # upload_bucket = AWS::S3.new.buckets[Settings.talk_upload_bucket]
    #
    # @presigned_s3_post_url = upload_bucket.presigned_post(key: "#{SecureRandom.uuid}",
    #                                           success_action_status: 201,
    #                                           acl: :bucket_owner_full_control).url
  end

end
