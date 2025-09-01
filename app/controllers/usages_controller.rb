class UsagesController < ApplicationController
  before_action :set_item

  def new
    @usage = @item.usages.build(used_on: Date.current)
  end

  def create
    @usage = @item.usages.build(usage_params)

    if @usage.save
      update_item_last_used_on
      redirect_to items_path, notice: t("flash.usages.created")
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def set_item
    @item = Current.user.items.find(params[:item_id])
  end

  def usage_params
    params.require(:usage).permit(:used_on, :note)
  end

  def update_item_last_used_on
    if @item.last_used_on.nil? || @usage.used_on > @item.last_used_on
      @item.update_column(:last_used_on, @usage.used_on)
    end
  end
end
