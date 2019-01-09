# CRUD controller for Vehicles
class VehiclesController < ApplicationController
  def index
    @vehicles = Vehicle.order('brand', 'name').all
  end

  def new
    @vehicle = Vehicle.new
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)

    return render :new, alert: 'Vehicle not valid' unless @vehicle.save

    redirect_to root_path, notice: 'Vehicle saved'
  end

  def edit
    @vehicle = Vehicle.find(params[:id])
  end

  def update
    @vehicle = Vehicle.find(params[:id])
    @vehicle.assign_attributes vehicle_params

    return render :edit, alert: 'Vehicle not valid' unless @vehicle.save

    redirect_to root_path, notice: 'Vehicle updated'
  end

  private

  def vehicle_params
    params.require(:vehicle).permit!
  end
end
