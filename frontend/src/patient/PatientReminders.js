import React, { useState, useEffect } from 'react';
import { Plus, Trash2, Calendar, Activity, Pill, Link as LinkIcon, FileText, ArrowLeft } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import styles from './PatientReminders.module.css';
import CreateReminderModal from './PatientReminderModal';

// Mock reminders
const mockReminders = [
  { id: 1, type: 'Medication', title: 'Take Blood Pressure Medication', time: '08:00', frequency: 'Daily', status: 'Active', details: 'After breakfast' },
  { id: 2, type: 'Exercise', title: 'Morning Walk', time: '06:30', frequency: 'Daily', status: 'Pending', details: '30 minutes walk' },
  { id: 3, type: 'Lab', title: 'Fasting Lab Work', time: '08:00', frequency: 'Once', status: 'Completed', details: 'No food 12 hours prior' },
];

// Helpers
const getNextOccurrence = (reminder) => {
  const now = new Date();
  const [hours, minutes] = reminder.time.split(':').map(Number);
  let next = new Date(now);
  next.setHours(hours, minutes, 0, 0);

  // If time already passed today, move to next day
  if (next <= now) {
    next.setDate(next.getDate() + 1);
  }

  return next;
};

const isUpcoming = (reminder) => {
  const now = new Date();
  const nextOccurrence = getNextOccurrence(reminder);
  return nextOccurrence - now <= 24 * 60 * 60 * 1000;
};

const isActiveFromSnooze = (reminder) => {
  if (reminder.status === 'Snoozed' && reminder.snoozeAt) {
    return Date.now() - new Date(reminder.snoozeAt).getTime() >= 5 * 1000; // 5 seconds for testing
  }
  return false;
};

