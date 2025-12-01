import React from 'react';
import { Link } from 'react-router-dom';

function Home() {
  return (
    <div>
      <div className="hero-section" style={{
        textAlign: 'center',
        padding: '4rem 2rem',
        maxWidth: '900px',
        margin: '0 auto'
      }}>
        <h1 style={{
          fontSize: '3rem',
          marginBottom: '1rem',
          color: 'var(--text-primary)'
        }}>
          Welcome to My Portfolio
        </h1>
        <p style={{
          fontSize: '1.3rem',
          color: 'var(--text-secondary)',
          marginBottom: '2rem',
          lineHeight: 1.6
        }}>
          Hi! I'm a developer passionate about building innovative web applications and machine learning solutions.
          This site showcases my projects, demos, and technical work.
        </p>
        
        <div style={{
          display: 'flex',
          gap: '1.5rem',
          justifyContent: 'center',
          flexWrap: 'wrap',
          margin: '3rem 0'
        }}>
          <Link to="/demos" style={{
            padding: '1rem 2rem',
            background: '#007bff',
            color: 'white',
            textDecoration: 'none',
            borderRadius: '8px',
            fontWeight: 'bold',
            transition: 'background 0.3s'
          }}>
            View Demos
          </Link>
          
          <a href="https://github.com/apluskett/final-web-app-assignments" target="_blank" rel="noopener noreferrer" style={{
            padding: '1rem 2rem',
            background: '#333',
            color: 'white',
            textDecoration: 'none',
            borderRadius: '8px',
            fontWeight: 'bold',
            transition: 'background 0.3s'
          }}>
            GitHub
          </a>
          
          <a href="#projects" style={{
            padding: '1rem 2rem',
            border: '2px solid var(--link-color)',
            color: 'var(--link-color)',
            textDecoration: 'none',
            borderRadius: '8px',
            fontWeight: 'bold',
            transition: 'all 0.3s'
          }}>
            Projects
          </a>
        </div>
      </div>

      <div id="projects" style={{
        maxWidth: '1000px',
        margin: '4rem auto',
        padding: '0 2rem'
      }}>
        <h2 style={{
          fontSize: '2rem',
          marginBottom: '2rem',
          textAlign: 'center',
          color: 'var(--text-primary)'
        }}>
          Featured Projects
        </h2>
        
        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))',
          gap: '2rem'
        }}>
          <div style={{
            border: '1px solid var(--border-color)',
            borderRadius: '8px',
            padding: '1.5rem',
            background: 'var(--bg-secondary)'
          }}>
            <h3 style={{ marginTop: 0, color: '#E10600' }}>F1 Race Predictions</h3>
            <p style={{ color: 'var(--text-secondary)', lineHeight: 1.6 }}>
              Machine learning models predicting Formula 1 race outcomes using XGBoost and Linear Regression.
              Analyzes driver performance, grid positions, and track characteristics.
            </p>
            <Link to="/demos" style={{
              color: 'var(--link-color)',
              textDecoration: 'none',
              fontWeight: 'bold'
            }}>
              View Demo →
            </Link>
          </div>
          
          <div style={{
            border: '1px solid var(--border-color)',
            borderRadius: '8px',
            padding: '1.5rem',
            background: 'var(--bg-secondary)'
          }}>
            <h3 style={{ marginTop: 0, color: 'var(--text-primary)' }}>Employee Management System</h3>
            <p style={{ color: 'var(--text-secondary)', lineHeight: 1.6 }}>
              Full-stack Rails application with CRUD operations, search functionality, and relationship management 
              for employees, projects, offices, and managers.
            </p>
            <a href="/employees" style={{
              color: 'var(--link-color)',
              textDecoration: 'none',
              fontWeight: 'bold'
            }}>
              View System →
            </a>
          </div>
          
          <div style={{
            border: '1px solid var(--border-color)',
            borderRadius: '8px',
            padding: '1.5rem',
            background: 'var(--bg-secondary)'
          }}>
            <h3 style={{ marginTop: 0, color: 'var(--text-primary)' }}>More Coming Soon</h3>
            <p style={{ color: 'var(--text-secondary)', lineHeight: 1.6 }}>
              Currently working on additional projects involving cloud deployment, containerization, 
              and advanced machine learning applications.
            </p>
            <a href="https://github.com/apluskett" style={{
              color: 'var(--link-color)',
              textDecoration: 'none',
              fontWeight: 'bold'
            }}>
              Follow on GitHub →
            </a>
          </div>
        </div>
      </div>

      <div style={{
        textAlign: 'center',
        padding: '3rem 2rem',
        margin: '4rem auto',
        maxWidth: '800px',
        background: 'var(--bg-secondary)',
        borderRadius: '8px',
        border: '1px solid var(--border-color)'
      }}>
        <h2 style={{ marginTop: 0, color: 'var(--text-primary)' }}>About This Portfolio</h2>
        <p style={{ color: 'var(--text-secondary)', lineHeight: 1.6 }}>
          This site is built with Ruby on Rails and React, showcasing various projects, demos, and technical documentation.
          All source code and project details are available on my GitHub profile. Feel free to explore the demos
          and reach out if you'd like to collaborate!
        </p>
      </div>
    </div>
  );
}

export default Home;
