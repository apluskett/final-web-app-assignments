import React from 'react';
import { createRoot } from 'react-dom/client';
import { BrowserRouter as Router } from 'react-router-dom';
import App from './components/App';

console.log('JavaScript loaded');

document.addEventListener('DOMContentLoaded', () => {
  console.log('DOM loaded');
  const rootElement = document.getElementById('root');
  console.log('Root element:', rootElement);
  if (rootElement) {
    console.log('Creating React root');
    const root = createRoot(rootElement);
    root.render(<App />);
    console.log('React app rendered');
  } else {
    console.error('Root element not found!');
  }
});
