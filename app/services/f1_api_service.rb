require 'net/http'
require 'json'

class F1ApiService
  API_BASE_URL = ENV.fetch('F1_API_URL', 'http://192.168.0.86:8000')
  
  # Last 6 races of 2025 F1 season
  # Add your YouTube video IDs here for each race highlight
  LAST_SIX_RACES = [
    {
      name: "United States Grand Prix",
      track: "Circuit of the Americas",
      date: "October 19, 2025",
      round: 19,
      highlights: "Austin, Texas hosts this modern circuit. Sprint race weekend with massive crowds and entertainment.",
      youtube_id: "CdKwc1bC44c?start=442"
    },
    {
      name: "Mexico City Grand Prix",
      track: "Autódromo Hermanos Rodríguez",
      date: "October 26, 2025",
      round: 20,
      highlights: "High altitude racing creates unique challenges. Incredible atmosphere from dedicated Mexican fans.",
      youtube_id: "hTqxfkWRimk?start=418"
    },
    {
      name: "São Paulo Grand Prix",
      track: "Interlagos",
      date: "November 9, 2025",
      round: 21,
      highlights: "Historic circuit with passionate fans. Counter-clockwise layout and unpredictable weather make this a fan favorite.",
      youtube_id: "MK83clSv6-k?start=419"
    },
    {
      name: "Las Vegas Grand Prix",
      track: "Las Vegas Street Circuit",
      date: "November 23, 2025",
      round: 22,
      highlights: "Spectacular night race on the Las Vegas Strip. High-speed street circuit with stunning backdrops.",
      youtube_id: "uQc-pW3QLuI?start=387"
    },
    {
      name: "Qatar Grand Prix",
      track: "Lusail",
      date: "November 30, 2025",
      round: 23,
      highlights: "Night race in the Middle East. Sprint race weekend adds extra excitement to the championship battle.",
      youtube_id: "BeaVJggQ2dc?start=425"
    },
    {
      name: "Abu Dhabi Grand Prix",
      track: "Yas Marina",
      date: "December 7, 2025",
      round: 24,
      highlights: "Season finale under the lights. The championship often comes down to this dramatic desert circuit.",
      youtube_id: nil
    }
  ]
  
  def self.predict_race(track, grid_positions, model_name = 'xgboost')
    uri = URI("#{API_BASE_URL}/predict-race/#{model_name}")
    
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
    request.body = {
      track: track,
      grid_positions: grid_positions
    }.to_json
    
    response = http.request(request)
    
    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      { error: "Failed to get predictions: #{response.code}" }
    end
  rescue => e
    { error: "API connection error: #{e.message}" }
  end
  
  def self.get_last_six_races_predictions
    results = []
    
    Rails.logger.info "Starting F1 predictions from API: #{API_BASE_URL}"
    
    LAST_SIX_RACES.each do |race|
      # Sample grid positions for 2025 season (top 20 drivers)
      grid_positions = {
        "Max Verstappen" => 1,
        "Lando Norris" => 2,
        "Charles Leclerc" => 3,
        "Oscar Piastri" => 4,
        "Carlos Sainz" => 5,
        "George Russell" => 6,
        "Lewis Hamilton" => 7,
        "Sergio Perez" => 8,
        "Fernando Alonso" => 9,
        "Lance Stroll" => 10,
        "Pierre Gasly" => 11,
        "Esteban Ocon" => 12,
        "Alexander Albon" => 13,
        "Yuki Tsunoda" => 14,
        "Daniel Ricciardo" => 15,
        "Nico Hulkenberg" => 16,
        "Kevin Magnussen" => 17,
        "Valtteri Bottas" => 18,
        "Zhou Guanyu" => 19,
        "Logan Sargeant" => 20
      }
      
      # Get predictions from both models
      linear_predictions = predict_race(race[:track], grid_positions, 'linear')
      Rails.logger.info "Linear predictions for #{race[:name]}: #{linear_predictions.inspect}"
      
      xgboost_predictions = predict_race(race[:track], grid_positions, 'xgboost')
      Rails.logger.info "XGBoost predictions for #{race[:name]}: #{xgboost_predictions.inspect}"
      
      results << {
        race: race,
        predictions: {
          linear: linear_predictions,
          xgboost: xgboost_predictions
        }
      }
    end
    
    results
  end
end
