class PagesController < ApplicationController

  layout 'velvet'

  def error
    raise 'Hello Errbit!'
  end

end
