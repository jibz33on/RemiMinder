import React, { useState } from "react";
import { ArrowLeft, Search, UserCheck, UserX, Clock, Heart } from "lucide-react";
import styles from "./PendingInvitations.module.css";
import { useNavigate } from "react-router-dom";

const PendingInvitations = () => {
  const [searchQuery, setSearchQuery] = useState("");
  const navigate = useNavigate();

  const invitations = [
    {
      id: 1,
      patientName: "Jane Doe",
      patientEmail: "jane.doe@example.com",
      patientAvatar:
        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150",
      relationship: "Mother",
      message:
        "I'd like to share my health information with you so you can help me stay on top of my appointments and medical care.",
      invitedDate: "Oct 28, 2025",
      status: "pending",
    },
    {
      id: 2,
      patientName: "Robert Anderson",
      patientEmail: "robert.anderson@example.com",
      patientAvatar:
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150",
      relationship: "Father",
      message:
        "Would appreciate your help managing my healthcare appointments and keeping track of my medical visits.",
      invitedDate: "Oct 25, 2025",
      status: "pending",
    },
  ];

  const filtered = invitations.filter((inv) =>
    [inv.patientName, inv.patientEmail, inv.relationship].some((field) =>
      field.toLowerCase().includes(searchQuery.toLowerCase())
    )
  );

  const renderCard = (inv) => (
    <div key={inv.id} className={styles.invitationCard}>
      <div className={styles.cardTop}>
        <img
          src={inv.patientAvatar}
          alt={inv.patientName}
          className={styles.avatar}
        />
        <div className={styles.cardInfo}>
          <div className={styles.nameRow}>
            <h3 className={styles.patientName}>{inv.patientName}</h3>
            <span className={`${styles.statusBadge} ${styles.statusPending}`}>
              <Clock size={12} />
              Pending
            </span>
          </div>
          <p className={styles.patientEmail}>{inv.patientEmail}</p>
          <p className={styles.metaText}>
            Relationship: {inv.relationship} • Invited on {inv.invitedDate}
          </p>
        </div>
      </div>

      <div className={styles.messageBox}>
        <p className={styles.messageText}>
          <em>"{inv.message}"</em>
        </p>
      </div>

      <div className={styles.actionButtons}>
        <button className={styles.acceptButton}>
          <UserCheck size={16} />
          Accept
        </button>
        <button className={styles.declineButton}>
          <UserX size={16} />
          Decline
        </button>
      </div>
    </div>
  );

  const renderEmpty = () => (
    <div className={styles.emptyState}>
      <div className={styles.emptyIcon}>
        <Clock size={32} className={styles.emptyIconInner} />
      </div>
      <h3>No pending invitations</h3>
      <p>
        You're all caught up! Patients can invite you from their MediMinder
        account.
      </p>
    </div>
  );

  return (
    <div className={styles.container}>
      {/* Header */}
      <header className={styles.header}>
        <div className={styles.headerContent}>
          <button
            className={styles.backButton}
            onClick={() => navigate("/dashboard/caregiver")}
          >
            <ArrowLeft size={20} />
          </button>
          <div className={styles.headerText}>
            <h2>Pending Invitations</h2>
            <p>Review and respond to patient invitations</p>
          </div>
        </div>
      </header>

      {/* Body */}
      <main className={styles.main}>
        {/* Search */}
        <div className={styles.searchBox}>
          <Search className={styles.searchIcon} />
          <input
            type="text"
            placeholder="Search invitations by name, email, or relationship..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className={styles.searchInput}
          />
        </div>

        {/* Invitations */}
        <div className={styles.invitationList}>
          {filtered.length > 0 ? filtered.map(renderCard) : renderEmpty()}
        </div>

        {/* Info banner */}
        <div className={styles.infoBanner}>
          <Heart className={styles.infoIcon} />
          <div>
            <p className={styles.infoTitle}>About Patient Invitations</p>
            <p className={styles.infoText}>
              Patients invite caregivers to access their health information. By
              accepting, you'll have read-only access to their visit summaries,
              appointments, and health notes.
            </p>
          </div>
        </div>
      </main>
    </div>
  );
};

export default PendingInvitations;
