class LayersController < ApplicationController
  # GET /layers
  # GET /layers.xml
  before_filter :get_board
  before_filter :require_token, :only => [:create, :update, :destroy]
  protect_from_forgery :except => [:update]

  # GET /layers/1
  # GET /layers/1.xml
  # GET /layers/new
  # GET /layers/new.xml
  def new
    @layer = @board.layers.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @layer }
    end
  end

  # POST /layers
  # POST /layers.xml
  def create
    @layer = @board.layers.new(params[:layer])

    respond_to do |format|
      if @layer.save
        format.html { redirect_to(@board.owner_link, :notice => 'Layer was successfully created.') }
        format.xml  { render :xml => @layer, :status => :created, :location => @layer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @layer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /layers/1
  # PUT /layers/1.xml
  def update
    @layer = @board.layers.find(params[:id])
    if params[:token] == @board.token
      @layer.update_with_params(params)
    elsif params[:token] == @layer.token
      @layer.update_with_params(:data => params[:data])
    end
    respond_to do |format|
      if @layer.save
        format.html { head :ok }
        format.xml  { head :ok }
      end
    end
  end

  # DELETE /layers/1
  # DELETE /layers/1.xml
  def destroy
    @layer = @board.layers.find(params[:id])
    @layer.destroy

    respond_to do |format|
      format.html { redirect_to(layers_url) }
      format.xml  { head :ok }
    end
  end

  def get_board
    begin
      @board = Board.find params[:board_id]
    rescue
      redirect_to root_path, :notice => "Board required"
    end
  end

  def require_token
    if @board.permission(params[:token]) == :viewer
      redirect_to root_path, :notice => "Valid token required"
    end
  end
end
