class VideoServersController < ApplicationController
  # GET /video_servers
  # GET /video_servers.json
  def index
    @video_servers = VideoServer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @video_servers }
    end
  end

  # GET /video_servers/1
  # GET /video_servers/1.json
  def show
    @video_server = VideoServer.find(params[:id])
    
    begin
      @video_server.fetch_video_system_rooms
      unless @video_server.video_system_rooms.empty?
        @video_server.video_system_rooms.each do |video_system_room|
          video_system_room.fetch_video_system_room_info
        end
      end
    rescue VideoSystemApi::VideoSystemApiException => e
      flash[:notice] = 'Server unreachable - API timed out'
    end
      
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @video_server }
    end
  end

  # GET /video_servers/new
  # GET /video_servers/new.json
  def new
    @video_server = VideoServer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @video_server }
    end
  end

  # GET /video_servers/1/edit
  def edit
    @video_server = VideoServer.find(params[:id])
  end

  # POST /video_servers
  # POST /video_servers.json
  def create
    @video_server = VideoServer.new(params[:video_server])

    respond_to do |format|
      if @video_server.save
        format.html { redirect_to @video_server, notice: 'Video server was successfully created.' }
        format.json { render json: @video_server, status: :created, location: @video_server }
      else
        format.html { render action: "new" }
        format.json { render json: @video_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /video_servers/1
  # PUT /video_servers/1.json
  def update
    @video_server = VideoServer.find(params[:id])

    respond_to do |format|
      if @video_server.update_attributes(params[:video_server])
        format.html { redirect_to @video_server, notice: 'Video server was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @video_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /video_servers/1
  # DELETE /video_servers/1.json
  def destroy
    @video_server = VideoServer.find(params[:id])
    @video_server.destroy

    respond_to do |format|
      format.html { redirect_to video_servers_url }
      format.json { head :no_content }
    end
  end
end
