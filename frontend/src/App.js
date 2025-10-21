import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

// Import your pages
import LandingPage from './components/LandingPage'; 
import RecordVisitPage from './components/AudioRecorder.js';

function App() {
  return (
    <Router>
      <Routes>
        {/* This route shows your landing page at the root URL */}
        <Route path="/" element={<LandingPage />} />
        
        {/* This NEW route shows your record page at /record */}
        <Route path="/record" element={<RecordVisitPage />} />
        
        {/* You will add other routes here later, e.g.: */}
        {/* <Route path="/login" element={<LoginPage />} /> */}
        {/* <Route path="/dashboard" element={<DashboardPage />} /> */}
      </Routes>
    </Router>
  );
}

export default App;
