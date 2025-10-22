import React, { useState, useEffect } from "react";
import { Auth } from "@supabase/auth-ui-react";
import { ThemeSupa } from "@supabase/auth-ui-shared";
import { supabase } from "../supabaseClient";
import styles from "./PatientRegistration.module.css";
import { FcGoogle } from "react-icons/fc";
import { AiOutlineMail } from "react-icons/ai";
import { FaApple, FaTimes } from "react-icons/fa";
import { useNavigate } from "react-router-dom";

export default function PatientRegistration() {
  const navigate = useNavigate();

  const [showEmailForm, setShowEmailForm] = useState(false);
  const [showAppleModal, setShowAppleModal] = useState(false);

  // --- Handle session and redirect after email verification ---
  useEffect(() => {
    const checkSession = async () => {
      const { data: { session } } = await supabase.auth.getSession();

      if (session?.user) {
        const user = session.user;
        // Check if the email is verified (depends on provider)
        if (user.email_confirmed_at || user.identities?.length > 0) {
          navigate("/consent");
        }
      }
    };
    checkSession();

    const { data: listener } = supabase.auth.onAuthStateChange((_event, session) => {
      if (session?.user) navigate("/consent");
    });

    return () => listener.subscription.unsubscribe();
  }, [navigate]);

  // --- Google Sign Up ---
  const handleGoogleSignUp = async () => {
    try {
      const { error } = await supabase.auth.signInWithOAuth({
        provider: "google",
        options: {
          redirectTo: `${window.location.origin}/consent`,
        },
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
        <div
          className="logo"
          style={{ cursor: "pointer" }}
          onClick={() => navigate("/")}
        >
          RemeMinderAI
        </div>
      </header>

      <main className={styles.main}>
        <div className={styles.card}>
          <h1 className={styles.title}>Create Patient Account</h1>
          <p className={styles.subtitle}>Choose your preferred sign-up method</p>

          {!showEmailForm ? (
            <div className={styles.buttonGroup}>
              <button
                className={`${styles.signUpButton} ${styles.emailButton}`}
                onClick={() => setShowEmailForm(true)}
              >
                <AiOutlineMail size={18} />
                Sign up with Email
              </button>
              <button
                className={`${styles.signUpButton} ${styles.googleButton}`}
                onClick={handleGoogleSignUp}
              >
                <FcGoogle size={18} />
                Sign up with Google
              </button>
              <button
                className={`${styles.signUpButton} ${styles.appleButton}`}
                onClick={() => setShowAppleModal(true)}
              >
                <FaApple size={18} />
                Sign up with Apple
              </button>
            </div>
          ) : (
            <div className={styles.formCard}>
              <Auth
                supabaseClient={supabase}
                appearance={{
                  theme: ThemeSupa,
                  style: {
                    button: { borderRadius: "8px", fontWeight: "600" },
                    input: { borderRadius: "8px" },
                  },
                }}
                theme="light"
                providers={[]}
                view="sign_up"
              />
              <button
                onClick={() => setShowEmailForm(false)}
                className={styles.backButton}
              >
                Back
              </button>
            </div>
          )}
        </div>
      </main>

      {showAppleModal && (
        <div className={styles.modalOverlay}>
          <div className={styles.modalCard}>
            <button
              className={styles.modalClose}
              onClick={() => setShowAppleModal(false)}
            >
              <FaTimes size={14} />
            </button>
            <h2 className={styles.modalTitle}>Coming Soon 🍎</h2>
            <p className={styles.modalText}>
              Apple sign-in isn’t available yet. Please try Google or Email for
              now.
            </p>
            <button
              onClick={() => setShowAppleModal(false)}
              className={styles.modalButton}
            >
              Got it
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
