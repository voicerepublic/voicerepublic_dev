class PagesController < ApplicationController

  layout 'velvet'

  skip_before_filter :check_browser


end
