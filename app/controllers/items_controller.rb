class ItemsController < ApplicationController
  helper :recipes

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
end
