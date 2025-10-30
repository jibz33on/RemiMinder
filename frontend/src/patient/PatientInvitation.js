import React, { useState } from "react";
import { ArrowLeft, Mail, Send, Check, Phone } from "lucide-react";
import styles from "./PatientInvitation.module.css";
import { useNavigate } from "react-router-dom";

export default function PatientInvitation({ onBack }) {
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState("");
  const [message, setMessage] = useState("");
  const [sent, setSent] = useState(false);
  const navigate = useNavigate();

  const handleSendInvite = () => {
    if (!email && !phone) {
    //   window.alert("Please provide an email or phone number.");
      return;
    }

    setSent(true);
    // window.alert("Invitation sent successfully!");
  };

  const handleBack = () => {
    navigate("/dashboard/patient");
  };

  if (sent) {
    return (
      <div className={styles.page}>
        <div className={styles.header}>
            <div className={styles.headerInner}>
                <button className={styles.backButton} onClick={handleBack}>
                <ArrowLeft size={20} />
                </button>
                <div className={styles.headerText}>
                    <h2>Invite Caregiver</h2>
                    <p className={styles.subtitle}>Share your health information with someone you trust</p>
                </div>
            </div>
        </div>

        <main className={styles.main}>
          <div className={styles.card}>
            <div className={styles.sentContainer}>
              <div className={styles.iconCircle}>
                <Check size={48} className={styles.checkIcon} />
              </div>
              <h2>Invitation Sent!</h2>
              <p>We’ve sent a secure invitation to {email || phone}.</p>

              <div className={styles.infoBox}>
                <p>
                  Your caregiver will receive an email with instructions to
                  create their account and access your health information.
                  You can manage their access anytime from your settings.
                </p>
              </div>

              <div className={styles.buttonRow}>
                <button
                  className={`${styles.button} ${styles.outline}`}
                  onClick={() => setSent(false)}
                >
                  Send Another
                </button>
                <button className={styles.button} onClick={handleBack}>
                  Back to Dashboard
                </button>
              </div>
            </div>
          </div>
        </main>
      </div>
    );
  }

  return (
    <div className={styles.page}>
        <div className={styles.header}>
            <div className={styles.headerInner}>
                <button className={styles.backButton} onClick={handleBack}>
                <ArrowLeft size={20} />
                </button>
                <div className={styles.headerText}>
                    <h2>Invite Caregiver</h2>
                    <p className={styles.subtitle}>Share your health information with someone you trust</p>
                </div>
            </div>
        </div>

      <main className={styles.main}>
        <div className={styles.card}>
          <label>Email Address *</label>
          <div className={styles.inputGroup}>
            <Mail size={18} className={styles.inputIcon} />
            <input
              type="email"
              placeholder="caregiver@example.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
          </div>
          
          <label>Phone Number (Optional)</label>
          <div className={styles.inputGroup}>
            <Phone size={18} className={styles.inputIcon} />
            <input
                type="tel"
                placeholder="+1 (555) 000-0000"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
            />
          </div>
          <p className={styles.hint}>
            We'll send an SMS invitation as well
          </p>

          <label>Personal Message (Optional)</label>
          <textarea
            rows="4"
            placeholder="I'd like to share my health information with you..."
            value={message}
            onChange={(e) => setMessage(e.target.value)}
          />
        </div>

        <div className={styles.card}>
          <h3>What Your Caregiver Will See</h3>
          <ul className={styles.list}>
            <li>All visit summaries and recordings</li>
            <li>Your health notes and medications</li>
            <li>Upcoming appointments and reminders</li>
          </ul>

          <div className={styles.warningBox}>
            You can revoke access at any time from your caregiver
            management settings.
          </div>
        </div>

        <div className={styles.buttonRow}>
          <button
            className={`${styles.button} ${styles.outline}`}
            onClick={handleBack}
          >
            Cancel
          </button>
          <button className={styles.button} onClick={handleSendInvite}>
            <Send size={16} style={{ marginRight: "6px" }} />
            Send Invitation
          </button>
        </div>
      </main>
    </div>
  );
}
