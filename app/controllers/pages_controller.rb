class PagesController < ApplicationController
  def home
  end

  def demos
  end

  def f1_predictions
    # Check if predictions were just generated
    @predictions = Rails.cache.read('f1_predictions')
  end
  
  def predict_races
    @predictions = F1ApiService.get_last_six_races_predictions
    Rails.cache.write('f1_predictions', @predictions, expires_in: 1.hour)

    respond_to do |format|
      format.json { render json: @predictions }
      format.html { redirect_to f1_predictions_path }
    end
  end
end
