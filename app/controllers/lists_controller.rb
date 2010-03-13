class ListsController < ApplicationController
  # GET /lists/1
  # GET /lists/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @list }
    end
  end

  def add
    if @list.nil?
      @list = List.create(:user => current_user)
      session[:list_id] = @list.id
    end
    
    if params[:recipe_id]
      @item = Recipe.find(params[:recipe_id]) if params[:recipe_id]
      @list.recipes << @item
    elsif params[:item_uid_id]
      @item = ItemUID.find(params[:item_uid_id]) if params[:item_uid_id]
      @list.item_uids << @item
    end
    
    respond_to do |format|
      format.html {redirect_to_referrer_or_home}
      format.js # render
    end
  end

  def remove
    @list.recipes.delete(Recipe.find(params[:recipe_id])) if params[:recipe_id]
    @list.item_uids.delete(ItemUID.find(params[:item_uid_id])) if params[:item_uid_id]
    
    redirect_to_referrer_or_home
  end
  
  # DELETE /lists/1.xml
  def destroy
    @list.destroy
    session[:list_id] = nil
    @list = nil
    
    redirect_to "/"
  end
end
