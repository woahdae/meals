class FoodsController < ApplicationController
  before_filter :find_food,    :only => [ :show, :edit, :update, :destroy ]
  before_filter :authenticate, :only => :create
  
  # GET /foods
  # GET /foods.xml
  def index
    @foods = Food.paginate(
      :per_page => params[:per_page] || 20,
      :page => params[:page] )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @foods }
    end
  end

  # GET /foods/1
  # GET /foods/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @food }
    end
  end

  # GET /foods/new
  # GET /foods/new.xml
  def new
    @food = Food.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @food }
    end
  end

  # GET /foods/1/edit
  def edit
  end

  # POST /foods
  # POST /foods.xml
  def create
    @food = Food.new(params[:food].merge(:user_id => current_user.id))

    respond_to do |format|
      if @food.save
        flash[:notice] = 'Food was successfully created.'
        format.html { redirect_to(@food) }
        format.xml  { render :xml => @food, :status => :created, :location => @food }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @food.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /foods/1
  # PUT /foods/1.xml
  def update
    respond_to do |format|
      if @food.update_attributes(params[:food])
        flash[:notice] = 'Food was successfully updated.'
        format.html { redirect_to(@food) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @food.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /foods/1
  # DELETE /foods/1.xml
  def destroy
    @food.destroy

    respond_to do |format|
      format.html { redirect_to(foods_url) }
      format.xml  { head :ok }
    end
  end

  private

  def find_food
    @food = Food.find(params[:id])
    raise ArgumentError, 'Invalid food id provided' unless @food
  end
end
