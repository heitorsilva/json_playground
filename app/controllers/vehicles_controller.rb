# CRUD controller for Vehicles
class VehiclesController < ApplicationController
  def index
    @vehicles = Vehicle.all
  end

  def new
    @vehicle = Vehicle.new
  end

  def create
    @vehicle = Vehicle.new
    @vehicle.attributes = vehicle_params
    if @vehicle.save
      redirect_to root_path, notice: 'Vehicle saved'
    else
      redirect_to '/vehicles/new', alert: 'Vehicle not valid'
    end
  end

  def edit
    @vehicle = Vehicle.find(params[:id])
  end

  def update
    @vehicle = Vehicle.find(params[:id])
    @vehicle.attributes = vehicle_params
    if @vehicle.save
      redirect_to root_path, notice: 'Vehicle saved'
    else
      redirect_to '/vehicles/new', alert: 'Vehicle not valid'
    end
  end

  private

  def vehicle_params
    params.require(:description).permit!
  end
end
