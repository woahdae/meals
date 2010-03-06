class ItemUidsController < ApplicationController
  def search
    @item_uids = FerretItemUID.search_by_name(params[:name])
    params[:selected] = nil if params[:selected].blank?
    respond_to do |format|
      # ideally I'd like to render json and have the other side
      # turn it into selects...
      format.json { render :text => @item_uids.to_json }
      format.js   { render :text => @template.options_for_item_uid_select(@item_uids, params[:selected]) }
    end
  end
end