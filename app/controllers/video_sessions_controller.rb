class VideoSessionsController < ApplicationController
  # GET /video_sessions
  # GET /video_sessions.json
  def index
    @video_sessions = VideoSession.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @video_sessions }
    end
  end

  # GET /video_sessions/1
  # GET /video_sessions/1.json
  def show
    @video_session = VideoSession.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @video_session }
    end
  end

  # GET /video_sessions/new
  # GET /video_sessions/new.json
  def new
    @video_session = VideoSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @video_session }
    end
  end

  # GET /video_sessions/1/edit
  def edit
    @video_session = VideoSession.find(params[:id])
  end

  # POST /video_sessions
  # POST /video_sessions.json
  def create
    @video_session = VideoSession.new(params[:video_session])

    respond_to do |format|
      if @video_session.save
        format.html { redirect_to @video_session, notice: 'Video session was successfully created.' }
        format.json { render json: @video_session, status: :created, location: @video_session }
      else
        format.html { render action: "new" }
        format.json { render json: @video_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /video_sessions/1
  # PUT /video_sessions/1.json
  def update
    @video_session = VideoSession.find(params[:id])

    respond_to do |format|
      if @video_session.update_attributes(params[:video_session])
        format.html { redirect_to @video_session, notice: 'Video session was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @video_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /video_sessions/1
  # DELETE /video_sessions/1.json
  def destroy
    @video_session = VideoSession.find(params[:id])
    @video_session.destroy

    respond_to do |format|
      format.html { redirect_to video_sessions_url }
      format.json { head :no_content }
    end
  end
end
