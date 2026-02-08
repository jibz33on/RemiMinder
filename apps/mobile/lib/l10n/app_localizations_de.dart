// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'RemiMinder';

  @override
  String get login => 'Anmelden';

  @override
  String get logout => 'Abmelden';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get profileSettings => 'Profileinstellungen';

  @override
  String get commonSkip => 'Überspringen';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonClose => 'Schließen';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get languageSpanish => 'Spanisch';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languageMandarin => 'Mandarin';

  @override
  String get languageArabic => 'Arabisch';

  @override
  String get languageFrench => 'Französisch';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get countryUnitedStates => 'Vereinigte Staaten';

  @override
  String get countryCanada => 'Kanada';

  @override
  String get countryUnitedKingdom => 'Vereinigtes Königreich';

  @override
  String get countryGermany => 'Deutschland';

  @override
  String get countryIndia => 'Indien';

  @override
  String get welcomeTitle => 'Willkommen bei RemiMinder';

  @override
  String get welcomeSubtitle =>
      'Smarte KI für Gesundheit und Pflegekoordination';

  @override
  String get welcomeDescription =>
      'Ihr intelligenter Begleiter für Medikamentenerinnerungen, Terminverfolgung und Pflegekoordination. Verpassen Sie keinen wichtigen Gesundheitsmoment mehr.';

  @override
  String get welcomeGetStarted => 'Loslegen';

  @override
  String get roleChooseYourRole => 'Wählen Sie Ihren Kontext';

  @override
  String get roleSelectHowYouUse =>
      'Wählen Sie aus, wie Sie RemiMinder nutzen möchten';

  @override
  String get rolePatient => 'Patienten‑Kontext';

  @override
  String get rolePatientDescription =>
      'Verwalten Sie Ihre eigenen Medikamente, Termine und Gesundheitsakten';

  @override
  String get roleCaregiver => 'Betreuer‑Kontext';

  @override
  String get roleCaregiverDescription =>
      'Helfen Sie bei der Medikamentenverwaltung und der Pflege von Angehörigen oder Patienten';

  @override
  String get roleContinue => 'Weiter';

  @override
  String get onboardingAppLanguageTitle => 'Wählen Sie Ihre App‑Sprache';

  @override
  String get onboardingAppLanguageSubtitle =>
      'Dies aktualisiert die UI‑Sprache.';

  @override
  String get onboardingCountryTitle => 'Wählen Sie Ihr Land oder Ihre Region';

  @override
  String get onboardingCountrySubtitle =>
      'Optional, hilft die Erfahrung anzupassen.';

  @override
  String get onboardingTimezoneTitle => 'Bestätigen Sie Ihre Zeitzone';

  @override
  String onboardingTimezoneDetected(Object timezone) {
    return 'Erkannt: $timezone';
  }

  @override
  String get onboardingTimezoneLabel => 'Zeitzone';

  @override
  String get onboardingTimezoneConfirm => 'Bestätigen';

  @override
  String get onboardingVisitLanguageTitle => 'Wählen Sie Ihre Besuchssprache';

  @override
  String get onboardingVisitLanguageSubtitle =>
      'Diese wird für die Aufzeichnung von Besuchen und die Erstellung von Zusammenfassungen verwendet';

  @override
  String get loginBrandName => 'RemiMinder.ai';

  @override
  String get loginContinueWithGoogle => 'Mit Google fortfahren';

  @override
  String get loginContinueWithApple => 'Mit Apple fortfahren';

  @override
  String get loginContinueWithEmail => 'Mit E‑Mail fortfahren';

  @override
  String get loginCreateAccount => 'Konto erstellen';

  @override
  String get loginForgotPassword => 'Passwort vergessen?';

  @override
  String get loginSignInWithEmailTitle => 'Mit E‑Mail anmelden';

  @override
  String get loginEmailLabel => 'E‑Mail';

  @override
  String get loginEmailHint => 'E‑Mail eingeben';

  @override
  String get loginPasswordLabel => 'Passwort';

  @override
  String get loginPasswordHint => 'Passwort eingeben';

  @override
  String get loginRememberMe => 'Angemeldet bleiben';

  @override
  String get loginSignIn => 'Anmelden';

  @override
  String get loginFillAllFields => 'Bitte füllen Sie alle Felder aus';

  @override
  String get loginAuthFailed =>
      'Authentifizierung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get loginInvalidEmailOrPassword =>
      'Ungültige E‑Mail oder Passwort. Bitte prüfen Sie Ihre Zugangsdaten und versuchen Sie es erneut.';

  @override
  String get loginEmailNotConfirmed =>
      'Bitte prüfen Sie Ihre E‑Mail und bestätigen Sie Ihr Konto, bevor Sie sich anmelden.';

  @override
  String get loginUserNotFound =>
      'Kein Konto mit dieser E‑Mail‑Adresse gefunden.';

  @override
  String get loginConnectionError =>
      'Verbindungsfehler. Bitte prüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.';

  @override
  String get loginRequestTimedOut =>
      'Anfragezeit überschritten. Bitte versuchen Sie es erneut.';

  @override
  String get loginSignInFailedGeneric =>
      'Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut oder wenden Sie sich an den Support, falls das Problem bestehen bleibt.';

  @override
  String get loginGoogleSignInFailed => 'Google‑Anmeldung fehlgeschlagen';

  @override
  String loginGoogleSignInFailedWithError(Object error) {
    return 'Google‑Anmeldung fehlgeschlagen: $error';
  }

  @override
  String get loginAppleSignInComingSoon => 'Apple‑Anmeldung – bald verfügbar!';

  @override
  String get loginContinueWithoutSigningIn => 'Ohne Anmeldung fortfahren';

  @override
  String get loginBypassPatient => 'Patient';

  @override
  String get loginBypassCaregiver => 'Betreuer';

  @override
  String get registerTitle => 'Konto erstellen';

  @override
  String get registerSubtitle => 'Treten Sie RemiMinder bei, um zu starten';

  @override
  String get registerFirstNameLabel => 'Vorname';

  @override
  String get registerFirstNameHint => 'Max';

  @override
  String get registerFirstNameRequired => 'Bitte geben Sie Ihren Vornamen ein';

  @override
  String get registerLastNameLabel => 'Nachname';

  @override
  String get registerLastNameHint => 'Mustermann';

  @override
  String get registerLastNameRequired => 'Bitte geben Sie Ihren Nachnamen ein';

  @override
  String get registerEmailLabel => 'E‑Mail';

  @override
  String get registerEmailHint => 'max.mustermann@example.com';

  @override
  String get registerEmailRequired => 'Bitte geben Sie Ihre E‑Mail ein';

  @override
  String get registerEmailInvalid => 'Bitte geben Sie eine gültige E‑Mail ein';

  @override
  String get registerPasswordLabel => 'Passwort';

  @override
  String get registerPasswordHint => 'Erstellen Sie ein starkes Passwort';

  @override
  String get registerPasswordRequired => 'Bitte geben Sie ein Passwort ein';

  @override
  String get registerPasswordTooShort =>
      'Das Passwort muss mindestens 8 Zeichen lang sein';

  @override
  String get registerConfirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get registerConfirmPasswordHint => 'Passwort erneut eingeben';

  @override
  String get registerConfirmPasswordRequired =>
      'Bitte bestätigen Sie Ihr Passwort';

  @override
  String get registerPasswordMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get registerTermsIntro =>
      'Mit der Erstellung eines Kontos stimmen Sie unseren ';

  @override
  String get registerTermsOfService => 'Nutzungsbedingungen';

  @override
  String get registerAnd => ' und der ';

  @override
  String get registerPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get registerCreateAccountButton => 'Konto erstellen';

  @override
  String get registerAlreadyHaveAccount => 'Haben Sie bereits ein Konto? ';

  @override
  String get registerSignIn => 'Anmelden';

  @override
  String get registerAcceptTermsError =>
      'Bitte akzeptieren Sie die Allgemeinen Geschäftsbedingungen';

  @override
  String get registerSelectRoleFirst => 'Bitte wählen Sie zuerst einen Kontext';

  @override
  String get registerAccountCreatedTitle => 'Konto erstellt!';

  @override
  String get registerAccountCreatedMessage =>
      'Ihr Konto wurde erfolgreich erstellt. Sie können sich jetzt mit Ihrer E‑Mail und Ihrem Passwort anmelden.';

  @override
  String get registerGoToSignIn => 'Zur Anmeldung';

  @override
  String get registerTermsTitle => 'Nutzungsbedingungen';

  @override
  String get registerTermsBody =>
      'Nutzungsbedingungen für RemiMinder\n\n1. Annahme der Bedingungen\nDurch die Nutzung von RemiMinder stimmen Sie diesen Bedingungen zu.\n\n2. Nutzung des Dienstes\nRemiMinder wurde entwickelt, um bei der Verwaltung von Gesundheitsversorgung und Medikamentenerinnerungen zu helfen.\n\n3. Datenschutz\nIhre Privatsphäre ist uns wichtig. Alle Gesundheitsdaten werden sicher behandelt.\n\n4. Kontoverantwortung\nSie sind für die Vertraulichkeit Ihres Kontos verantwortlich.\n\n5. Haftungsbeschränkung\nRemiMinder ist kein Ersatz für professionelle medizinische Beratung.\n\nFür die vollständigen Nutzungsbedingungen besuchen Sie bitte unsere Website.';

  @override
  String get registerPrivacyTitle => 'Datenschutzerklärung';

  @override
  String get registerPrivacyBody =>
      'Datenschutzerklärung für RemiMinder\n\n1. Informationen, die wir erfassen\nWir erfassen die von Ihnen bereitgestellten Informationen und Nutzungsdaten, um unseren Service zu verbessern.\n\n2. Wie wir Informationen verwenden\nInformationen werden genutzt, um Gesundheitsmanagement‑Dienste bereitzustellen und die Nutzererfahrung zu verbessern.\n\n3. Informationsweitergabe\nWir verkaufen Ihre persönlichen Informationen nicht. Daten werden nur mit von Ihnen autorisierten Gesundheitsdienstleistern geteilt.\n\n4. Datensicherheit\nWir implementieren branchenübliche Sicherheitsmaßnahmen zum Schutz Ihrer Gesundheitsdaten.\n\n5. Ihre Rechte\nSie haben das Recht, auf Ihre persönlichen Informationen zuzugreifen, sie zu berichtigen oder zu löschen.\n\nFür die vollständige Datenschutzerklärung besuchen Sie bitte unsere Website.';

  @override
  String get registerAccountExists =>
      'Ein Konto mit dieser E‑Mail existiert bereits. Bitte melden Sie sich stattdessen an.';

  @override
  String get registerWeakPassword =>
      'Das Passwort ist zu schwach. Bitte verwenden Sie mindestens 8 Zeichen mit Buchstaben und Zahlen.';

  @override
  String get registerConnectionError =>
      'Verbindungsfehler. Bitte prüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.';

  @override
  String get registerRequestTimedOut =>
      'Anfragezeit überschritten. Bitte versuchen Sie es erneut.';

  @override
  String get registerFailedGeneric =>
      'Registrierung fehlgeschlagen. Bitte versuchen Sie es erneut oder wenden Sie sich an den Support, falls das Problem bestehen bleibt.';

  @override
  String get forgotPasswordTitle => 'Passwort vergessen?';

  @override
  String get forgotPasswordSubtitle =>
      'Kein Problem! Geben Sie Ihre E‑Mail ein, und wir senden Ihnen Anweisungen zum Zurücksetzen.';

  @override
  String get forgotPasswordEmailHint => 'E‑Mail‑Adresse eingeben';

  @override
  String get forgotPasswordEmailRequired => 'Bitte geben Sie Ihre E‑Mail ein';

  @override
  String get forgotPasswordEmailInvalid =>
      'Bitte geben Sie eine gültige E‑Mail ein';

  @override
  String get forgotPasswordSendInstructions =>
      'Anweisungen zum Zurücksetzen senden';

  @override
  String get forgotPasswordRememberPassword =>
      'Erinnern Sie sich an Ihr Passwort?';

  @override
  String get forgotPasswordBackToLogin => 'Zurück zur Anmeldung';

  @override
  String get forgotPasswordSuccessMessage =>
      'Wenn ein Konto für diese E‑Mail existiert, haben wir Ihnen Anweisungen zum Zurücksetzen gesendet.';

  @override
  String get forgotPasswordSendFailed =>
      'Senden der Zurücksetz‑E‑Mail fehlgeschlagen. Bitte prüfen Sie die E‑Mail und versuchen Sie es erneut.';

  @override
  String get forgotPasswordNotAvailable =>
      'Passwort‑Zurücksetzung ist für dieses Konto nicht verfügbar.';

  @override
  String get forgotPasswordTooManyRequests =>
      'Zu viele Anfragen. Bitte versuchen Sie es später erneut.';

  @override
  String get forgotPasswordNetworkError =>
      'Netzwerkfehler. Bitte prüfen Sie Ihre Internetverbindung.';

  @override
  String get patientHomeGreetingMorning => 'Guten Morgen';

  @override
  String get patientHomeGreetingAfternoon => 'Guten Tag';

  @override
  String get patientHomeGreetingEvening => 'Guten Abend';

  @override
  String get patientHomeGreetingNight => 'Gute Nacht';

  @override
  String get patientHomeFeelingToday => 'Wie fühlen Sie sich heute?';

  @override
  String get patientHomeTodaysSchedule => 'Heutiger Plan';

  @override
  String get patientHomeTodoList => 'Aufgabenliste';

  @override
  String get patientHomeUpNext => 'Als Nächstes';

  @override
  String get patientHomeNoUpcomingReminders =>
      'Keine bevorstehenden Erinnerungen';

  @override
  String get patientHomeMarkedAsTaken => 'Als genommen markiert!';

  @override
  String get patientHomeTakeNow => 'Jetzt einnehmen';

  @override
  String get patientHomeReminderSnoozed => 'Erinnerung für 1 Stunde verschoben';

  @override
  String get patientHomeNothingScheduled => 'Für heute nichts geplant';

  @override
  String get patientHomeViewAll => 'Alle anzeigen';

  @override
  String get patientHomeAddItem => 'Eintrag hinzufügen';

  @override
  String get patientHomeNoTasksYet => 'Noch keine Aufgaben';

  @override
  String get patientHomeAddTask => 'Aufgabe hinzufügen';

  @override
  String get patientHomeAddedRecently => 'Kürzlich hinzugefügt';

  @override
  String patientHomeAddedDate(Object date) {
    return 'Hinzugefügt am $date';
  }

  @override
  String get patientHomeUpcoming => 'Bevorstehend';

  @override
  String get patientHomeDueNow => 'Jetzt fällig';

  @override
  String patientHomeDueInMinutes(Object minutes) {
    return 'Fällig in $minutes Min';
  }

  @override
  String patientHomeDueInHours(Object hours) {
    return 'Fällig in $hours Stunden';
  }

  @override
  String patientHomeDueInDays(Object days) {
    return 'Fällig in $days Tagen';
  }

  @override
  String patientHomeDueOnDate(Object date) {
    return 'Fällig am $date';
  }

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get caregiverPatientsTitle => 'Meine Patienten';

  @override
  String get caregiverPatientsSearchHint =>
      'Patienten nach Name, Beziehung oder Erkrankung suchen...';

  @override
  String get caregiverPatientsClearFilter => 'Filter zurücksetzen';

  @override
  String caregiverPatientsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# Patienten',
      one: '# Patient',
    );
    return '$_temp0';
  }

  @override
  String get caregiverPatientsFilterAll => 'Alle';

  @override
  String get caregiverPatientsFilterActive => 'Aktiv';

  @override
  String get caregiverPatientsFilterAttention => 'Aufmerksamkeit';

  @override
  String get caregiverPatientsFilterCritical => 'Kritisch';

  @override
  String get caregiverPatientsFilterDialogTitle => 'Patienten filtern';

  @override
  String get caregiverPatientsEmptyNoMatch =>
      'Keine Patienten passen zu Ihrer Suche';

  @override
  String get caregiverPatientsEmptyNone => 'Keine Patienten gefunden';

  @override
  String get caregiverPatientsEmptyAdjustSearch =>
      'Passen Sie Ihre Suchbegriffe an';

  @override
  String get caregiverPatientsEmptyAddPatients =>
      'Fügen Sie Patienten hinzu, um deren Pflege zu verwalten';

  @override
  String get caregiverPatientsAddFirstComingSoon =>
      'Ersten Patienten hinzufügen – bald verfügbar!';

  @override
  String get caregiverPatientsAddPatientButton => 'Patient hinzufügen';

  @override
  String get caregiverPatientsLoadFailed =>
      'Patienten konnten nicht geladen werden';

  @override
  String get caregiverPatientsAddNewComingSoon =>
      'Neuen Patienten hinzufügen – bald verfügbar!';

  @override
  String caregiverPatientsRelationshipAge(Object age, Object relationship) {
    return '$relationship • Alter $age';
  }

  @override
  String get caregiverPatientsStatAdherence => 'Adhärenz';

  @override
  String get caregiverPatientsStatAppointments => 'Termine';

  @override
  String get caregiverPatientsStatLastVisit => 'Letzter Besuch';

  @override
  String caregiverPatientsViewAlerts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# Hinweise anzeigen',
      one: '# Hinweis anzeigen',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsViewAppointments(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# Termine',
      one: '# Termin',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsViewAlertsComingSoon(Object name) {
    return 'Hinweise für $name anzeigen – bald verfügbar!';
  }

  @override
  String caregiverPatientsViewAppointmentsComingSoon(Object name) {
    return 'Termine für $name anzeigen – bald verfügbar!';
  }

  @override
  String get caregiverPatientsLastVisitToday => 'Heute';

  @override
  String get caregiverPatientsLastVisitYesterday => 'Gestern';

  @override
  String caregiverPatientsLastVisitDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor # Tagen',
      one: 'vor # Tag',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsLastVisitWeeks(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor # Wochen',
      one: 'vor # Woche',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsLastVisitMonths(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor # Monaten',
      one: 'vor # Monat',
    );
    return '$_temp0';
  }

  @override
  String get caregiverPatientOverviewTitle => 'Patientenübersicht';

  @override
  String get caregiverPatientOverviewTabVisits => 'Besuche';

  @override
  String get caregiverPatientOverviewTabReminders => 'Erinnerungen';

  @override
  String get caregiverPatientOverviewTabNotes => 'Notizen';

  @override
  String get caregiverPatientOverviewNoVisits => 'Keine Besuche verfügbar';

  @override
  String get caregiverPatientOverviewNoReminders =>
      'Keine Erinnerungen verfügbar';

  @override
  String get caregiverPatientOverviewNoNotes => 'Keine Notizen verfügbar';

  @override
  String get caregiverPatientOverviewEditComingSoon =>
      'Patient bearbeiten – bald verfügbar!';

  @override
  String get caregiverPatientOverviewCallPatient => 'Patient anrufen';

  @override
  String get caregiverPatientOverviewSendMessage => 'Nachricht senden';

  @override
  String get caregiverPatientOverviewEmergencyContact => 'Notfallkontakt';

  @override
  String get caregiverPatientOverviewSharePatientInfo =>
      'Patienteninfos teilen';

  @override
  String get caregiverPatientOverviewScheduleAppointment =>
      'Neuen Termin planen – bald verfügbar!';

  @override
  String get caregiverPatientOverviewAddReminder =>
      'Neue Erinnerung hinzufügen – bald verfügbar!';

  @override
  String get caregiverPatientOverviewAddNote =>
      'Neue Notiz hinzufügen – bald verfügbar!';

  @override
  String caregiverPatientOverviewViewVisitDetails(Object type) {
    return '$type-Details anzeigen – bald verfügbar!';
  }

  @override
  String caregiverPatientOverviewViewReminderDetails(Object title) {
    return 'Details zu $title anzeigen – bald verfügbar!';
  }

  @override
  String caregiverPatientOverviewViewNoteDetails(Object title) {
    return 'Details zu $title anzeigen – bald verfügbar!';
  }

  @override
  String get caregiverPatientOverviewMissingPatientId => 'patientId fehlt';

  @override
  String get caregiverPatientOverviewOverdue => 'Überfällig';

  @override
  String caregiverPatientOverviewInHours(Object hours) {
    return 'In $hours Stunden';
  }

  @override
  String get caregiverPatientOverviewDefaultRelationship => 'Pflege‑Team';

  @override
  String get caregiverPatientOverviewDefaultCondition =>
      'Autorisierter Zugriff';

  @override
  String get caregiverAlertsTitle => 'Hinweise';

  @override
  String get caregiverAlertsFilterAll => 'Alle';

  @override
  String get caregiverAlertsFilterUnread => 'Ungelesen';

  @override
  String get caregiverAlertsFilterRead => 'Gelesen';

  @override
  String get caregiverAlertsFilterHighPriority => 'Hohe Priorität';

  @override
  String get caregiverAlertsFilterActionRequired => 'Aktion erforderlich';

  @override
  String get caregiverAlertsClearFilter => 'Filter zurücksetzen';

  @override
  String caregiverAlertsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# Hinweise',
      one: '# Hinweis',
    );
    return '$_temp0';
  }

  @override
  String get caregiverAlertsMarkAllReadTooltip => 'Alle als gelesen markieren';

  @override
  String get caregiverAlertsActionRequired => 'Aktion erforderlich';

  @override
  String get caregiverAlertsMarkRead => 'Als gelesen markieren';

  @override
  String get caregiverAlertsTakeAction => 'Aktion ausführen';

  @override
  String get caregiverAlertsEmptyAllTitle => 'Derzeit keine Hinweise';

  @override
  String get caregiverAlertsEmptyAllSubtitle =>
      'Alle Patientenaktivitäten laufen reibungslos';

  @override
  String get caregiverAlertsEmptyFilteredTitle =>
      'Keine Hinweise passen zu diesem Filter';

  @override
  String get caregiverAlertsEmptyFilteredSubtitle =>
      'Passen Sie den Filter an, um weitere Hinweise zu sehen';

  @override
  String get caregiverAlertsViewAll => 'Alle Hinweise anzeigen';

  @override
  String get caregiverAlertsMarkedRead => 'Hinweis als gelesen markiert';

  @override
  String get caregiverAlertsMarkedUnread => 'Hinweis als ungelesen markiert';

  @override
  String get caregiverAlertsAllAlreadyRead =>
      'Alle Hinweise sind bereits gelesen';

  @override
  String caregiverAlertsMarkedAllRead(Object count) {
    return '$count Hinweise als gelesen markiert';
  }

  @override
  String caregiverAlertsTakingAction(Object type) {
    return 'Aktion für $type-Hinweis wird ausgeführt';
  }

  @override
  String caregiverAlertsViewDetails(Object type) {
    return 'Details für $type-Hinweis anzeigen';
  }

  @override
  String get caregiverInvitationsTitle => 'Betreuer‑Einladungen';

  @override
  String get caregiverInvitationsRetry => 'Erneut versuchen';

  @override
  String get caregiverInvitationsEmpty => 'Keine ausstehenden Einladungen';

  @override
  String caregiverInvitationsRole(Object role) {
    return 'Rolle: $role';
  }

  @override
  String caregiverInvitationsPermission(Object permission) {
    return 'Berechtigung: $permission';
  }

  @override
  String get caregiverInvitationsAccept => 'Annehmen';

  @override
  String get caregiverInvitationsMissingToken => 'Einladungs‑Token fehlt';

  @override
  String get caregiverInvitationsAccepted => 'Einladung angenommen';

  @override
  String get caregiverInvitationsPatientFallback => 'Patient';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get overviewTitle => 'Übersicht';

  @override
  String get overviewSearchHint => 'Zusammenfassungen suchen...';

  @override
  String get overviewTabSummaries => 'ZUSAMMENFASSUNGEN';

  @override
  String get overviewTabLabResults => 'LABORERGEBNISSE';

  @override
  String get overviewTabScannedDocs => 'GESCANNTE DOKUMENTE';

  @override
  String get overviewNewSummaryTitle =>
      '🎉 Ihre Besuchszusammenfassung ist fertig!';

  @override
  String get overviewNewSummaryPrompt => 'Möchten Sie sie jetzt ansehen?';

  @override
  String get overviewNewSummaryLater => 'Später';

  @override
  String get overviewNewSummaryView => 'Zusammenfassung ansehen';

  @override
  String get overviewSelectAtLeastOne =>
      'Wählen Sie mindestens eine Zusammenfassung aus';

  @override
  String get overviewDeleteSummaryTitleSingular => 'Zusammenfassung löschen?';

  @override
  String get overviewDeleteSummaryTitlePlural => 'Zusammenfassungen löschen?';

  @override
  String get overviewDeleteSummaryConfirmSingular =>
      'Möchten Sie diese Zusammenfassung wirklich löschen? Dies kann nicht rückgängig gemacht werden.';

  @override
  String overviewDeleteSummaryConfirmPlural(Object count) {
    return 'Möchten Sie wirklich $count Zusammenfassungen löschen? Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get overviewAuthError =>
      'Authentifizierungsfehler. Bitte melden Sie sich erneut an.';

  @override
  String overviewDeleteSuccess(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# Zusammenfassungen',
      one: '# Zusammenfassung',
    );
    return '$_temp0 erfolgreich gelöscht';
  }

  @override
  String get overviewDeleteFailed =>
      'Zusammenfassungen konnten nicht gelöscht werden. Bitte versuchen Sie es erneut.';

  @override
  String get overviewNoCaregiver => 'Noch kein Betreuer hinzugefügt';

  @override
  String get overviewShareTitleShare => 'Zusammenfassung teilen?';

  @override
  String get overviewShareTitleStop => 'Teilen beenden?';

  @override
  String get overviewShareConfirmShare =>
      'Sie teilen diese Zusammenfassung mit Ihren Betreuern. Sie können diese Besuchszusammenfassung anzeigen.';

  @override
  String get overviewShareConfirmStop =>
      'Betreuer können diese Zusammenfassung nicht mehr anzeigen.';

  @override
  String get overviewShareAction => 'Teilen';

  @override
  String get overviewStopShareAction => 'Teilen beenden';

  @override
  String get overviewSharingEnabled => 'Betreuerfreigabe aktiviert';

  @override
  String get overviewSharingDisabled => 'Betreuerfreigabe deaktiviert';

  @override
  String get overviewSummariesLoadFailed =>
      'Zusammenfassungen konnten nicht geladen werden';

  @override
  String get overviewNoSummariesTitle => 'Noch keine Zusammenfassungen';

  @override
  String get overviewNoSummariesSubtitle =>
      'Ihre Besuchszusammenfassungen erscheinen hier';

  @override
  String get overviewProcessingTitle =>
      '🕒 Ihr letzter Besuch wird verarbeitet';

  @override
  String get overviewProcessingSubtitle =>
      'Wir benachrichtigen Sie, sobald er bereit ist.';

  @override
  String get overviewLabResultsComingSoon => 'Laborergebnisse – bald verfügbar';

  @override
  String get overviewScannedDocsComingSoon =>
      'Gescannte Dokumente – bald verfügbar';

  @override
  String get overviewShareLabel => 'Teilen';

  @override
  String get overviewDoctorVisit => 'Arztbesuch';

  @override
  String overviewDoctorPrefix(Object name) {
    return 'Dr. $name';
  }

  @override
  String overviewMinutesAgo(Object count) {
    return 'vor $count Min';
  }

  @override
  String overviewTodayAt(Object time) {
    return 'Heute, $time';
  }

  @override
  String overviewYesterdayAt(Object time) {
    return 'Gestern, $time';
  }

  @override
  String get remindersTitle => 'Erinnerungen';

  @override
  String get remindersTabAll => 'Alle';

  @override
  String get remindersTabToday => 'Heute';

  @override
  String get remindersTabPending => 'Ausstehend';

  @override
  String get remindersTabCompleted => 'Abgeschlossen';

  @override
  String get remindersSearchHint => 'Erinnerungen suchen...';

  @override
  String get remindersDeleteTitle => 'Erinnerung löschen';

  @override
  String get remindersDeleteConfirm =>
      'Möchten Sie diese Erinnerung wirklich löschen?';

  @override
  String get remindersMarkDone => 'Als erledigt markieren';

  @override
  String get remindersSnooze => 'Schlummern';

  @override
  String get remindersCreateButton => 'Erinnerung erstellen';

  @override
  String get remindersCreateComingSoon =>
      'Neue Erinnerung erstellen – bald verfügbar!';

  @override
  String remindersEditComingSoon(Object title) {
    return '$title bearbeiten – bald verfügbar!';
  }

  @override
  String get remindersMarkedCompleted =>
      'Erinnerung als abgeschlossen markiert!';

  @override
  String get remindersSnoozedForHour => 'Erinnerung für 1 Stunde verschoben';

  @override
  String get remindersDeleted => 'Erinnerung gelöscht';

  @override
  String get remindersEmptyTitle => 'Keine Erinnerungen gefunden';

  @override
  String get remindersEmptySearchTitle =>
      'Keine Erinnerungen entsprechen Ihrer Suche';

  @override
  String get remindersEmptySubtitle =>
      'Erstellen Sie Ihre erste Erinnerung, um zu starten';

  @override
  String get remindersEmptySearchSubtitle =>
      'Versuchen Sie, Ihre Suchbegriffe anzupassen';

  @override
  String remindersSnoozedUntil(Object time) {
    return 'Verschoben bis $time';
  }

  @override
  String get remindersStatusDone => 'Erledigt';

  @override
  String get remindersStatusPending => 'Ausstehend';

  @override
  String get remindersStatusSnoozed => 'Verschoben';

  @override
  String get remindersStatusUnknown => 'Unbekannt';

  @override
  String remindersTimeHoursAgo(Object count) {
    return 'vor $count Stunden';
  }

  @override
  String remindersTimeMinutesAgo(Object count) {
    return 'vor $count Minuten';
  }

  @override
  String remindersTimeInHours(Object count) {
    return 'In $count Stunden';
  }

  @override
  String remindersTimeInMinutes(Object count) {
    return 'In $count Minuten';
  }

  @override
  String get remindersTimeNow => 'Jetzt';

  @override
  String get remindersAdherenceTitle => 'Medikamentenadhärenz';

  @override
  String get remindersAdherenceThisWeek => 'Diese Woche';

  @override
  String get remindersAdherenceThisMonth => 'Diesen Monat';

  @override
  String get remindersAdherenceOverall => 'Insgesamt';

  @override
  String get remindersAdherenceByMedication => 'Nach Medikament';

  @override
  String get remindersAdherenceTipsTitle => 'Adhärenz‑Tipps';

  @override
  String get remindersAdherenceTipsBody =>
      '• Stellen Sie Telefonerinnerungen für Medikamentenzeiten ein\n• Bewahren Sie Medikamente an einem gut sichtbaren Ort auf\n• Verwenden Sie einen Tablettenorganizer für tägliche Dosen\n• Verfolgen Sie Ihren Fortschritt, um motiviert zu bleiben';

  @override
  String get visitRecordingTitle => 'Besuch aufzeichnen';

  @override
  String get visitRecordingSave => 'Speichern';

  @override
  String get visitRecordingGenerateSummary => 'Zusammenfassung erstellen';

  @override
  String get visitRecordingDiscardRecording => 'Aufzeichnung verwerfen';

  @override
  String get visitRecordingCompleted => 'Aufzeichnung abgeschlossen!';

  @override
  String get visitRecordingSaveFailed =>
      'Aufzeichnung konnte nicht gespeichert werden';

  @override
  String get visitRecordingDiscarded => 'Aufzeichnung verworfen';

  @override
  String get visitRecordingNoRecording => 'Keine Aufzeichnung verfügbar';

  @override
  String get visitRecordingUploadingAudio => 'Audio wird hochgeladen...';

  @override
  String get visitRecordingProcessingTitle => '✅ Ihr Besuch wird verarbeitet';

  @override
  String get visitRecordingGoToHome => 'Zur Startseite';

  @override
  String visitRecordingUploadFailed(Object error) {
    return 'Audio‑Upload fehlgeschlagen: $error';
  }

  @override
  String get visitRecordingStopTitle => 'Aufzeichnung stoppen?';

  @override
  String get visitRecordingContinue => 'Aufzeichnung fortsetzen';

  @override
  String get visitRecordingStopAndDiscard => 'Stoppen und verwerfen';

  @override
  String get visitRecordingAudioPermissionTitle => 'Audioaufzeichnung';

  @override
  String get visitRecordingNotNow => 'Nicht jetzt';

  @override
  String get visitRecordingYesRecord => 'Ja, aufzeichnen';

  @override
  String get visitRecordingStatusReady => 'Bereit zur Aufzeichnung';

  @override
  String get visitRecordingStatusRecording => 'Aufzeichnung läuft...';

  @override
  String get visitRecordingStatusComplete => 'Aufzeichnung abgeschlossen';

  @override
  String get visitRecordingInstructionIdle =>
      'Tippen Sie, um Ihren Besuch aufzuzeichnen\nIhre Aufzeichnung bleibt privat und sicher';

  @override
  String get visitRecordingInstructionRecording => 'Aufzeichnung läuft...';

  @override
  String get visitRecordingInstructionComplete =>
      'Aufzeichnung abgeschlossen!\nTippen Sie auf Erstellen, um Ihre Besuchszusammenfassung zu verarbeiten';

  @override
  String get visitRecordingMicPermission =>
      'Mikrofonzugriff erforderlich. Bitte in Einstellungen > RemiMinder > Mikrofon aktivieren.';

  @override
  String get visitRecordingProcessingBody =>
      'Dies kann etwa 30–60 Sekunden dauern.\nSie können die App weiter nutzen. Wir informieren Sie, wenn es fertig ist.';

  @override
  String get visitRecordingStopConfirm =>
      'Möchten Sie die Aufzeichnung wirklich stoppen? Dieser Vorgang kann nicht rückgängig gemacht werden.';

  @override
  String get visitRecordingAudioConsentBody =>
      'Die Aufzeichnung hilft, Besuchsnotizen, Zusammenfassungen und Erinnerungen zu erstellen.\n\n• Audio wird nur aufgezeichnet, wenn Sie auf Aufzeichnen tippen\n• Aufzeichnungen werden sicher verarbeitet und von Ihrem Telefon gelöscht\n• Sie können die Aufzeichnung jederzeit stoppen\n\nMöchten Sie fortfahren?';

  @override
  String get visitDetailsTitle => 'Besuchsdetails';

  @override
  String get visitDetailsSummaryCardTitle =>
      'Gesundheits‑Besuchszusammenfassung';

  @override
  String get visitDetailsRefreshTooltip => 'Zusammenfassung aktualisieren';

  @override
  String get visitDetailsProcessingTitle =>
      'Besuchszusammenfassung wird vorbereitet...';

  @override
  String get visitDetailsProcessingSubtitle => 'Dies kann eine Minute dauern.';

  @override
  String get visitDetailsLoadFailed =>
      'Besuchszusammenfassung konnte nicht geladen werden';

  @override
  String get visitDetailsRetry => 'Erneut versuchen';

  @override
  String get visitDetailsUnavailable =>
      'Besuchszusammenfassung ist nicht verfügbar';

  @override
  String get visitDetailsSummarySection => 'Besuchszusammenfassung';

  @override
  String get visitDetailsFinalSummarySection => 'Besuchszusammenfassung';

  @override
  String get visitRecordingSaved =>
      'Aufnahme erfolgreich gespeichert! Sie können jetzt eine Zusammenfassung erstellen.';

  @override
  String get visitDetailsDecisionsSection => 'Klinische Entscheidungen';

  @override
  String get visitDetailsMedicationsSection => 'Medikamente';

  @override
  String get visitDetailsActionsSection => 'Nächste Schritte';

  @override
  String get historyTitle => 'Verlauf';

  @override
  String get historySearchHint => 'Ereignisse, Dokumente, Besuche suchen...';

  @override
  String get historyTabAll => 'ALLE';

  @override
  String get historyTabScannedDocs => 'GESCANNTE DOKUMENTE';

  @override
  String get historyTabLabResults => 'LABORERGEBNISSE';

  @override
  String get historyLoadFailed => 'Verlauf konnte nicht geladen werden';

  @override
  String get historyRetry => 'Erneut versuchen';

  @override
  String get historyVisitSummaryFallback => 'Besuchszusammenfassung';

  @override
  String get historyNoSummary => 'Keine Zusammenfassung verfügbar';

  @override
  String get historyUnknownDate => 'Unbekanntes Datum';

  @override
  String get historyUnknownTime => 'Unbekannte Uhrzeit';

  @override
  String get historyNoScannedDocs => 'Noch keine gescannten Dokumente';

  @override
  String get historyNoScannedDocsSubtitle =>
      'Gescannte Rezepte und Dokumente erscheinen hier';

  @override
  String get historyNoLabResults => 'Noch keine Laborergebnisse';

  @override
  String get historyNoLabResultsSubtitle =>
      'Laborergebnisse und Testberichte erscheinen hier';

  @override
  String historyNoEventsSearch(Object query) {
    return 'Keine Ereignisse für \"$query\" gefunden';
  }

  @override
  String get historyNoEvents => 'Noch keine Ereignisse';

  @override
  String get historyDocumentViewerSoon => 'Dokumentenanzeige kommt bald';

  @override
  String get historyFeatureSoon => 'Funktion kommt bald';

  @override
  String get notificationSettingsTitle => 'Benachrichtigungen';

  @override
  String get notificationSectionTypes => 'Benachrichtigungstypen';

  @override
  String get notificationMedicationTitle => 'Medikamentenerinnerungen';

  @override
  String get notificationMedicationSubtitle =>
      'Benachrichtigung, wenn es Zeit ist, Ihre Medikamente einzunehmen';

  @override
  String get notificationAppointmentTitle => 'Terminerinnerungen';

  @override
  String get notificationAppointmentSubtitle =>
      'Erinnerungen für kommende Arztbesuche und Tests';

  @override
  String get notificationHealthTipsTitle => 'Gesundheitstipps';

  @override
  String get notificationHealthTipsSubtitle =>
      'Tägliche Tipps zur Verwaltung Ihrer Gesundheitszustände';

  @override
  String get notificationCaregiverUpdatesTitle => 'Betreuer‑Updates';

  @override
  String get notificationCaregiverUpdatesSubtitle =>
      'Benachrichtigungen, wenn Betreuer Ihre Informationen ansehen';

  @override
  String get notificationEmergencyAlertsTitle => 'Notfallwarnungen';

  @override
  String get notificationEmergencyAlertsSubtitle =>
      'Kritische Gesundheitswarnungen und Notfallbenachrichtigungen';

  @override
  String get notificationDailySummaryTitle => 'Tägliche Zusammenfassung';

  @override
  String get notificationDailySummarySubtitle =>
      'Abendliche Zusammenfassung Ihrer täglichen Gesundheitsaktivitäten';

  @override
  String get notificationSectionTiming => 'Timing‑Einstellungen';

  @override
  String get notificationMorningReminder => 'Zeit der Morgen‑Erinnerung';

  @override
  String get notificationEveningReminder => 'Zeit der Abend‑Erinnerung';

  @override
  String get notificationAdvanceTime => 'Vorlaufzeit der Erinnerung';

  @override
  String get notificationAdvance5Min => '5 Min';

  @override
  String get notificationAdvance10Min => '10 Min';

  @override
  String get notificationAdvance15Min => '15 Min';

  @override
  String get notificationAdvance30Min => '30 Min';

  @override
  String get notificationAdvance60Min => '1 Stunde';

  @override
  String get notificationSectionSound => 'Ton & Hinweise';

  @override
  String get notificationSoundTitle => 'Ton‑Benachrichtigungen';

  @override
  String get notificationVibrationTitle => 'Vibration';

  @override
  String get notificationVolumeTitle => 'Lautstärke';

  @override
  String get notificationSectionTest => 'Benachrichtigungen testen';

  @override
  String get notificationSendTest => 'Testbenachrichtigung senden';

  @override
  String get notificationTestSent => 'Testbenachrichtigung gesendet!';

  @override
  String get languageSettingsChooseApp => 'App‑Sprache auswählen';

  @override
  String get languageSettingsChooseVisit => 'Besuchssprache auswählen';

  @override
  String get languageSettingsAppLabel => 'App‑Sprache';

  @override
  String get languageSettingsVisitLabel => 'Besuchssprache';

  @override
  String get languageSettingsSave => 'Einstellungen speichern';

  @override
  String get languageSettingsInfo =>
      'Das Ändern der Besuchssprache beeinflusst Spracherkennung und KI‑Zusammenfassungen.';

  @override
  String get languageSettingsLoadFailed =>
      'Spracheinstellungen konnten nicht geladen werden';

  @override
  String get languageSettingsSaveSuccess => 'Spracheinstellungen gespeichert';

  @override
  String get languageSettingsSaveFailed =>
      'Spracheinstellungen konnten nicht gespeichert werden';

  @override
  String get changePasswordTitle => 'Passwort ändern';

  @override
  String get changePasswordSubtitle =>
      'Aktualisieren Sie Ihr Passwort, um Ihr Konto zu schützen.';

  @override
  String get changePasswordCurrentLabel => 'Aktuelles Passwort';

  @override
  String get changePasswordCurrentHint =>
      'Geben Sie Ihr aktuelles Passwort ein';

  @override
  String get changePasswordNewLabel => 'Neues Passwort';

  @override
  String get changePasswordNewHint => 'Geben Sie Ihr neues Passwort ein';

  @override
  String get changePasswordConfirmLabel => 'Neues Passwort bestätigen';

  @override
  String get changePasswordConfirmHint =>
      'Geben Sie Ihr neues Passwort erneut ein';

  @override
  String get changePasswordUpdateButton => 'Passwort aktualisieren';

  @override
  String get changePasswordCurrentRequired =>
      'Bitte geben Sie Ihr aktuelles Passwort ein';

  @override
  String get changePasswordNewRequired =>
      'Bitte geben Sie ein neues Passwort ein';

  @override
  String get changePasswordTooShort =>
      'Das Passwort muss mindestens 8 Zeichen lang sein';

  @override
  String get changePasswordConfirmRequired =>
      'Bitte bestätigen Sie Ihr neues Passwort';

  @override
  String get changePasswordMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get changePasswordSuccess => 'Passwort erfolgreich aktualisiert';

  @override
  String get changePasswordNotAuthenticated => 'Benutzer nicht authentifiziert';

  @override
  String get changePasswordFailed => 'Passwortaktualisierung fehlgeschlagen';

  @override
  String get changePasswordWrongPassword => 'Aktuelles Passwort ist falsch';

  @override
  String get changePasswordWeakPassword => 'Passwort ist zu schwach';

  @override
  String get changePasswordRecentLogin => 'Bitte erneut anmelden und versuchen';

  @override
  String get changePasswordCheckConnection =>
      'Überprüfen Sie Ihre Internetverbindung';

  @override
  String get accountSecurityTitle => 'Kontosicherheit';

  @override
  String get accountSecurityChangePasswordTitle => 'Passwort ändern';

  @override
  String get accountSecurityChangePasswordSubtitle =>
      'Aktualisieren Sie Ihr Konto‑Passwort zur Sicherheit';

  @override
  String get accountSecurityChangePasswordButton => 'Passwort ändern';

  @override
  String get accountSecurityPrivacyTitle => 'Datenschutzeinstellungen';

  @override
  String get accountSecurityPrivacySubtitle =>
      'Verwalten Sie Ihre Datenfreigabe‑Einstellungen';

  @override
  String get accountSecurityPrivacyButton => 'Datenschutz verwalten';

  @override
  String get accountSecurityDialogTitle => 'Passwort ändern';

  @override
  String accountSecurityDialogBody(Object provider) {
    return 'Sie haben sich mit $provider angemeldet. Bitte ändern Sie Ihr Passwort in Ihrem $provider-Konto.';
  }

  @override
  String get accountSecurityDialogOk => 'OK';

  @override
  String get profileAccountDetailsTitle => 'Kontodetails';

  @override
  String get profileAccountDetailsSubtitle => 'Profilinformationen anzeigen';

  @override
  String get profileAccountSecurityTitle => 'Kontosicherheit';

  @override
  String get profileAccountSecuritySubtitle =>
      'Passwort und Datenschutz verwalten';

  @override
  String get profileAppLanguageLabel => 'App‑Sprache';

  @override
  String get profilePreferredSummaryLanguageLabel =>
      'Bevorzugte Zusammenfassungssprache';

  @override
  String get profileDefaultVisitLanguageLabel => 'Standard‑Besuchssprache';

  @override
  String get profileTimezoneLabel => 'Zeitzone';

  @override
  String get profileCountryOptionalLabel => 'Land (optional)';

  @override
  String get profileCountryOrRegionLabel => 'Land oder Region';

  @override
  String get profileNotificationsTitle => 'Benachrichtigungen';

  @override
  String get profileNotificationsMobile => 'Mobil';

  @override
  String get profileNotificationsEmail => 'E‑Mail';

  @override
  String get profileUpgrade => 'Upgrade';

  @override
  String get profileSignOut => 'Abmelden';

  @override
  String get profileNotSet => 'Nicht festgelegt';

  @override
  String profileSignOutFailed(Object error) {
    return 'Abmelden fehlgeschlagen: $error';
  }

  @override
  String get upgradeBenefitsTitle => 'Upgrade‑Vorteile';

  @override
  String get upgradeUnlockTitle => 'Premium‑Pflege freischalten';

  @override
  String get upgradeSubtitle => 'Mehr beruhigende Sicherheit.';

  @override
  String get upgradeBenefitUnlimitedCaregivers => 'Unbegrenzte Betreuer';

  @override
  String get upgradeBenefitHealthTrends => 'Erweiterte Gesundheitstrends';

  @override
  String get upgradeBenefitPrioritySupport => 'Priorisierter Support';

  @override
  String get upgradeMonthlyPlan => 'Monatlicher Plan';

  @override
  String get upgradeAnnualPlan => 'Jahresplan';

  @override
  String get upgradePerMonth => '/ Monat';

  @override
  String get upgradePerYear => '/ Jahr';

  @override
  String get upgradeCancelAnytime => 'Jederzeit kündbar';

  @override
  String get upgradeContinuePayment => 'Weiter zur Zahlung';

  @override
  String get upgradePaymentComingSoon => 'Zahlungsablauf kommt bald';

  @override
  String get caregiversTitle => 'Betreuer';

  @override
  String get caregiversMyCaregivers => 'Meine Betreuer';

  @override
  String get caregiversEmptyTitle => 'Noch keine Betreuer';

  @override
  String get caregiversEmptySubtitle =>
      'Laden Sie Familie oder Freunde ein,\num bei der Gesundheitsversorgung zu helfen';

  @override
  String get caregiversInviteFirst => 'Ersten Betreuer einladen';

  @override
  String get caregiversLoadFailed => 'Betreuer konnten nicht geladen werden';

  @override
  String get caregiversResendInvite => 'Einladung erneut senden';

  @override
  String get caregiversCancel => 'Abbrechen';

  @override
  String get caregiversActiveLabel => 'Aktiver Betreuer';

  @override
  String caregiversPermissionsCount(Object count) {
    return '$count Berechtigungen';
  }

  @override
  String caregiversActivityCount(Object count) {
    return '$count Aktivitäten';
  }

  @override
  String caregiversLastActive(Object time) {
    return 'Zuletzt aktiv: $time';
  }

  @override
  String get caregiversStatusActive => 'Aktiv';

  @override
  String get caregiversStatusPending => 'Ausstehend';

  @override
  String get caregiversStatusDeclined => 'Abgelehnt';

  @override
  String get caregiversStatusUnknown => 'Unbekannt';

  @override
  String get caregiversInviteTitle => 'Betreuer einladen';

  @override
  String get caregiversFullNameLabel => 'Vollständiger Name';

  @override
  String get caregiversFullNameHint =>
      'Geben Sie den vollständigen Namen des Betreuers ein';

  @override
  String get caregiversFullNameRequired => 'Bitte geben Sie einen Namen ein';

  @override
  String get caregiversEmailLabel => 'E‑Mail‑Adresse';

  @override
  String get caregiversEmailHint => 'caregiver@example.com';

  @override
  String get caregiversEmailRequired => 'Bitte geben Sie eine E‑Mail ein';

  @override
  String get caregiversEmailInvalid =>
      'Bitte geben Sie eine gültige E‑Mail ein';

  @override
  String get caregiversRelationshipLabel => 'Beziehung';

  @override
  String get caregiversSendInvitation => 'Einladung senden';

  @override
  String caregiversInvitationSent(Object email) {
    return 'Einladung an $email gesendet';
  }

  @override
  String caregiversInvitationResent(Object email) {
    return 'Einladung erneut an $email gesendet';
  }

  @override
  String get caregiversCancelInvitationTitle => 'Einladung abbrechen';

  @override
  String get caregiversCancelInvitationConfirm =>
      'Möchten Sie diese Einladung wirklich abbrechen?';

  @override
  String get caregiversKeep => 'Behalten';

  @override
  String get caregiversCancelInvitationAction => 'Einladung abbrechen';

  @override
  String get caregiversDone => 'Fertig';

  @override
  String get caregiversAccessRemoved => 'Zugriff entfernt';

  @override
  String caregiversPermissionTitle(Object name) {
    return 'Berechtigungen für $name';
  }

  @override
  String get caregiversPermissionViewMedications => 'Medikamente anzeigen';

  @override
  String get caregiversPermissionViewMedicationsDesc =>
      'Kann Medikationspläne und Verlauf sehen';

  @override
  String get caregiversPermissionViewVisits => 'Besuchsaufzeichnungen anzeigen';

  @override
  String get caregiversPermissionViewVisitsDesc =>
      'Kann auf Besuchszusammenfassungen und Transkripte zugreifen';

  @override
  String get caregiversPermissionViewHealthData => 'Gesundheitsdaten anzeigen';

  @override
  String get caregiversPermissionViewHealthDataDesc =>
      'Kann Gesundheitsmetriken und Trends sehen';

  @override
  String get caregiversPermissionEditMedications => 'Medikamente bearbeiten';

  @override
  String get caregiversPermissionEditMedicationsDesc =>
      'Kann Medikationspläne ändern';

  @override
  String get caregiversPermissionManageEmergency => 'Notfallkontakte verwalten';

  @override
  String get caregiversPermissionManageEmergencyDesc =>
      'Kann Notfallkontakt‑Einstellungen ändern';

  @override
  String get caregiversPermissionReceiveAlerts => 'Warnungen erhalten';

  @override
  String get caregiversPermissionReceiveAlertsDesc =>
      'Erhält Benachrichtigungen über wichtige Gesundheitsereignisse';

  @override
  String get caregiversRelationshipFamily => 'Familienmitglied';

  @override
  String get caregiversRelationshipFriend => 'Freund';

  @override
  String get caregiversRelationshipSpouse => 'Ehepartner/Partner';

  @override
  String get caregiversRelationshipParent => 'Elternteil';

  @override
  String get caregiversRelationshipChild => 'Kind';

  @override
  String get caregiversRelationshipHealthcare => 'Gesundheitsfachkraft';

  @override
  String get caregiversRelationshipCaregiver => 'Betreuer';

  @override
  String get caregiversRelationshipOther => 'Andere';

  @override
  String caregiversLastActiveDays(Object count) {
    return 'vor $count Tagen';
  }

  @override
  String caregiversLastActiveHours(Object count) {
    return 'vor $count Std.';
  }

  @override
  String caregiversLastActiveMinutes(Object count) {
    return 'vor $count Min.';
  }

  @override
  String get caregiversLastActiveJustNow => 'Gerade eben';

  @override
  String commonComingSoon(Object feature) {
    return '$feature kommt bald';
  }

  @override
  String get privacyTitle => 'Datenschutzeinstellungen';

  @override
  String get privacyDataSharing => 'Datenfreigabe';

  @override
  String get privacyNoCaregiver => 'Noch kein Betreuer hinzugefügt';

  @override
  String get privacyAllowCaregiverSummaries =>
      'Betreuern erlauben, Zusammenfassungen zu sehen';

  @override
  String get privacyAllowCaregiverMedications =>
      'Betreuern erlauben, Medikamente zu sehen';

  @override
  String get privacyAllowCaregiverReminders =>
      'Betreuern erlauben, Erinnerungen zu sehen';

  @override
  String get privacyAllowAiImprove =>
      'KI darf meine Daten zur Produktverbesserung verwenden';

  @override
  String get privacyCaregiverSharingEnabled => 'Betreuerfreigabe aktiviert';

  @override
  String get privacyCaregiverSharingDisabled => 'Betreuerfreigabe deaktiviert';

  @override
  String get privacyCommunicationConsent => 'Kommunikation & Einwilligung';

  @override
  String get privacyAllowEmailNotifications =>
      'E‑Mail‑Benachrichtigungen erlauben';

  @override
  String get privacyAllowSmsNotifications => 'SMS‑Benachrichtigungen erlauben';

  @override
  String get privacyAllowPushNotifications =>
      'Push‑Benachrichtigungen erlauben';

  @override
  String get privacyDataControl => 'Datenkontrolle';

  @override
  String get privacyExportData => 'Meine Daten exportieren';

  @override
  String get privacyDataExportLabel => 'Datenexport';

  @override
  String get privacyDeleteRecords =>
      'Alle meine medizinischen Datensätze löschen';

  @override
  String get privacyDeleteRecordsTitle => 'Medizinische Datensätze löschen';

  @override
  String get privacyDeleteRecordsBody =>
      'Dies löscht dauerhaft alle Ihre medizinischen Datensätze. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get privacyDeleteRecordsAction => 'Datensätze löschen';

  @override
  String get privacyDeleteAccount => 'Mein Konto löschen';

  @override
  String get privacyDeleteAccountTitle => 'Konto löschen';

  @override
  String get privacyDeleteAccountBody =>
      'Dies löscht dauerhaft Ihr Konto und alle zugehörigen Daten. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get privacyDeleteAccountAction => 'Konto löschen';

  @override
  String get privacyLegal => 'Rechtliches';

  @override
  String get privacyViewPolicy => 'Datenschutzerklärung anzeigen';

  @override
  String get privacyViewTerms => 'Nutzungsbedingungen anzeigen';

  @override
  String get privacyTermsTitle => 'Nutzungsbedingungen';

  @override
  String get privacyTermsBody =>
      'Nutzungsbedingungen für RemiMinder\n\n1. Annahme der Bedingungen\nDurch die Nutzung von RemiMinder stimmen Sie diesen Bedingungen zu.\n\n2. Nutzung des Dienstes\nRemiMinder wurde entwickelt, um bei der Verwaltung von Gesundheitsversorgung und Medikamentenerinnerungen zu helfen.\n\n3. Datenschutz\nIhre Privatsphäre ist uns wichtig. Alle Gesundheitsdaten werden sicher behandelt.\n\nFür die vollständigen Nutzungsbedingungen besuchen Sie bitte unsere Website.';

  @override
  String get privacyPolicyTitle => 'Datenschutzerklärung';

  @override
  String get privacyPolicyBody =>
      'Datenschutzerklärung für RemiMinder\n\n1. Informationen, die wir erfassen\nWir erfassen die von Ihnen bereitgestellten Informationen und Nutzungsdaten, um unseren Service zu verbessern.\n\n2. Wie wir Informationen verwenden\nInformationen werden genutzt, um Gesundheitsmanagement‑Dienste bereitzustellen.\n\n3. Informationsweitergabe\nWir verkaufen Ihre persönlichen Informationen nicht.\n\nFür die vollständige Datenschutzerklärung besuchen Sie bitte unsere Website.';

  @override
  String get healthDashboardTitle => 'Gesundheitsdashboard';

  @override
  String get healthDashboardLast7Days => 'Letzte 7 Tage';

  @override
  String get healthDashboardLast30Days => 'Letzte 30 Tage';

  @override
  String get healthDashboardLast90Days => 'Letzte 90 Tage';

  @override
  String get healthDashboardBloodPressure => 'Blutdruck';

  @override
  String get healthDashboardWeightTrend => 'Gewichtstrend';

  @override
  String get healthDashboardMedicationAdherence => 'Medikamentenadhärenz';

  @override
  String get healthDashboardKeyMetrics => 'Schlüsselmetriken';

  @override
  String get healthDashboardUnitMmhg => 'mmHg';

  @override
  String get healthDashboardBpTrend => '+2 Punkte diese Woche';

  @override
  String get healthDashboardWeight => 'Gewicht';

  @override
  String get healthDashboardUnitLbs => 'lbs';

  @override
  String get healthDashboardWeightTrendText => 'Diese Woche -1.4 lbs';

  @override
  String get healthDashboardMedAdherence => 'Medikamentenadhärenz';

  @override
  String get healthDashboardThisWeek => 'diese Woche';

  @override
  String get healthDashboardGoodProgress => 'Guter Fortschritt';

  @override
  String get healthDashboardHeartRate => 'Herzfrequenz';

  @override
  String get healthDashboardUnitBpm => 'bpm';

  @override
  String get healthDashboardRestingAverage => 'Ruhedurchschnitt';

  @override
  String get healthDashboardInsightsTitle => 'Gesundheits‑Einblicke';

  @override
  String get healthDashboardInsightBpTitle => 'Blutdrucktrend';

  @override
  String get healthDashboardInsightBpBody =>
      'Ihr systolischer Druck war stabil mit einem leichten Abwärtstrend. Weiter so!';

  @override
  String get healthDashboardInsightWeightTitle => 'Gewichtsmanagement';

  @override
  String get healthDashboardInsightWeightBody =>
      'Konstante Gewichtsabnahme von 1.4 lbs diese Woche. Sie sind auf Kurs für Ihr Ziel!';

  @override
  String get healthDashboardInsightAdherenceTitle => 'Medikamentenadhärenz';

  @override
  String get healthDashboardInsightAdherenceBody =>
      '86% Adhärenz diese Woche. Erwägen Sie, Medikamentenerinnerungen einzurichten, um 100% zu erreichen.';

  @override
  String get healthDashboardInsightCheckupTitle => 'Nächste Untersuchung';

  @override
  String get healthDashboardInsightCheckupBody =>
      'Ihr nächster Kardiologie‑Termin ist in 3 Monaten fällig. Planen Sie ihn bald.';

  @override
  String get healthDashboardRecentMeasurements => 'Neueste Messungen';

  @override
  String get healthDashboardRecentBpValue => '126/81 mmHg';

  @override
  String get healthDashboardRecentBpTime => 'Heute, 08:30 Uhr';

  @override
  String get healthDashboardRecentWeightValue => '163.8 lbs';

  @override
  String get healthDashboardRecentWeightTime => 'Heute, 07:45 Uhr';

  @override
  String get healthDashboardRecentHeartRateValue => '72 bpm';

  @override
  String get healthDashboardRecentHeartRateTime => 'Gestern, 08:15 Uhr';

  @override
  String get healthDashboardAddMeasurement => 'Messung hinzufügen';

  @override
  String get healthDashboardAddMeasurementSoon =>
      'Neue Messung hinzufügen - kommt bald!';

  @override
  String get emergencyContactsTitle => 'Notfallkontakte';

  @override
  String get emergencySosLabel => 'NOTFALL SOS';

  @override
  String get emergencySosSubtitle => 'Alle Notfallkontakte anrufen';

  @override
  String get emergencyMedicalAlertTitle => 'Medizinische Warninformationen';

  @override
  String get emergencyMedicalAlertBody =>
      'Herzpatient, allergisch gegen Penicillin, nimmt täglich Medikamente';

  @override
  String get emergencySosDialogTitle => 'Notfall‑SOS';

  @override
  String get emergencySosDialogBody =>
      'Dies ruft ALLE Notfallkontakte gleichzeitig an. Sind Sie sicher?';

  @override
  String get emergencySosDialogNote =>
      'Notfallkontakte werden in Prioritätsreihenfolge angerufen';

  @override
  String get emergencySosDialogAction => 'Notfallkontakte anrufen';

  @override
  String get emergencySosActivated =>
      'Notfall‑SOS aktiviert! Alle Kontakte werden angerufen...';

  @override
  String emergencyCallingContact(Object name) {
    return 'Rufe $name an...';
  }

  @override
  String get emergencyAddContactTitle => 'Notfallkontakt hinzufügen';

  @override
  String get emergencyContactFullNameLabel => 'Vollständiger Name';

  @override
  String get emergencyContactFullNameHint => 'Kontaktname eingeben';

  @override
  String get emergencyContactPhoneLabel => 'Telefonnummer';

  @override
  String get emergencyContactPhoneHint => '(555) 123-4567';

  @override
  String get emergencyContactTypeLabel => 'Kontakttyp';

  @override
  String get emergencyContactRelationshipLabel => 'Beziehung';

  @override
  String get emergencyContactRelationshipHint =>
      'Ehepartner, Kind, Elternteil usw.';

  @override
  String get emergencyAddContactAction => 'Kontakt hinzufügen';

  @override
  String emergencyEditContactComingSoon(Object name) {
    return '$name bearbeiten – kommt bald!';
  }

  @override
  String get emergencyDeleteContactTitle => 'Kontakt löschen';

  @override
  String emergencyDeleteContactBody(Object name) {
    return 'Möchten Sie $name wirklich aus den Notfallkontakten entfernen?';
  }

  @override
  String get emergencyContactRemoved => 'Kontakt entfernt';

  @override
  String emergencyContactAdded(Object name) {
    return '$name zu Notfallkontakten hinzugefügt';
  }

  @override
  String get emergencyEditMedicalInfoComingSoon =>
      'Medizinische Informationen bearbeiten – kommt bald!';

  @override
  String get emergencyContactTypeFamily => 'Familie';

  @override
  String get emergencyContactTypeMedical => 'Medizinisch';

  @override
  String get emergencyContactTypeFriend => 'Freund';

  @override
  String get emergencyContactTypeOther => 'Andere';

  @override
  String get commonEdit => 'Bearbeiten';

  @override
  String get careTeamTitle => 'Betreuungsteam';

  @override
  String get careTeamSubtitle =>
      'Sie haben die Kontrolle. Prüfen Sie unten Ihre Freigabeberechtigungen.';

  @override
  String get careTeamEmptyCaregivers => 'Noch keine Betreuer hinzugefügt';

  @override
  String get careTeamActiveCaregivers => 'Aktive Betreuer';

  @override
  String get careTeamPendingInvitations => 'Ausstehende Einladungen';

  @override
  String get careTeamInviteTitle => 'Betreuer einladen';

  @override
  String get careTeamInviteNameLabel => 'Name';

  @override
  String get careTeamInviteNameHint =>
      'Vollständigen Namen des Betreuers eingeben';

  @override
  String get careTeamInviteEmailLabel => 'E‑Mail';

  @override
  String get careTeamInviteEmailHint => 'E‑Mail‑Adresse des Betreuers eingeben';

  @override
  String get careTeamInviteRelationshipLabel => 'Beziehung';

  @override
  String get careTeamInviteRelationshipHint =>
      'z. B. Sohn, Tochter, Freund, Pflegekraft';

  @override
  String get careTeamInviteRequiredFields =>
      'E‑Mail und Rolle sind erforderlich';

  @override
  String get careTeamInviteSend => 'Einladung senden';

  @override
  String get careTeamAccessUpdated => 'Zugriff erfolgreich aktualisiert';

  @override
  String get careTeamAccessUpdateFailed =>
      'Zugriff konnte nicht aktualisiert werden. Bitte versuchen Sie es erneut.';

  @override
  String get careTeamRemoveTitle => 'Betreuer entfernen?';

  @override
  String get careTeamRemoveBody =>
      'Möchten Sie diesen Betreuer wirklich entfernen? Der Zugriff wird sofort entzogen.';

  @override
  String get careTeamRemoveConfirm => 'Entfernen';

  @override
  String get careTeamRemoving => 'Betreuer wird entfernt...';

  @override
  String get careTeamRemoveFailed =>
      'Betreuer konnte nicht entfernt werden. Bitte versuchen Sie es erneut.';

  @override
  String get careTeamManageAccessTitle => 'Zugriff verwalten';

  @override
  String get careTeamManageAccessSubtitle =>
      'Berechtigungen aktualisieren oder Zugriff entfernen.';

  @override
  String get careTeamUpdatingAccess => 'Zugriff wird aktualisiert...';

  @override
  String get careTeamAccessView => 'Zugriff ansehen';

  @override
  String get careTeamAccessFull => 'Voller Zugriff';

  @override
  String get careTeamAccessViewOnly => 'Nur ansehen';

  @override
  String get careTeamResendingInvite => 'Einladung wird erneut gesendet...';

  @override
  String get careTeamInviteResent => 'Einladung erneut gesendet';

  @override
  String get careTeamInviteResendFailed =>
      'Einladung konnte nicht erneut gesendet werden';

  @override
  String get careTeamCancelingInvite => 'Einladung wird abgebrochen...';

  @override
  String get careTeamInviteCanceled => 'Einladung abgebrochen';

  @override
  String get careTeamInviteCancelFailed =>
      'Einladung konnte nicht abgebrochen werden';

  @override
  String get careTeamInvitationPending => 'Einladung ausstehend';

  @override
  String get careTeamResend => 'Erneut senden';

  @override
  String get careTeamManageButton => 'Verwalten';

  @override
  String get careTeamInviteTileTitle => 'Betreuer einladen';

  @override
  String get careTeamInviteTileSubtitle =>
      'Zugriff auf Ihre Gesundheitsinformationen teilen';

  @override
  String get cameraSave => 'Speichern';

  @override
  String get cameraModeRx => 'Rx';

  @override
  String get cameraModeLab => 'Lab';

  @override
  String get cameraModeMed => 'Med';

  @override
  String get cameraTapToCapture => 'Tippen zum Aufnehmen';

  @override
  String get cameraProcessingShort => 'Wird verarbeitet...';

  @override
  String get cameraProcessingImage => 'Bild wird verarbeitet...';

  @override
  String get cameraScanSuccessful => 'Scan erfolgreich!';

  @override
  String get cameraShare => 'Teilen';

  @override
  String get cameraNotReady =>
      'Kamera nicht bereit. Bitte versuchen Sie es erneut.';

  @override
  String cameraCaptureFailed(Object error) {
    return 'Bildaufnahme fehlgeschlagen: $error';
  }

  @override
  String get cameraUploadSuccess => 'Bild erfolgreich hochgeladen!';

  @override
  String cameraUploadFailed(Object error) {
    return 'Bild‑Upload fehlgeschlagen: $error';
  }

  @override
  String get cameraScanSaved => 'Scan erfolgreich gespeichert!';

  @override
  String get cameraShareComingSoon => 'Teilen‑Funktion – kommt bald!';

  @override
  String get cameraPrescriptionScanned => 'Rezept erfolgreich gescannt';

  @override
  String get cameraLabReportProcessed => 'Laborbericht erfolgreich verarbeitet';

  @override
  String get cameraMedicationExtracted =>
      'Medikamenteninformationen extrahiert';

  @override
  String get cameraConsentTitle => 'Dokumentenscan';

  @override
  String get cameraConsentBody =>
      'Die Kamera hilft beim Scannen medizinischer Dokumente wie Rezepte und Laborberichte.\n\n• Die Kamera wird nur verwendet, wenn Sie den Scan auswählen\n• Bilder werden sicher verarbeitet und von Ihrem Telefon gelöscht\n• Fotos werden niemals in Ihrer Gerätegalerie gespeichert\n\nMöchten Sie fortfahren?';

  @override
  String get cameraConsentNotNow => 'Nicht jetzt';

  @override
  String get cameraConsentConfirm => 'Ja, scannen';

  @override
  String get cameraSectionPrescriptionDetails => 'Rezeptdetails';

  @override
  String get cameraLabelMedication => 'Medikament';

  @override
  String get cameraValueLisinopril => 'Lisinopril';

  @override
  String get cameraLabelDosage => 'Dosierung';

  @override
  String get cameraValue10mg => '10mg';

  @override
  String get cameraLabelFrequency => 'Häufigkeit';

  @override
  String get cameraValueOnceDaily => 'Einmal täglich';

  @override
  String get cameraLabelQuantity => 'Menge';

  @override
  String get cameraValue90Tablets => '90 Tabletten';

  @override
  String get cameraLabelRefills => 'Nachfüllungen';

  @override
  String get cameraValue3Remaining => '3 verbleibend';

  @override
  String get cameraSectionPrescriberInfo => 'Verschreiber‑Informationen';

  @override
  String get cameraLabelDoctor => 'Arzt';

  @override
  String get cameraValueDrSarahJohnson => 'Dr. Sarah Johnson';

  @override
  String get cameraLabelLicense => 'Lizenz';

  @override
  String get cameraValueLicenseId => 'MD123456';

  @override
  String get cameraLabelDate => 'Datum';

  @override
  String get cameraValueDec122024 => '12. Dez 2024';

  @override
  String get cameraSectionPharmacyInfo => 'Apothekeninformationen';

  @override
  String get cameraLabelPharmacy => 'Apotheke';

  @override
  String get cameraValueCityMedicalPharmacy => 'City‑Medizinische Apotheke';

  @override
  String get cameraLabelPhone => 'Telefon';

  @override
  String get cameraValuePhoneSample => '(555) 123-4567';

  @override
  String get cameraLabelAddress => 'Adresse';

  @override
  String get cameraValuePharmacyAddress => '123 Hauptstr., Stadt, ST 12345';

  @override
  String get cameraSectionPatientInfo => 'Patienteninformationen';

  @override
  String get cameraLabelName => 'Name';

  @override
  String get cameraValueJohnDoe => 'John Doe';

  @override
  String get cameraLabelDob => 'Geburtsdatum';

  @override
  String get cameraValueDobSample => '01/15/1985';

  @override
  String get cameraLabelId => 'ID';

  @override
  String get cameraValuePatientId => 'P123456789';

  @override
  String get cameraSectionTestResults => 'Testergebnisse';

  @override
  String get cameraLabelCholesterolTotal => 'Cholesterin (gesamt)';

  @override
  String get cameraValueCholesterolTotal => '185 mg/dL';

  @override
  String get cameraRefCholesterolTotal => 'Normal: <200';

  @override
  String get cameraLabelHdlCholesterol => 'HDL‑Cholesterin';

  @override
  String get cameraValueHdl => '45 mg/dL';

  @override
  String get cameraRefHdl => 'Normal: >40';

  @override
  String get cameraLabelLdlCholesterol => 'LDL‑Cholesterin';

  @override
  String get cameraValueLdl => '120 mg/dL';

  @override
  String get cameraRefLdl => 'Normal: <130';

  @override
  String get cameraLabelTriglycerides => 'Triglyzeride';

  @override
  String get cameraValueTriglycerides => '150 mg/dL';

  @override
  String get cameraRefTriglycerides => 'Normal: <150';

  @override
  String get cameraSectionLabInfo => 'Laborinformationen';

  @override
  String get cameraLabelLab => 'Labor';

  @override
  String get cameraValueCityMedicalLabs => 'City‑Medizinische Labore';

  @override
  String get cameraLabelReportDate => 'Berichtsdatum';

  @override
  String get cameraValueDec102024 => '10. Dez 2024';

  @override
  String get cameraLabelCollected => 'Entnommen';

  @override
  String get cameraValueDec092024 => '9. Dez 2024';

  @override
  String get cameraSectionMedicationInfo => 'Medikamenteninformationen';

  @override
  String get cameraLabelStrength => 'Stärke';

  @override
  String get cameraLabelForm => 'Darreichungsform';

  @override
  String get cameraValueTablet => 'Tablette';

  @override
  String get cameraSectionUsageInstructions => 'Anwendungshinweise';

  @override
  String get cameraLabelDirections => 'Anweisungen';

  @override
  String get cameraValueDirectionsSample =>
      'Einmal täglich eine Tablette oral einnehmen';

  @override
  String get cameraLabelPurpose => 'Zweck';

  @override
  String get cameraValuePurposeSample => 'Blutdruckmanagement';

  @override
  String get cameraLabelStorage => 'Aufbewahrung';

  @override
  String get cameraValueStorageSample => 'Bei Raumtemperatur lagern';

  @override
  String get cameraSectionAdditionalInfo => 'Zusätzliche Informationen';

  @override
  String get cameraLabelManufacturer => 'Hersteller';

  @override
  String get cameraValueManufacturerSample => 'Generische Pharmazeutika';

  @override
  String get cameraLabelLotNumber => 'Chargennummer';

  @override
  String get cameraValueLotNumberSample => 'LP2024001';

  @override
  String get cameraLabelExpiration => 'Ablaufdatum';

  @override
  String get cameraValueExpirationSample => '06/2026';

  @override
  String get accountDetailsTitle => 'Kontodetails';

  @override
  String get accountDetailsNameLabel => 'Name';

  @override
  String get accountDetailsEmailLabel => 'E‑Mail';

  @override
  String get accountDetailsAccountTypeLabel => 'Kontotyp';

  @override
  String get accountDetailsAccountTypePatient => 'Patient';

  @override
  String get accountDetailsAccountTypeCaregiver => 'Betreuer';

  @override
  String get accountDetailsNotSet => 'Nicht festgelegt';

  @override
  String get accountDetailsPhoneLabel => 'Telefon';

  @override
  String get accountDetailsPhoneEdit => 'Bearbeiten';

  @override
  String get accountDetailsPhoneAdd => 'Hinzufügen';

  @override
  String get accountDetailsPlanLabel => 'Plan';

  @override
  String get accountDetailsPlanFree => 'Kostenlos';

  @override
  String get accountDetailsPlanPremium => 'Premium';

  @override
  String get accountDetailsPlanUpgrade => 'Upgrade';

  @override
  String get accountDetailsPlanManage => 'Verwalten';

  @override
  String get accountDetailsUsageLabel => 'Nutzung';

  @override
  String accountDetailsUsageFreePlan(Object limit, Object used) {
    return 'Kostenloser Plan — $used / $limit Zusammenfassungen genutzt';
  }

  @override
  String get accountDetailsUsageUnlimited => 'Unbegrenzt';

  @override
  String get accountDetailsPhoneEditTitle => 'Telefonnummer bearbeiten';

  @override
  String get accountDetailsPhoneHint => '+1 (555) 123-4567';

  @override
  String get accountDetailsPhoneMinLengthError =>
      'Die Telefonnummer muss mindestens 8 Zeichen lang sein';

  @override
  String get accountDetailsPhoneUpdated =>
      'Telefonnummer erfolgreich aktualisiert';

  @override
  String accountDetailsPhoneUpdateFailed(Object error) {
    return 'Telefonnummer konnte nicht aktualisiert werden: $error';
  }

  @override
  String get commonSave => 'Speichern';
}
