require 'json'

class Api::V1::PropertiesController < ApplicationController

  def index
    properties = File.read("db/feeds/parsed_feed_example.json")
    render json: properties
  end

  def show
    properties = File.read("db/feeds/parsed_feed_example.json")
    property   = JSON.parse(properties)[params[:id].to_i]
    render json: property.to_json
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
