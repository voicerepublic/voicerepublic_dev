class Admin::KlusController < Admin::BaseController
  # GET /klus
  # GET /klus.json
  def index
    @klus = Klu.paginate(:page => params[:page], :per_page => 5)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @klus }
    end
  end

  # GET /klus/1
  # GET /klus/1.json
  def show
    @klu = Klu.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @klu }
    end
  end

  # GET /klus/new
  # GET /klus/new.json
  def new
    @klu = Klu.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @klu }
    end
  end

  # GET /klus/1/edit
  def edit
    @klu = Klu.find(params[:id])
  end

  # POST /klus
  # POST /klus.json
  def create
    @klu = Klu.new(params[:klu])

    respond_to do |format|
      if @klu.save
        format.html { redirect_to @klu, notice: 'Klu was successfully created.' }
        format.json { render json: @klu, status: :created, location: @klu }
      else
        format.html { render action: "new" }
        format.json { render json: @klu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /klus/1
  # PUT /klus/1.json
  def update
    @klu = Klu.find(params[:id])

    respond_to do |format|
      if @klu.update_attributes(params[:klu])
        format.html { redirect_to user_klu_path(:user_id => @klu.user, :id => @klu), notice: 'Klu was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @klu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /klus/1
  # DELETE /klus/1.json
  def destroy
    @klu = Klu.find(params[:id])
    _user = @klu.user
    @klu.destroy

    respond_to do |format|
      format.html { redirect_to user_klus_url(:user_id => _user) }
      format.json { head :no_content }
    end
  end
end
