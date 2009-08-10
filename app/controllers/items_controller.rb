class ItemsController < ApplicationController
  helper :recipes

  before_filter :find_recipe, :except => :new
  before_filter :find_item, :only => [ :show, :edit, :update, :destroy ]

  # GET /items
  # GET /items.xml
  def index
    @items = Item.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end

  # GET /items/1
  # GET /items/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/new
  # GET /items/new.xml
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
      format.js do
        # a buncha work to get the right form builder
        @recipe = Recipe.new(:items => [@item])
        @child_index = params[:child_index]
        @template.fields_for(@recipe) do |f|
          f.fields_for(:items, :child_index => @child_index) do |item_form|
            render :partial => "/items/item", :locals => {:f => item_form, :item => @item}
          end
        end
      end
    end
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.xml
  def create
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        flash[:notice] = 'Item was successfully created.'
        format.html { redirect_to(recipe_url(@item.recipe_id)) }
        format.xml  { render :xml => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.xml
  def update
    respond_to do |format|
      if @item.update_attributes(params[:item])
        flash[:notice] = 'Item was successfully updated.'
        format.html { redirect_to(recipe_url(@item.recipe_id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(recipe_url(@item.recipe_id)) }
      format.xml  { head :ok }
    end
  end

  private

  def find_recipe
    @recipe = Recipe.find(params[:recipe_id])
    raise ArgumentError, 'Invalid recipe id provided' unless @recipe
  end

  def find_item
    @item = @recipe.items.find(params[:id])
    raise ArgumentError, 'Invalid item id provided' unless @item
  end
end
