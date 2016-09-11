require 'api_constraints'

Rails.application.routes.draw do

  # `app/controllers/api/`
  namespace :api, defaults: { format: :json },
                  # constraints: { subdomain: 'api' },
                  path: '/' do

    # `app/controllers/api/v1/`
    # URL: `http://api.example.com/v1/products/1`
    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: true) do

      get 'properties/normalized'     => 'properties#normalized',
                                          as: :properties_normalized
      get 'properties/:id/normalized' => 'properties#normalized',
                                          as: :property_normalized
      resources :properties, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
