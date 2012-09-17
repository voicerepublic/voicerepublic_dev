class BookmarksController < ApplicationController
  layout "users"
  #before_filter :set_user
  
  # GET /bookmarks
  # GET /bookmarks.json
  def index
    @user = User.find(params[:user_id])
    @bookmarks = @user.bookmarks

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bookmarks }
    end
  end

  # GET /bookmarks/1
  # GET /bookmarks/1.json
  def show
    @bookmark = Bookmark.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bookmark }
    end
  end

  # POST /bookmarks
  # POST /bookmarks.json
  def create
    _user = current_user
    @bookmark = _user.bookmarks.build(:klu_id => params[:klu_id])

    respond_to do |format|
      if @bookmark.save
        format.html { redirect_to( user_bookmarks_path(:user_id => @bookmark.user), notice: 'Bookmark was successfully created.') }
        format.json { render json: @bookmark, status: :created, location: @bookmark }
      else
        format.html { render action: "new" }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bookmarks/1
  # PUT /bookmarks/1.json
  def update
    @bookmark = Bookmark.find(params[:id])

    respond_to do |format|
      if @bookmark.update_attributes(params[:bookmark])
        format.html { redirect_to user_bookmarks_url( :user_id => @bookmark.user), notice: 'Bookmark was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/1
  # DELETE /bookmarks/1.json
  def destroy
    @bookmark = Bookmark.find(params[:id])
    _user = @bookmark.user
    @bookmark.destroy

    respond_to do |format|
      format.html { redirect_to user_bookmarks_url(:user_id => _user) }
      format.json { head :no_content }
    end
  end
  
end
