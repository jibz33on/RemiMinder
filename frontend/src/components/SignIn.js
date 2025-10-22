import React, { useState, useEffect } from "react";
import { Auth } from "@supabase/auth-ui-react";
import { ThemeSupa } from "@supabase/auth-ui-shared";
import { supabase } from "../supabaseClient";
import styles from "./PatientRegistration.module.css";
import { FcGoogle } from "react-icons/fc";
import { AiOutlineMail } from "react-icons/ai";
import { FaApple, FaTimes } from "react-icons/fa";
import { useNavigate } from "react-router-dom";

export default function PatientSignIn() {
  const navigate = useNavigate();
  const [showEmailForm, setShowEmailForm] = useState(false);
  const [showAppleModal, setShowAppleModal] = useState(false);
  const [showForgotModal, setShowForgotModal] = useState(false);
  const [resetEmail, setResetEmail] = useState("");
  const [resetMessage, setResetMessage] = useState("");

  // --- Redirect if already signed in ---
  useEffect(() => {
    const checkSession = async () => {
      const { data: { session } } = await supabase.auth.getSession();
      if (session?.user) navigate("/dashboard/patient");
    };
    checkSession();

    const { data: listener } = supabase.auth.onAuthStateChange((_event, session) => {
      if (session?.user) navigate("/dashboard/patient");
    });
    return () => listener.subscription.unsubscribe();
  }, [navigate]);

  // --- Google Sign In ---
  const handleGoogleSignIn = async () => {
    try {
      const { error } = await supabase.auth.signInWithOAuth({
        provider: "google",
        options: { redirectTo: `${window.location.origin}/dashboard/patient` },
      });
      if (error) throw error;
    } catch (err) {
      console.error("Google sign-in error:", err.message);
      alert("Failed to sign in with Google. Please try again.");
    }
  };

  return (
    <div className={styles.container}>
      <header className={styles.header}>
        <div className="logo" style={{ cursor: "pointer" }} onClick={() => navigate("/")}>
          RemeMinderAI
        </div>
      </header>

      <main className={styles.main}>
        <div className={styles.card}>
          <h1 className={styles.title}>Sign In</h1>
          <p className={styles.subtitle}>Choose your preferred sign-in method</p>

          {!showEmailForm ? (
            <div className={styles.buttonGroup}>
              <button
                className={`${styles.signUpButton} ${styles.emailButton}`}
                onClick={() => setShowEmailForm(true)}
              >
                <AiOutlineMail size={18} />
                Sign in with Email
              </button>
              <button
                className={`${styles.signUpButton} ${styles.googleButton}`}
                onClick={handleGoogleSignIn}
              >
                <FcGoogle size={18} />
                Sign in with Google
              </button>
              <button
                className={`${styles.signUpButton} ${styles.appleButton}`}
                onClick={() => setShowAppleModal(true)}
              >
                <FaApple size={18} />
                Sign in with Apple
              </button>
            </div>
          ) : (
            <div className={styles.formCard}>
              <Auth
                supabaseClient={supabase}
                appearance={{
                  theme: ThemeSupa,
                  style: { button: { borderRadius: "8px", fontWeight: "600" }, input: { borderRadius: "8px" } },
                }}
                theme="light"
                providers={[]} // only email/password
                view="sign_in"
              />
              <button onClick={() => setShowEmailForm(false)} className={styles.backButton}>
                Back
              </button>
            </div>
          )}
        </div>
      </main>

      {/* --- Apple Modal --- */}
      {showAppleModal && (
        <div className={styles.modalOverlay}>
          <div className={styles.modalCard}>
            <button className={styles.modalClose} onClick={() => setShowAppleModal(false)}>
              <FaTimes size={14} />
            </button>
            <h2 className={styles.modalTitle}>Coming Soon 🍎</h2>
            <p className={styles.modalText}>
              Apple sign-in isn’t available yet. Please try Google or Email for now.
            </p>
            <button onClick={() => setShowAppleModal(false)} className={styles.modalButton}>
              Got it
            </button>
          </div>
        </div>
      )}

      {/* --- Forgot Password Modal --- */}
      {showForgotModal && (
        <div className={styles.modalOverlay}>
          <div className={styles.modalCard}>
            <button className={styles.modalClose} onClick={() => setShowForgotModal(false)}>
              <FaTimes size={14} />
            </button>
            <h2 className={styles.modalTitle}>Reset Password</h2>
            <p>Enter your email to receive a password reset link:</p>
            <input
              type="email"
              placeholder="you@example.com"
              value={resetEmail}
              onChange={(e) => setResetEmail(e.target.value)}
              className={styles.input}
            />
            <button
              className={styles.modalButton}
              onClick={async () => {
                const { error } = await supabase.auth.resetPasswordForEmail(resetEmail, {
                  redirectTo: `${window.location.origin}/sign-in`,
                });
                if (error) setResetMessage(error.message);
                else setResetMessage("Check your email for the reset link!");
              }}
            >
              Send Reset Link
            </button>
            {resetMessage && <p>{resetMessage}</p>}
          </div>
        </div>
      )}
    </div>
  );
}
