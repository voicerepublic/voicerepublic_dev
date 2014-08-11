class BaseController < ApplicationController

  # TODO move this into TalksController, where its actually needed
  include OnTheFlyGuestUser

end
