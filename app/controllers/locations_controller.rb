class LocationsController < ApplicationController
  before_action :set_location, only: [ :edit, :update, :destroy ]

  def index
    @locations = Current.user.locations
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    @location.user = Current.user
    if @location.save
      redirect_to locations_path, notice: t("flash.locations.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @location.update(location_params)
      redirect_to locations_path, notice: t("flash.locations.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_path, notice: t("flash.locations.deleted") }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@location) }
    end
  end

  private

  def set_location
    @location = Current.user.locations.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name, :storage)
  end
end
