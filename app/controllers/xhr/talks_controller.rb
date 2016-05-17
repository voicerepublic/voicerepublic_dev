class Xhr::TalksController < Xhr::BaseController

  ALLOWED_EVENTS = %w( start_talk
                       end_talk )

  load_and_authorize_resource

  def update
    @talk.assign_attributes(talk_params)

    # TODO move to model
    @talk.send(@talk.event) if ALLOWED_EVENTS.include?(@talk.event)

    @talk.save
    head :ok

  rescue => e
    render status: 409, text: e.message
  end

  private

  def talk_params
    params.required(:talk).permit(:event)
  end

  # TODO fix
  def verified_request?
    true
  end

end
