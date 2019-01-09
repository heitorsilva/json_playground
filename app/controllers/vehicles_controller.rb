class VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]

  def index
    @vehicles = Vehicle.all
  end

  def show
  end

  def new
    @vehicle = Vehicle.new
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)

    if @vehicle.save
      redirect_to vehicles_url, notice: 'Vehicle was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    params = vehicle_params
    Description.enrich_params!(params, @vehicle)
    if @vehicle.update(params)
      redirect_to vehicles_url, notice: 'Vehicle was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @vehicle.destroy
    redirect_to vehicles_url, notice: 'Vehicle was successfully destroyed.'
  end

  private

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  def vehicle_params
    params.require(:vehicle).permit!
  end
end
