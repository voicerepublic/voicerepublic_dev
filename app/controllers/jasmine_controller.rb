class JasmineController < ApplicationController
  def show
    file = params[:file] || "SpecRunner.html"

    extname = File.extname(file)[1..-1]
    mime_type = Mime::Type.lookup_by_extension(extname)
    content_type = mime_type.to_s unless mime_type.nil?

    render file: "/jasmine/" + file,
      content_type: content_type,
      layout: false
  end
end
