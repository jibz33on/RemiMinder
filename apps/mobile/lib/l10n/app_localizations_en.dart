// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'RemiMinder';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get profileSettings => 'Profile Settings';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClose => 'Close';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languageMandarin => 'Mandarin';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageFrench => 'French';

  @override
  String get languageGerman => 'German';

  @override
  String get countryUnitedStates => 'United States';

  @override
  String get countryCanada => 'Canada';

  @override
  String get countryUnitedKingdom => 'United Kingdom';

  @override
  String get countryGermany => 'Germany';

  @override
  String get countryIndia => 'India';

  @override
  String get welcomeTitle => 'Welcome to RemiMinder';

  @override
  String get welcomeSubtitle => 'Smart AI for Health & Care Coordination';

  @override
  String get welcomeDescription =>
      'Your intelligent companion for medication reminders, appointment tracking, and care coordination. Never miss an important health moment again.';

  @override
  String get welcomeGetStarted => 'Get Started';

  @override
  String get roleChooseYourRole => 'Choose Your Context';

  @override
  String get roleSelectHowYouUse => 'Select how you want to use RemiMinder';

  @override
  String get rolePatient => 'Patient context';

  @override
  String get rolePatientDescription =>
      'Manage your own medications, appointments, and health records';

  @override
  String get roleCaregiver => 'Caregiver context';

  @override
  String get roleCaregiverDescription =>
      'Help manage medications and care for family members or patients';

  @override
  String get roleContinue => 'Continue';

  @override
  String get onboardingAppLanguageTitle => 'Choose your app language';

  @override
  String get onboardingAppLanguageSubtitle => 'This updates the UI language.';

  @override
  String get onboardingCountryTitle => 'Select your country or region';

  @override
  String get onboardingCountrySubtitle =>
      'Optional, helps tailor the experience.';

  @override
  String get onboardingTimezoneTitle => 'Confirm your timezone';

  @override
  String onboardingTimezoneDetected(Object timezone) {
    return 'We detected: $timezone';
  }

  @override
  String get onboardingTimezoneLabel => 'Timezone';

  @override
  String get onboardingTimezoneConfirm => 'Confirm';

  @override
  String get onboardingVisitLanguageTitle => 'Choose your visit language';

  @override
  String get onboardingVisitLanguageSubtitle =>
      'This will be used for recording visits and generating summaries';

  @override
  String get loginBrandName => 'RemiMinder.ai';

  @override
  String get loginContinueWithGoogle => 'Continue with Google';

  @override
  String get loginContinueWithApple => 'Continue with Apple';

  @override
  String get loginContinueWithEmail => 'Continue with Email';

  @override
  String get loginCreateAccount => 'Create an Account';

  @override
  String get loginForgotPassword => 'Forgot Password?';

  @override
  String get loginSignInWithEmailTitle => 'Sign in with Email';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'Enter your email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginRememberMe => 'Remember me';

  @override
  String get loginSignIn => 'Sign In';

  @override
  String get loginFillAllFields => 'Please fill in all fields';

  @override
  String get loginAuthFailed => 'Authentication failed. Please try again.';

  @override
  String get loginInvalidEmailOrPassword =>
      'Invalid email or password. Please check your credentials and try again.';

  @override
  String get loginEmailNotConfirmed =>
      'Please check your email and confirm your account before signing in.';

  @override
  String get loginUserNotFound => 'No account found with this email address.';

  @override
  String get loginConnectionError =>
      'Connection error. Please check your internet connection and try again.';

  @override
  String get loginRequestTimedOut => 'Request timed out. Please try again.';

  @override
  String get loginSignInFailedGeneric =>
      'Sign in failed. Please try again or contact support if the problem persists.';

  @override
  String get loginGoogleSignInFailed => 'Google Sign In failed';

  @override
  String loginGoogleSignInFailedWithError(Object error) {
    return 'Google Sign In failed: $error';
  }

  @override
  String get loginAppleSignInComingSoon => 'Apple Sign In - Coming Soon!';

  @override
  String get loginContinueWithoutSigningIn => 'Continue without signing in';

  @override
  String get loginBypassPatient => 'Patient';

  @override
  String get loginBypassCaregiver => 'Caregiver';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'Join RemiMinder to get started';

  @override
  String get registerFirstNameLabel => 'First Name';

  @override
  String get registerFirstNameHint => 'John';

  @override
  String get registerFirstNameRequired => 'Please enter your first name';

  @override
  String get registerLastNameLabel => 'Last Name';

  @override
  String get registerLastNameHint => 'Doe';

  @override
  String get registerLastNameRequired => 'Please enter your last name';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerEmailHint => 'john.doe@example.com';

  @override
  String get registerEmailRequired => 'Please enter your email';

  @override
  String get registerEmailInvalid => 'Please enter a valid email';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerPasswordHint => 'Create a strong password';

  @override
  String get registerPasswordRequired => 'Please enter a password';

  @override
  String get registerPasswordTooShort =>
      'Password must be at least 8 characters';

  @override
  String get registerConfirmPasswordLabel => 'Confirm Password';

  @override
  String get registerConfirmPasswordHint => 'Re-enter your password';

  @override
  String get registerConfirmPasswordRequired => 'Please confirm your password';

  @override
  String get registerPasswordMismatch => 'Passwords do not match';

  @override
  String get registerTermsIntro => 'By creating an account, you agree to our ';

  @override
  String get registerTermsOfService => 'Terms of Service';

  @override
  String get registerAnd => ' and ';

  @override
  String get registerPrivacyPolicy => 'Privacy Policy';

  @override
  String get registerCreateAccountButton => 'Create Account';

  @override
  String get registerAlreadyHaveAccount => 'Already have an account? ';

  @override
  String get registerSignIn => 'Sign In';

  @override
  String get registerAcceptTermsError =>
      'Please accept the Terms and Conditions';

  @override
  String get registerSelectRoleFirst => 'Please select a context first';

  @override
  String get registerAccountCreatedTitle => 'Account Created!';

  @override
  String get registerAccountCreatedMessage =>
      'Your account has been created successfully. You can now sign in with your email and password.';

  @override
  String get registerGoToSignIn => 'Go to Sign In';

  @override
  String get registerTermsTitle => 'Terms of Service';

  @override
  String get registerTermsBody =>
      'Terms of Service for RemiMinder\n\n1. Acceptance of Terms\nBy using RemiMinder, you agree to these terms.\n\n2. Use of Service\nRemiMinder is designed to help manage healthcare and medication reminders.\n\n3. Privacy\nYour privacy is important to us. All health data is handled securely.\n\n4. Account Responsibility\nYou are responsible for maintaining the confidentiality of your account.\n\n5. Limitation of Liability\nRemiMinder is not a substitute for professional medical advice.\n\nFor the complete Terms of Service, please visit our website.';

  @override
  String get registerPrivacyTitle => 'Privacy Policy';

  @override
  String get registerPrivacyBody =>
      'Privacy Policy for RemiMinder\n\n1. Information We Collect\nWe collect information you provide and usage data to improve our service.\n\n2. How We Use Information\nInformation is used to provide healthcare management services and improve user experience.\n\n3. Information Sharing\nWe do not sell your personal information. Data is only shared with healthcare providers you authorize.\n\n4. Data Security\nWe implement industry-standard security measures to protect your health data.\n\n5. Your Rights\nYou have the right to access, correct, or delete your personal information.\n\nFor the complete Privacy Policy, please visit our website.';

  @override
  String get registerAccountExists =>
      'An account with this email already exists. Please sign in instead.';

  @override
  String get registerWeakPassword =>
      'Password is too weak. Please use at least 8 characters with letters and numbers.';

  @override
  String get registerConnectionError =>
      'Connection error. Please check your internet connection and try again.';

  @override
  String get registerRequestTimedOut => 'Request timed out. Please try again.';

  @override
  String get registerFailedGeneric =>
      'Registration failed. Please try again or contact support if the problem persists.';

  @override
  String get forgotPasswordTitle => 'Forgot Password?';

  @override
  String get forgotPasswordSubtitle =>
      'No worries! Enter your email and we\'ll send you reset instructions.';

  @override
  String get forgotPasswordEmailHint => 'Enter your email address';

  @override
  String get forgotPasswordEmailRequired => 'Please enter your email';

  @override
  String get forgotPasswordEmailInvalid => 'Please enter a valid email';

  @override
  String get forgotPasswordSendInstructions => 'Send Reset Instructions';

  @override
  String get forgotPasswordRememberPassword => 'Remember your password?';

  @override
  String get forgotPasswordBackToLogin => 'Back to Login';

  @override
  String get forgotPasswordSuccessMessage =>
      'If an account exists for this email, we\'ve sent you password reset instructions.';

  @override
  String get forgotPasswordSendFailed =>
      'Failed to send reset email. Please check the email and try again.';

  @override
  String get forgotPasswordNotAvailable =>
      'Password reset is not available for this account.';

  @override
  String get forgotPasswordTooManyRequests =>
      'Too many requests. Please try again later.';

  @override
  String get forgotPasswordNetworkError =>
      'Network error. Please check your internet connection.';

  @override
  String get patientHomeGreetingMorning => 'Good morning';

  @override
  String get patientHomeGreetingAfternoon => 'Good afternoon';

  @override
  String get patientHomeGreetingEvening => 'Good evening';

  @override
  String get patientHomeGreetingNight => 'Good night';

  @override
  String get patientHomeFeelingToday => 'How are you feeling today?';

  @override
  String get patientHomeTodaysSchedule => 'Today\'s Schedule';

  @override
  String get patientHomeTodoList => 'To-do List';

  @override
  String get patientHomeUpNext => 'Up Next';

  @override
  String get patientHomeNoUpcomingReminders => 'No upcoming reminders';

  @override
  String get patientHomeMarkedAsTaken => 'Marked as taken!';

  @override
  String get patientHomeTakeNow => 'Take Now';

  @override
  String get patientHomeReminderSnoozed => 'Reminder snoozed for 1 hour';

  @override
  String get patientHomeNothingScheduled => 'Nothing scheduled for today';

  @override
  String get patientHomeViewAll => 'View All';

  @override
  String get patientHomeAddItem => 'Add Item';

  @override
  String get patientHomeNoTasksYet => 'No tasks yet';

  @override
  String get patientHomeAddTask => 'Add Task';

  @override
  String get patientHomeAddedRecently => 'Added recently';

  @override
  String patientHomeAddedDate(Object date) {
    return 'Added $date';
  }

  @override
  String get patientHomeUpcoming => 'Upcoming';

  @override
  String get patientHomeDueNow => 'Due now';

  @override
  String patientHomeDueInMinutes(Object minutes) {
    return 'Due in $minutes min';
  }

  @override
  String patientHomeDueInHours(Object hours) {
    return 'Due in $hours hours';
  }

  @override
  String patientHomeDueInDays(Object days) {
    return 'Due in $days days';
  }

  @override
  String patientHomeDueOnDate(Object date) {
    return 'Due $date';
  }

  @override
  String get commonRetry => 'Retry';

  @override
  String get caregiverPatientsTitle => 'My Patients';

  @override
  String get caregiverPatientsSearchHint =>
      'Search patients by name, relationship, or condition...';

  @override
  String get caregiverPatientsClearFilter => 'Clear Filter';

  @override
  String caregiverPatientsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# Patients',
      one: '# Patient',
    );
    return '$_temp0';
  }

  @override
  String get caregiverPatientsFilterAll => 'All';

  @override
  String get caregiverPatientsFilterActive => 'Active';

  @override
  String get caregiverPatientsFilterAttention => 'Attention';

  @override
  String get caregiverPatientsFilterCritical => 'Critical';

  @override
  String get caregiverPatientsFilterDialogTitle => 'Filter Patients';

  @override
  String get caregiverPatientsEmptyNoMatch => 'No patients match your search';

  @override
  String get caregiverPatientsEmptyNone => 'No patients found';

  @override
  String get caregiverPatientsEmptyAdjustSearch =>
      'Try adjusting your search terms';

  @override
  String get caregiverPatientsEmptyAddPatients =>
      'Add patients to start managing their care';

  @override
  String get caregiverPatientsAddFirstComingSoon =>
      'Add First Patient - Coming Soon!';

  @override
  String get caregiverPatientsAddPatientButton => 'Add Patient';

  @override
  String get caregiverPatientsLoadFailed => 'Failed to load patients';

  @override
  String get caregiverPatientsAddNewComingSoon =>
      'Add New Patient - Coming Soon!';

  @override
  String caregiverPatientsRelationshipAge(Object age, Object relationship) {
    return '$relationship • Age $age';
  }

  @override
  String get caregiverPatientsStatAdherence => 'Adherence';

  @override
  String get caregiverPatientsStatAppointments => 'Appointments';

  @override
  String get caregiverPatientsStatLastVisit => 'Last Visit';

  @override
  String caregiverPatientsViewAlerts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'View # Alerts',
      one: 'View # Alert',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsViewAppointments(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# Appointments',
      one: '# Appointment',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsViewAlertsComingSoon(Object name) {
    return 'View alerts for $name - Coming Soon!';
  }

  @override
  String caregiverPatientsViewAppointmentsComingSoon(Object name) {
    return 'View appointments for $name - Coming Soon!';
  }

  @override
  String get caregiverPatientsLastVisitToday => 'Today';

  @override
  String get caregiverPatientsLastVisitYesterday => 'Yesterday';

  @override
  String caregiverPatientsLastVisitDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# days ago',
      one: '# day ago',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsLastVisitWeeks(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# weeks ago',
      one: '# week ago',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsLastVisitMonths(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# months ago',
      one: '# month ago',
    );
    return '$_temp0';
  }

  @override
  String get caregiverPatientOverviewTitle => 'Patient Overview';

  @override
  String get caregiverPatientOverviewTabVisits => 'Visits';

  @override
  String get caregiverPatientOverviewTabReminders => 'Reminders';

  @override
  String get caregiverPatientOverviewTabNotes => 'Notes';

  @override
  String get caregiverPatientOverviewNoVisits => 'No visits available';

  @override
  String get caregiverPatientOverviewNoReminders => 'No reminders available';

  @override
  String get caregiverPatientOverviewNoNotes => 'No notes available';

  @override
  String get caregiverPatientOverviewEditComingSoon =>
      'Edit Patient - Coming Soon!';

  @override
  String get caregiverPatientOverviewCallPatient => 'Call Patient';

  @override
  String get caregiverPatientOverviewSendMessage => 'Send Message';

  @override
  String get caregiverPatientOverviewEmergencyContact => 'Emergency Contact';

  @override
  String get caregiverPatientOverviewSharePatientInfo => 'Share Patient Info';

  @override
  String get caregiverPatientOverviewScheduleAppointment =>
      'Schedule New Appointment - Coming Soon!';

  @override
  String get caregiverPatientOverviewAddReminder =>
      'Add New Reminder - Coming Soon!';

  @override
  String get caregiverPatientOverviewAddNote => 'Add New Note - Coming Soon!';

  @override
  String caregiverPatientOverviewViewVisitDetails(Object type) {
    return 'View $type details - Coming Soon!';
  }

  @override
  String caregiverPatientOverviewViewReminderDetails(Object title) {
    return 'View $title details - Coming Soon!';
  }

  @override
  String caregiverPatientOverviewViewNoteDetails(Object title) {
    return 'View $title details - Coming Soon!';
  }

  @override
  String get caregiverPatientOverviewMissingPatientId => 'Missing patientId';

  @override
  String get caregiverPatientOverviewOverdue => 'Overdue';

  @override
  String caregiverPatientOverviewInHours(Object hours) {
    return 'In $hours hours';
  }

  @override
  String get caregiverPatientOverviewDefaultRelationship => 'Care Team';

  @override
  String get caregiverPatientOverviewDefaultCondition => 'Authorized access';

  @override
  String get caregiverAlertsTitle => 'Alerts';

  @override
  String get caregiverAlertsFilterAll => 'All';

  @override
  String get caregiverAlertsFilterUnread => 'Unread';

  @override
  String get caregiverAlertsFilterRead => 'Read';

  @override
  String get caregiverAlertsFilterHighPriority => 'High Priority';

  @override
  String get caregiverAlertsFilterActionRequired => 'Action Required';

  @override
  String get caregiverAlertsClearFilter => 'Clear Filter';

  @override
  String caregiverAlertsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# Alerts',
      one: '# Alert',
    );
    return '$_temp0';
  }

  @override
  String get caregiverAlertsMarkAllReadTooltip => 'Mark all as read';

  @override
  String get caregiverAlertsActionRequired => 'Action Required';

  @override
  String get caregiverAlertsMarkRead => 'Mark Read';

  @override
  String get caregiverAlertsTakeAction => 'Take Action';

  @override
  String get caregiverAlertsEmptyAllTitle => 'No alerts at this time';

  @override
  String get caregiverAlertsEmptyAllSubtitle =>
      'All patient activities are running smoothly';

  @override
  String get caregiverAlertsEmptyFilteredTitle => 'No alerts match this filter';

  @override
  String get caregiverAlertsEmptyFilteredSubtitle =>
      'Try adjusting your filter to see more alerts';

  @override
  String get caregiverAlertsViewAll => 'View All Alerts';

  @override
  String get caregiverAlertsMarkedRead => 'Alert marked as read';

  @override
  String get caregiverAlertsMarkedUnread => 'Alert marked as unread';

  @override
  String get caregiverAlertsAllAlreadyRead => 'All alerts are already read';

  @override
  String caregiverAlertsMarkedAllRead(Object count) {
    return 'Marked $count alerts as read';
  }

  @override
  String caregiverAlertsTakingAction(Object type) {
    return 'Taking action on $type alert';
  }

  @override
  String caregiverAlertsViewDetails(Object type) {
    return 'View details for $type alert';
  }

  @override
  String get caregiverInvitationsTitle => 'Caregiver Invitations';

  @override
  String get caregiverInvitationsRetry => 'Retry';

  @override
  String get caregiverInvitationsEmpty => 'No pending invitations';

  @override
  String caregiverInvitationsRole(Object role) {
    return 'Role: $role';
  }

  @override
  String caregiverInvitationsPermission(Object permission) {
    return 'Permission: $permission';
  }

  @override
  String get caregiverInvitationsAccept => 'Accept';

  @override
  String get caregiverInvitationsMissingToken => 'Invitation token is missing';

  @override
  String get caregiverInvitationsAccepted => 'Invitation accepted';

  @override
  String get caregiverInvitationsPatientFallback => 'Patient';

  @override
  String get commonDelete => 'Delete';

  @override
  String get overviewTitle => 'Overview';

  @override
  String get overviewSearchHint => 'Search summaries...';

  @override
  String get overviewTabSummaries => 'SUMMARIES';

  @override
  String get overviewTabLabResults => 'LAB RESULTS';

  @override
  String get overviewTabScannedDocs => 'SCANNED DOCS';

  @override
  String get overviewNewSummaryTitle => '🎉 Your visit summary is ready!';

  @override
  String get overviewNewSummaryPrompt => 'Would you like to view it now?';

  @override
  String get overviewNewSummaryLater => 'Later';

  @override
  String get overviewNewSummaryView => 'View Summary';

  @override
  String get overviewSelectAtLeastOne => 'Select at least one summary';

  @override
  String get overviewDeleteSummaryTitleSingular => 'Delete summary?';

  @override
  String get overviewDeleteSummaryTitlePlural => 'Delete summaries?';

  @override
  String get overviewDeleteSummaryConfirmSingular =>
      'Are you sure you want to delete this summary? This cannot be undone.';

  @override
  String overviewDeleteSummaryConfirmPlural(Object count) {
    return 'Are you sure you want to delete $count summaries? This cannot be undone.';
  }

  @override
  String get overviewAuthError => 'Authentication error. Please log in again.';

  @override
  String overviewDeleteSuccess(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# summaries',
      one: '# summary',
    );
    return 'Successfully deleted $_temp0';
  }

  @override
  String get overviewDeleteFailed =>
      'Failed to delete summaries. Please try again.';

  @override
  String get overviewNoCaregiver => 'No caregiver added yet';

  @override
  String get overviewShareTitleShare => 'Share summary?';

  @override
  String get overviewShareTitleStop => 'Stop sharing?';

  @override
  String get overviewShareConfirmShare =>
      'You are about to share this summary with your caregivers. They will be able to view this visit summary.';

  @override
  String get overviewShareConfirmStop =>
      'Caregivers will no longer be able to view this summary.';

  @override
  String get overviewShareAction => 'Share';

  @override
  String get overviewStopShareAction => 'Stop Sharing';

  @override
  String get overviewSharingEnabled => 'Caregiver sharing enabled';

  @override
  String get overviewSharingDisabled => 'Caregiver sharing disabled';

  @override
  String get overviewSummariesLoadFailed => 'Failed to load summaries';

  @override
  String get overviewNoSummariesTitle => 'No summaries yet';

  @override
  String get overviewNoSummariesSubtitle =>
      'Your visit summaries will appear here';

  @override
  String get overviewProcessingTitle =>
      '🕒 Your latest visit is being processed';

  @override
  String get overviewProcessingSubtitle =>
      'We\'ll notify you when it\'s ready.';

  @override
  String get overviewLabResultsComingSoon => 'Lab Results - Coming Soon';

  @override
  String get overviewScannedDocsComingSoon => 'Scanned Documents - Coming Soon';

  @override
  String get overviewShareLabel => 'Share';

  @override
  String get overviewDoctorVisit => 'Doctor Visit';

  @override
  String overviewDoctorPrefix(Object name) {
    return 'Dr. $name';
  }

  @override
  String overviewMinutesAgo(Object count) {
    return '$count min ago';
  }

  @override
  String overviewTodayAt(Object time) {
    return 'Today, $time';
  }

  @override
  String overviewYesterdayAt(Object time) {
    return 'Yesterday, $time';
  }

  @override
  String get remindersTitle => 'Reminders';

  @override
  String get remindersTabAll => 'All';

  @override
  String get remindersTabToday => 'Today';

  @override
  String get remindersTabPending => 'Pending';

  @override
  String get remindersTabCompleted => 'Completed';

  @override
  String get remindersSearchHint => 'Search reminders...';

  @override
  String get remindersDeleteTitle => 'Delete Reminder';

  @override
  String get remindersDeleteConfirm =>
      'Are you sure you want to delete this reminder?';

  @override
  String get remindersMarkDone => 'Mark Done';

  @override
  String get remindersSnooze => 'Snooze';

  @override
  String get remindersCreateButton => 'Create Reminder';

  @override
  String get remindersCreateComingSoon => 'Create New Reminder - Coming Soon!';

  @override
  String remindersEditComingSoon(Object title) {
    return 'Edit $title - Coming Soon!';
  }

  @override
  String get remindersMarkedCompleted => 'Reminder marked as completed!';

  @override
  String get remindersSnoozedForHour => 'Reminder snoozed for 1 hour';

  @override
  String get remindersDeleted => 'Reminder deleted';

  @override
  String get remindersEmptyTitle => 'No reminders found';

  @override
  String get remindersEmptySearchTitle => 'No reminders match your search';

  @override
  String get remindersEmptySubtitle =>
      'Create your first reminder to get started';

  @override
  String get remindersEmptySearchSubtitle => 'Try adjusting your search terms';

  @override
  String remindersSnoozedUntil(Object time) {
    return 'Snoozed until $time';
  }

  @override
  String get remindersStatusDone => 'Done';

  @override
  String get remindersStatusPending => 'Pending';

  @override
  String get remindersStatusSnoozed => 'Snoozed';

  @override
  String get remindersStatusUnknown => 'Unknown';

  @override
  String remindersTimeHoursAgo(Object count) {
    return '$count hours ago';
  }

  @override
  String remindersTimeMinutesAgo(Object count) {
    return '$count minutes ago';
  }

  @override
  String remindersTimeInHours(Object count) {
    return 'In $count hours';
  }

  @override
  String remindersTimeInMinutes(Object count) {
    return 'In $count minutes';
  }

  @override
  String get remindersTimeNow => 'Now';

  @override
  String get remindersAdherenceTitle => 'Medication Adherence';

  @override
  String get remindersAdherenceThisWeek => 'This Week';

  @override
  String get remindersAdherenceThisMonth => 'This Month';

  @override
  String get remindersAdherenceOverall => 'Overall';

  @override
  String get remindersAdherenceByMedication => 'By Medication';

  @override
  String get remindersAdherenceTipsTitle => 'Adherence Tips';

  @override
  String get remindersAdherenceTipsBody =>
      '• Set phone reminders for medication times\n• Keep medications in a visible location\n• Use a pill organizer for daily doses\n• Track your progress to stay motivated';

  @override
  String get visitRecordingTitle => 'Record Visit';

  @override
  String get visitRecordingSave => 'Save';

  @override
  String get visitRecordingGenerateSummary => 'Generate Summary';

  @override
  String get visitRecordingDiscardRecording => 'Discard Recording';

  @override
  String get visitRecordingCompleted => 'Recording completed!';

  @override
  String get visitRecordingSaveFailed => 'Failed to save recording';

  @override
  String get visitRecordingDiscarded => 'Recording discarded';

  @override
  String get visitRecordingNoRecording => 'No recording available';

  @override
  String get visitRecordingUploadingAudio => 'Uploading audio...';

  @override
  String get visitRecordingProcessingTitle => '✅ Your visit is being processed';

  @override
  String get visitRecordingGoToHome => 'Go to Home';

  @override
  String visitRecordingUploadFailed(Object error) {
    return 'Failed to upload audio: $error';
  }

  @override
  String get visitRecordingStopTitle => 'Stop Recording?';

  @override
  String get visitRecordingContinue => 'Continue Recording';

  @override
  String get visitRecordingStopAndDiscard => 'Stop & Discard';

  @override
  String get visitRecordingAudioPermissionTitle => 'Audio Recording';

  @override
  String get visitRecordingNotNow => 'Not Now';

  @override
  String get visitRecordingYesRecord => 'Yes, Record';

  @override
  String get visitRecordingStatusReady => 'Ready to Record';

  @override
  String get visitRecordingStatusRecording => 'Recording...';

  @override
  String get visitRecordingStatusComplete => 'Recording complete';

  @override
  String get visitRecordingInstructionIdle =>
      'Tap to start recording your visit\nYour recording stays private and secure';

  @override
  String get visitRecordingInstructionRecording => 'Recording in progress...';

  @override
  String get visitRecordingInstructionComplete =>
      'Recording complete!\nTap Generate to process your visit summary';

  @override
  String get visitRecordingMicPermission =>
      'Microphone permission is required. Please enable it in Settings > RemiMinder > Microphone.';

  @override
  String get visitRecordingProcessingBody =>
      'This may take ~30–60 seconds.\nYou can continue using the app. We\'ll notify you when it\'s ready.';

  @override
  String get visitRecordingStopConfirm =>
      'Are you sure you want to stop recording? This action cannot be undone.';

  @override
  String get visitRecordingAudioConsentBody =>
      'Recording helps create visit notes, summaries, and reminders.\n\n• Audio is recorded only when you tap Record\n• Recordings are processed securely and deleted from your phone\n• You can stop recording at any time\n\nWould you like to proceed?';

  @override
  String get visitDetailsTitle => 'Visit Details';

  @override
  String get visitDetailsSummaryCardTitle => 'Health Visit Summary';

  @override
  String get visitDetailsRefreshTooltip => 'Refresh summary';

  @override
  String get visitDetailsProcessingTitle => 'Preparing visit summary...';

  @override
  String get visitDetailsProcessingSubtitle => 'This may take a minute.';

  @override
  String get visitDetailsLoadFailed => 'Unable to load visit summary';

  @override
  String get visitDetailsRetry => 'Retry';

  @override
  String get visitDetailsUnavailable => 'Visit summary is unavailable';

  @override
  String get visitDetailsSummarySection => 'Visit Summary';

  @override
  String get visitDetailsFinalSummarySection => 'Visit Summary';

  @override
  String get visitRecordingSaved =>
      'Recording saved successfully! You can now generate a summary.';

  @override
  String get visitDetailsDecisionsSection => 'Clinical Decisions';

  @override
  String get visitDetailsMedicationsSection => 'Medications';

  @override
  String get visitDetailsActionsSection => 'Next Steps';

  @override
  String get historyTitle => 'History';

  @override
  String get historySearchHint => 'Search events, documents, visits...';

  @override
  String get historyTabAll => 'ALL';

  @override
  String get historyTabScannedDocs => 'SCANNED DOCS';

  @override
  String get historyTabLabResults => 'LAB RESULTS';

  @override
  String get historyLoadFailed => 'Failed to load history';

  @override
  String get historyRetry => 'Retry';

  @override
  String get historyVisitSummaryFallback => 'Visit Summary';

  @override
  String get historyNoSummary => 'No summary available';

  @override
  String get historyUnknownDate => 'Unknown date';

  @override
  String get historyUnknownTime => 'Unknown time';

  @override
  String get historyNoScannedDocs => 'No scanned documents yet';

  @override
  String get historyNoScannedDocsSubtitle =>
      'Scanned prescriptions and documents will appear here';

  @override
  String get historyNoLabResults => 'No lab results yet';

  @override
  String get historyNoLabResultsSubtitle =>
      'Lab results and test reports will appear here';

  @override
  String historyNoEventsSearch(Object query) {
    return 'No events found for \"$query\"';
  }

  @override
  String get historyNoEvents => 'No events yet';

  @override
  String get historyDocumentViewerSoon => 'Document viewer coming soon';

  @override
  String get historyFeatureSoon => 'Feature coming soon';

  @override
  String get notificationSettingsTitle => 'Notifications';

  @override
  String get notificationSectionTypes => 'Notification Types';

  @override
  String get notificationMedicationTitle => 'Medication Reminders';

  @override
  String get notificationMedicationSubtitle =>
      'Get notified when it\'s time to take your medications';

  @override
  String get notificationAppointmentTitle => 'Appointment Reminders';

  @override
  String get notificationAppointmentSubtitle =>
      'Reminders for upcoming doctor visits and tests';

  @override
  String get notificationHealthTipsTitle => 'Health Tips';

  @override
  String get notificationHealthTipsSubtitle =>
      'Daily tips for managing your health conditions';

  @override
  String get notificationCaregiverUpdatesTitle => 'Caregiver Updates';

  @override
  String get notificationCaregiverUpdatesSubtitle =>
      'Notifications when caregivers view your information';

  @override
  String get notificationEmergencyAlertsTitle => 'Emergency Alerts';

  @override
  String get notificationEmergencyAlertsSubtitle =>
      'Critical health alerts and emergency notifications';

  @override
  String get notificationDailySummaryTitle => 'Daily Summary';

  @override
  String get notificationDailySummarySubtitle =>
      'Evening summary of your day\'s health activities';

  @override
  String get notificationSectionTiming => 'Timing Preferences';

  @override
  String get notificationMorningReminder => 'Morning Reminder Time';

  @override
  String get notificationEveningReminder => 'Evening Reminder Time';

  @override
  String get notificationAdvanceTime => 'Reminder Advance Time';

  @override
  String get notificationAdvance5Min => '5 min';

  @override
  String get notificationAdvance10Min => '10 min';

  @override
  String get notificationAdvance15Min => '15 min';

  @override
  String get notificationAdvance30Min => '30 min';

  @override
  String get notificationAdvance60Min => '1 hour';

  @override
  String get notificationSectionSound => 'Sound & Alerts';

  @override
  String get notificationSoundTitle => 'Sound Notifications';

  @override
  String get notificationVibrationTitle => 'Vibration';

  @override
  String get notificationVolumeTitle => 'Volume Level';

  @override
  String get notificationSectionTest => 'Test Notifications';

  @override
  String get notificationSendTest => 'Send Test Notification';

  @override
  String get notificationTestSent => 'Test notification sent!';

  @override
  String get languageSettingsChooseApp => 'Choose App Language';

  @override
  String get languageSettingsChooseVisit => 'Choose Visit Language';

  @override
  String get languageSettingsAppLabel => 'App Language';

  @override
  String get languageSettingsVisitLabel => 'Visit Language';

  @override
  String get languageSettingsSave => 'Save Settings';

  @override
  String get languageSettingsInfo =>
      'Changing visit language affects speech recognition and AI summaries.';

  @override
  String get languageSettingsLoadFailed =>
      'Failed to load language preferences';

  @override
  String get languageSettingsSaveSuccess => 'Language settings saved';

  @override
  String get languageSettingsSaveFailed => 'Failed to save language settings';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get changePasswordSubtitle =>
      'Update your password to keep your account secure.';

  @override
  String get changePasswordCurrentLabel => 'Current Password';

  @override
  String get changePasswordCurrentHint => 'Enter your current password';

  @override
  String get changePasswordNewLabel => 'New Password';

  @override
  String get changePasswordNewHint => 'Enter your new password';

  @override
  String get changePasswordConfirmLabel => 'Confirm New Password';

  @override
  String get changePasswordConfirmHint => 'Re-enter your new password';

  @override
  String get changePasswordUpdateButton => 'Update Password';

  @override
  String get changePasswordCurrentRequired =>
      'Please enter your current password';

  @override
  String get changePasswordNewRequired => 'Please enter a new password';

  @override
  String get changePasswordTooShort => 'Password must be at least 8 characters';

  @override
  String get changePasswordConfirmRequired =>
      'Please confirm your new password';

  @override
  String get changePasswordMismatch => 'Passwords do not match';

  @override
  String get changePasswordSuccess => 'Password updated successfully';

  @override
  String get changePasswordNotAuthenticated => 'User not authenticated';

  @override
  String get changePasswordFailed => 'Failed to update password';

  @override
  String get changePasswordWrongPassword => 'Current password is incorrect';

  @override
  String get changePasswordWeakPassword => 'Password is too weak';

  @override
  String get changePasswordRecentLogin => 'Please log in again and try';

  @override
  String get changePasswordCheckConnection => 'Check your internet connection';

  @override
  String get accountSecurityTitle => 'Account Security';

  @override
  String get accountSecurityChangePasswordTitle => 'Change Password';

  @override
  String get accountSecurityChangePasswordSubtitle =>
      'Update your account password for security';

  @override
  String get accountSecurityChangePasswordButton => 'Change Password';

  @override
  String get accountSecurityPrivacyTitle => 'Privacy Settings';

  @override
  String get accountSecurityPrivacySubtitle =>
      'Manage your data sharing preferences';

  @override
  String get accountSecurityPrivacyButton => 'Manage Privacy';

  @override
  String get accountSecurityDialogTitle => 'Change Password';

  @override
  String accountSecurityDialogBody(Object provider) {
    return 'You signed in using $provider. Please change your password in your $provider account.';
  }

  @override
  String get accountSecurityDialogOk => 'OK';

  @override
  String get profileAccountDetailsTitle => 'Account Details';

  @override
  String get profileAccountDetailsSubtitle => 'View your profile information';

  @override
  String get profileAccountSecurityTitle => 'Account Security';

  @override
  String get profileAccountSecuritySubtitle => 'Manage password and privacy';

  @override
  String get profileAppLanguageLabel => 'App language';

  @override
  String get profilePreferredSummaryLanguageLabel =>
      'Preferred summary language';

  @override
  String get profileDefaultVisitLanguageLabel => 'Default visit language';

  @override
  String get profileTimezoneLabel => 'Timezone';

  @override
  String get profileCountryOptionalLabel => 'Country (optional)';

  @override
  String get profileCountryOrRegionLabel => 'Country or region';

  @override
  String get profileNotificationsTitle => 'Notifications';

  @override
  String get profileNotificationsMobile => 'Mobile';

  @override
  String get profileNotificationsEmail => 'Email';

  @override
  String get profileUpgrade => 'Upgrade';

  @override
  String get profileSignOut => 'Sign Out';

  @override
  String get profileNotSet => 'Not set';

  @override
  String profileSignOutFailed(Object error) {
    return 'Sign out failed: $error';
  }

  @override
  String get upgradeBenefitsTitle => 'Upgrade Benefits';

  @override
  String get upgradeUnlockTitle => 'Unlock Premium Care';

  @override
  String get upgradeSubtitle => 'Get more peace of mind.';

  @override
  String get upgradeBenefitUnlimitedCaregivers => 'Unlimited Caregivers';

  @override
  String get upgradeBenefitHealthTrends => 'Advanced Health Trends';

  @override
  String get upgradeBenefitPrioritySupport => 'Priority Support';

  @override
  String get upgradeMonthlyPlan => 'Monthly Plan';

  @override
  String get upgradeAnnualPlan => 'Annual Plan';

  @override
  String get upgradePerMonth => '/ month';

  @override
  String get upgradePerYear => '/ year';

  @override
  String get upgradeCancelAnytime => 'Cancel anytime';

  @override
  String get upgradeContinuePayment => 'Continue to Payment';

  @override
  String get upgradePaymentComingSoon => 'Payment flow coming soon';

  @override
  String get caregiversTitle => 'Caregivers';

  @override
  String get caregiversMyCaregivers => 'My Caregivers';

  @override
  String get caregiversEmptyTitle => 'No caregivers yet';

  @override
  String get caregiversEmptySubtitle =>
      'Invite family members or friends\nto help manage your healthcare';

  @override
  String get caregiversInviteFirst => 'Invite First Caregiver';

  @override
  String get caregiversLoadFailed => 'Failed to load caregivers';

  @override
  String get caregiversResendInvite => 'Resend Invite';

  @override
  String get caregiversCancel => 'Cancel';

  @override
  String get caregiversActiveLabel => 'Active Caregiver';

  @override
  String caregiversPermissionsCount(Object count) {
    return '$count perms';
  }

  @override
  String caregiversActivityCount(Object count) {
    return '$count acts';
  }

  @override
  String caregiversLastActive(Object time) {
    return 'Last active: $time';
  }

  @override
  String get caregiversStatusActive => 'Active';

  @override
  String get caregiversStatusPending => 'Pending';

  @override
  String get caregiversStatusDeclined => 'Declined';

  @override
  String get caregiversStatusUnknown => 'Unknown';

  @override
  String get caregiversInviteTitle => 'Invite Caregiver';

  @override
  String get caregiversFullNameLabel => 'Full Name';

  @override
  String get caregiversFullNameHint => 'Enter caregiver\'s full name';

  @override
  String get caregiversFullNameRequired => 'Please enter a name';

  @override
  String get caregiversEmailLabel => 'Email Address';

  @override
  String get caregiversEmailHint => 'caregiver@example.com';

  @override
  String get caregiversEmailRequired => 'Please enter an email';

  @override
  String get caregiversEmailInvalid => 'Please enter a valid email';

  @override
  String get caregiversRelationshipLabel => 'Relationship';

  @override
  String get caregiversSendInvitation => 'Send Invitation';

  @override
  String caregiversInvitationSent(Object email) {
    return 'Invitation sent to $email';
  }

  @override
  String caregiversInvitationResent(Object email) {
    return 'Invitation resent to $email';
  }

  @override
  String get caregiversCancelInvitationTitle => 'Cancel Invitation';

  @override
  String get caregiversCancelInvitationConfirm =>
      'Are you sure you want to cancel this invitation?';

  @override
  String get caregiversKeep => 'Keep';

  @override
  String get caregiversCancelInvitationAction => 'Cancel Invitation';

  @override
  String get caregiversDone => 'Done';

  @override
  String get caregiversAccessRemoved => 'Access removed';

  @override
  String caregiversPermissionTitle(Object name) {
    return 'Permissions for $name';
  }

  @override
  String get caregiversPermissionViewMedications => 'View Medications';

  @override
  String get caregiversPermissionViewMedicationsDesc =>
      'Can see medication schedules and history';

  @override
  String get caregiversPermissionViewVisits => 'View Visit Records';

  @override
  String get caregiversPermissionViewVisitsDesc =>
      'Can access visit summaries and transcripts';

  @override
  String get caregiversPermissionViewHealthData => 'View Health Data';

  @override
  String get caregiversPermissionViewHealthDataDesc =>
      'Can see health metrics and trends';

  @override
  String get caregiversPermissionEditMedications => 'Edit Medications';

  @override
  String get caregiversPermissionEditMedicationsDesc =>
      'Can modify medication schedules';

  @override
  String get caregiversPermissionManageEmergency => 'Manage Emergency Contacts';

  @override
  String get caregiversPermissionManageEmergencyDesc =>
      'Can modify emergency contact settings';

  @override
  String get caregiversPermissionReceiveAlerts => 'Receive Alerts';

  @override
  String get caregiversPermissionReceiveAlertsDesc =>
      'Gets notified of important health events';

  @override
  String get caregiversRelationshipFamily => 'Family Member';

  @override
  String get caregiversRelationshipFriend => 'Friend';

  @override
  String get caregiversRelationshipSpouse => 'Spouse/Partner';

  @override
  String get caregiversRelationshipParent => 'Parent';

  @override
  String get caregiversRelationshipChild => 'Child';

  @override
  String get caregiversRelationshipHealthcare => 'Healthcare Professional';

  @override
  String get caregiversRelationshipCaregiver => 'Caregiver';

  @override
  String get caregiversRelationshipOther => 'Other';

  @override
  String caregiversLastActiveDays(Object count) {
    return '${count}d ago';
  }

  @override
  String caregiversLastActiveHours(Object count) {
    return '${count}h ago';
  }

  @override
  String caregiversLastActiveMinutes(Object count) {
    return '${count}m ago';
  }

  @override
  String get caregiversLastActiveJustNow => 'Just now';

  @override
  String commonComingSoon(Object feature) {
    return '$feature coming soon';
  }

  @override
  String get privacyTitle => 'Privacy Settings';

  @override
  String get privacyDataSharing => 'Data Sharing';

  @override
  String get privacyNoCaregiver => 'No caregiver added yet';

  @override
  String get privacyAllowCaregiverSummaries =>
      'Allow caregiver to view summaries';

  @override
  String get privacyAllowCaregiverMedications =>
      'Allow caregiver to view medications';

  @override
  String get privacyAllowCaregiverReminders =>
      'Allow caregiver to view reminders';

  @override
  String get privacyAllowAiImprove =>
      'Allow AI to use my data to improve the product';

  @override
  String get privacyCaregiverSharingEnabled => 'Caregiver sharing enabled';

  @override
  String get privacyCaregiverSharingDisabled => 'Caregiver sharing disabled';

  @override
  String get privacyCommunicationConsent => 'Communication & Consent';

  @override
  String get privacyAllowEmailNotifications => 'Allow email notifications';

  @override
  String get privacyAllowSmsNotifications => 'Allow SMS notifications';

  @override
  String get privacyAllowPushNotifications => 'Allow push notifications';

  @override
  String get privacyDataControl => 'Data Control';

  @override
  String get privacyExportData => 'Export my data';

  @override
  String get privacyDataExportLabel => 'Data export';

  @override
  String get privacyDeleteRecords => 'Delete all my medical records';

  @override
  String get privacyDeleteRecordsTitle => 'Delete Medical Records';

  @override
  String get privacyDeleteRecordsBody =>
      'This will permanently delete all your medical records. This action cannot be undone.';

  @override
  String get privacyDeleteRecordsAction => 'Delete Records';

  @override
  String get privacyDeleteAccount => 'Delete my account';

  @override
  String get privacyDeleteAccountTitle => 'Delete Account';

  @override
  String get privacyDeleteAccountBody =>
      'This will permanently delete your account and all associated data. This action cannot be undone.';

  @override
  String get privacyDeleteAccountAction => 'Delete Account';

  @override
  String get privacyLegal => 'Legal';

  @override
  String get privacyViewPolicy => 'View Privacy Policy';

  @override
  String get privacyViewTerms => 'View Terms of Service';

  @override
  String get privacyTermsTitle => 'Terms of Service';

  @override
  String get privacyTermsBody =>
      'Terms of Service for RemiMinder\n\n1. Acceptance of Terms\nBy using RemiMinder, you agree to these terms.\n\n2. Use of Service\nRemiMinder is designed to help manage healthcare and medication reminders.\n\n3. Privacy\nYour privacy is important to us. All health data is handled securely.\n\nFor the complete Terms of Service, please visit our website.';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicyBody =>
      'Privacy Policy for RemiMinder\n\n1. Information We Collect\nWe collect information you provide and usage data to improve our service.\n\n2. How We Use Information\nInformation is used to provide healthcare management services.\n\n3. Information Sharing\nWe do not sell your personal information.\n\nFor the complete Privacy Policy, please visit our website.';

  @override
  String get healthDashboardTitle => 'Health Dashboard';

  @override
  String get healthDashboardLast7Days => 'Last 7 days';

  @override
  String get healthDashboardLast30Days => 'Last 30 days';

  @override
  String get healthDashboardLast90Days => 'Last 90 days';

  @override
  String get healthDashboardBloodPressure => 'Blood Pressure';

  @override
  String get healthDashboardWeightTrend => 'Weight Trend';

  @override
  String get healthDashboardMedicationAdherence => 'Medication Adherence';

  @override
  String get healthDashboardKeyMetrics => 'Key Metrics';

  @override
  String get healthDashboardUnitMmhg => 'mmHg';

  @override
  String get healthDashboardBpTrend => '+2 pts this week';

  @override
  String get healthDashboardWeight => 'Weight';

  @override
  String get healthDashboardUnitLbs => 'lbs';

  @override
  String get healthDashboardWeightTrendText => '-1.4 lbs this week';

  @override
  String get healthDashboardMedAdherence => 'Med Adherence';

  @override
  String get healthDashboardThisWeek => 'this week';

  @override
  String get healthDashboardGoodProgress => 'Good progress';

  @override
  String get healthDashboardHeartRate => 'Heart Rate';

  @override
  String get healthDashboardUnitBpm => 'bpm';

  @override
  String get healthDashboardRestingAverage => 'Resting average';

  @override
  String get healthDashboardInsightsTitle => 'Health Insights';

  @override
  String get healthDashboardInsightBpTitle => 'Blood Pressure Trend';

  @override
  String get healthDashboardInsightBpBody =>
      'Your systolic pressure has been stable with a slight downward trend. Keep up the good work!';

  @override
  String get healthDashboardInsightWeightTitle => 'Weight Management';

  @override
  String get healthDashboardInsightWeightBody =>
      'Consistent weight loss of 1.4 lbs this week. You\'re on track for your goal!';

  @override
  String get healthDashboardInsightAdherenceTitle => 'Medication Adherence';

  @override
  String get healthDashboardInsightAdherenceBody =>
      '86% adherence this week. Consider setting medication reminders to reach 100%.';

  @override
  String get healthDashboardInsightCheckupTitle => 'Next Checkup';

  @override
  String get healthDashboardInsightCheckupBody =>
      'Your next cardiology appointment is due in 3 months. Schedule it soon.';

  @override
  String get healthDashboardRecentMeasurements => 'Recent Measurements';

  @override
  String get healthDashboardRecentBpValue => '126/81 mmHg';

  @override
  String get healthDashboardRecentBpTime => 'Today, 8:30 AM';

  @override
  String get healthDashboardRecentWeightValue => '163.8 lbs';

  @override
  String get healthDashboardRecentWeightTime => 'Today, 7:45 AM';

  @override
  String get healthDashboardRecentHeartRateValue => '72 bpm';

  @override
  String get healthDashboardRecentHeartRateTime => 'Yesterday, 8:15 AM';

  @override
  String get healthDashboardAddMeasurement => 'Add Measurement';

  @override
  String get healthDashboardAddMeasurementSoon =>
      'Add new measurement - Coming Soon!';

  @override
  String get emergencyContactsTitle => 'Emergency Contacts';

  @override
  String get emergencySosLabel => 'EMERGENCY SOS';

  @override
  String get emergencySosSubtitle => 'Call all emergency contacts';

  @override
  String get emergencyMedicalAlertTitle => 'Medical Alert Information';

  @override
  String get emergencyMedicalAlertBody =>
      'Cardiac patient, allergic to penicillin, takes daily medications';

  @override
  String get emergencySosDialogTitle => 'Emergency SOS';

  @override
  String get emergencySosDialogBody =>
      'This will call ALL emergency contacts simultaneously. Are you sure?';

  @override
  String get emergencySosDialogNote =>
      'Emergency contacts will be called in priority order';

  @override
  String get emergencySosDialogAction => 'Call Emergency Contacts';

  @override
  String get emergencySosActivated =>
      'Emergency SOS activated! Calling all contacts...';

  @override
  String emergencyCallingContact(Object name) {
    return 'Calling $name...';
  }

  @override
  String get emergencyAddContactTitle => 'Add Emergency Contact';

  @override
  String get emergencyContactFullNameLabel => 'Full Name';

  @override
  String get emergencyContactFullNameHint => 'Enter contact name';

  @override
  String get emergencyContactPhoneLabel => 'Phone Number';

  @override
  String get emergencyContactPhoneHint => '(555) 123-4567';

  @override
  String get emergencyContactTypeLabel => 'Contact Type';

  @override
  String get emergencyContactRelationshipLabel => 'Relationship';

  @override
  String get emergencyContactRelationshipHint => 'Spouse, Child, Parent, etc.';

  @override
  String get emergencyAddContactAction => 'Add Contact';

  @override
  String emergencyEditContactComingSoon(Object name) {
    return 'Edit $name - Coming Soon!';
  }

  @override
  String get emergencyDeleteContactTitle => 'Delete Contact';

  @override
  String emergencyDeleteContactBody(Object name) {
    return 'Are you sure you want to remove $name from emergency contacts?';
  }

  @override
  String get emergencyContactRemoved => 'Contact removed';

  @override
  String emergencyContactAdded(Object name) {
    return '$name added to emergency contacts';
  }

  @override
  String get emergencyEditMedicalInfoComingSoon =>
      'Edit medical information - Coming Soon!';

  @override
  String get emergencyContactTypeFamily => 'Family';

  @override
  String get emergencyContactTypeMedical => 'Medical';

  @override
  String get emergencyContactTypeFriend => 'Friend';

  @override
  String get emergencyContactTypeOther => 'Other';

  @override
  String get commonEdit => 'Edit';

  @override
  String get careTeamTitle => 'Care Team';

  @override
  String get careTeamSubtitle =>
      'You are in control. Review your sharing permissions below.';

  @override
  String get careTeamEmptyCaregivers => 'No caregivers added yet';

  @override
  String get careTeamActiveCaregivers => 'Active Caregivers';

  @override
  String get careTeamPendingInvitations => 'Pending Invitations';

  @override
  String get careTeamInviteTitle => 'Invite Caregiver';

  @override
  String get careTeamInviteNameLabel => 'Name';

  @override
  String get careTeamInviteNameHint => 'Enter caregiver\'s full name';

  @override
  String get careTeamInviteEmailLabel => 'Email';

  @override
  String get careTeamInviteEmailHint => 'Enter caregiver\'s email address';

  @override
  String get careTeamInviteRelationshipLabel => 'Relationship';

  @override
  String get careTeamInviteRelationshipHint =>
      'e.g., Son, Daughter, Friend, Nurse';

  @override
  String get careTeamInviteRequiredFields => 'Email and role are required';

  @override
  String get careTeamInviteSend => 'Send Invite';

  @override
  String get careTeamAccessUpdated => 'Access updated successfully';

  @override
  String get careTeamAccessUpdateFailed =>
      'Failed to update access. Please try again.';

  @override
  String get careTeamRemoveTitle => 'Remove caregiver?';

  @override
  String get careTeamRemoveBody =>
      'Are you sure you want to remove this caregiver? They will lose access immediately.';

  @override
  String get careTeamRemoveConfirm => 'Remove';

  @override
  String get careTeamRemoving => 'Removing caregiver...';

  @override
  String get careTeamRemoveFailed =>
      'Failed to remove caregiver. Please try again.';

  @override
  String get careTeamManageAccessTitle => 'Manage Access';

  @override
  String get careTeamManageAccessSubtitle =>
      'Update caregiver permission or remove access.';

  @override
  String get careTeamUpdatingAccess => 'Updating access...';

  @override
  String get careTeamAccessView => 'View Access';

  @override
  String get careTeamAccessFull => 'Full Access';

  @override
  String get careTeamAccessViewOnly => 'View Only';

  @override
  String get careTeamResendingInvite => 'Resending invitation...';

  @override
  String get careTeamInviteResent => 'Invitation resent';

  @override
  String get careTeamInviteResendFailed => 'Failed to resend invitation';

  @override
  String get careTeamCancelingInvite => 'Canceling invitation...';

  @override
  String get careTeamInviteCanceled => 'Invitation canceled';

  @override
  String get careTeamInviteCancelFailed => 'Failed to cancel invitation';

  @override
  String get careTeamInvitationPending => 'Invitation Pending';

  @override
  String get careTeamResend => 'Resend';

  @override
  String get careTeamManageButton => 'Manage';

  @override
  String get careTeamInviteTileTitle => 'Invite Caregiver';

  @override
  String get careTeamInviteTileSubtitle =>
      'Share access to your health information';

  @override
  String get cameraSave => 'Save';

  @override
  String get cameraModeRx => 'Rx';

  @override
  String get cameraModeLab => 'Lab';

  @override
  String get cameraModeMed => 'Med';

  @override
  String get cameraTapToCapture => 'Tap to capture';

  @override
  String get cameraProcessingShort => 'Processing...';

  @override
  String get cameraProcessingImage => 'Processing image...';

  @override
  String get cameraScanSuccessful => 'Scan Successful!';

  @override
  String get cameraShare => 'Share';

  @override
  String get cameraNotReady => 'Camera not ready. Please try again.';

  @override
  String cameraCaptureFailed(Object error) {
    return 'Failed to capture image: $error';
  }

  @override
  String get cameraUploadSuccess => 'Image uploaded successfully!';

  @override
  String cameraUploadFailed(Object error) {
    return 'Failed to upload image: $error';
  }

  @override
  String get cameraScanSaved => 'Scan saved successfully!';

  @override
  String get cameraShareComingSoon => 'Share functionality - Coming Soon!';

  @override
  String get cameraPrescriptionScanned => 'Prescription scanned successfully';

  @override
  String get cameraLabReportProcessed => 'Lab report processed successfully';

  @override
  String get cameraMedicationExtracted => 'Medication information extracted';

  @override
  String get cameraConsentTitle => 'Document Scanning';

  @override
  String get cameraConsentBody =>
      'The camera helps scan medical documents like prescriptions and lab reports.\n\n• Camera is used only when you choose to scan\n• Images are processed securely and deleted from your phone\n• Photos are never saved to your device gallery\n\nWould you like to proceed?';

  @override
  String get cameraConsentNotNow => 'Not Now';

  @override
  String get cameraConsentConfirm => 'Yes, Scan';

  @override
  String get cameraSectionPrescriptionDetails => 'Prescription Details';

  @override
  String get cameraLabelMedication => 'Medication';

  @override
  String get cameraValueLisinopril => 'Lisinopril';

  @override
  String get cameraLabelDosage => 'Dosage';

  @override
  String get cameraValue10mg => '10mg';

  @override
  String get cameraLabelFrequency => 'Frequency';

  @override
  String get cameraValueOnceDaily => 'Once daily';

  @override
  String get cameraLabelQuantity => 'Quantity';

  @override
  String get cameraValue90Tablets => '90 tablets';

  @override
  String get cameraLabelRefills => 'Refills';

  @override
  String get cameraValue3Remaining => '3 remaining';

  @override
  String get cameraSectionPrescriberInfo => 'Prescriber Information';

  @override
  String get cameraLabelDoctor => 'Doctor';

  @override
  String get cameraValueDrSarahJohnson => 'Dr. Sarah Johnson';

  @override
  String get cameraLabelLicense => 'License';

  @override
  String get cameraValueLicenseId => 'MD123456';

  @override
  String get cameraLabelDate => 'Date';

  @override
  String get cameraValueDec122024 => 'Dec 12, 2024';

  @override
  String get cameraSectionPharmacyInfo => 'Pharmacy Information';

  @override
  String get cameraLabelPharmacy => 'Pharmacy';

  @override
  String get cameraValueCityMedicalPharmacy => 'City Medical Pharmacy';

  @override
  String get cameraLabelPhone => 'Phone';

  @override
  String get cameraValuePhoneSample => '(555) 123-4567';

  @override
  String get cameraLabelAddress => 'Address';

  @override
  String get cameraValuePharmacyAddress => '123 Main St, City, ST 12345';

  @override
  String get cameraSectionPatientInfo => 'Patient Information';

  @override
  String get cameraLabelName => 'Name';

  @override
  String get cameraValueJohnDoe => 'John Doe';

  @override
  String get cameraLabelDob => 'DOB';

  @override
  String get cameraValueDobSample => '01/15/1985';

  @override
  String get cameraLabelId => 'ID';

  @override
  String get cameraValuePatientId => 'P123456789';

  @override
  String get cameraSectionTestResults => 'Test Results';

  @override
  String get cameraLabelCholesterolTotal => 'Cholesterol (Total)';

  @override
  String get cameraValueCholesterolTotal => '185 mg/dL';

  @override
  String get cameraRefCholesterolTotal => 'Normal: <200';

  @override
  String get cameraLabelHdlCholesterol => 'HDL Cholesterol';

  @override
  String get cameraValueHdl => '45 mg/dL';

  @override
  String get cameraRefHdl => 'Normal: >40';

  @override
  String get cameraLabelLdlCholesterol => 'LDL Cholesterol';

  @override
  String get cameraValueLdl => '120 mg/dL';

  @override
  String get cameraRefLdl => 'Normal: <130';

  @override
  String get cameraLabelTriglycerides => 'Triglycerides';

  @override
  String get cameraValueTriglycerides => '150 mg/dL';

  @override
  String get cameraRefTriglycerides => 'Normal: <150';

  @override
  String get cameraSectionLabInfo => 'Lab Information';

  @override
  String get cameraLabelLab => 'Lab';

  @override
  String get cameraValueCityMedicalLabs => 'City Medical Labs';

  @override
  String get cameraLabelReportDate => 'Report Date';

  @override
  String get cameraValueDec102024 => 'Dec 10, 2024';

  @override
  String get cameraLabelCollected => 'Collected';

  @override
  String get cameraValueDec092024 => 'Dec 9, 2024';

  @override
  String get cameraSectionMedicationInfo => 'Medication Information';

  @override
  String get cameraLabelStrength => 'Strength';

  @override
  String get cameraLabelForm => 'Form';

  @override
  String get cameraValueTablet => 'Tablet';

  @override
  String get cameraSectionUsageInstructions => 'Usage Instructions';

  @override
  String get cameraLabelDirections => 'Directions';

  @override
  String get cameraValueDirectionsSample =>
      'Take one tablet by mouth once daily';

  @override
  String get cameraLabelPurpose => 'Purpose';

  @override
  String get cameraValuePurposeSample => 'Blood pressure management';

  @override
  String get cameraLabelStorage => 'Storage';

  @override
  String get cameraValueStorageSample => 'Store at room temperature';

  @override
  String get cameraSectionAdditionalInfo => 'Additional Information';

  @override
  String get cameraLabelManufacturer => 'Manufacturer';

  @override
  String get cameraValueManufacturerSample => 'Generic Pharmaceuticals';

  @override
  String get cameraLabelLotNumber => 'Lot Number';

  @override
  String get cameraValueLotNumberSample => 'LP2024001';

  @override
  String get cameraLabelExpiration => 'Expiration';

  @override
  String get cameraValueExpirationSample => '06/2026';

  @override
  String get accountDetailsTitle => 'Account Details';

  @override
  String get accountDetailsNameLabel => 'Name';

  @override
  String get accountDetailsEmailLabel => 'Email';

  @override
  String get accountDetailsAccountTypeLabel => 'Account Type';

  @override
  String get accountDetailsAccountTypePatient => 'Patient';

  @override
  String get accountDetailsAccountTypeCaregiver => 'Caregiver';

  @override
  String get accountDetailsNotSet => 'Not set';

  @override
  String get accountDetailsPhoneLabel => 'Phone';

  @override
  String get accountDetailsPhoneEdit => 'Edit';

  @override
  String get accountDetailsPhoneAdd => 'Add';

  @override
  String get accountDetailsPlanLabel => 'Plan';

  @override
  String get accountDetailsPlanFree => 'Free';

  @override
  String get accountDetailsPlanPremium => 'Premium';

  @override
  String get accountDetailsPlanUpgrade => 'Upgrade';

  @override
  String get accountDetailsPlanManage => 'Manage';

  @override
  String get accountDetailsUsageLabel => 'Usage';

  @override
  String accountDetailsUsageFreePlan(Object limit, Object used) {
    return 'Free plan — $used / $limit summaries used';
  }

  @override
  String get accountDetailsUsageUnlimited => 'Unlimited';

  @override
  String get accountDetailsPhoneEditTitle => 'Edit Phone Number';

  @override
  String get accountDetailsPhoneHint => '+1 (555) 123-4567';

  @override
  String get accountDetailsPhoneMinLengthError =>
      'Phone number must be at least 8 characters long';

  @override
  String get accountDetailsPhoneUpdated => 'Phone number updated successfully';

  @override
  String accountDetailsPhoneUpdateFailed(Object error) {
    return 'Failed to update phone number: $error';
  }

  @override
  String get commonSave => 'Save';
}
