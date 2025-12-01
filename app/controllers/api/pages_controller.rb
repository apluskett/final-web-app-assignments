module Api
  class PagesController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    def predict_races
      predictions = F1ApiService.get_last_six_races_predictions
      # Store in Rails cache
      Rails.cache.write('f1_predictions', predictions, expires_in: 1.hour)
      
      render json: predictions
    end
  end
end
