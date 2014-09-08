class Xhr::UploadTalksController < Xhr::BaseController

  before_filter :authenticate_user!

  def create
    f = File.open("/tmp/#{params[:talk][:uuid]}.dat", "wb")
    # TODO: Write Journal
    # params[:file].original_filename
    f.write(params[:file].tempfile.read)
    f.close
    render json: { message: 'all done' }
  end

  private

  def social_share_params
    params.require(:talk).permit( :uuid )
  end

end
