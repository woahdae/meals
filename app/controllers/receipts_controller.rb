class ReceiptsController < ApplicationController
  before_filter :find_receipt,        :only => [ :show, :edit, :update, :destroy ]
  before_filter :authenticate
  before_filter :find_receipt_items,  :only => [ :show, :edit ]
  before_filter :find_stores,         :only => [ :new,  :edit ]
  before_filter :find_foods,          :only => [ :new,  :edit ]
  before_render :find_foods_on_error, :only => [ :create, :update ]
  
  # GET /receipts
  # GET /receipts.xml
  def index
    @receipts = Receipt.all(:conditions => {:user_id => current_user})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @receipts }
    end
  end

  # GET /receipts/1
  # GET /receipts/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @receipt }
    end
  end

  # GET /receipts/new
  # GET /receipts/new.xml
  def new
    items = (0...20).collect { ReceiptItem.new } 
    @receipt = Receipt.new(:items => items)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @receipt }
    end
  end

  # GET /receipts/1/edit
  def edit
    5.times do 
      @items << @receipt.items.new
    end
  end

  # POST /receipts
  # POST /receipts.xml
  def create
    @receipt = Receipt.new(params[:receipt])
    @receipt.user = current_user
    
    respond_to do |format|
      if @receipt.save
        flash[:notice] = 'Receipt was successfully created.'
        format.html { redirect_to(@receipt) }
        format.xml  { render :xml => @receipt, :status => :created, :location => @receipt }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @receipt.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /receipts/1
  # PUT /receipts/1.xml
  def update
    respond_to do |format|
      if @receipt.update_attributes(params[:receipt])
        flash[:notice] = 'Receipt was successfully updated.'
        format.html { redirect_to(@receipt) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @receipt.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /receipts/1
  # DELETE /receipts/1.xml
  def destroy
    @receipt.destroy

    respond_to do |format|
      format.html { redirect_to(receipts_url) }
      format.xml  { head :ok }
    end
  end

  private
  
  def find_receipt
    @receipt = Receipt.find(params[:id])
  end
  
  def find_receipt_items
    @items = @receipt.items.to_a
  end
  
  def find_stores
    @stores = Store.all
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
    find_foods if @receipt.errors.any?
  end
end
