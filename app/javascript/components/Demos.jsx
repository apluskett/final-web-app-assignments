import React from 'react';
import { Link } from 'react-router-dom';

function Demos() {
  return (
    <div style={{ maxWidth: '1000px', margin: '2rem auto', padding: '0 2rem' }}>
      <h1 style={{
        fontSize: '2.5rem',
        marginBottom: '1rem',
        color: 'var(--text-primary)'
      }}>
        Project Demos
      </h1>
      <p style={{
        fontSize: '1.1rem',
        color: 'var(--text-secondary)',
        marginBottom: '3rem'
      }}>
        Explore interactive demonstrations of my projects. Each demo showcases different technologies and problem-solving approaches.
      </p>
      
      <div style={{ display: 'grid', gap: '2rem' }}>
        {/* F1 Predictions Demo */}
        <div style={{
          border: '2px solid #E10600',
          borderRadius: '12px',
          padding: '2rem',
          background: 'var(--bg-secondary)',
          transition: 'transform 0.3s, box-shadow 0.3s'
        }}>
          <div style={{ display: 'flex', alignItems: 'start', gap: '1.5rem' }}>
            <div style={{ fontSize: '3rem' }}>🏎️</div>
            <div style={{ flex: 1 }}>
              <h2 style={{ margin: '0 0 0.5rem 0', color: '#E10600' }}>
                F1 Race Predictions
              </h2>
              <p style={{
                color: 'var(--text-secondary)',
                lineHeight: 1.6,
                marginBottom: '1rem'
              }}>
                Machine learning models that predict Formula 1 race outcomes for the last 6 races of the 2025 season.
                Uses two different ML approaches: Weighted Linear Regression and XGBoost to analyze driver performance,
                grid positions, and track characteristics.
              </p>
              <div style={{
                background: 'var(--bg-primary)',
                padding: '1rem',
                borderRadius: '6px',
                marginBottom: '1rem',
                border: '1px solid var(--border-color)'
              }}>
                <strong style={{ color: 'var(--text-primary)' }}>Technologies:</strong>{' '}
                <span style={{ color: 'var(--text-secondary)' }}>
                  FastAPI, Python, Scikit-learn, XGBoost, Pandas, Rails API Integration
                </span>
              </div>
              <Link to="/f1_predictions" style={{
                display: 'inline-block',
                padding: '0.75rem 2rem',
                background: '#E10600',
                color: 'white',
                textDecoration: 'none',
                borderRadius: '6px',
                fontWeight: 'bold',
                transition: 'background 0.3s'
              }}>
                Launch F1 Demo →
              </Link>
            </div>
          </div>
        </div>
        
        {/* Employee Management Demo */}
        <div style={{
          border: '2px solid #007bff',
          borderRadius: '12px',
          padding: '2rem',
          background: 'var(--bg-secondary)'
        }}>
          <div style={{ display: 'flex', alignItems: 'start', gap: '1.5rem' }}>
            <div style={{ fontSize: '3rem' }}>👥</div>
            <div style={{ flex: 1 }}>
              <h2 style={{ margin: '0 0 0.5rem 0', color: '#007bff' }}>
                Employee Management System
              </h2>
              <p style={{
                color: 'var(--text-secondary)',
                lineHeight: 1.6,
                marginBottom: '1rem'
              }}>
                Full-featured CRUD application for managing employees, projects, offices, and office managers.
                Includes advanced search functionality, relationship management, and data validation.
              </p>
              <div style={{
                background: 'var(--bg-primary)',
                padding: '1rem',
                borderRadius: '6px',
                marginBottom: '1rem',
                border: '1px solid var(--border-color)'
              }}>
                <strong style={{ color: 'var(--text-primary)' }}>Technologies:</strong>{' '}
                <span style={{ color: 'var(--text-secondary)' }}>
                  Ruby on Rails 8, SQLite, Turbo, Stimulus, RESTful API
                </span>
              </div>
              <a href="/employees" style={{
                display: 'inline-block',
                padding: '0.75rem 2rem',
                background: '#007bff',
                color: 'white',
                textDecoration: 'none',
                borderRadius: '6px',
                fontWeight: 'bold',
                transition: 'background 0.3s'
              }}>
                Launch Employee Demo →
              </a>
            </div>
          </div>
        </div>
        
        {/* Coming Soon */}
        <div style={{
          border: '2px solid var(--border-color)',
          borderRadius: '12px',
          padding: '2rem',
          background: 'var(--bg-secondary)'
        }}>
          <div style={{ display: 'flex', alignItems: 'start', gap: '1.5rem' }}>
            <div style={{ fontSize: '3rem' }}>🚀</div>
            <div style={{ flex: 1 }}>
              <h2 style={{ margin: '0 0 0.5rem 0', color: 'var(--text-secondary)' }}>
                More Demos Coming Soon
              </h2>
              <p style={{
                color: 'var(--text-secondary)',
                lineHeight: 1.6,
                marginBottom: '1rem'
              }}>
                Working on additional demos including containerized microservices, real-time data visualization,
                and cloud-deployed applications. Check back soon!
              </p>
            </div>
          </div>
        </div>
      </div>
      
      <div style={{
        marginTop: '3rem',
        padding: '2rem',
        background: 'var(--bg-secondary)',
        borderRadius: '8px',
        textAlign: 'center',
        border: '1px solid var(--border-color)'
      }}>
        <Link to="/" style={{
          color: 'var(--link-color)',
          textDecoration: 'none',
          fontWeight: 'bold'
        }}>
          ← Back to Home
        </Link>
      </div>
    </div>
  );
}

export default Demos;
