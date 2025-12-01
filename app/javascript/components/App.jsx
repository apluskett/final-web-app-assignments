import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import { ThemeProvider, useTheme } from './ThemeContext';
import Home from './Home';
import Demos from './Demos';
import F1Predictions from './F1Predictions';
import './App.css';

function Navigation() {
  const { theme, setTheme } = useTheme();
  
  return (
    <header style={{
      background: 'var(--bg-secondary)',
      borderBottom: '2px solid var(--border-color)',
      padding: '1rem 2rem',
      marginBottom: '2rem'
    }}>
      <nav style={{
        maxWidth: '1200px',
        margin: '0 auto',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        flexWrap: 'wrap',
        gap: '1rem'
      }}>
        <div style={{ display: 'flex', gap: '2rem', alignItems: 'center' }}>
          <Link to="/" style={{
            fontSize: '1.5rem',
            fontWeight: 'bold',
            textDecoration: 'none',
            color: 'var(--text-primary)'
          }}>
            Alex Pluskett
          </Link>
          <ul style={{
            listStyle: 'none',
            display: 'flex',
            gap: '1.5rem',
            padding: 0,
            margin: 0
          }}>
            <li><Link to="/" style={{ textDecoration: 'none', fontWeight: 500, color: 'var(--link-color)' }}>Home</Link></li>
            <li><Link to="/demos" style={{ textDecoration: 'none', fontWeight: 500, color: 'var(--link-color)' }}>Demos</Link></li>
            <li><a href="/employees" style={{ textDecoration: 'none', fontWeight: 500, color: 'var(--link-color)' }}>Employees</a></li>
          </ul>
        </div>
        
        <div className="theme-switcher" style={{ display: 'flex', gap: '0.5rem', alignItems: 'center' }}>
          <span style={{ fontSize: '0.9rem', color: 'var(--text-secondary)' }}>Theme:</span>
          <button
            className={`theme-btn ${theme === 'light' ? 'active' : ''}`}
            onClick={() => setTheme('light')}
          >
            ☀️ Light
          </button>
          <button
            className={`theme-btn ${theme === 'dark' ? 'active' : ''}`}
            onClick={() => setTheme('dark')}
          >
            🌙 Dark
          </button>
          <button
            className={`theme-btn ${theme === 'f1' ? 'active' : ''}`}
            onClick={() => setTheme('f1')}
          >
            🏎️ F1
          </button>
        </div>
      </nav>
    </header>
  );
}

function Footer() {
  return (
    <footer style={{
      background: 'var(--bg-secondary)',
      borderTop: '2px solid var(--border-color)',
      padding: '2rem',
      marginTop: '4rem',
      textAlign: 'center'
    }}>
      <p style={{ color: 'var(--text-secondary)', margin: 0 }}>
        Built with Ruby on Rails & React • <a href="https://github.com/apluskett/final-web-app-assignments" target="_blank" rel="noopener noreferrer" style={{ color: 'var(--link-color)' }}>View on GitHub</a>
      </p>
    </footer>
  );
}

function App() {
  return (
    <ThemeProvider>
      <Router>
        <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
          <Navigation />
          <main style={{ flex: 1 }}>
            <Routes>
              <Route path="/" element={<Home />} />
              <Route path="/demos" element={<Demos />} />
              <Route path="/f1_predictions" element={<F1Predictions />} />
            </Routes>
          </main>
          <Footer />
        </div>
      </Router>
    </ThemeProvider>
  );
}

export default App;
