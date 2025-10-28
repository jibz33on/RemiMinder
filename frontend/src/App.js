import './App.css';
import LandingPage from './components/LandingPage';
import SignIn from './components/SignIn';
import PatientRegistration from './components/PatientRegistration';
import SignUpConfirmation from './components/SignUpConfirmation';
import PatientConsent from './components/PatientConsent';
import PatientProfileSetup from './components/PatientProfileSetup';
import PatientAudioSetup from './components/PatientAudioSetup';
import PatientDashboard from './components/PatientDashboard';
import PatientReminders from './components/PatientReminders';
import PatientSettings from "./components/PatientSettings";
import CaregiverDashboard from './components/CaregiverDashboard';
import CaregiverSettings from "./components/CaregiverSettings";
import { BrowserRouter, Routes, Route } from "react-router-dom";

function App() {
  return (
    <div className="App">
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<LandingPage />} />
          <Route path="/signin" element={<SignIn />} />
          <Route path="/register/patient" element={<PatientRegistration />} />
          <Route path="/signup-confirmation" element={<SignUpConfirmation />} />
          <Route path="/consent/patient" element={<PatientConsent />} />
          <Route path="/profile/patient" element={<PatientProfileSetup />} />
          <Route path="/audio" element={<PatientAudioSetup />} />
          <Route path="/dashboard/patient" element={<PatientDashboard />} />
          <Route path="/patient/reminders" element={<PatientReminders />} />
          <Route path="/patient/settings" element={<PatientSettings />} />
          <Route path="/dashboard/caregiver" element={<CaregiverDashboard />} />
          <Route path="/caregiver/settings" element={<CaregiverSettings />} />
        </Routes>
    </BrowserRouter>
    </div>
  );
}

export default App;