const RemindersListPage = () => {
  const navigate = useNavigate();
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [reminders, setReminders] = useState(() => {
    const stored = localStorage.getItem('mockReminders');
    return stored ? JSON.parse(stored) : mockReminders;
  });

  // Inside PatientReminders.jsx or a setup file
  useEffect(() => {
    const stored = localStorage.getItem('mockReminders');
    if (!stored) {
      localStorage.setItem('mockReminders', JSON.stringify(mockReminders));
    }
  }, []);

  const updateReminders = (newReminders) => {
    setReminders(newReminders);
    localStorage.setItem('mockReminders', JSON.stringify(newReminders));
  };

  // Auto-reactivate snoozed reminders
  useEffect(() => {
    const interval = setInterval(() => {
      setReminders(prev =>
        prev.map(r =>
          isActiveFromSnooze(r) ? { ...r, status: 'Active', snoozeAt: null } : r
        )
      );
    }, 1000); // check every second for testing
    return () => clearInterval(interval);
  }, []);

  const handleCreateReminder = (formData) => {
    const newReminder = {
      id: Math.random(),
      title: formData.title,
      type: formData.reminderType,
      time: formData.time,
      frequency: formData.frequency,
      status: 'Pending',
      details: formData.notes || '',
    };
    setReminders([newReminder, ...reminders]);
  };

  const handleDelete = (id) => {
    setReminders(reminders.filter(r => r.id !== id));
  };

  const handleSnooze = (id) => {
    updateReminders(
      reminders.map(r =>
        r.id === id ? { ...r, status: 'Snoozed', snoozeAt: new Date() } : r
      )
    );
  };

  const handleComplete = (id) => {
    setReminders(reminders.map(r =>
      r.id === id ? { ...r, status: 'Completed' } : r
    ));
  };

  const getIcon = (type) => {
    switch(type) {
      case 'Appointment': return <Calendar size={18} className={styles.iconAppointment} />;
      case 'Exercise': return <Activity size={18} className={styles.iconExercise} />;
      case 'Medication': return <Pill size={18} className={styles.iconMedication} />;
      case 'Lab': return <FileText size={18} className={styles.iconLab} />;
      default: return <LinkIcon size={18} className={styles.iconDisabled} />;
    }
  };

  const getTagColor = (type) => {
    switch(type) {
      case 'Appointment': return styles.tagPurple;
      case 'Exercise': return styles.tagGreen;
      case 'Medication': return styles.tagBlue;
      case 'Lab': return styles.tagOrange;
      default: return styles.tagGray;
    }
  };

  // Categorize reminders
  const sections = {
    Today: reminders.filter(r => r.status === 'Active' || isActiveFromSnooze(r)),
    Upcoming: reminders.filter(r => r.status === 'Pending' && isUpcoming(r)),
    Past: reminders.filter(r => r.status === 'Completed' || r.status === 'Snoozed'),
  };

  return (
    <div className={styles.pageContainer}>
      {/* Header */}
      <header className={styles.header}>
        <div className={styles.headerLeft}>
          <button className={styles.backButton} onClick={() => navigate('/patient-dashboard')}>
            <ArrowLeft size={20} />
          </button>
          <div>
            <h1 className={styles.headerTitle}>Reminders</h1>
            <p className={styles.headerSubtitle}>Manage your health reminders and notifications</p>
          </div>
        </div>
        <button className={styles.newReminderButton} onClick={() => setShowCreateModal(true)}>
          <Plus size={16} /> New Reminder
        </button>
      </header>

      {/* Overview */}
      <section className={styles.overviewSection}>
        <h2 className={styles.sectionTitle}>Overview</h2>
        <p className={styles.sectionSubtitle}>Quick snapshot of your reminders</p>
        <div className={styles.overviewBox}>
          <div className={styles.statItem}>
            <span className={styles.statValue}>{reminders.length}</span>
            <span className={styles.statLabel}>Total</span>
          </div>
          <div className={styles.statItem}>
            <span className={styles.statValue}>{sections.Today.length}</span>
            <span className={styles.statLabel}>Today</span>
          </div>
          <div className={styles.statItem}>
            <span className={styles.statValue}>{sections.Upcoming.length}</span>
            <span className={styles.statLabel}>Upcoming</span>
          </div>
          <div className={styles.statItem}>
            <span className={styles.statValue}>{sections.Past.length}</span>
            <span className={styles.statLabel}>Past</span>
          </div>
        </div>
      </section>

      {/* Reminders */}
      <section className={styles.remindersSection}>
        {Object.entries(sections).map(([sectionLabel, items]) => (
          <div key={sectionLabel} className={styles.sectionGroup}>
            <h2 className={styles.sectionTitle}>{sectionLabel}</h2>
            {items.length === 0 ? (
              <p className={styles.sectionEmpty}>No {sectionLabel.toLowerCase()} reminders.</p>
            ) : (
              items.map(reminder => (
                <div
                  key={reminder.id}
                  className={`${styles.reminderCard} ${reminder.status === 'Completed' ? styles.disabledCard : ''}`}
                >
                  {/* Icon */}
                  <div className={styles.reminderIcon}>{getIcon(reminder.type)}</div>

                  {/* Content */}
                  <div className={styles.reminderContent}>
                    {/* Header: Title + Tag + Actions */}
                    <div className={styles.reminderHeader}>
                      <div className={styles.titleTag}>
                        <span className={styles.reminderTitle}>{reminder.title}</span>
                        <span className={`${styles.reminderTag} ${getTagColor(reminder.type)}`}>
                          {reminder.type}
                        </span>
                      </div>

                      <div className={styles.reminderActions}>
                        {(reminder.status === 'Active' || isActiveFromSnooze(reminder)) && (
                          <>
                            <button
                              className={styles.snoozeButton}
                              onClick={() => handleSnooze(reminder.id)}
                            >
                              Snooze
                            </button>
                            <button
                              className={styles.completeButton}
                              onClick={() => handleComplete(reminder.id)}
                            >
                              Mark Completed
                            </button>
                          </>
                        )}
                        <button
                          className={styles.deleteButton}
                          onClick={() => handleDelete(reminder.id)}
                        >
                          <Trash2 size={16} />
                        </button>
                      </div>
                    </div>

                    {/* Additional info below */}
                    <p className={styles.reminderDetails}>
                      {reminder.time} • {reminder.frequency}
                    </p>
                    {reminder.details && (
                      <p className={styles.reminderDetails}>{reminder.details}</p>
                    )}
                    {/* Optional: status below */}
                    {/* <p className={styles.reminderNext}>{reminder.status}</p> */}
                  </div>
                </div>
              ))
            )}
          </div>
        ))}
      </section>

      {/* Create Modal */}
      {showCreateModal && (
        <CreateReminderModal 
          onClose={() => setShowCreateModal(false)}
          onCreate={handleCreateReminder}
        />
      )}
    </div>
  );
};

export default RemindersListPage;
