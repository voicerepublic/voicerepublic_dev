# http://oembed.com/
#
class Api::OembedController < ApplicationController

  include ApplicationHelper

  def show
    return unsupported_format unless request.format.json?

    case params[:url]
    when %r{#{root_url}talks/(.+)\z}
      talk = Talk.find($1)
    else
      return invalid_url_schema
    end

    width     = 445
    height    = 140
    maxwidth  = params[:maxwidth]
    maxheight = params[:maxheight]
    width     = [ maxwidth.to_i  || width  ].min if maxwidth
    height    = [ maxheight.to_i || height ].min if maxheight

    response = {
      type: 'rich',
      version: '1.0',
      html: render_to_string(partial: 'talks/embedded', formats: ['html'],
                             locals: { embedded: talk,
                                       width: width, height: height }),
      width: width,
      height: height,
      provider_name: 'Voice Republic',
      provider_url: root_url
    }

    # with love for our dear friends at republica
    if params[:mode] == '42'
      response.merge!( title: talk.title,
                       author_name: talk.speaker_list,
                       thumbnail_url: talk.image.url,
                       thumbnail_width: talk.image.width,
                       thumbnail_height: talk.image.height )
      response[:url] = vrmedia_url(talk) if talk.archived?
    end

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
