class Api::V1::PropertiesController < ApplicationController
  respond_to :json

  def index
    respond_with Property.all
  end

  def show
    respond_with Property.find(params[:id])
  end

  def create
    property = Property.new(property_params)
    if property.save
       render json: property, status: 201, location: [:api, property]
     else
       render json: { errors: property.errors }, status: 422
    end
  end

  def update
    property = Property.find(params[:id])

    if property.update(property_params)
      render json: property, status: 200, location: [:api, property]
    else
      render json: { errors: property.errors }, status: 422
    end
  end

  def destroy
    property = Property.find(params[:id])
    property.destroy
    head 204
  end

  private

    def property_params
      params.require(:property).permit(:name, :description)
    end
end
