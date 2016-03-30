class Api::OembedController < ApplicationController

  def show
    return unsupported_format unless request.format.json?

    case params[:url]
    when %r{#{root_url}talks/(.+)\z}
      talk = Talk.find($1)
    else
      return invalid_url_schema
    end

    width = params[:maxwidth] || 445
    height = params[:maxheight] || 220

    response = {
      version: '1.0',
      type: 'rich',
      html: render_to_string(partial: 'talks/embedded', formats: ['html'],
                             locals: { embedded: talk,
                                       width: width, height: height }),
      width: width,
      height: height,
      provider_name: 'Voice Republic',
      provider_url: root_url
    }

    render json: response.to_json
  end

  private

  def unsupported_format
    logger.debug 'Unsupported format.'
    render status: 501, text: 'Not Implemented. (Unsupported format.)'
  end

  def invalid_url_schema
    logger.debug 'Invalid url schema.'
    render status: 501, text: 'Not Implemented. (Invalid url schema.)'
  end

end
