class ListsController < ApplicationController
  # GET /lists/1
  # GET /lists/1.xml
  def show
    begin
      @list ||= List.find(session[:list_id])
    rescue ActiveRecord::RecordNotFound
      @list = List.create(:user => current_user)
      session[:list_id] = @list.id
    end

    respond_to do |format|
      format.mobile
      format.html
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
      @list.add_recipe(@item)
    elsif params[:food_id]
      @item = Food.find(params[:food_id]) if params[:food_id]
      @list.add_food(@item, params[:qty])
    end
    
    respond_to do |format|
      format.mobile do
        render "add.mobile.erb", 
          :content_type => "application/javascript", 
          :layout => false
      end
      format.html {redirect_to_referrer_or_home}
      format.js
    end
  end

  def remove
    @list.recipes.delete(Recipe.find(params[:recipe_id])) if params[:recipe_id]
    @list.foods.delete(Food.find(params[:food_id])) if params[:food_id]
    
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
