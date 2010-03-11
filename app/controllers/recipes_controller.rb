class RecipesController < ApplicationController
  before_filter :find_recipe,         :only   => [ :show, :edit, :update, :destroy ]
  before_filter :authenticate,        :except => [ :index, :show ]#, :edit, :new ]
  before_filter :find_items,          :only   => [ :show, :edit ]
  before_filter :find_photos,         :only   => [ :show, :edit ]
  before_filter :find_item_uids,      :only   => [ :new,  :edit ]
  before_render :find_iuids_on_error, :only   => [ :create, :update ]
  
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
    @recipes = Recipe.all(:conditions => conditions, :include => [:items, :photos, :user])
    @recipes = @recipes.sort_by(&:completion).reverse
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @recipes }
    end
  end

  # GET /recipes/1
  # GET /recipes/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
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
    @recipe = Recipe.find(params[:id])
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
  
  def find_item_uids
    if @items
      @item_uids = @items.inject({}) do |item_uids, item|
        item_uids[item.id] = FerretItemUID.search_by_name(item.name)
        item_uids
      end
    else
      @item_uids = []
    end
  end
  
  def find_iuids_on_error
    find_item_uids if @recipe.errors.any?
  end
end






