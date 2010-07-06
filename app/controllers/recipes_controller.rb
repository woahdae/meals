class RecipesController < ApplicationController
  before_filter :find_recipe,         :only   => [ :show, :edit, :update, :destroy ]
  before_filter :authenticate,        :except => [ :index, :show ]#, :edit, :new ]
  before_filter :find_items,          :only   => [ :show, :edit ]
  before_filter :find_photos,         :only   => [ :show, :edit ]
  before_filter :find_foods,          :only   => [ :new,  :edit ]
  # before_render :find_foods_on_error, :only   => [ :create, :update ]
  
  # GET /recipes
  # GET /recipes.xml
  def index
    if params[:user_id] == "0"
      if !logged_in?
        authenticate
      else
        redirect_to user_recipes_path(current_user)
      end
      return
    end
    
    user_id = params[:user_id] && params[:user_id].to_i
    user_id ||= current_user.try(:id)
    
    if user_id != current_user.try(:id)
      @viewing_user = User.find(user_id)
    end
    
    conditions = {:user_id => user_id} if user_id
    @recipes = Recipe.all(:conditions => conditions, :include => [{:items => {:food => :receipt_items}}, :photos, :user])
    @recipes = @recipes.sort_by(&:completion).reverse
    
    respond_to do |format|
      format.html # index.html.haml
      format.mobile # index.mobile.haml
      format.xml  { render :xml => @recipes }
    end
  end

  # GET /recipes/1
  # GET /recipes/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.mobile
      format.xml  { render :xml => @recipe }
    end
  end

  # GET /recipes/new
  # GET /recipes/new.xml
  def new
    items = (0...10).collect { Item.new } 
    @recipe = Recipe.new(:items => items)
    find_photos
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @recipe }
    end
  end

  # GET /recipes/1/edit
  def edit
    5.times do 
      @items << @recipe.items.new
    end
  end

  # POST /recipes
  # POST /recipes.xml
  def create
    @recipe = Recipe.new(params[:recipe])
    @recipe.user = current_user
    find_photos

    respond_to do |format|
      if @recipe.save
        flash[:notice] = 'Recipe was successfully created.'
        format.html { redirect_to(@recipe) }
        format.xml  { render :xml => @recipe, :status => :created, :location => @recipe }
      else
        find_foods_on_error
        format.html { render :action => "new" }
        format.xml  { render :xml => @recipe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /recipes/1
  # PUT /recipes/1.xml
  def update
    respond_to do |format|
      if @recipe.update_attributes(params[:recipe])
        flash[:notice] = 'Recipe was successfully updated.'
        format.html { redirect_to(@recipe) }
        format.xml  { head :ok }
      else
        find_foods_on_error
        format.html { find_items; render :action => "edit" }
        format.xml  { render :xml => @recipe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.xml
  def destroy
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to(recipes_url) }
      format.xml  { head :ok }
    end
  end

private
  
  def find_recipe
    @recipe = Recipe.find(params[:id], :include => {:items => {:food => [:receipt_items]}})
  end
  
  def find_items
    @items = @recipe.items.to_a
  end
  
  def find_photos
    if @recipe.photos.to_a.size >= 4
      2.times { @recipe.photos << RecipePhoto.new }
    else
      (@recipe.photos.to_a.size...4).each { @recipe.photos << RecipePhoto.new }
    end
  end
  
  def find_foods
    if @items
      @foods = @items.inject({}) do |foods, item|
        foods[item.id] = FerretFood.search_by_name(item.name)
        foods
      end
    else
      @foods = []
    end
  end
  
  def find_foods_on_error
    find_foods if @recipe.errors.any?
  end
end






