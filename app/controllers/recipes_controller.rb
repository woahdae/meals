class RecipesController < ApplicationController
  helper :recipes

  before_filter :find_recipe,    :only   => [ :show, :edit, :update, :destroy ]
  before_filter :authenticate,   :except => [ :index, :show ]#, :edit, :new ]
  before_filter :find_items,     :only   => [ :show, :edit ]
  before_filter :find_photos,    :only   => [ :show, :edit ]

  # GET /recipes
  # GET /recipes.xml
  def index
    current_user_id = current_user && current_user.id
    user_id = params[:user_id] && params[:user_id].split("-").first.to_i
    user_id ||= current_user_id
    
    if user_id != current_user_id
      @viewing_user = User.find(user_id)
    end

    @recipes = Recipe.all(:conditions => {:user_id => user_id})
    
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
    items = [Item.new]
    photos = [RecipePhoto.new]
    @recipe = Recipe.new(:items => items, :photos => photos)
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @recipe }
    end
  end

  # GET /recipes/1/edit
  def edit
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
        @items = @recipe.items
        format.html { render :action => "edit" }
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
  
  def authenticate
    login_required || return
    
    if @recipe && !@template.user_owns_recipe?(@recipe)
      flash[:error] = "You are not the owner of this recipe"
      redirect_to_referrer_or_home
    end
  end
  
  def find_recipe
    @recipe = Recipe.find(params[:id])
    raise ArgumentError, 'Invalid recipe id provided' unless @recipe
  end
  
  def find_items
    @recipe.items
  end

  def find_photos
    @recipe.photos = [RecipePhoto.new] if @recipe.photos.empty?
  end
end
