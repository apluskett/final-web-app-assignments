require 'net/http'
require 'json'

class F1ApiService
    VALID_2025_DRIVERS = [
      "Max Verstappen", "Lando Norris", "Oscar Piastri", "Kimi Antonelli", "Charles Leclerc", "Fernando Alonso", "Lewis Hamilton", "Oliver Bearman", "Carlos Sainz", "Isack Hadjar", "Yuki Tsunoda", "Lance Stroll", "Alexander Albon", "Liam Lawson", "Franco Colapinto", "Gabriel Bortoleto", "Esteban Ocon", "Pierre Gasly", "Nico Hulkenberg", "George Russell", "Jack Doohan"
    ]
  API_BASE_URL = ENV.fetch('F1_API_URL', 'https://ml.alexpluskett.com')
  
  # Last 6 races of 2025 F1 season with actual results
  LAST_SIX_RACES = [
    {
      name: "United States Grand Prix",
      track: "Circuit of the Americas",
      date: "October 19, 2025",
      round: 19,
      highlights: "Austin, Texas hosts this modern circuit. Sprint race weekend with massive crowds and entertainment.",
      youtube_id: "CdKwc1bC44c?start=442",
      actual_podium: ["Max Verstappen", "Lando Norris", "Charles Leclerc"]
    },
    {
      name: "Mexico City Grand Prix",
      track: "Autódromo Hermanos Rodríguez",
      date: "October 26, 2025",
      round: 20,
      highlights: "High altitude racing creates unique challenges. Incredible atmosphere from dedicated Mexican fans.",
      youtube_id: "hTqxfkWRimk?start=418",
      actual_podium: ["Lando Norris", "Charles Leclerc", "Max Verstappen"]
    },
    {
      name: "São Paulo Grand Prix",
      track: "Interlagos",
      date: "November 9, 2025",
      round: 21,
      highlights: "Historic circuit with passionate fans. Counter-clockwise layout and unpredictable weather make this a fan favorite.",
      youtube_id: "MK83clSv6-k?start=419",
      actual_podium: ["Lando Norris", "Kimi Antonelli", "Max Verstappen"]
    },
    {
      name: "Las Vegas Grand Prix",
      track: "Las Vegas Street Circuit",
      date: "November 23, 2025",
      round: 22,
      highlights: "Spectacular night race on the Las Vegas Strip. High-speed street circuit with stunning backdrops.",
      youtube_id: "uQc-pW3QLuI?start=387",
      actual_podium: ["Max Verstappen", "George Russell", "Kimi Antonelli"]
    },
    {
      name: "Qatar Grand Prix",
      track: "Lusail",
      date: "November 30, 2025",
      round: 23,
      highlights: "Night race in the Middle East. Sprint race weekend adds extra excitement to the championship battle.",
      youtube_id: "BeaVJggQ2dc?start=425",
      actual_podium: ["Max Verstappen", "Oscar Piastri", "Carlos Sainz"]
    },
    {
      name: "Abu Dhabi Grand Prix",
      track: "Yas Marina",
      date: "December 7, 2025",
      round: 24,
      highlights: "Season finale under the lights. The championship often comes down to this dramatic desert circuit.",
      youtube_id: nil,
      actual_podium: nil
    }
  ]
  
  def self.predict_race(track, grid_positions, model_name = 'xgboost')
    uri = URI("#{API_BASE_URL}/predict-race/#{model_name}")

    filtered_grid = grid_positions.select { |driver, _| VALID_2025_DRIVERS.include?(driver) }
    payload = {
      track: track,
      grid_positions: filtered_grid
    }
    Rails.logger.info "ML API request payload: #{payload.to_json}"

    http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end
    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
    request.body = payload.to_json

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      { error: "Failed to get predictions: #{response.code}", payload: payload }
    end
  rescue => e
    { error: "API connection error: #{e.message}", payload: payload }
  end
  
  def self.get_last_six_races_predictions
    results = []
    
    Rails.logger.info "Starting F1 predictions from API: #{API_BASE_URL}"
    
    # Actual grid positions from CSV validation data (2025 season with new drivers)
    race_grids = [
      # Austin (United States) - Verstappen on pole
      {
        "Max Verstappen" => 1, "Lando Norris" => 2, "Charles Leclerc" => 3,
        "George Russell" => 4, "Lewis Hamilton" => 5, "Oscar Piastri" => 6,
        "Kimi Antonelli" => 7, "Oliver Bearman" => 8, "Carlos Sainz" => 9,
        "Fernando Alonso" => 10, "Nico Hulkenberg" => 11, "Liam Lawson" => 12,
        "Yuki Tsunoda" => 13, "Pierre Gasly" => 14, "Franco Colapinto" => 15,
        "Gabriel Bortoleto" => 16, "Esteban Ocon" => 17, "Alexander Albon" => 18,
        "Lance Stroll" => 19, "Isack Hadjar" => 20
      },
      # Mexico City - Norris leads Leclerc
      {
        "Lando Norris" => 1, "Charles Leclerc" => 2, "Lewis Hamilton" => 3,
        "George Russell" => 4, "Max Verstappen" => 5, "Kimi Antonelli" => 6,
        "Oscar Piastri" => 7, "Isack Hadjar" => 8, "Oliver Bearman" => 9,
        "Yuki Tsunoda" => 10, "Esteban Ocon" => 11, "Carlos Sainz" => 12,
        "Nico Hulkenberg" => 13, "Fernando Alonso" => 14, "Liam Lawson" => 15,
        "Gabriel Bortoleto" => 16, "Alexander Albon" => 17, "Pierre Gasly" => 18,
        "Lance Stroll" => 19, "Franco Colapinto" => 20
      },
      # São Paulo (Brazil) - Norris on pole, Verstappen P19!
      {
        "Lando Norris" => 1, "Kimi Antonelli" => 2, "Charles Leclerc" => 3,
        "Oscar Piastri" => 4, "Isack Hadjar" => 5, "George Russell" => 6,
        "Liam Lawson" => 7, "Oliver Bearman" => 8, "Pierre Gasly" => 9,
        "Fernando Alonso" => 11, "Alexander Albon" => 12, "Lewis Hamilton" => 13,
        "Lance Stroll" => 14, "Carlos Sainz" => 15, "Franco Colapinto" => 16,
        "Yuki Tsunoda" => 17, "Gabriel Bortoleto" => 18, "Max Verstappen" => 19,
        "Esteban Ocon" => 20
      },
      # Las Vegas - Norris and Verstappen front row
      {
        "Lando Norris" => 1, "Max Verstappen" => 2, "Carlos Sainz" => 3,
        "George Russell" => 4, "Oscar Piastri" => 5, "Liam Lawson" => 6,
        "Fernando Alonso" => 7, "Isack Hadjar" => 8, "Charles Leclerc" => 9,
        "Pierre Gasly" => 10, "Nico Hulkenberg" => 11, "Lance Stroll" => 12,
        "Esteban Ocon" => 13, "Oliver Bearman" => 14, "Franco Colapinto" => 15,
        "Alexander Albon" => 16, "Kimi Antonelli" => 17, "Gabriel Bortoleto" => 18,
        "Lewis Hamilton" => 19, "Yuki Tsunoda" => 20
      },
      # Qatar - Verstappen pole position
      {
        "Max Verstappen" => 1, "Oscar Piastri" => 2, "Lando Norris" => 3,
        "Carlos Sainz" => 4, "Kimi Antonelli" => 5, "George Russell" => 6,
        "Fernando Alonso" => 7, "Charles Leclerc" => 8, "Liam Lawson" => 9,
        "Yuki Tsunoda" => 10, "Alexander Albon" => 11, "Lewis Hamilton" => 12,
        "Gabriel Bortoleto" => 13, "Franco Colapinto" => 14, "Esteban Ocon" => 15,
        "Pierre Gasly" => 16, "Lance Stroll" => 17, "Isack Hadjar" => 18,
        "Oliver Bearman" => 19, "Nico Hulkenberg" => 20
      },
      # Abu Dhabi - Title decider (synthetic grid for finale)
      {
        "Lando Norris" => 1, "Max Verstappen" => 2, "Oscar Piastri" => 3,
        "Charles Leclerc" => 4, "Carlos Sainz" => 5, "George Russell" => 6,
        "Lewis Hamilton" => 7, "Kimi Antonelli" => 8, "Fernando Alonso" => 9,
        "Liam Lawson" => 10, "Pierre Gasly" => 11, "Esteban Ocon" => 12,
        "Yuki Tsunoda" => 13, "Alexander Albon" => 14, "Isack Hadjar" => 15,
        "Nico Hulkenberg" => 16, "Oliver Bearman" => 17, "Lance Stroll" => 18,
        "Gabriel Bortoleto" => 19, "Franco Colapinto" => 20
      }
    ]
    
    LAST_SIX_RACES.each_with_index do |race, index|
      grid_positions = race_grids[index]
      
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
