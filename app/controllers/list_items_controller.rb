class ListItemsController < ApplicationController
  def destroy
    begin
      @list_item = @list.list_items.find(params[:id])
      @list_item.destroy
    rescue ActiveRecord::RecordNotFound
      @list_item = ListItem.new
      @list_item.id = params[:id]
    end

    respond_to do |format|
      format.html {redirect_to :back}
      format.mobile {render "destroy.js.erb", :content_type => "application/javascript", :layout => false}
      format.js
    end
  end
end