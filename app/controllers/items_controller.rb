class ItemsController < ApplicationController
  before_action :set_item, only: [ :edit, :update, :destroy ]

  def index
    @items_by_category = items_by_category_for(discarded: false)
  end

  def discarded
    @items_by_category = items_by_category_for(discarded: true)
    render :index
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
      redirect_to items_path, notice: t("flash.items.created")
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
      redirect_to items_path, notice: t("flash.items.updated")
    else
      @categories = Current.user.categories
      @locations = Current.user.locations
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_path, notice: t("flash.items.deleted") }
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

  def items_by_category_for(discarded:)
    condition = discarded ? "IS NOT NULL" : "IS NULL"
    Current.user.categories
                .joins(:items)
                .includes(items: :location)
                .where("items.discarded_on #{condition}")
                .order(:name)
                .group_by(&:itself)
                .transform_values { |categories| categories.first.items.where(discarded ? "discarded_on IS NOT NULL" : "discarded_on IS NULL") }
  end
end
