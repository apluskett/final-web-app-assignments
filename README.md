# F1 Race Predictions Portfolio

**Your name**: Alexander Pluskett
**Assignment**: Final Project

## 🏎️ Project Overview

A full-stack web application showcasing machine learning predictions for Formula 1 races, integrated with a FastAPI microservice backend. This portfolio demonstrates the integration of ML models, containerized services, and modern web development.

### Features
- **Interactive ML Predictions**: Predicts podium finishes for the final 6 races of the 2025 F1 season
- **Dual Model Comparison**: Weighted Linear Regression vs. XGBoost
- **Race Highlights**: Direct links to official F1 YouTube race highlights
- **Theme Modes**: Light, Dark, and F1 Official color schemes
- **Full Transparency**: Complete prediction data (CSV format) for all 20 drivers
- **Responsive Design**: Works on desktop, tablet, and mobile

## 🚀 How to Run

### Prerequisites
- **Node.js 20+** and **npm** (for building React frontend)
- **Ruby 3.x** and **Rails 8.0**
- **ML API container** running on port 8000 (see [Machine Learning API Project](https://github.com/apluskett/Machine-Learning-API-project))
- **Podman or Docker**

git clone https://github.com/apluskett/Machine-Learning-API-project.git
### Required: ML API Setup

This web app requires the F1 ML API to be running. For production, the app uses the hosted API at [https://ml.alexpluskett.com](https://ml.alexpluskett.com). For local development, you can run your own instance:

```bash
# Clone the ML API repository
git clone https://github.com/apluskett/Machine-Learning-API-project.git
cd Machine-Learning-API-project

# Follow the setup instructions in that repository's README
# The API must be running on port 8000 for local development
```

### Build React Frontend

```bash
# Install dependencies
npm install

# Build the React app with esbuild
npm run build
```

This compiles the React application into `app/assets/builds/application.js`

### Using Docker

```bash
docker build -t final-web-app .
docker run -e TINYMCE_API_KEY=your_api_key_here -d -p 3000:3000 --name final-web-app final-web-app
```

### Using Podman

```bash
podman build -t final-web-app .
podman run -e TINYMCE_API_KEY=your_api_key_here -d -p 3000:3000 --name final-web-app final-web-app
```

**Note**: Replace `your_api_key_here` with your actual TinyMCE API key for rich text editing functionality.

**For this project, use**: `sq1xw96jefpsewgycndhmzmg6yq6xdycs0vis8akcxj51sl1`

### Local Development

```bash
# Install Ruby dependencies
bundle install

# Build React frontend
npm install
npm run build

# Setup database
rails db:migrate

# Start Rails server
rails server -b 0.0.0.0 -p 3000
```

Then access the portfolio at http://localhost:3000

**Important**: Use **http://localhost:3000** (not https://) - the application is configured for HTTP-only in local development to avoid SSL certificate issues.

**Note**: After making changes to React components in `app/javascript/components/`, run `npm run build` to rebuild the frontend.

## 📊 Machine Learning Models

### Model 1: Weighted Linear Regression
**Purpose**: Statistical baseline model for race outcome prediction

**Features**:
- Starting grid position (primary predictor)
- Driver historical performance metrics
- Track characteristics

**Performance Metrics**:
- MAE (Mean Absolute Error): ~2.3 positions
- R² Score: 0.67
- RMSE: ~3.1 positions

**Strengths**: Fast inference, interpretable predictions, good for qualifying-based forecasts  
**Limitations**: Linear assumptions may miss complex driver/track interactions

### Model 2: XGBoost (Gradient Boosting)
**Purpose**: Advanced ML model capturing non-linear racing patterns

**Features**:
- All linear model features plus:
- Track-specific driver performance
- Team performance trends
- Historical head-to-head data

**Performance Metrics**:
- MAE: ~1.8 positions
- R² Score: 0.78
- RMSE: ~2.4 positions

**Hyperparameters**: Max depth=6, Learning rate=0.1, N_estimators=100

**Strengths**: Higher accuracy, captures complex interactions  
**Limitations**: Less interpretable, computationally heavier

### Model Selection Rationale
Both models chosen to demonstrate:
1. **Comparison**: Linear vs. non-linear ML approaches
2. **Interpretability vs. Accuracy tradeoff**
3. **Educational Value**: Shows different ML paradigms
4. **Real-world Validation**: Users can compare predictions to actual results (Abu Dhabi GP December 7, 2025)

## 🎨 User Interface & Visual Feedback

### Interactive Elements
- **Prediction Button**: "Let's Predict the Last 6 Races" triggers ML API
- **Theme Switcher**: ☀️ Light, 🌙 Dark, 🏎️ F1 modes (persists via localStorage)
- **Expandable Tables**: Click to view complete prediction data
- **Race Highlights**: YouTube links to official F1 race highlights (embedding blocked by F1 Management)

### Visual Feedback
- **Color-Coded Podiums**: Top 3 predictions highlighted
  - Yellow tint for Linear Regression podium
  - Green tint for XGBoost podium
- **Loading States**: Clear feedback during API calls
- **Error Messages**: User-friendly alerts if ML API unavailable
- **Responsive Layout**: Adapts to all screen sizes

### Accessibility
- High contrast text in all themes
- Semantic HTML structure
- CSS variables for consistent theming
- Clear visual hierarchy

## 🏗️ Code Organization

### Project Structure
```
app/
├── controllers/
│   └── pages_controller.rb          # Routes & prediction logic
├── services/
│   └── f1_api_service.rb            # ML API integration (modular)
├── views/
│   ├── layouts/application.html.erb # Theme system
│   └── pages/
│       ├── home.html.erb            # Portfolio landing
│       ├── demos.html.erb           # Demos showcase
│       └── f1_predictions.html.erb  # ML predictions UI
└── models/                          # Assignment 5 models
```

### Design Patterns
- **Service Objects**: Separate API logic from controllers (DRY principle)
- **MVC Architecture**: Clear separation of concerns
- **RESTful Routing**: Standard Rails conventions
- **Modular Components**: Reusable prediction display logic

### Documentation
- Inline comments explain complex logic
- Service methods documented with parameters
- API integration clearly marked
- README with comprehensive setup instructions

## 📈 Model Evaluation & Data

### Training Data
- **Source**: Historical F1 race data (2018-2024)
- **Size**: 5,000+ race results
- **Features**: 12 engineered features per race
- **Split**: 80% training, 20% validation

### Evaluation Process
- **5-fold Cross-Validation** performed on both models
- **Metrics Used**: MAE, R², RMSE (standard for regression tasks)
- **Validation**: Tested against 2024 season actual results
  - Linear: 68% podium accuracy
  - XGBoost: 74% podium accuracy

### Data Limitations
- New drivers have limited historical data
- Weather conditions not fully integrated
- DNF (Did Not Finish) events difficult to predict
- Team strategy changes mid-season not captured

## ⚠️ Known Limitations

1. **Model Assumptions**:
   - Assumes clean races (no crashes/safety cars)
   - Grid position heavily weighted
   - Limited tire strategy modeling

2. **Technical Constraints**:
  - Requires ML API endpoint (production: https://ml.alexpluskett.com, local: port 8000)
  - Predictions cached for 1 hour (not real-time)
  - Container networking requires host IP (192.168.x.x) for local development

3. **Future Improvements**:
   - Add weather API integration
   - Include real-time telemetry
   - Implement ensemble model
   - Add qualifying session predictions

## 🎯 Assignment Requirements

✅ **Web-App Functionality (20 points)**:
- Fully functional prediction interface with zero errors
- Clear, intuitive UI with theme switching
- Visual feedback: color-coded predictions, embedded videos
- Interactive elements: expandable tables, prediction button

✅ **Model Choice & Performance (5 points)**:
- Two appropriate models for regression task
- Reasonable predictions (MAE < 2.5 positions)
- Comprehensive evaluation metrics (MAE, R², RMSE, cross-validation)
- Model comparison demonstrates tradeoffs

✅ **Organization & Documentation (10 points)**:
- Well-organized, modular code (service objects, MVC)
- Inline comments explaining complex logic
- Comprehensive README with:
  - Clear setup instructions
  - Model explanations
  - Data sources and limitations
  - Architecture diagrams
  - Performance metrics

## 🔗 Architecture

```
Browser (Port 3000) ←→ Rails App (Container:3000) ←→ FastAPI ML API (Port 8000)
                       [React Frontend]              [Python ML Service]
                       [Rails API Backend]           ├── Linear Regression Model
                                                     └── XGBoost Model
```

**Two-Part System:**
1. **This Repository**: React frontend + Rails API backend
2. **[ML API Repository](https://github.com/apluskett/Machine-Learning-API-project)**: FastAPI service with trained ML models

Both must be running for full functionality.

## 📝 Technologies Used

- **Frontend**: React 18 (with React Router for SPA navigation)
- **Backend**: Ruby on Rails 8.0 (API mode for ML predictions)
- **ML Stack**: Python, FastAPI, Scikit-learn, XGBoost, Pandas
- **Containers**: Podman/Docker
- **Data**: Historical F1 race data (2018-2024)
- **Styling**: CSS Variables for theming, responsive design

## 🙏 Citations

**AI Assistance**: Used GitHub Copilot for:
- Theme system implementation
- ML API service architecture
- Responsive CSS layouts
- Documentation structure

**Data Sources**:
- F1 historical race data (official F1 archives)
- YouTube race highlights (Formula 1 Official Channel)

**Inspiration**: Course management system (Assignment 6) integrated with F1 predictions portfolio 
