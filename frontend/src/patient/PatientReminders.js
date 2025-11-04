import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  ArrowLeft,
  Pill,
  ClipboardCheck,
  CalendarDays,
  CheckCircle2,
  Clock4,
  XCircle,
  BellRing,
  Plus,
  X,
} from "lucide-react";
import styles from "./PatientReminders.module.css";

export default function PatientReminders() {
  const navigate = useNavigate();
  const [showForm, setShowForm] = useState(false);
  const goBack = () => navigate(-1);

  const openForm = () => setShowForm(true);
  const closeForm = () => setShowForm(false);

  const reminders = [
    // {
    //   id: 1,
    //   type: "Medication",
    //   title: "Take Metoprolol (50mg)",
    //   time: "8:00 PM",
    //   status: "upcoming",
    //   persona: "Elderly Patient",
    //   message:
    //     "It’s time for your evening medication — Metoprolol 50mg. Take it with a sip of water and unwind for the night 🌙",
    // },
    // {
    //   id: 2,
    //   type: "Task",
    //   title: "Check blood pressure",
    //   time: "8:15 PM",
    //   status: "active",
    //   persona: "Elderly Patient",
    //   message:
    //     "Please measure your blood pressure and log it in the app when ready. You’re doing great — steady progress every day 💗",
    // },
    // {
    //   id: 3,
    //   type: "Appointment",
    //   title: "Doctor Visit: Dr. Kim (Cardiology)",
    //   time: "10:30 AM",
    //   status: "past",
    //   outcome: "completed",
    //   persona: "Elderly Patient",
    //   message:
    //     "Hope your appointment with Dr. Kim went well! You can record your visit notes or upload your summary anytime 🩺",
    // },
    // {
    //   id: 4,
    //   type: "Medication",
    //   title: "Take Atorvastatin (20mg)",
    //   time: "7:30 AM",
    //   status: "past",
    //   outcome: "snoozed",
    //   persona: "Elderly Patient",
    //   message:
    //     "Don’t forget your morning medication — Atorvastatin 20mg. You’ve snoozed this one before, so be sure to take it soon 💊",
    // },
  ];  

  const renderIcon = (type) => {
    switch (type) {
      case "Medication":
        return (
          <div className={styles.iconCirclePurple}>
            <Pill size={18} />
          </div>
        );
      case "Task":
        return (
          <div className={styles.iconCircleBlue}>
            <ClipboardCheck size={18} />
          </div>
        );
      case "Appointment":
        return (
          <div className={styles.iconCircleGreen}>
            <CalendarDays size={18} />
          </div>
        );
      default:
        return (
          <div className={styles.iconCirclePurple}>
            <BellRing size={18} />
          </div>
        );
    }
  };

  const renderStatus = (reminder) => {
    const outcome = reminder.outcome || reminder.status;
    switch (outcome) {
      case "completed":
        return (
          <span className={styles.statusCompleted}>
            <CheckCircle2 size={16} /> Completed
          </span>
        );
      case "snoozed":
        return (
          <span className={styles.statusSnoozed}>
            <Clock4 size={16} /> Snoozed
          </span>
        );
      case "missed":
      case "skipped":
        return (
          <span className={styles.statusMissed}>
            <XCircle size={16} /> Skipped
          </span>
        );
      case "active":
        return (
          <span className={styles.statusActive}>
            <BellRing size={16} /> Due Now
          </span>
        );
      case "upcoming":
        return (
          <span className={styles.statusUpcoming}>
            <Clock4 size={16} /> Upcoming
          </span>
        );
      default:
        return null;
    }
  };

  const sections = {
    Active: reminders.filter((r) => r.status === "active"),
    Upcoming: reminders.filter((r) => r.status === "upcoming"),
    Past: reminders.filter((r) => r.status === "past"),
  };

  const STATUS_LABELS = {
    active: "Today",
    upcoming: "Upcoming",
    past: "Past",
  };  

  return (
    <div className={`${styles.container} ${styles.purpleGradient}`}>
      {/* Header */}
      <header className={styles.header}>
        <div className={styles.headerContent}>
          <button className={styles.backButton} onClick={goBack}>
            <ArrowLeft size={20} />
          </button>
          <div className={styles.headerText}>
            <h1 className={styles.headerTitle}>Reminders</h1>
            <p className={styles.headerSubtitle}>
              View and track your upcoming medications, tasks, and appointments.
            </p>
          </div>
          <button className={styles.newReminderButton} onClick={openForm}>
            <Plus size={16} />
            New Reminder
          </button>
        </div>
      </header>

      {/* Content */}
      <div className={styles.content}>
        {/* Overview Section */}
        <div className={styles.overviewCard}>
          <div className={styles.overviewHeader}>
            <h2>Reminders Overview</h2>
            <p>Quick snapshot of your reminders</p>
          </div>

          <div className={styles.overviewGrid}>
            <div className={styles.overviewStat}>
              <span className={styles.statNumber}>{reminders.length}</span>
              <span className={styles.statLabel}>Total</span>
            </div>
            <div className={styles.overviewStat}>
              <span className={styles.statNumber}>{sections.Active.length}</span>
              <span className={styles.statLabel}>Active Today</span>
            </div>
            <div className={styles.overviewStat}>
              <span className={styles.statNumber}>{sections.Upcoming.length}</span>
              <span className={styles.statLabel}>Upcoming</span>
            </div>
            <div className={styles.overviewStat}>
              <span className={styles.statNumber}>{sections.Past.length}</span>
              <span className={styles.statLabel}>Past</span>
            </div>
          </div>
        </div>

        {Object.entries(sections).map(([label, group]) => (
          <div key={label} className={styles.card}>
            <div className={styles.cardHeader}>
              <h2>{STATUS_LABELS[label.toLowerCase()] || label}</h2>
            </div>
            {group.length === 0 ? (
              <p className={styles.subtext}>No {label.toLowerCase()} reminders.</p>
            ) : (
              <div className={styles.reminderList}>
                {group.map((reminder) => (
                  <div key={reminder.id} className={styles.reminderItem}>
                    <div className={styles.reminderHeader}>
                      {renderIcon(reminder.type)}
                      <div>
                        <h3>{reminder.title}</h3>
                        <p className={styles.personaTag}>{reminder.type} Reminder</p>
                        <p className={styles.reminderMessage}>{reminder.message}</p>
                      </div>
                    </div>
                    <div className={styles.reminderMeta}>
                        <span className={styles.time}>{reminder.time}</span>
                        {renderStatus(reminder)}

                        {reminder.status === "active" && (
                            <div className={styles.reminderActions}>
                            <button className={styles.snoozeButton}>Snooze</button>
                            <button className={styles.stopButton}>Mark as Completed</button>
                            </div>
                        )}
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        ))}
      </div>

      {/* Overlay Form */}
      {showForm && (
        <div className={styles.overlay}>
          <div className={styles.formModal}>
            <div className={styles.formHeader}>
              <h2>Create New Reminder</h2>
              <button className={styles.closeButton} onClick={closeForm}>
                <X size={18} />
              </button>
            </div>
            <p className={styles.formSubtitle}>
              Set up a reminder for medications, appointments, or health activities.
            </p>

            <form className={styles.formBody}>
              <label>
                Title
                <input
                  type="text"
                  placeholder="e.g., Take morning medication"
                />
              </label>

              <label>
                Select type
                <select>
                  <option value="">Choose a type</option>
                  <option value="Medication">Medication Reminder</option>
                  <option value="Task">Task Reminder</option>
                  <option value="Appointment">Appointment Reminder</option>
                </select>
              </label>

              <label>
                Select time
                <input type="time" />
              </label>

              <label>
                Select frequency
                <select>
                  <option>Once</option>
                  <option>Daily</option>
                  <option>Weekly</option>
                  <option>Monthly</option>
                </select>
              </label>

              <label>
                Additional notes...
                <textarea placeholder="Add any special instructions or context" />
              </label>

              <div className={styles.formActions}>
                <button
                  type="button"
                  className={styles.cancelButton}
                  onClick={closeForm}
                >
                  Cancel
                </button>
                <button type="button" className={styles.createButton}>
                  Create Reminder
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
