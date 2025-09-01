class CategoriesController < ApplicationController
  before_action :set_category, only: [ :edit, :update, :destroy ]

  def index
    @categories = Current.user.categories
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @category.user = Current.user
    if @category.save
      redirect_to categories_path, notice: t("flash.categories.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: t("flash.categories.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_path, notice: t("flash.categories.deleted") }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@category) }
    end
  end

  private

  def set_category
    @category = Current.user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
