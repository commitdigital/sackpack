class ItemsController < ApplicationController
  before_action :set_item, only: [ :edit, :update, :destroy ]

  def index
    @items_by_category = Current.user.categories
                                     .joins(:items)
                                     .includes(items: :location)
                                     .order(:name)
                                     .group_by(&:itself)
                                     .transform_values { |categories| categories.first.items }
  end

  def new
    @item = Item.new
    @categories = Current.user.categories
    @locations = Current.user.locations
  end

  def create
    @item = Item.new(item_params)
    @item.user = Current.user
    if @item.save
      redirect_to items_path, notice: "Item created"
    else
      @categories = Current.user.categories
      @locations = Current.user.locations
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Current.user.categories
    @locations = Current.user.locations
  end

  def update
    if @item.update(item_params)
      redirect_to items_path, notice: "Item updated"
    else
      @categories = Current.user.categories
      @locations = Current.user.locations
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_path, notice: "Item deleted" }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@item) }
    end
  end

  private

  def set_item
    @item = Current.user.items.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :note, :category_id, :location_id, :purchase_value_cents, :current_value_cents, :acquired_on, :discarded_on, :last_seen_on, :expected_uses)
  end
end
