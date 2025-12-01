import React, { useState } from 'react';
import { Link } from 'react-router-dom';

function F1Predictions() {
  const [predictions, setPredictions] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const handlePredict = async () => {
    setLoading(true);
    setError(null);
    
    try {
      const response = await fetch('/api/f1_predictions/predict', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.content || ''
        }
      });
      
      if (!response.ok) {
        throw new Error('Failed to fetch predictions');
      }
      
      const data = await response.json();
      setPredictions(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ maxWidth: '1200px', margin: '2rem auto', padding: '0 2rem' }}>
      <div style={{ textAlign: 'center', marginBottom: '3rem' }}>
        <h1 style={{
          fontSize: '3rem',
          marginBottom: '0.5rem',
          color: 'var(--text-primary)'
        }}>
          🏎️ F1 Race Predictions
        </h1>
        <p style={{ fontSize: '1.2rem', color: 'var(--text-secondary)' }}>
          Machine Learning predictions for the last 6 races of the 2025 Formula 1 Season
        </p>
      </div>
      
      {!predictions ? (
        <>
          <div style={{
            textAlign: 'center',
            padding: '4rem 2rem',
            background: 'linear-gradient(135deg, #E10600 0%, #15151E 100%)',
            borderRadius: '12px',
            color: 'white'
          }}>
            <h2 style={{ fontSize: '2rem', marginBottom: '1rem' }}>
              Ready to See the Predictions?
            </h2>
            <p style={{
              fontSize: '1.1rem',
              marginBottom: '2rem',
              opacity: 0.9
            }}>
              Our ML models will predict the podium finishers for Abu Dhabi, Qatar, Las Vegas, São Paulo, Mexico City, and Austin.
            </p>
            <button
              onClick={handlePredict}
              disabled={loading}
              style={{
                padding: '1.5rem 3rem',
                fontSize: '1.2rem',
                background: 'var(--bg-primary)',
                color: '#E10600',
                border: '2px solid #E10600',
                borderRadius: '8px',
                fontWeight: 'bold',
                cursor: loading ? 'not-allowed' : 'pointer',
                transition: 'transform 0.3s, box-shadow 0.3s',
                opacity: loading ? 0.6 : 1
              }}
            >
              {loading ? 'Loading Predictions...' : "Let's Predict the Last 6 Races"}
            </button>
            {error && (
              <p style={{ color: '#ffcccc', marginTop: '1rem' }}>
                Error: {error}
              </p>
            )}
          </div>
          
          <div style={{
            marginTop: '3rem',
            padding: '2rem',
            background: 'var(--bg-secondary)',
            borderRadius: '8px',
            border: '1px solid var(--border-color)'
          }}>
            <h3 style={{ color: 'var(--text-primary)' }}>About the Models</h3>
            <div style={{
              display: 'grid',
              gridTemplateColumns: '1fr 1fr',
              gap: '2rem',
              marginTop: '1rem'
            }}>
              <div>
                <h4 style={{ color: '#E10600' }}>📊 Weighted Linear Regression</h4>
                <p style={{ color: 'var(--text-secondary)' }}>
                  A statistical model that learns from historical race data to predict finishing positions based on 
                  starting grid position, driver performance, and track characteristics.
                </p>
              </div>
              <div>
                <h4 style={{ color: '#E10600' }}>🤖 XGBoost</h4>
                <p style={{ color: 'var(--text-secondary)' }}>
                  An advanced gradient boosting algorithm that captures complex patterns in racing data, 
                  considering multiple factors and non-linear relationships.
                </p>
              </div>
            </div>
          </div>
        </>
      ) : (
        <>
          {predictions.map((result, index) => (
            <div key={index} style={{
              marginBottom: '4rem',
              border: '2px solid #E10600',
              borderRadius: '12px',
              overflow: 'hidden'
            }}>
              {/* Race Header */}
              <div style={{
                background: 'linear-gradient(135deg, #E10600 0%, #15151E 100%)',
                color: 'white',
                padding: '2rem'
              }}>
                <h1 style={{ margin: '0 0 0.5rem 0', fontSize: '2.5rem' }}>
                  {result.race.name}
                </h1>
                <p style={{ margin: 0, fontSize: '1.1rem', opacity: 0.9 }}>
                  {result.race.track} • {result.race.date} • Round {result.race.round}
                </p>
              </div>
              
              {/* Race Highlights */}
              <div style={{
                padding: '1.5rem 2rem',
                background: 'var(--bg-secondary)',
                color: 'var(--text-primary)'
              }}>
                <strong>Race Highlights:</strong> {result.race.highlights}
                
                {result.race.youtube_id && (
                  <div style={{
                    marginTop: '1rem',
                    padding: '1rem',
                    background: 'rgba(225, 6, 0, 0.1)',
                    borderLeft: '4px solid #E10600',
                    borderRadius: '4px'
                  }}>
                    <p style={{
                      margin: '0 0 0.5rem 0',
                      fontWeight: 'bold',
                      color: 'var(--text-primary)'
                    }}>
                      📺 Watch Race Highlights
                    </p>
                    <a
                      href={`https://www.youtube.com/watch?v=${result.race.youtube_id}`}
                      target="_blank"
                      rel="noopener noreferrer"
                      style={{
                        color: '#E10600',
                        textDecoration: 'none',
                        fontWeight: 'bold',
                        display: 'inline-flex',
                        alignItems: 'center',
                        gap: '0.5rem'
                      }}
                    >
                      View on YouTube →
                    </a>
                    <p style={{
                      margin: '0.5rem 0 0 0',
                      fontSize: '0.9rem',
                      color: 'var(--text-secondary)'
                    }}>
                      (F1 race highlights cannot be embedded but can be watched directly on YouTube)
                    </p>
                  </div>
                )}
              </div>
              
              {/* Podium Predictions */}
              <div style={{ padding: '2rem' }}>
                <h2 style={{ marginTop: 0, color: '#E10600' }}>🏆 Predicted Podium</h2>
                
                <div style={{
                  display: 'grid',
                  gridTemplateColumns: '1fr 1fr',
                  gap: '2rem',
                  marginBottom: '2rem'
                }}>
                  {/* Linear Model */}
                  <div style={{
                    border: '1px solid var(--border-color)',
                    borderRadius: '8px',
                    padding: '1.5rem',
                    background: 'var(--bg-secondary)'
                  }}>
                    <h3 style={{ marginTop: 0, color: '#007bff' }}>
                      📊 Linear Regression Model
                    </h3>
                    {result.predictions.linear.error ? (
                      <p style={{ color: '#dc3545' }}>{result.predictions.linear.error}</p>
                    ) : result.predictions.linear.predictions?.length > 0 ? (
                      <ol style={{ fontSize: '1.1rem', lineHeight: 2 }}>
                        {result.predictions.linear.predictions
                          .sort((a, b) => a.predicted_position - b.predicted_position)
                          .slice(0, 3)
                          .map((driver, idx) => (
                            <li key={idx} style={{ color: 'var(--text-primary)' }}>
                              <strong>{driver.driver}</strong> (Grid: {Math.floor(driver.grid)})
                            </li>
                          ))}
                      </ol>
                    ) : (
                      <p style={{ color: '#dc3545' }}>No predictions available</p>
                    )}
                  </div>
                  
                  {/* XGBoost Model */}
                  <div style={{
                    border: '1px solid var(--border-color)',
                    borderRadius: '8px',
                    padding: '1.5rem',
                    background: 'var(--bg-secondary)'
                  }}>
                    <h3 style={{ marginTop: 0, color: '#28a745' }}>
                      🤖 XGBoost Model
                    </h3>
                    {result.predictions.xgboost.error ? (
                      <p style={{ color: '#dc3545' }}>{result.predictions.xgboost.error}</p>
                    ) : result.predictions.xgboost.predictions?.length > 0 ? (
                      <ol style={{ fontSize: '1.1rem', lineHeight: 2 }}>
                        {result.predictions.xgboost.predictions
                          .sort((a, b) => a.predicted_position - b.predicted_position)
                          .slice(0, 3)
                          .map((driver, idx) => (
                            <li key={idx} style={{ color: 'var(--text-primary)' }}>
                              <strong>{driver.driver}</strong> (Grid: {Math.floor(driver.grid)})
                            </li>
                          ))}
                      </ol>
                    ) : (
                      <p style={{ color: '#dc3545' }}>No predictions available</p>
                    )}
                  </div>
                </div>
                
                {/* Full Predictions Table */}
                <details style={{ marginTop: '2rem' }}>
                  <summary style={{
                    cursor: 'pointer',
                    fontSize: '1.1rem',
                    fontWeight: 'bold',
                    color: '#E10600',
                    padding: '1rem',
                    background: 'var(--bg-secondary)',
                    borderRadius: '6px'
                  }}>
                    📋 View Complete Prediction Data (All Positions)
                  </summary>
                  
                  <div style={{ marginTop: '1rem', overflowX: 'auto' }}>
                    <h4 style={{ color: 'var(--text-primary)' }}>Linear Regression - All Predictions</h4>
                    {result.predictions.linear.predictions && (
                      <table style={{
                        width: '100%',
                        borderCollapse: 'collapse',
                        marginBottom: '2rem'
                      }}>
                        <thead>
                          <tr style={{ background: 'var(--bg-secondary)' }}>
                            <th style={{
                              padding: '0.75rem',
                              textAlign: 'left',
                              border: '1px solid var(--border-color)',
                              color: 'var(--text-primary)'
                            }}>Predicted Pos</th>
                            <th style={{
                              padding: '0.75rem',
                              textAlign: 'left',
                              border: '1px solid var(--border-color)',
                              color: 'var(--text-primary)'
                            }}>Driver</th>
                            <th style={{
                              padding: '0.75rem',
                              textAlign: 'left',
                              border: '1px solid var(--border-color)',
                              color: 'var(--text-primary)'
                            }}>Grid Position</th>
                            <th style={{
                              padding: '0.75rem',
                              textAlign: 'left',
                              border: '1px solid var(--border-color)',
                              color: 'var(--text-primary)'
                            }}>Predicted Score</th>
                          </tr>
                        </thead>
                        <tbody>
                          {result.predictions.linear.predictions
                            .sort((a, b) => a.predicted_position - b.predicted_position)
                            .map((driver, idx) => (
                              <tr
                                key={idx}
                                style={{
                                  background: idx < 3 ? 'rgba(255, 243, 205, 0.3)' : 'transparent',
                                  color: 'var(--text-primary)'
                                }}
                              >
                                <td style={{
                                  padding: '0.75rem',
                                  border: '1px solid var(--border-color)'
                                }}>{idx + 1}</td>
                                <td style={{
                                  padding: '0.75rem',
                                  border: '1px solid var(--border-color)'
                                }}>
                                  <strong>{driver.driver}</strong>
                                </td>
                                <td style={{
                                  padding: '0.75rem',
                                  border: '1px solid var(--border-color)'
                                }}>{Math.floor(driver.grid)}</td>
                                <td style={{
                                  padding: '0.75rem',
                                  border: '1px solid var(--border-color)'
                                }}>{driver.predicted_position.toFixed(2)}</td>
                              </tr>
                            ))}
                        </tbody>
                      </table>
                    )}
                    
                    <h4 style={{ color: 'var(--text-primary)' }}>XGBoost - All Predictions</h4>
                    {result.predictions.xgboost.predictions && (
                      <table style={{ width: '100%', borderCollapse: 'collapse' }}>
                        <thead>
                          <tr style={{ background: 'var(--bg-secondary)' }}>
                            <th style={{
                              padding: '0.75rem',
                              textAlign: 'left',
                              border: '1px solid var(--border-color)',
                              color: 'var(--text-primary)'
                            }}>Predicted Pos</th>
                            <th style={{
                              padding: '0.75rem',
                              textAlign: 'left',
                              border: '1px solid var(--border-color)',
                              color: 'var(--text-primary)'
                            }}>Driver</th>
                            <th style={{
                              padding: '0.75rem',
                              textAlign: 'left',
                              border: '1px solid var(--border-color)',
                              color: 'var(--text-primary)'
                            }}>Grid Position</th>
                            <th style={{
                              padding: '0.75rem',
                              textAlign: 'left',
                              border: '1px solid var(--border-color)',
                              color: 'var(--text-primary)'
                            }}>Predicted Score</th>
                          </tr>
                        </thead>
                        <tbody>
                          {result.predictions.xgboost.predictions
                            .sort((a, b) => a.predicted_position - b.predicted_position)
                            .map((driver, idx) => (
                              <tr
                                key={idx}
                                style={{
                                  background: idx < 3 ? 'rgba(212, 237, 218, 0.3)' : 'transparent',
                                  color: 'var(--text-primary)'
                                }}
                              >
                                <td style={{
                                  padding: '0.75rem',
                                  border: '1px solid var(--border-color)'
                                }}>{idx + 1}</td>
                                <td style={{
                                  padding: '0.75rem',
                                  border: '1px solid var(--border-color)'
                                }}>
                                  <strong>{driver.driver}</strong>
                                </td>
                                <td style={{
                                  padding: '0.75rem',
                                  border: '1px solid var(--border-color)'
                                }}>{Math.floor(driver.grid)}</td>
                                <td style={{
                                  padding: '0.75rem',
                                  border: '1px solid var(--border-color)'
                                }}>{driver.predicted_position.toFixed(2)}</td>
                              </tr>
                            ))}
                        </tbody>
                      </table>
                    )}
                  </div>
                </details>
              </div>
            </div>
          ))}
          
          <div style={{ textAlign: 'center', marginTop: '3rem' }}>
            <button
              onClick={handlePredict}
              style={{
                padding: '1rem 2rem',
                background: '#E10600',
                color: 'white',
                border: 'none',
                borderRadius: '6px',
                fontWeight: 'bold',
                cursor: 'pointer',
                marginRight: '1rem'
              }}
            >
              Run Predictions Again
            </button>
            <Link
              to="/demos"
              style={{
                padding: '1rem 2rem',
                border: '2px solid #E10600',
                color: '#E10600',
                textDecoration: 'none',
                borderRadius: '6px',
                fontWeight: 'bold',
                display: 'inline-block'
              }}
            >
              ← Back to Demos
            </Link>
          </div>
        </>
      )}
    </div>
  );
}

export default F1Predictions;
