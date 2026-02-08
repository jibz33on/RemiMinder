import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('hi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'RemiMinder'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettings;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// No description provided for @languageMandarin.
  ///
  /// In en, this message translates to:
  /// **'Mandarin'**
  String get languageMandarin;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get languageGerman;

  /// No description provided for @countryUnitedStates.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get countryUnitedStates;

  /// No description provided for @countryCanada.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get countryCanada;

  /// No description provided for @countryUnitedKingdom.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get countryUnitedKingdom;

  /// No description provided for @countryGermany.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get countryGermany;

  /// No description provided for @countryIndia.
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get countryIndia;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to RemiMinder'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Smart AI for Health & Care Coordination'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Your intelligent companion for medication reminders, appointment tracking, and care coordination. Never miss an important health moment again.'**
  String get welcomeDescription;

  /// No description provided for @welcomeGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get welcomeGetStarted;

  /// No description provided for @roleChooseYourRole.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Context'**
  String get roleChooseYourRole;

  /// No description provided for @roleSelectHowYouUse.
  ///
  /// In en, this message translates to:
  /// **'Select how you want to use RemiMinder'**
  String get roleSelectHowYouUse;

  /// No description provided for @rolePatient.
  ///
  /// In en, this message translates to:
  /// **'Patient context'**
  String get rolePatient;

  /// No description provided for @rolePatientDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your own medications, appointments, and health records'**
  String get rolePatientDescription;

  /// No description provided for @roleCaregiver.
  ///
  /// In en, this message translates to:
  /// **'Caregiver context'**
  String get roleCaregiver;

  /// No description provided for @roleCaregiverDescription.
  ///
  /// In en, this message translates to:
  /// **'Help manage medications and care for family members or patients'**
  String get roleCaregiverDescription;

  /// No description provided for @roleContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get roleContinue;

  /// No description provided for @onboardingAppLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your app language'**
  String get onboardingAppLanguageTitle;

  /// No description provided for @onboardingAppLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This updates the UI language.'**
  String get onboardingAppLanguageSubtitle;

  /// No description provided for @onboardingCountryTitle.
  ///
  /// In en, this message translates to:
  /// **'Select your country or region'**
  String get onboardingCountryTitle;

  /// No description provided for @onboardingCountrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional, helps tailor the experience.'**
  String get onboardingCountrySubtitle;

  /// No description provided for @onboardingTimezoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your timezone'**
  String get onboardingTimezoneTitle;

  /// No description provided for @onboardingTimezoneDetected.
  ///
  /// In en, this message translates to:
  /// **'We detected: {timezone}'**
  String onboardingTimezoneDetected(Object timezone);

  /// No description provided for @onboardingTimezoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get onboardingTimezoneLabel;

  /// No description provided for @onboardingTimezoneConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get onboardingTimezoneConfirm;

  /// No description provided for @onboardingVisitLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your visit language'**
  String get onboardingVisitLanguageTitle;

  /// No description provided for @onboardingVisitLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This will be used for recording visits and generating summaries'**
  String get onboardingVisitLanguageSubtitle;

  /// No description provided for @loginBrandName.
  ///
  /// In en, this message translates to:
  /// **'RemiMinder.ai'**
  String get loginBrandName;

  /// No description provided for @loginContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginContinueWithGoogle;

  /// No description provided for @loginContinueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get loginContinueWithApple;

  /// No description provided for @loginContinueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with Email'**
  String get loginContinueWithEmail;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get loginCreateAccount;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginForgotPassword;

  /// No description provided for @loginSignInWithEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Email'**
  String get loginSignInWithEmailTitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @loginRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get loginRememberMe;

  /// No description provided for @loginSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginSignIn;

  /// No description provided for @loginFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get loginFillAllFields;

  /// No description provided for @loginAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get loginAuthFailed;

  /// No description provided for @loginInvalidEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password. Please check your credentials and try again.'**
  String get loginInvalidEmailOrPassword;

  /// No description provided for @loginEmailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Please check your email and confirm your account before signing in.'**
  String get loginEmailNotConfirmed;

  /// No description provided for @loginUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email address.'**
  String get loginUserNotFound;

  /// No description provided for @loginConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please check your internet connection and try again.'**
  String get loginConnectionError;

  /// No description provided for @loginRequestTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get loginRequestTimedOut;

  /// No description provided for @loginSignInFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed. Please try again or contact support if the problem persists.'**
  String get loginSignInFailedGeneric;

  /// No description provided for @loginGoogleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google Sign In failed'**
  String get loginGoogleSignInFailed;

  /// No description provided for @loginGoogleSignInFailedWithError.
  ///
  /// In en, this message translates to:
  /// **'Google Sign In failed: {error}'**
  String loginGoogleSignInFailedWithError(Object error);

  /// No description provided for @loginAppleSignInComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Apple Sign In - Coming Soon!'**
  String get loginAppleSignInComingSoon;

  /// No description provided for @loginContinueWithoutSigningIn.
  ///
  /// In en, this message translates to:
  /// **'Continue without signing in'**
  String get loginContinueWithoutSigningIn;

  /// No description provided for @loginBypassPatient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get loginBypassPatient;

  /// No description provided for @loginBypassCaregiver.
  ///
  /// In en, this message translates to:
  /// **'Caregiver'**
  String get loginBypassCaregiver;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join RemiMinder to get started'**
  String get registerSubtitle;

  /// No description provided for @registerFirstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get registerFirstNameLabel;

  /// No description provided for @registerFirstNameHint.
  ///
  /// In en, this message translates to:
  /// **'John'**
  String get registerFirstNameHint;

  /// No description provided for @registerFirstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get registerFirstNameRequired;

  /// No description provided for @registerLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get registerLastNameLabel;

  /// No description provided for @registerLastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Doe'**
  String get registerLastNameHint;

  /// No description provided for @registerLastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get registerLastNameRequired;

  /// No description provided for @registerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerEmailLabel;

  /// No description provided for @registerEmailHint.
  ///
  /// In en, this message translates to:
  /// **'john.doe@example.com'**
  String get registerEmailHint;

  /// No description provided for @registerEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get registerEmailRequired;

  /// No description provided for @registerEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get registerEmailInvalid;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPasswordLabel;

  /// No description provided for @registerPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password'**
  String get registerPasswordHint;

  /// No description provided for @registerPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get registerPasswordRequired;

  /// No description provided for @registerPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get registerPasswordTooShort;

  /// No description provided for @registerConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get registerConfirmPasswordLabel;

  /// No description provided for @registerConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get registerConfirmPasswordHint;

  /// No description provided for @registerConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get registerConfirmPasswordRequired;

  /// No description provided for @registerPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get registerPasswordMismatch;

  /// No description provided for @registerTermsIntro.
  ///
  /// In en, this message translates to:
  /// **'By creating an account, you agree to our '**
  String get registerTermsIntro;

  /// No description provided for @registerTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get registerTermsOfService;

  /// No description provided for @registerAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get registerAnd;

  /// No description provided for @registerPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get registerPrivacyPolicy;

  /// No description provided for @registerCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerCreateAccountButton;

  /// No description provided for @registerAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get registerAlreadyHaveAccount;

  /// No description provided for @registerSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get registerSignIn;

  /// No description provided for @registerAcceptTermsError.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms and Conditions'**
  String get registerAcceptTermsError;

  /// No description provided for @registerSelectRoleFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a context first'**
  String get registerSelectRoleFirst;

  /// No description provided for @registerAccountCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Created!'**
  String get registerAccountCreatedTitle;

  /// No description provided for @registerAccountCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account has been created successfully. You can now sign in with your email and password.'**
  String get registerAccountCreatedMessage;

  /// No description provided for @registerGoToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Go to Sign In'**
  String get registerGoToSignIn;

  /// No description provided for @registerTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get registerTermsTitle;

  /// No description provided for @registerTermsBody.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service for RemiMinder\n\n1. Acceptance of Terms\nBy using RemiMinder, you agree to these terms.\n\n2. Use of Service\nRemiMinder is designed to help manage healthcare and medication reminders.\n\n3. Privacy\nYour privacy is important to us. All health data is handled securely.\n\n4. Account Responsibility\nYou are responsible for maintaining the confidentiality of your account.\n\n5. Limitation of Liability\nRemiMinder is not a substitute for professional medical advice.\n\nFor the complete Terms of Service, please visit our website.'**
  String get registerTermsBody;

  /// No description provided for @registerPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get registerPrivacyTitle;

  /// No description provided for @registerPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy for RemiMinder\n\n1. Information We Collect\nWe collect information you provide and usage data to improve our service.\n\n2. How We Use Information\nInformation is used to provide healthcare management services and improve user experience.\n\n3. Information Sharing\nWe do not sell your personal information. Data is only shared with healthcare providers you authorize.\n\n4. Data Security\nWe implement industry-standard security measures to protect your health data.\n\n5. Your Rights\nYou have the right to access, correct, or delete your personal information.\n\nFor the complete Privacy Policy, please visit our website.'**
  String get registerPrivacyBody;

  /// No description provided for @registerAccountExists.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists. Please sign in instead.'**
  String get registerAccountExists;

  /// No description provided for @registerWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Please use at least 8 characters with letters and numbers.'**
  String get registerWeakPassword;

  /// No description provided for @registerConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please check your internet connection and try again.'**
  String get registerConnectionError;

  /// No description provided for @registerRequestTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get registerRequestTimedOut;

  /// No description provided for @registerFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again or contact support if the problem persists.'**
  String get registerFailedGeneric;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No worries! Enter your email and we\'ll send you reset instructions.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get forgotPasswordEmailHint;

  /// No description provided for @forgotPasswordEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get forgotPasswordEmailRequired;

  /// No description provided for @forgotPasswordEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get forgotPasswordEmailInvalid;

  /// No description provided for @forgotPasswordSendInstructions.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Instructions'**
  String get forgotPasswordSendInstructions;

  /// No description provided for @forgotPasswordRememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get forgotPasswordRememberPassword;

  /// No description provided for @forgotPasswordBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get forgotPasswordBackToLogin;

  /// No description provided for @forgotPasswordSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for this email, we\'ve sent you password reset instructions.'**
  String get forgotPasswordSuccessMessage;

  /// No description provided for @forgotPasswordSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset email. Please check the email and try again.'**
  String get forgotPasswordSendFailed;

  /// No description provided for @forgotPasswordNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Password reset is not available for this account.'**
  String get forgotPasswordNotAvailable;

  /// No description provided for @forgotPasswordTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again later.'**
  String get forgotPasswordTooManyRequests;

  /// No description provided for @forgotPasswordNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get forgotPasswordNetworkError;

  /// No description provided for @patientHomeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get patientHomeGreetingMorning;

  /// No description provided for @patientHomeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get patientHomeGreetingAfternoon;

  /// No description provided for @patientHomeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get patientHomeGreetingEvening;

  /// No description provided for @patientHomeGreetingNight.
  ///
  /// In en, this message translates to:
  /// **'Good night'**
  String get patientHomeGreetingNight;

  /// No description provided for @patientHomeFeelingToday.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today?'**
  String get patientHomeFeelingToday;

  /// No description provided for @patientHomeTodaysSchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get patientHomeTodaysSchedule;

  /// No description provided for @patientHomeTodoList.
  ///
  /// In en, this message translates to:
  /// **'To-do List'**
  String get patientHomeTodoList;

  /// No description provided for @patientHomeUpNext.
  ///
  /// In en, this message translates to:
  /// **'Up Next'**
  String get patientHomeUpNext;

  /// No description provided for @patientHomeNoUpcomingReminders.
  ///
  /// In en, this message translates to:
  /// **'No upcoming reminders'**
  String get patientHomeNoUpcomingReminders;

  /// No description provided for @patientHomeMarkedAsTaken.
  ///
  /// In en, this message translates to:
  /// **'Marked as taken!'**
  String get patientHomeMarkedAsTaken;

  /// No description provided for @patientHomeTakeNow.
  ///
  /// In en, this message translates to:
  /// **'Take Now'**
  String get patientHomeTakeNow;

  /// No description provided for @patientHomeReminderSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Reminder snoozed for 1 hour'**
  String get patientHomeReminderSnoozed;

  /// No description provided for @patientHomeNothingScheduled.
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled for today'**
  String get patientHomeNothingScheduled;

  /// No description provided for @patientHomeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get patientHomeViewAll;

  /// No description provided for @patientHomeAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get patientHomeAddItem;

  /// No description provided for @patientHomeNoTasksYet.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get patientHomeNoTasksYet;

  /// No description provided for @patientHomeAddTask.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get patientHomeAddTask;

  /// No description provided for @patientHomeAddedRecently.
  ///
  /// In en, this message translates to:
  /// **'Added recently'**
  String get patientHomeAddedRecently;

  /// No description provided for @patientHomeAddedDate.
  ///
  /// In en, this message translates to:
  /// **'Added {date}'**
  String patientHomeAddedDate(Object date);

  /// No description provided for @patientHomeUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get patientHomeUpcoming;

  /// No description provided for @patientHomeDueNow.
  ///
  /// In en, this message translates to:
  /// **'Due now'**
  String get patientHomeDueNow;

  /// No description provided for @patientHomeDueInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Due in {minutes} min'**
  String patientHomeDueInMinutes(Object minutes);

  /// No description provided for @patientHomeDueInHours.
  ///
  /// In en, this message translates to:
  /// **'Due in {hours} hours'**
  String patientHomeDueInHours(Object hours);

  /// No description provided for @patientHomeDueInDays.
  ///
  /// In en, this message translates to:
  /// **'Due in {days} days'**
  String patientHomeDueInDays(Object days);

  /// No description provided for @patientHomeDueOnDate.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String patientHomeDueOnDate(Object date);

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @caregiverPatientsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Patients'**
  String get caregiverPatientsTitle;

  /// No description provided for @caregiverPatientsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search patients by name, relationship, or condition...'**
  String get caregiverPatientsSearchHint;

  /// No description provided for @caregiverPatientsClearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get caregiverPatientsClearFilter;

  /// No description provided for @caregiverPatientsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {# Patient} other {# Patients}}'**
  String caregiverPatientsCount(num count);

  /// No description provided for @caregiverPatientsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get caregiverPatientsFilterAll;

  /// No description provided for @caregiverPatientsFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get caregiverPatientsFilterActive;

  /// No description provided for @caregiverPatientsFilterAttention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get caregiverPatientsFilterAttention;

  /// No description provided for @caregiverPatientsFilterCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get caregiverPatientsFilterCritical;

  /// No description provided for @caregiverPatientsFilterDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Patients'**
  String get caregiverPatientsFilterDialogTitle;

  /// No description provided for @caregiverPatientsEmptyNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No patients match your search'**
  String get caregiverPatientsEmptyNoMatch;

  /// No description provided for @caregiverPatientsEmptyNone.
  ///
  /// In en, this message translates to:
  /// **'No patients found'**
  String get caregiverPatientsEmptyNone;

  /// No description provided for @caregiverPatientsEmptyAdjustSearch.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search terms'**
  String get caregiverPatientsEmptyAdjustSearch;

  /// No description provided for @caregiverPatientsEmptyAddPatients.
  ///
  /// In en, this message translates to:
  /// **'Add patients to start managing their care'**
  String get caregiverPatientsEmptyAddPatients;

  /// No description provided for @caregiverPatientsAddFirstComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Add First Patient - Coming Soon!'**
  String get caregiverPatientsAddFirstComingSoon;

  /// No description provided for @caregiverPatientsAddPatientButton.
  ///
  /// In en, this message translates to:
  /// **'Add Patient'**
  String get caregiverPatientsAddPatientButton;

  /// No description provided for @caregiverPatientsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load patients'**
  String get caregiverPatientsLoadFailed;

  /// No description provided for @caregiverPatientsAddNewComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Add New Patient - Coming Soon!'**
  String get caregiverPatientsAddNewComingSoon;

  /// No description provided for @caregiverPatientsRelationshipAge.
  ///
  /// In en, this message translates to:
  /// **'{relationship} • Age {age}'**
  String caregiverPatientsRelationshipAge(Object age, Object relationship);

  /// No description provided for @caregiverPatientsStatAdherence.
  ///
  /// In en, this message translates to:
  /// **'Adherence'**
  String get caregiverPatientsStatAdherence;

  /// No description provided for @caregiverPatientsStatAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get caregiverPatientsStatAppointments;

  /// No description provided for @caregiverPatientsStatLastVisit.
  ///
  /// In en, this message translates to:
  /// **'Last Visit'**
  String get caregiverPatientsStatLastVisit;

  /// No description provided for @caregiverPatientsViewAlerts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {View # Alert} other {View # Alerts}}'**
  String caregiverPatientsViewAlerts(num count);

  /// No description provided for @caregiverPatientsViewAppointments.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {# Appointment} other {# Appointments}}'**
  String caregiverPatientsViewAppointments(num count);

  /// No description provided for @caregiverPatientsViewAlertsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'View alerts for {name} - Coming Soon!'**
  String caregiverPatientsViewAlertsComingSoon(Object name);

  /// No description provided for @caregiverPatientsViewAppointmentsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'View appointments for {name} - Coming Soon!'**
  String caregiverPatientsViewAppointmentsComingSoon(Object name);

  /// No description provided for @caregiverPatientsLastVisitToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get caregiverPatientsLastVisitToday;

  /// No description provided for @caregiverPatientsLastVisitYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get caregiverPatientsLastVisitYesterday;

  /// No description provided for @caregiverPatientsLastVisitDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {# day ago} other {# days ago}}'**
  String caregiverPatientsLastVisitDays(num count);

  /// No description provided for @caregiverPatientsLastVisitWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {# week ago} other {# weeks ago}}'**
  String caregiverPatientsLastVisitWeeks(num count);

  /// No description provided for @caregiverPatientsLastVisitMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {# month ago} other {# months ago}}'**
  String caregiverPatientsLastVisitMonths(num count);

  /// No description provided for @caregiverPatientOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Patient Overview'**
  String get caregiverPatientOverviewTitle;

  /// No description provided for @caregiverPatientOverviewTabVisits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get caregiverPatientOverviewTabVisits;

  /// No description provided for @caregiverPatientOverviewTabReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get caregiverPatientOverviewTabReminders;

  /// No description provided for @caregiverPatientOverviewTabNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get caregiverPatientOverviewTabNotes;

  /// No description provided for @caregiverPatientOverviewNoVisits.
  ///
  /// In en, this message translates to:
  /// **'No visits available'**
  String get caregiverPatientOverviewNoVisits;

  /// No description provided for @caregiverPatientOverviewNoReminders.
  ///
  /// In en, this message translates to:
  /// **'No reminders available'**
  String get caregiverPatientOverviewNoReminders;

  /// No description provided for @caregiverPatientOverviewNoNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes available'**
  String get caregiverPatientOverviewNoNotes;

  /// No description provided for @caregiverPatientOverviewEditComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit Patient - Coming Soon!'**
  String get caregiverPatientOverviewEditComingSoon;

  /// No description provided for @caregiverPatientOverviewCallPatient.
  ///
  /// In en, this message translates to:
  /// **'Call Patient'**
  String get caregiverPatientOverviewCallPatient;

  /// No description provided for @caregiverPatientOverviewSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get caregiverPatientOverviewSendMessage;

  /// No description provided for @caregiverPatientOverviewEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get caregiverPatientOverviewEmergencyContact;

  /// No description provided for @caregiverPatientOverviewSharePatientInfo.
  ///
  /// In en, this message translates to:
  /// **'Share Patient Info'**
  String get caregiverPatientOverviewSharePatientInfo;

  /// No description provided for @caregiverPatientOverviewScheduleAppointment.
  ///
  /// In en, this message translates to:
  /// **'Schedule New Appointment - Coming Soon!'**
  String get caregiverPatientOverviewScheduleAppointment;

  /// No description provided for @caregiverPatientOverviewAddReminder.
  ///
  /// In en, this message translates to:
  /// **'Add New Reminder - Coming Soon!'**
  String get caregiverPatientOverviewAddReminder;

  /// No description provided for @caregiverPatientOverviewAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add New Note - Coming Soon!'**
  String get caregiverPatientOverviewAddNote;

  /// No description provided for @caregiverPatientOverviewViewVisitDetails.
  ///
  /// In en, this message translates to:
  /// **'View {type} details - Coming Soon!'**
  String caregiverPatientOverviewViewVisitDetails(Object type);

  /// No description provided for @caregiverPatientOverviewViewReminderDetails.
  ///
  /// In en, this message translates to:
  /// **'View {title} details - Coming Soon!'**
  String caregiverPatientOverviewViewReminderDetails(Object title);

  /// No description provided for @caregiverPatientOverviewViewNoteDetails.
  ///
  /// In en, this message translates to:
  /// **'View {title} details - Coming Soon!'**
  String caregiverPatientOverviewViewNoteDetails(Object title);

  /// No description provided for @caregiverPatientOverviewMissingPatientId.
  ///
  /// In en, this message translates to:
  /// **'Missing patientId'**
  String get caregiverPatientOverviewMissingPatientId;

  /// No description provided for @caregiverPatientOverviewOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get caregiverPatientOverviewOverdue;

  /// No description provided for @caregiverPatientOverviewInHours.
  ///
  /// In en, this message translates to:
  /// **'In {hours} hours'**
  String caregiverPatientOverviewInHours(Object hours);

  /// No description provided for @caregiverPatientOverviewDefaultRelationship.
  ///
  /// In en, this message translates to:
  /// **'Care Team'**
  String get caregiverPatientOverviewDefaultRelationship;

  /// No description provided for @caregiverPatientOverviewDefaultCondition.
  ///
  /// In en, this message translates to:
  /// **'Authorized access'**
  String get caregiverPatientOverviewDefaultCondition;

  /// No description provided for @caregiverAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get caregiverAlertsTitle;

  /// No description provided for @caregiverAlertsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get caregiverAlertsFilterAll;

  /// No description provided for @caregiverAlertsFilterUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get caregiverAlertsFilterUnread;

  /// No description provided for @caregiverAlertsFilterRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get caregiverAlertsFilterRead;

  /// No description provided for @caregiverAlertsFilterHighPriority.
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get caregiverAlertsFilterHighPriority;

  /// No description provided for @caregiverAlertsFilterActionRequired.
  ///
  /// In en, this message translates to:
  /// **'Action Required'**
  String get caregiverAlertsFilterActionRequired;

  /// No description provided for @caregiverAlertsClearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get caregiverAlertsClearFilter;

  /// No description provided for @caregiverAlertsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {# Alert} other {# Alerts}}'**
  String caregiverAlertsCount(num count);

  /// No description provided for @caregiverAlertsMarkAllReadTooltip.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get caregiverAlertsMarkAllReadTooltip;

  /// No description provided for @caregiverAlertsActionRequired.
  ///
  /// In en, this message translates to:
  /// **'Action Required'**
  String get caregiverAlertsActionRequired;

  /// No description provided for @caregiverAlertsMarkRead.
  ///
  /// In en, this message translates to:
  /// **'Mark Read'**
  String get caregiverAlertsMarkRead;

  /// No description provided for @caregiverAlertsTakeAction.
  ///
  /// In en, this message translates to:
  /// **'Take Action'**
  String get caregiverAlertsTakeAction;

  /// No description provided for @caregiverAlertsEmptyAllTitle.
  ///
  /// In en, this message translates to:
  /// **'No alerts at this time'**
  String get caregiverAlertsEmptyAllTitle;

  /// No description provided for @caregiverAlertsEmptyAllSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All patient activities are running smoothly'**
  String get caregiverAlertsEmptyAllSubtitle;

  /// No description provided for @caregiverAlertsEmptyFilteredTitle.
  ///
  /// In en, this message translates to:
  /// **'No alerts match this filter'**
  String get caregiverAlertsEmptyFilteredTitle;

  /// No description provided for @caregiverAlertsEmptyFilteredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filter to see more alerts'**
  String get caregiverAlertsEmptyFilteredSubtitle;

  /// No description provided for @caregiverAlertsViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All Alerts'**
  String get caregiverAlertsViewAll;

  /// No description provided for @caregiverAlertsMarkedRead.
  ///
  /// In en, this message translates to:
  /// **'Alert marked as read'**
  String get caregiverAlertsMarkedRead;

  /// No description provided for @caregiverAlertsMarkedUnread.
  ///
  /// In en, this message translates to:
  /// **'Alert marked as unread'**
  String get caregiverAlertsMarkedUnread;

  /// No description provided for @caregiverAlertsAllAlreadyRead.
  ///
  /// In en, this message translates to:
  /// **'All alerts are already read'**
  String get caregiverAlertsAllAlreadyRead;

  /// No description provided for @caregiverAlertsMarkedAllRead.
  ///
  /// In en, this message translates to:
  /// **'Marked {count} alerts as read'**
  String caregiverAlertsMarkedAllRead(Object count);

  /// No description provided for @caregiverAlertsTakingAction.
  ///
  /// In en, this message translates to:
  /// **'Taking action on {type} alert'**
  String caregiverAlertsTakingAction(Object type);

  /// No description provided for @caregiverAlertsViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details for {type} alert'**
  String caregiverAlertsViewDetails(Object type);

  /// No description provided for @caregiverInvitationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Caregiver Invitations'**
  String get caregiverInvitationsTitle;

  /// No description provided for @caregiverInvitationsRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get caregiverInvitationsRetry;

  /// No description provided for @caregiverInvitationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No pending invitations'**
  String get caregiverInvitationsEmpty;

  /// No description provided for @caregiverInvitationsRole.
  ///
  /// In en, this message translates to:
  /// **'Role: {role}'**
  String caregiverInvitationsRole(Object role);

  /// No description provided for @caregiverInvitationsPermission.
  ///
  /// In en, this message translates to:
  /// **'Permission: {permission}'**
  String caregiverInvitationsPermission(Object permission);

  /// No description provided for @caregiverInvitationsAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get caregiverInvitationsAccept;

  /// No description provided for @caregiverInvitationsMissingToken.
  ///
  /// In en, this message translates to:
  /// **'Invitation token is missing'**
  String get caregiverInvitationsMissingToken;

  /// No description provided for @caregiverInvitationsAccepted.
  ///
  /// In en, this message translates to:
  /// **'Invitation accepted'**
  String get caregiverInvitationsAccepted;

  /// No description provided for @caregiverInvitationsPatientFallback.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get caregiverInvitationsPatientFallback;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @overviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewTitle;

  /// No description provided for @overviewSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search summaries...'**
  String get overviewSearchHint;

  /// No description provided for @overviewTabSummaries.
  ///
  /// In en, this message translates to:
  /// **'SUMMARIES'**
  String get overviewTabSummaries;

  /// No description provided for @overviewTabLabResults.
  ///
  /// In en, this message translates to:
  /// **'LAB RESULTS'**
  String get overviewTabLabResults;

  /// No description provided for @overviewTabScannedDocs.
  ///
  /// In en, this message translates to:
  /// **'SCANNED DOCS'**
  String get overviewTabScannedDocs;

  /// No description provided for @overviewNewSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'🎉 Your visit summary is ready!'**
  String get overviewNewSummaryTitle;

  /// No description provided for @overviewNewSummaryPrompt.
  ///
  /// In en, this message translates to:
  /// **'Would you like to view it now?'**
  String get overviewNewSummaryPrompt;

  /// No description provided for @overviewNewSummaryLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get overviewNewSummaryLater;

  /// No description provided for @overviewNewSummaryView.
  ///
  /// In en, this message translates to:
  /// **'View Summary'**
  String get overviewNewSummaryView;

  /// No description provided for @overviewSelectAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Select at least one summary'**
  String get overviewSelectAtLeastOne;

  /// No description provided for @overviewDeleteSummaryTitleSingular.
  ///
  /// In en, this message translates to:
  /// **'Delete summary?'**
  String get overviewDeleteSummaryTitleSingular;

  /// No description provided for @overviewDeleteSummaryTitlePlural.
  ///
  /// In en, this message translates to:
  /// **'Delete summaries?'**
  String get overviewDeleteSummaryTitlePlural;

  /// No description provided for @overviewDeleteSummaryConfirmSingular.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this summary? This cannot be undone.'**
  String get overviewDeleteSummaryConfirmSingular;

  /// No description provided for @overviewDeleteSummaryConfirmPlural.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} summaries? This cannot be undone.'**
  String overviewDeleteSummaryConfirmPlural(Object count);

  /// No description provided for @overviewAuthError.
  ///
  /// In en, this message translates to:
  /// **'Authentication error. Please log in again.'**
  String get overviewAuthError;

  /// No description provided for @overviewDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully deleted {count, plural, one {# summary} other {# summaries}}'**
  String overviewDeleteSuccess(num count);

  /// No description provided for @overviewDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete summaries. Please try again.'**
  String get overviewDeleteFailed;

  /// No description provided for @overviewNoCaregiver.
  ///
  /// In en, this message translates to:
  /// **'No caregiver added yet'**
  String get overviewNoCaregiver;

  /// No description provided for @overviewShareTitleShare.
  ///
  /// In en, this message translates to:
  /// **'Share summary?'**
  String get overviewShareTitleShare;

  /// No description provided for @overviewShareTitleStop.
  ///
  /// In en, this message translates to:
  /// **'Stop sharing?'**
  String get overviewShareTitleStop;

  /// No description provided for @overviewShareConfirmShare.
  ///
  /// In en, this message translates to:
  /// **'You are about to share this summary with your caregivers. They will be able to view this visit summary.'**
  String get overviewShareConfirmShare;

  /// No description provided for @overviewShareConfirmStop.
  ///
  /// In en, this message translates to:
  /// **'Caregivers will no longer be able to view this summary.'**
  String get overviewShareConfirmStop;

  /// No description provided for @overviewShareAction.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get overviewShareAction;

  /// No description provided for @overviewStopShareAction.
  ///
  /// In en, this message translates to:
  /// **'Stop Sharing'**
  String get overviewStopShareAction;

  /// No description provided for @overviewSharingEnabled.
  ///
  /// In en, this message translates to:
  /// **'Caregiver sharing enabled'**
  String get overviewSharingEnabled;

  /// No description provided for @overviewSharingDisabled.
  ///
  /// In en, this message translates to:
  /// **'Caregiver sharing disabled'**
  String get overviewSharingDisabled;

  /// No description provided for @overviewSummariesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load summaries'**
  String get overviewSummariesLoadFailed;

  /// No description provided for @overviewNoSummariesTitle.
  ///
  /// In en, this message translates to:
  /// **'No summaries yet'**
  String get overviewNoSummariesTitle;

  /// No description provided for @overviewNoSummariesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your visit summaries will appear here'**
  String get overviewNoSummariesSubtitle;

  /// No description provided for @overviewProcessingTitle.
  ///
  /// In en, this message translates to:
  /// **'🕒 Your latest visit is being processed'**
  String get overviewProcessingTitle;

  /// No description provided for @overviewProcessingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll notify you when it\'s ready.'**
  String get overviewProcessingSubtitle;

  /// No description provided for @overviewLabResultsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Lab Results - Coming Soon'**
  String get overviewLabResultsComingSoon;

  /// No description provided for @overviewScannedDocsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Scanned Documents - Coming Soon'**
  String get overviewScannedDocsComingSoon;

  /// No description provided for @overviewShareLabel.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get overviewShareLabel;

  /// No description provided for @overviewDoctorVisit.
  ///
  /// In en, this message translates to:
  /// **'Doctor Visit'**
  String get overviewDoctorVisit;

  /// No description provided for @overviewDoctorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Dr. {name}'**
  String overviewDoctorPrefix(Object name);

  /// No description provided for @overviewMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String overviewMinutesAgo(Object count);

  /// No description provided for @overviewTodayAt.
  ///
  /// In en, this message translates to:
  /// **'Today, {time}'**
  String overviewTodayAt(Object time);

  /// No description provided for @overviewYesterdayAt.
  ///
  /// In en, this message translates to:
  /// **'Yesterday, {time}'**
  String overviewYesterdayAt(Object time);

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersTitle;

  /// No description provided for @remindersTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get remindersTabAll;

  /// No description provided for @remindersTabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get remindersTabToday;

  /// No description provided for @remindersTabPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get remindersTabPending;

  /// No description provided for @remindersTabCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get remindersTabCompleted;

  /// No description provided for @remindersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search reminders...'**
  String get remindersSearchHint;

  /// No description provided for @remindersDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Reminder'**
  String get remindersDeleteTitle;

  /// No description provided for @remindersDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this reminder?'**
  String get remindersDeleteConfirm;

  /// No description provided for @remindersMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark Done'**
  String get remindersMarkDone;

  /// No description provided for @remindersSnooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get remindersSnooze;

  /// No description provided for @remindersCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create Reminder'**
  String get remindersCreateButton;

  /// No description provided for @remindersCreateComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Create New Reminder - Coming Soon!'**
  String get remindersCreateComingSoon;

  /// No description provided for @remindersEditComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit {title} - Coming Soon!'**
  String remindersEditComingSoon(Object title);

  /// No description provided for @remindersMarkedCompleted.
  ///
  /// In en, this message translates to:
  /// **'Reminder marked as completed!'**
  String get remindersMarkedCompleted;

  /// No description provided for @remindersSnoozedForHour.
  ///
  /// In en, this message translates to:
  /// **'Reminder snoozed for 1 hour'**
  String get remindersSnoozedForHour;

  /// No description provided for @remindersDeleted.
  ///
  /// In en, this message translates to:
  /// **'Reminder deleted'**
  String get remindersDeleted;

  /// No description provided for @remindersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No reminders found'**
  String get remindersEmptyTitle;

  /// No description provided for @remindersEmptySearchTitle.
  ///
  /// In en, this message translates to:
  /// **'No reminders match your search'**
  String get remindersEmptySearchTitle;

  /// No description provided for @remindersEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first reminder to get started'**
  String get remindersEmptySubtitle;

  /// No description provided for @remindersEmptySearchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search terms'**
  String get remindersEmptySearchSubtitle;

  /// No description provided for @remindersSnoozedUntil.
  ///
  /// In en, this message translates to:
  /// **'Snoozed until {time}'**
  String remindersSnoozedUntil(Object time);

  /// No description provided for @remindersStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get remindersStatusDone;

  /// No description provided for @remindersStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get remindersStatusPending;

  /// No description provided for @remindersStatusSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Snoozed'**
  String get remindersStatusSnoozed;

  /// No description provided for @remindersStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get remindersStatusUnknown;

  /// No description provided for @remindersTimeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String remindersTimeHoursAgo(Object count);

  /// No description provided for @remindersTimeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String remindersTimeMinutesAgo(Object count);

  /// No description provided for @remindersTimeInHours.
  ///
  /// In en, this message translates to:
  /// **'In {count} hours'**
  String remindersTimeInHours(Object count);

  /// No description provided for @remindersTimeInMinutes.
  ///
  /// In en, this message translates to:
  /// **'In {count} minutes'**
  String remindersTimeInMinutes(Object count);

  /// No description provided for @remindersTimeNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get remindersTimeNow;

  /// No description provided for @remindersAdherenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Medication Adherence'**
  String get remindersAdherenceTitle;

  /// No description provided for @remindersAdherenceThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get remindersAdherenceThisWeek;

  /// No description provided for @remindersAdherenceThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get remindersAdherenceThisMonth;

  /// No description provided for @remindersAdherenceOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get remindersAdherenceOverall;

  /// No description provided for @remindersAdherenceByMedication.
  ///
  /// In en, this message translates to:
  /// **'By Medication'**
  String get remindersAdherenceByMedication;

  /// No description provided for @remindersAdherenceTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Adherence Tips'**
  String get remindersAdherenceTipsTitle;

  /// No description provided for @remindersAdherenceTipsBody.
  ///
  /// In en, this message translates to:
  /// **'• Set phone reminders for medication times\n• Keep medications in a visible location\n• Use a pill organizer for daily doses\n• Track your progress to stay motivated'**
  String get remindersAdherenceTipsBody;

  /// No description provided for @visitRecordingTitle.
  ///
  /// In en, this message translates to:
  /// **'Record Visit'**
  String get visitRecordingTitle;

  /// No description provided for @visitRecordingSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get visitRecordingSave;

  /// No description provided for @visitRecordingGenerateSummary.
  ///
  /// In en, this message translates to:
  /// **'Generate Summary'**
  String get visitRecordingGenerateSummary;

  /// No description provided for @visitRecordingDiscardRecording.
  ///
  /// In en, this message translates to:
  /// **'Discard Recording'**
  String get visitRecordingDiscardRecording;

  /// No description provided for @visitRecordingCompleted.
  ///
  /// In en, this message translates to:
  /// **'Recording completed!'**
  String get visitRecordingCompleted;

  /// No description provided for @visitRecordingSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save recording'**
  String get visitRecordingSaveFailed;

  /// No description provided for @visitRecordingDiscarded.
  ///
  /// In en, this message translates to:
  /// **'Recording discarded'**
  String get visitRecordingDiscarded;

  /// No description provided for @visitRecordingNoRecording.
  ///
  /// In en, this message translates to:
  /// **'No recording available'**
  String get visitRecordingNoRecording;

  /// No description provided for @visitRecordingUploadingAudio.
  ///
  /// In en, this message translates to:
  /// **'Uploading audio...'**
  String get visitRecordingUploadingAudio;

  /// No description provided for @visitRecordingProcessingTitle.
  ///
  /// In en, this message translates to:
  /// **'✅ Your visit is being processed'**
  String get visitRecordingProcessingTitle;

  /// No description provided for @visitRecordingGoToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get visitRecordingGoToHome;

  /// No description provided for @visitRecordingUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload audio: {error}'**
  String visitRecordingUploadFailed(Object error);

  /// No description provided for @visitRecordingStopTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop Recording?'**
  String get visitRecordingStopTitle;

  /// No description provided for @visitRecordingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue Recording'**
  String get visitRecordingContinue;

  /// No description provided for @visitRecordingStopAndDiscard.
  ///
  /// In en, this message translates to:
  /// **'Stop & Discard'**
  String get visitRecordingStopAndDiscard;

  /// No description provided for @visitRecordingAudioPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Audio Recording'**
  String get visitRecordingAudioPermissionTitle;

  /// No description provided for @visitRecordingNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get visitRecordingNotNow;

  /// No description provided for @visitRecordingYesRecord.
  ///
  /// In en, this message translates to:
  /// **'Yes, Record'**
  String get visitRecordingYesRecord;

  /// No description provided for @visitRecordingStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to Record'**
  String get visitRecordingStatusReady;

  /// No description provided for @visitRecordingStatusRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording...'**
  String get visitRecordingStatusRecording;

  /// No description provided for @visitRecordingStatusComplete.
  ///
  /// In en, this message translates to:
  /// **'Recording complete'**
  String get visitRecordingStatusComplete;

  /// No description provided for @visitRecordingInstructionIdle.
  ///
  /// In en, this message translates to:
  /// **'Tap to start recording your visit\nYour recording stays private and secure'**
  String get visitRecordingInstructionIdle;

  /// No description provided for @visitRecordingInstructionRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording in progress...'**
  String get visitRecordingInstructionRecording;

  /// No description provided for @visitRecordingInstructionComplete.
  ///
  /// In en, this message translates to:
  /// **'Recording complete!\nTap Generate to process your visit summary'**
  String get visitRecordingInstructionComplete;

  /// No description provided for @visitRecordingMicPermission.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required. Please enable it in Settings > RemiMinder > Microphone.'**
  String get visitRecordingMicPermission;

  /// No description provided for @visitRecordingProcessingBody.
  ///
  /// In en, this message translates to:
  /// **'This may take ~30–60 seconds.\nYou can continue using the app. We\'ll notify you when it\'s ready.'**
  String get visitRecordingProcessingBody;

  /// No description provided for @visitRecordingStopConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to stop recording? This action cannot be undone.'**
  String get visitRecordingStopConfirm;

  /// No description provided for @visitRecordingAudioConsentBody.
  ///
  /// In en, this message translates to:
  /// **'Recording helps create visit notes, summaries, and reminders.\n\n• Audio is recorded only when you tap Record\n• Recordings are processed securely and deleted from your phone\n• You can stop recording at any time\n\nWould you like to proceed?'**
  String get visitRecordingAudioConsentBody;

  /// No description provided for @visitDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Visit Details'**
  String get visitDetailsTitle;

  /// No description provided for @visitDetailsSummaryCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Visit Summary'**
  String get visitDetailsSummaryCardTitle;

  /// No description provided for @visitDetailsRefreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh summary'**
  String get visitDetailsRefreshTooltip;

  /// No description provided for @visitDetailsProcessingTitle.
  ///
  /// In en, this message translates to:
  /// **'Preparing visit summary...'**
  String get visitDetailsProcessingTitle;

  /// No description provided for @visitDetailsProcessingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This may take a minute.'**
  String get visitDetailsProcessingSubtitle;

  /// No description provided for @visitDetailsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to load visit summary'**
  String get visitDetailsLoadFailed;

  /// No description provided for @visitDetailsRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get visitDetailsRetry;

  /// No description provided for @visitDetailsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Visit summary is unavailable'**
  String get visitDetailsUnavailable;

  /// No description provided for @visitDetailsSummarySection.
  ///
  /// In en, this message translates to:
  /// **'Visit Summary'**
  String get visitDetailsSummarySection;

  /// No description provided for @visitDetailsFinalSummarySection.
  ///
  /// In en, this message translates to:
  /// **'Visit Summary'**
  String get visitDetailsFinalSummarySection;

  /// No description provided for @visitRecordingSaved.
  ///
  /// In en, this message translates to:
  /// **'Recording saved successfully! You can now generate a summary.'**
  String get visitRecordingSaved;

  /// No description provided for @visitDetailsDecisionsSection.
  ///
  /// In en, this message translates to:
  /// **'Clinical Decisions'**
  String get visitDetailsDecisionsSection;

  /// No description provided for @visitDetailsMedicationsSection.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get visitDetailsMedicationsSection;

  /// No description provided for @visitDetailsActionsSection.
  ///
  /// In en, this message translates to:
  /// **'Next Steps'**
  String get visitDetailsActionsSection;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search events, documents, visits...'**
  String get historySearchHint;

  /// No description provided for @historyTabAll.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get historyTabAll;

  /// No description provided for @historyTabScannedDocs.
  ///
  /// In en, this message translates to:
  /// **'SCANNED DOCS'**
  String get historyTabScannedDocs;

  /// No description provided for @historyTabLabResults.
  ///
  /// In en, this message translates to:
  /// **'LAB RESULTS'**
  String get historyTabLabResults;

  /// No description provided for @historyLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load history'**
  String get historyLoadFailed;

  /// No description provided for @historyRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get historyRetry;

  /// No description provided for @historyVisitSummaryFallback.
  ///
  /// In en, this message translates to:
  /// **'Visit Summary'**
  String get historyVisitSummaryFallback;

  /// No description provided for @historyNoSummary.
  ///
  /// In en, this message translates to:
  /// **'No summary available'**
  String get historyNoSummary;

  /// No description provided for @historyUnknownDate.
  ///
  /// In en, this message translates to:
  /// **'Unknown date'**
  String get historyUnknownDate;

  /// No description provided for @historyUnknownTime.
  ///
  /// In en, this message translates to:
  /// **'Unknown time'**
  String get historyUnknownTime;

  /// No description provided for @historyNoScannedDocs.
  ///
  /// In en, this message translates to:
  /// **'No scanned documents yet'**
  String get historyNoScannedDocs;

  /// No description provided for @historyNoScannedDocsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scanned prescriptions and documents will appear here'**
  String get historyNoScannedDocsSubtitle;

  /// No description provided for @historyNoLabResults.
  ///
  /// In en, this message translates to:
  /// **'No lab results yet'**
  String get historyNoLabResults;

  /// No description provided for @historyNoLabResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Lab results and test reports will appear here'**
  String get historyNoLabResultsSubtitle;

  /// No description provided for @historyNoEventsSearch.
  ///
  /// In en, this message translates to:
  /// **'No events found for \"{query}\"'**
  String historyNoEventsSearch(Object query);

  /// No description provided for @historyNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events yet'**
  String get historyNoEvents;

  /// No description provided for @historyDocumentViewerSoon.
  ///
  /// In en, this message translates to:
  /// **'Document viewer coming soon'**
  String get historyDocumentViewerSoon;

  /// No description provided for @historyFeatureSoon.
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon'**
  String get historyFeatureSoon;

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationSettingsTitle;

  /// No description provided for @notificationSectionTypes.
  ///
  /// In en, this message translates to:
  /// **'Notification Types'**
  String get notificationSectionTypes;

  /// No description provided for @notificationMedicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Medication Reminders'**
  String get notificationMedicationTitle;

  /// No description provided for @notificationMedicationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified when it\'s time to take your medications'**
  String get notificationMedicationSubtitle;

  /// No description provided for @notificationAppointmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment Reminders'**
  String get notificationAppointmentTitle;

  /// No description provided for @notificationAppointmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders for upcoming doctor visits and tests'**
  String get notificationAppointmentSubtitle;

  /// No description provided for @notificationHealthTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Tips'**
  String get notificationHealthTipsTitle;

  /// No description provided for @notificationHealthTipsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily tips for managing your health conditions'**
  String get notificationHealthTipsSubtitle;

  /// No description provided for @notificationCaregiverUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Caregiver Updates'**
  String get notificationCaregiverUpdatesTitle;

  /// No description provided for @notificationCaregiverUpdatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications when caregivers view your information'**
  String get notificationCaregiverUpdatesSubtitle;

  /// No description provided for @notificationEmergencyAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Alerts'**
  String get notificationEmergencyAlertsTitle;

  /// No description provided for @notificationEmergencyAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Critical health alerts and emergency notifications'**
  String get notificationEmergencyAlertsSubtitle;

  /// No description provided for @notificationDailySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Summary'**
  String get notificationDailySummaryTitle;

  /// No description provided for @notificationDailySummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Evening summary of your day\'s health activities'**
  String get notificationDailySummarySubtitle;

  /// No description provided for @notificationSectionTiming.
  ///
  /// In en, this message translates to:
  /// **'Timing Preferences'**
  String get notificationSectionTiming;

  /// No description provided for @notificationMorningReminder.
  ///
  /// In en, this message translates to:
  /// **'Morning Reminder Time'**
  String get notificationMorningReminder;

  /// No description provided for @notificationEveningReminder.
  ///
  /// In en, this message translates to:
  /// **'Evening Reminder Time'**
  String get notificationEveningReminder;

  /// No description provided for @notificationAdvanceTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder Advance Time'**
  String get notificationAdvanceTime;

  /// No description provided for @notificationAdvance5Min.
  ///
  /// In en, this message translates to:
  /// **'5 min'**
  String get notificationAdvance5Min;

  /// No description provided for @notificationAdvance10Min.
  ///
  /// In en, this message translates to:
  /// **'10 min'**
  String get notificationAdvance10Min;

  /// No description provided for @notificationAdvance15Min.
  ///
  /// In en, this message translates to:
  /// **'15 min'**
  String get notificationAdvance15Min;

  /// No description provided for @notificationAdvance30Min.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get notificationAdvance30Min;

  /// No description provided for @notificationAdvance60Min.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get notificationAdvance60Min;

  /// No description provided for @notificationSectionSound.
  ///
  /// In en, this message translates to:
  /// **'Sound & Alerts'**
  String get notificationSectionSound;

  /// No description provided for @notificationSoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound Notifications'**
  String get notificationSoundTitle;

  /// No description provided for @notificationVibrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get notificationVibrationTitle;

  /// No description provided for @notificationVolumeTitle.
  ///
  /// In en, this message translates to:
  /// **'Volume Level'**
  String get notificationVolumeTitle;

  /// No description provided for @notificationSectionTest.
  ///
  /// In en, this message translates to:
  /// **'Test Notifications'**
  String get notificationSectionTest;

  /// No description provided for @notificationSendTest.
  ///
  /// In en, this message translates to:
  /// **'Send Test Notification'**
  String get notificationSendTest;

  /// No description provided for @notificationTestSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent!'**
  String get notificationTestSent;

  /// No description provided for @languageSettingsChooseApp.
  ///
  /// In en, this message translates to:
  /// **'Choose App Language'**
  String get languageSettingsChooseApp;

  /// No description provided for @languageSettingsChooseVisit.
  ///
  /// In en, this message translates to:
  /// **'Choose Visit Language'**
  String get languageSettingsChooseVisit;

  /// No description provided for @languageSettingsAppLabel.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get languageSettingsAppLabel;

  /// No description provided for @languageSettingsVisitLabel.
  ///
  /// In en, this message translates to:
  /// **'Visit Language'**
  String get languageSettingsVisitLabel;

  /// No description provided for @languageSettingsSave.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get languageSettingsSave;

  /// No description provided for @languageSettingsInfo.
  ///
  /// In en, this message translates to:
  /// **'Changing visit language affects speech recognition and AI summaries.'**
  String get languageSettingsInfo;

  /// No description provided for @languageSettingsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load language preferences'**
  String get languageSettingsLoadFailed;

  /// No description provided for @languageSettingsSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Language settings saved'**
  String get languageSettingsSaveSuccess;

  /// No description provided for @languageSettingsSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save language settings'**
  String get languageSettingsSaveFailed;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your password to keep your account secure.'**
  String get changePasswordSubtitle;

  /// No description provided for @changePasswordCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get changePasswordCurrentLabel;

  /// No description provided for @changePasswordCurrentHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get changePasswordCurrentHint;

  /// No description provided for @changePasswordNewLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get changePasswordNewLabel;

  /// No description provided for @changePasswordNewHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get changePasswordNewHint;

  /// No description provided for @changePasswordConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get changePasswordConfirmLabel;

  /// No description provided for @changePasswordConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your new password'**
  String get changePasswordConfirmHint;

  /// No description provided for @changePasswordUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get changePasswordUpdateButton;

  /// No description provided for @changePasswordCurrentRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password'**
  String get changePasswordCurrentRequired;

  /// No description provided for @changePasswordNewRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get changePasswordNewRequired;

  /// No description provided for @changePasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get changePasswordTooShort;

  /// No description provided for @changePasswordConfirmRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get changePasswordConfirmRequired;

  /// No description provided for @changePasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get changePasswordMismatch;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get changePasswordSuccess;

  /// No description provided for @changePasswordNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'User not authenticated'**
  String get changePasswordNotAuthenticated;

  /// No description provided for @changePasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update password'**
  String get changePasswordFailed;

  /// No description provided for @changePasswordWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get changePasswordWrongPassword;

  /// No description provided for @changePasswordWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get changePasswordWeakPassword;

  /// No description provided for @changePasswordRecentLogin.
  ///
  /// In en, this message translates to:
  /// **'Please log in again and try'**
  String get changePasswordRecentLogin;

  /// No description provided for @changePasswordCheckConnection.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection'**
  String get changePasswordCheckConnection;

  /// No description provided for @accountSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Security'**
  String get accountSecurityTitle;

  /// No description provided for @accountSecurityChangePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get accountSecurityChangePasswordTitle;

  /// No description provided for @accountSecurityChangePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your account password for security'**
  String get accountSecurityChangePasswordSubtitle;

  /// No description provided for @accountSecurityChangePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get accountSecurityChangePasswordButton;

  /// No description provided for @accountSecurityPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get accountSecurityPrivacyTitle;

  /// No description provided for @accountSecurityPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your data sharing preferences'**
  String get accountSecurityPrivacySubtitle;

  /// No description provided for @accountSecurityPrivacyButton.
  ///
  /// In en, this message translates to:
  /// **'Manage Privacy'**
  String get accountSecurityPrivacyButton;

  /// No description provided for @accountSecurityDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get accountSecurityDialogTitle;

  /// No description provided for @accountSecurityDialogBody.
  ///
  /// In en, this message translates to:
  /// **'You signed in using {provider}. Please change your password in your {provider} account.'**
  String accountSecurityDialogBody(Object provider);

  /// No description provided for @accountSecurityDialogOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get accountSecurityDialogOk;

  /// No description provided for @profileAccountDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get profileAccountDetailsTitle;

  /// No description provided for @profileAccountDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your profile information'**
  String get profileAccountDetailsSubtitle;

  /// No description provided for @profileAccountSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Security'**
  String get profileAccountSecurityTitle;

  /// No description provided for @profileAccountSecuritySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage password and privacy'**
  String get profileAccountSecuritySubtitle;

  /// No description provided for @profileAppLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get profileAppLanguageLabel;

  /// No description provided for @profilePreferredSummaryLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred summary language'**
  String get profilePreferredSummaryLanguageLabel;

  /// No description provided for @profileDefaultVisitLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Default visit language'**
  String get profileDefaultVisitLanguageLabel;

  /// No description provided for @profileTimezoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get profileTimezoneLabel;

  /// No description provided for @profileCountryOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Country (optional)'**
  String get profileCountryOptionalLabel;

  /// No description provided for @profileCountryOrRegionLabel.
  ///
  /// In en, this message translates to:
  /// **'Country or region'**
  String get profileCountryOrRegionLabel;

  /// No description provided for @profileNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotificationsTitle;

  /// No description provided for @profileNotificationsMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get profileNotificationsMobile;

  /// No description provided for @profileNotificationsEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileNotificationsEmail;

  /// No description provided for @profileUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get profileUpgrade;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get profileSignOut;

  /// No description provided for @profileNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get profileNotSet;

  /// No description provided for @profileSignOutFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign out failed: {error}'**
  String profileSignOutFailed(Object error);

  /// No description provided for @upgradeBenefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Benefits'**
  String get upgradeBenefitsTitle;

  /// No description provided for @upgradeUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium Care'**
  String get upgradeUnlockTitle;

  /// No description provided for @upgradeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get more peace of mind.'**
  String get upgradeSubtitle;

  /// No description provided for @upgradeBenefitUnlimitedCaregivers.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Caregivers'**
  String get upgradeBenefitUnlimitedCaregivers;

  /// No description provided for @upgradeBenefitHealthTrends.
  ///
  /// In en, this message translates to:
  /// **'Advanced Health Trends'**
  String get upgradeBenefitHealthTrends;

  /// No description provided for @upgradeBenefitPrioritySupport.
  ///
  /// In en, this message translates to:
  /// **'Priority Support'**
  String get upgradeBenefitPrioritySupport;

  /// No description provided for @upgradeMonthlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Monthly Plan'**
  String get upgradeMonthlyPlan;

  /// No description provided for @upgradeAnnualPlan.
  ///
  /// In en, this message translates to:
  /// **'Annual Plan'**
  String get upgradeAnnualPlan;

  /// No description provided for @upgradePerMonth.
  ///
  /// In en, this message translates to:
  /// **'/ month'**
  String get upgradePerMonth;

  /// No description provided for @upgradePerYear.
  ///
  /// In en, this message translates to:
  /// **'/ year'**
  String get upgradePerYear;

  /// No description provided for @upgradeCancelAnytime.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime'**
  String get upgradeCancelAnytime;

  /// No description provided for @upgradeContinuePayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to Payment'**
  String get upgradeContinuePayment;

  /// No description provided for @upgradePaymentComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Payment flow coming soon'**
  String get upgradePaymentComingSoon;

  /// No description provided for @caregiversTitle.
  ///
  /// In en, this message translates to:
  /// **'Caregivers'**
  String get caregiversTitle;

  /// No description provided for @caregiversMyCaregivers.
  ///
  /// In en, this message translates to:
  /// **'My Caregivers'**
  String get caregiversMyCaregivers;

  /// No description provided for @caregiversEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No caregivers yet'**
  String get caregiversEmptyTitle;

  /// No description provided for @caregiversEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invite family members or friends\nto help manage your healthcare'**
  String get caregiversEmptySubtitle;

  /// No description provided for @caregiversInviteFirst.
  ///
  /// In en, this message translates to:
  /// **'Invite First Caregiver'**
  String get caregiversInviteFirst;

  /// No description provided for @caregiversLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load caregivers'**
  String get caregiversLoadFailed;

  /// No description provided for @caregiversResendInvite.
  ///
  /// In en, this message translates to:
  /// **'Resend Invite'**
  String get caregiversResendInvite;

  /// No description provided for @caregiversCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get caregiversCancel;

  /// No description provided for @caregiversActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active Caregiver'**
  String get caregiversActiveLabel;

  /// No description provided for @caregiversPermissionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} perms'**
  String caregiversPermissionsCount(Object count);

  /// No description provided for @caregiversActivityCount.
  ///
  /// In en, this message translates to:
  /// **'{count} acts'**
  String caregiversActivityCount(Object count);

  /// No description provided for @caregiversLastActive.
  ///
  /// In en, this message translates to:
  /// **'Last active: {time}'**
  String caregiversLastActive(Object time);

  /// No description provided for @caregiversStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get caregiversStatusActive;

  /// No description provided for @caregiversStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get caregiversStatusPending;

  /// No description provided for @caregiversStatusDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get caregiversStatusDeclined;

  /// No description provided for @caregiversStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get caregiversStatusUnknown;

  /// No description provided for @caregiversInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite Caregiver'**
  String get caregiversInviteTitle;

  /// No description provided for @caregiversFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get caregiversFullNameLabel;

  /// No description provided for @caregiversFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter caregiver\'s full name'**
  String get caregiversFullNameHint;

  /// No description provided for @caregiversFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get caregiversFullNameRequired;

  /// No description provided for @caregiversEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get caregiversEmailLabel;

  /// No description provided for @caregiversEmailHint.
  ///
  /// In en, this message translates to:
  /// **'caregiver@example.com'**
  String get caregiversEmailHint;

  /// No description provided for @caregiversEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email'**
  String get caregiversEmailRequired;

  /// No description provided for @caregiversEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get caregiversEmailInvalid;

  /// No description provided for @caregiversRelationshipLabel.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get caregiversRelationshipLabel;

  /// No description provided for @caregiversSendInvitation.
  ///
  /// In en, this message translates to:
  /// **'Send Invitation'**
  String get caregiversSendInvitation;

  /// No description provided for @caregiversInvitationSent.
  ///
  /// In en, this message translates to:
  /// **'Invitation sent to {email}'**
  String caregiversInvitationSent(Object email);

  /// No description provided for @caregiversInvitationResent.
  ///
  /// In en, this message translates to:
  /// **'Invitation resent to {email}'**
  String caregiversInvitationResent(Object email);

  /// No description provided for @caregiversCancelInvitationTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Invitation'**
  String get caregiversCancelInvitationTitle;

  /// No description provided for @caregiversCancelInvitationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this invitation?'**
  String get caregiversCancelInvitationConfirm;

  /// No description provided for @caregiversKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get caregiversKeep;

  /// No description provided for @caregiversCancelInvitationAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel Invitation'**
  String get caregiversCancelInvitationAction;

  /// No description provided for @caregiversDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get caregiversDone;

  /// No description provided for @caregiversAccessRemoved.
  ///
  /// In en, this message translates to:
  /// **'Access removed'**
  String get caregiversAccessRemoved;

  /// No description provided for @caregiversPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions for {name}'**
  String caregiversPermissionTitle(Object name);

  /// No description provided for @caregiversPermissionViewMedications.
  ///
  /// In en, this message translates to:
  /// **'View Medications'**
  String get caregiversPermissionViewMedications;

  /// No description provided for @caregiversPermissionViewMedicationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Can see medication schedules and history'**
  String get caregiversPermissionViewMedicationsDesc;

  /// No description provided for @caregiversPermissionViewVisits.
  ///
  /// In en, this message translates to:
  /// **'View Visit Records'**
  String get caregiversPermissionViewVisits;

  /// No description provided for @caregiversPermissionViewVisitsDesc.
  ///
  /// In en, this message translates to:
  /// **'Can access visit summaries and transcripts'**
  String get caregiversPermissionViewVisitsDesc;

  /// No description provided for @caregiversPermissionViewHealthData.
  ///
  /// In en, this message translates to:
  /// **'View Health Data'**
  String get caregiversPermissionViewHealthData;

  /// No description provided for @caregiversPermissionViewHealthDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Can see health metrics and trends'**
  String get caregiversPermissionViewHealthDataDesc;

  /// No description provided for @caregiversPermissionEditMedications.
  ///
  /// In en, this message translates to:
  /// **'Edit Medications'**
  String get caregiversPermissionEditMedications;

  /// No description provided for @caregiversPermissionEditMedicationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Can modify medication schedules'**
  String get caregiversPermissionEditMedicationsDesc;

  /// No description provided for @caregiversPermissionManageEmergency.
  ///
  /// In en, this message translates to:
  /// **'Manage Emergency Contacts'**
  String get caregiversPermissionManageEmergency;

  /// No description provided for @caregiversPermissionManageEmergencyDesc.
  ///
  /// In en, this message translates to:
  /// **'Can modify emergency contact settings'**
  String get caregiversPermissionManageEmergencyDesc;

  /// No description provided for @caregiversPermissionReceiveAlerts.
  ///
  /// In en, this message translates to:
  /// **'Receive Alerts'**
  String get caregiversPermissionReceiveAlerts;

  /// No description provided for @caregiversPermissionReceiveAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Gets notified of important health events'**
  String get caregiversPermissionReceiveAlertsDesc;

  /// No description provided for @caregiversRelationshipFamily.
  ///
  /// In en, this message translates to:
  /// **'Family Member'**
  String get caregiversRelationshipFamily;

  /// No description provided for @caregiversRelationshipFriend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get caregiversRelationshipFriend;

  /// No description provided for @caregiversRelationshipSpouse.
  ///
  /// In en, this message translates to:
  /// **'Spouse/Partner'**
  String get caregiversRelationshipSpouse;

  /// No description provided for @caregiversRelationshipParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get caregiversRelationshipParent;

  /// No description provided for @caregiversRelationshipChild.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get caregiversRelationshipChild;

  /// No description provided for @caregiversRelationshipHealthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare Professional'**
  String get caregiversRelationshipHealthcare;

  /// No description provided for @caregiversRelationshipCaregiver.
  ///
  /// In en, this message translates to:
  /// **'Caregiver'**
  String get caregiversRelationshipCaregiver;

  /// No description provided for @caregiversRelationshipOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get caregiversRelationshipOther;

  /// No description provided for @caregiversLastActiveDays.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String caregiversLastActiveDays(Object count);

  /// No description provided for @caregiversLastActiveHours.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String caregiversLastActiveHours(Object count);

  /// No description provided for @caregiversLastActiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String caregiversLastActiveMinutes(Object count);

  /// No description provided for @caregiversLastActiveJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get caregiversLastActiveJustNow;

  /// No description provided for @commonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} coming soon'**
  String commonComingSoon(Object feature);

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacyTitle;

  /// No description provided for @privacyDataSharing.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get privacyDataSharing;

  /// No description provided for @privacyNoCaregiver.
  ///
  /// In en, this message translates to:
  /// **'No caregiver added yet'**
  String get privacyNoCaregiver;

  /// No description provided for @privacyAllowCaregiverSummaries.
  ///
  /// In en, this message translates to:
  /// **'Allow caregiver to view summaries'**
  String get privacyAllowCaregiverSummaries;

  /// No description provided for @privacyAllowCaregiverMedications.
  ///
  /// In en, this message translates to:
  /// **'Allow caregiver to view medications'**
  String get privacyAllowCaregiverMedications;

  /// No description provided for @privacyAllowCaregiverReminders.
  ///
  /// In en, this message translates to:
  /// **'Allow caregiver to view reminders'**
  String get privacyAllowCaregiverReminders;

  /// No description provided for @privacyAllowAiImprove.
  ///
  /// In en, this message translates to:
  /// **'Allow AI to use my data to improve the product'**
  String get privacyAllowAiImprove;

  /// No description provided for @privacyCaregiverSharingEnabled.
  ///
  /// In en, this message translates to:
  /// **'Caregiver sharing enabled'**
  String get privacyCaregiverSharingEnabled;

  /// No description provided for @privacyCaregiverSharingDisabled.
  ///
  /// In en, this message translates to:
  /// **'Caregiver sharing disabled'**
  String get privacyCaregiverSharingDisabled;

  /// No description provided for @privacyCommunicationConsent.
  ///
  /// In en, this message translates to:
  /// **'Communication & Consent'**
  String get privacyCommunicationConsent;

  /// No description provided for @privacyAllowEmailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow email notifications'**
  String get privacyAllowEmailNotifications;

  /// No description provided for @privacyAllowSmsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow SMS notifications'**
  String get privacyAllowSmsNotifications;

  /// No description provided for @privacyAllowPushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow push notifications'**
  String get privacyAllowPushNotifications;

  /// No description provided for @privacyDataControl.
  ///
  /// In en, this message translates to:
  /// **'Data Control'**
  String get privacyDataControl;

  /// No description provided for @privacyExportData.
  ///
  /// In en, this message translates to:
  /// **'Export my data'**
  String get privacyExportData;

  /// No description provided for @privacyDataExportLabel.
  ///
  /// In en, this message translates to:
  /// **'Data export'**
  String get privacyDataExportLabel;

  /// No description provided for @privacyDeleteRecords.
  ///
  /// In en, this message translates to:
  /// **'Delete all my medical records'**
  String get privacyDeleteRecords;

  /// No description provided for @privacyDeleteRecordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Medical Records'**
  String get privacyDeleteRecordsTitle;

  /// No description provided for @privacyDeleteRecordsBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your medical records. This action cannot be undone.'**
  String get privacyDeleteRecordsBody;

  /// No description provided for @privacyDeleteRecordsAction.
  ///
  /// In en, this message translates to:
  /// **'Delete Records'**
  String get privacyDeleteRecordsAction;

  /// No description provided for @privacyDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get privacyDeleteAccount;

  /// No description provided for @privacyDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get privacyDeleteAccountTitle;

  /// No description provided for @privacyDeleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all associated data. This action cannot be undone.'**
  String get privacyDeleteAccountBody;

  /// No description provided for @privacyDeleteAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get privacyDeleteAccountAction;

  /// No description provided for @privacyLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get privacyLegal;

  /// No description provided for @privacyViewPolicy.
  ///
  /// In en, this message translates to:
  /// **'View Privacy Policy'**
  String get privacyViewPolicy;

  /// No description provided for @privacyViewTerms.
  ///
  /// In en, this message translates to:
  /// **'View Terms of Service'**
  String get privacyViewTerms;

  /// No description provided for @privacyTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get privacyTermsTitle;

  /// No description provided for @privacyTermsBody.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service for RemiMinder\n\n1. Acceptance of Terms\nBy using RemiMinder, you agree to these terms.\n\n2. Use of Service\nRemiMinder is designed to help manage healthcare and medication reminders.\n\n3. Privacy\nYour privacy is important to us. All health data is handled securely.\n\nFor the complete Terms of Service, please visit our website.'**
  String get privacyTermsBody;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyBody.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy for RemiMinder\n\n1. Information We Collect\nWe collect information you provide and usage data to improve our service.\n\n2. How We Use Information\nInformation is used to provide healthcare management services.\n\n3. Information Sharing\nWe do not sell your personal information.\n\nFor the complete Privacy Policy, please visit our website.'**
  String get privacyPolicyBody;

  /// No description provided for @healthDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Dashboard'**
  String get healthDashboardTitle;

  /// No description provided for @healthDashboardLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get healthDashboardLast7Days;

  /// No description provided for @healthDashboardLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get healthDashboardLast30Days;

  /// No description provided for @healthDashboardLast90Days.
  ///
  /// In en, this message translates to:
  /// **'Last 90 days'**
  String get healthDashboardLast90Days;

  /// No description provided for @healthDashboardBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get healthDashboardBloodPressure;

  /// No description provided for @healthDashboardWeightTrend.
  ///
  /// In en, this message translates to:
  /// **'Weight Trend'**
  String get healthDashboardWeightTrend;

  /// No description provided for @healthDashboardMedicationAdherence.
  ///
  /// In en, this message translates to:
  /// **'Medication Adherence'**
  String get healthDashboardMedicationAdherence;

  /// No description provided for @healthDashboardKeyMetrics.
  ///
  /// In en, this message translates to:
  /// **'Key Metrics'**
  String get healthDashboardKeyMetrics;

  /// No description provided for @healthDashboardUnitMmhg.
  ///
  /// In en, this message translates to:
  /// **'mmHg'**
  String get healthDashboardUnitMmhg;

  /// No description provided for @healthDashboardBpTrend.
  ///
  /// In en, this message translates to:
  /// **'+2 pts this week'**
  String get healthDashboardBpTrend;

  /// No description provided for @healthDashboardWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get healthDashboardWeight;

  /// No description provided for @healthDashboardUnitLbs.
  ///
  /// In en, this message translates to:
  /// **'lbs'**
  String get healthDashboardUnitLbs;

  /// No description provided for @healthDashboardWeightTrendText.
  ///
  /// In en, this message translates to:
  /// **'-1.4 lbs this week'**
  String get healthDashboardWeightTrendText;

  /// No description provided for @healthDashboardMedAdherence.
  ///
  /// In en, this message translates to:
  /// **'Med Adherence'**
  String get healthDashboardMedAdherence;

  /// No description provided for @healthDashboardThisWeek.
  ///
  /// In en, this message translates to:
  /// **'this week'**
  String get healthDashboardThisWeek;

  /// No description provided for @healthDashboardGoodProgress.
  ///
  /// In en, this message translates to:
  /// **'Good progress'**
  String get healthDashboardGoodProgress;

  /// No description provided for @healthDashboardHeartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get healthDashboardHeartRate;

  /// No description provided for @healthDashboardUnitBpm.
  ///
  /// In en, this message translates to:
  /// **'bpm'**
  String get healthDashboardUnitBpm;

  /// No description provided for @healthDashboardRestingAverage.
  ///
  /// In en, this message translates to:
  /// **'Resting average'**
  String get healthDashboardRestingAverage;

  /// No description provided for @healthDashboardInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Insights'**
  String get healthDashboardInsightsTitle;

  /// No description provided for @healthDashboardInsightBpTitle.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure Trend'**
  String get healthDashboardInsightBpTitle;

  /// No description provided for @healthDashboardInsightBpBody.
  ///
  /// In en, this message translates to:
  /// **'Your systolic pressure has been stable with a slight downward trend. Keep up the good work!'**
  String get healthDashboardInsightBpBody;

  /// No description provided for @healthDashboardInsightWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight Management'**
  String get healthDashboardInsightWeightTitle;

  /// No description provided for @healthDashboardInsightWeightBody.
  ///
  /// In en, this message translates to:
  /// **'Consistent weight loss of 1.4 lbs this week. You\'re on track for your goal!'**
  String get healthDashboardInsightWeightBody;

  /// No description provided for @healthDashboardInsightAdherenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Medication Adherence'**
  String get healthDashboardInsightAdherenceTitle;

  /// No description provided for @healthDashboardInsightAdherenceBody.
  ///
  /// In en, this message translates to:
  /// **'86% adherence this week. Consider setting medication reminders to reach 100%.'**
  String get healthDashboardInsightAdherenceBody;

  /// No description provided for @healthDashboardInsightCheckupTitle.
  ///
  /// In en, this message translates to:
  /// **'Next Checkup'**
  String get healthDashboardInsightCheckupTitle;

  /// No description provided for @healthDashboardInsightCheckupBody.
  ///
  /// In en, this message translates to:
  /// **'Your next cardiology appointment is due in 3 months. Schedule it soon.'**
  String get healthDashboardInsightCheckupBody;

  /// No description provided for @healthDashboardRecentMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Recent Measurements'**
  String get healthDashboardRecentMeasurements;

  /// No description provided for @healthDashboardRecentBpValue.
  ///
  /// In en, this message translates to:
  /// **'126/81 mmHg'**
  String get healthDashboardRecentBpValue;

  /// No description provided for @healthDashboardRecentBpTime.
  ///
  /// In en, this message translates to:
  /// **'Today, 8:30 AM'**
  String get healthDashboardRecentBpTime;

  /// No description provided for @healthDashboardRecentWeightValue.
  ///
  /// In en, this message translates to:
  /// **'163.8 lbs'**
  String get healthDashboardRecentWeightValue;

  /// No description provided for @healthDashboardRecentWeightTime.
  ///
  /// In en, this message translates to:
  /// **'Today, 7:45 AM'**
  String get healthDashboardRecentWeightTime;

  /// No description provided for @healthDashboardRecentHeartRateValue.
  ///
  /// In en, this message translates to:
  /// **'72 bpm'**
  String get healthDashboardRecentHeartRateValue;

  /// No description provided for @healthDashboardRecentHeartRateTime.
  ///
  /// In en, this message translates to:
  /// **'Yesterday, 8:15 AM'**
  String get healthDashboardRecentHeartRateTime;

  /// No description provided for @healthDashboardAddMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Add Measurement'**
  String get healthDashboardAddMeasurement;

  /// No description provided for @healthDashboardAddMeasurementSoon.
  ///
  /// In en, this message translates to:
  /// **'Add new measurement - Coming Soon!'**
  String get healthDashboardAddMeasurementSoon;

  /// No description provided for @emergencyContactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContactsTitle;

  /// No description provided for @emergencySosLabel.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY SOS'**
  String get emergencySosLabel;

  /// No description provided for @emergencySosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Call all emergency contacts'**
  String get emergencySosSubtitle;

  /// No description provided for @emergencyMedicalAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical Alert Information'**
  String get emergencyMedicalAlertTitle;

  /// No description provided for @emergencyMedicalAlertBody.
  ///
  /// In en, this message translates to:
  /// **'Cardiac patient, allergic to penicillin, takes daily medications'**
  String get emergencyMedicalAlertBody;

  /// No description provided for @emergencySosDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency SOS'**
  String get emergencySosDialogTitle;

  /// No description provided for @emergencySosDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This will call ALL emergency contacts simultaneously. Are you sure?'**
  String get emergencySosDialogBody;

  /// No description provided for @emergencySosDialogNote.
  ///
  /// In en, this message translates to:
  /// **'Emergency contacts will be called in priority order'**
  String get emergencySosDialogNote;

  /// No description provided for @emergencySosDialogAction.
  ///
  /// In en, this message translates to:
  /// **'Call Emergency Contacts'**
  String get emergencySosDialogAction;

  /// No description provided for @emergencySosActivated.
  ///
  /// In en, this message translates to:
  /// **'Emergency SOS activated! Calling all contacts...'**
  String get emergencySosActivated;

  /// No description provided for @emergencyCallingContact.
  ///
  /// In en, this message translates to:
  /// **'Calling {name}...'**
  String emergencyCallingContact(Object name);

  /// No description provided for @emergencyAddContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Emergency Contact'**
  String get emergencyAddContactTitle;

  /// No description provided for @emergencyContactFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get emergencyContactFullNameLabel;

  /// No description provided for @emergencyContactFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter contact name'**
  String get emergencyContactFullNameHint;

  /// No description provided for @emergencyContactPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get emergencyContactPhoneLabel;

  /// No description provided for @emergencyContactPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'(555) 123-4567'**
  String get emergencyContactPhoneHint;

  /// No description provided for @emergencyContactTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Type'**
  String get emergencyContactTypeLabel;

  /// No description provided for @emergencyContactRelationshipLabel.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get emergencyContactRelationshipLabel;

  /// No description provided for @emergencyContactRelationshipHint.
  ///
  /// In en, this message translates to:
  /// **'Spouse, Child, Parent, etc.'**
  String get emergencyContactRelationshipHint;

  /// No description provided for @emergencyAddContactAction.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get emergencyAddContactAction;

  /// No description provided for @emergencyEditContactComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit {name} - Coming Soon!'**
  String emergencyEditContactComingSoon(Object name);

  /// No description provided for @emergencyDeleteContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Contact'**
  String get emergencyDeleteContactTitle;

  /// No description provided for @emergencyDeleteContactBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name} from emergency contacts?'**
  String emergencyDeleteContactBody(Object name);

  /// No description provided for @emergencyContactRemoved.
  ///
  /// In en, this message translates to:
  /// **'Contact removed'**
  String get emergencyContactRemoved;

  /// No description provided for @emergencyContactAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} added to emergency contacts'**
  String emergencyContactAdded(Object name);

  /// No description provided for @emergencyEditMedicalInfoComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit medical information - Coming Soon!'**
  String get emergencyEditMedicalInfoComingSoon;

  /// No description provided for @emergencyContactTypeFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get emergencyContactTypeFamily;

  /// No description provided for @emergencyContactTypeMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get emergencyContactTypeMedical;

  /// No description provided for @emergencyContactTypeFriend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get emergencyContactTypeFriend;

  /// No description provided for @emergencyContactTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get emergencyContactTypeOther;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @careTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'Care Team'**
  String get careTeamTitle;

  /// No description provided for @careTeamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You are in control. Review your sharing permissions below.'**
  String get careTeamSubtitle;

  /// No description provided for @careTeamEmptyCaregivers.
  ///
  /// In en, this message translates to:
  /// **'No caregivers added yet'**
  String get careTeamEmptyCaregivers;

  /// No description provided for @careTeamActiveCaregivers.
  ///
  /// In en, this message translates to:
  /// **'Active Caregivers'**
  String get careTeamActiveCaregivers;

  /// No description provided for @careTeamPendingInvitations.
  ///
  /// In en, this message translates to:
  /// **'Pending Invitations'**
  String get careTeamPendingInvitations;

  /// No description provided for @careTeamInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite Caregiver'**
  String get careTeamInviteTitle;

  /// No description provided for @careTeamInviteNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get careTeamInviteNameLabel;

  /// No description provided for @careTeamInviteNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter caregiver\'s full name'**
  String get careTeamInviteNameHint;

  /// No description provided for @careTeamInviteEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get careTeamInviteEmailLabel;

  /// No description provided for @careTeamInviteEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter caregiver\'s email address'**
  String get careTeamInviteEmailHint;

  /// No description provided for @careTeamInviteRelationshipLabel.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get careTeamInviteRelationshipLabel;

  /// No description provided for @careTeamInviteRelationshipHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Son, Daughter, Friend, Nurse'**
  String get careTeamInviteRelationshipHint;

  /// No description provided for @careTeamInviteRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Email and role are required'**
  String get careTeamInviteRequiredFields;

  /// No description provided for @careTeamInviteSend.
  ///
  /// In en, this message translates to:
  /// **'Send Invite'**
  String get careTeamInviteSend;

  /// No description provided for @careTeamAccessUpdated.
  ///
  /// In en, this message translates to:
  /// **'Access updated successfully'**
  String get careTeamAccessUpdated;

  /// No description provided for @careTeamAccessUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update access. Please try again.'**
  String get careTeamAccessUpdateFailed;

  /// No description provided for @careTeamRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove caregiver?'**
  String get careTeamRemoveTitle;

  /// No description provided for @careTeamRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this caregiver? They will lose access immediately.'**
  String get careTeamRemoveBody;

  /// No description provided for @careTeamRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get careTeamRemoveConfirm;

  /// No description provided for @careTeamRemoving.
  ///
  /// In en, this message translates to:
  /// **'Removing caregiver...'**
  String get careTeamRemoving;

  /// No description provided for @careTeamRemoveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove caregiver. Please try again.'**
  String get careTeamRemoveFailed;

  /// No description provided for @careTeamManageAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Access'**
  String get careTeamManageAccessTitle;

  /// No description provided for @careTeamManageAccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update caregiver permission or remove access.'**
  String get careTeamManageAccessSubtitle;

  /// No description provided for @careTeamUpdatingAccess.
  ///
  /// In en, this message translates to:
  /// **'Updating access...'**
  String get careTeamUpdatingAccess;

  /// No description provided for @careTeamAccessView.
  ///
  /// In en, this message translates to:
  /// **'View Access'**
  String get careTeamAccessView;

  /// No description provided for @careTeamAccessFull.
  ///
  /// In en, this message translates to:
  /// **'Full Access'**
  String get careTeamAccessFull;

  /// No description provided for @careTeamAccessViewOnly.
  ///
  /// In en, this message translates to:
  /// **'View Only'**
  String get careTeamAccessViewOnly;

  /// No description provided for @careTeamResendingInvite.
  ///
  /// In en, this message translates to:
  /// **'Resending invitation...'**
  String get careTeamResendingInvite;

  /// No description provided for @careTeamInviteResent.
  ///
  /// In en, this message translates to:
  /// **'Invitation resent'**
  String get careTeamInviteResent;

  /// No description provided for @careTeamInviteResendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to resend invitation'**
  String get careTeamInviteResendFailed;

  /// No description provided for @careTeamCancelingInvite.
  ///
  /// In en, this message translates to:
  /// **'Canceling invitation...'**
  String get careTeamCancelingInvite;

  /// No description provided for @careTeamInviteCanceled.
  ///
  /// In en, this message translates to:
  /// **'Invitation canceled'**
  String get careTeamInviteCanceled;

  /// No description provided for @careTeamInviteCancelFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel invitation'**
  String get careTeamInviteCancelFailed;

  /// No description provided for @careTeamInvitationPending.
  ///
  /// In en, this message translates to:
  /// **'Invitation Pending'**
  String get careTeamInvitationPending;

  /// No description provided for @careTeamResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get careTeamResend;

  /// No description provided for @careTeamManageButton.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get careTeamManageButton;

  /// No description provided for @careTeamInviteTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite Caregiver'**
  String get careTeamInviteTileTitle;

  /// No description provided for @careTeamInviteTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share access to your health information'**
  String get careTeamInviteTileSubtitle;

  /// No description provided for @cameraSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get cameraSave;

  /// No description provided for @cameraModeRx.
  ///
  /// In en, this message translates to:
  /// **'Rx'**
  String get cameraModeRx;

  /// No description provided for @cameraModeLab.
  ///
  /// In en, this message translates to:
  /// **'Lab'**
  String get cameraModeLab;

  /// No description provided for @cameraModeMed.
  ///
  /// In en, this message translates to:
  /// **'Med'**
  String get cameraModeMed;

  /// No description provided for @cameraTapToCapture.
  ///
  /// In en, this message translates to:
  /// **'Tap to capture'**
  String get cameraTapToCapture;

  /// No description provided for @cameraProcessingShort.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get cameraProcessingShort;

  /// No description provided for @cameraProcessingImage.
  ///
  /// In en, this message translates to:
  /// **'Processing image...'**
  String get cameraProcessingImage;

  /// No description provided for @cameraScanSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Scan Successful!'**
  String get cameraScanSuccessful;

  /// No description provided for @cameraShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get cameraShare;

  /// No description provided for @cameraNotReady.
  ///
  /// In en, this message translates to:
  /// **'Camera not ready. Please try again.'**
  String get cameraNotReady;

  /// No description provided for @cameraCaptureFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to capture image: {error}'**
  String cameraCaptureFailed(Object error);

  /// No description provided for @cameraUploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Image uploaded successfully!'**
  String get cameraUploadSuccess;

  /// No description provided for @cameraUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image: {error}'**
  String cameraUploadFailed(Object error);

  /// No description provided for @cameraScanSaved.
  ///
  /// In en, this message translates to:
  /// **'Scan saved successfully!'**
  String get cameraScanSaved;

  /// No description provided for @cameraShareComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Share functionality - Coming Soon!'**
  String get cameraShareComingSoon;

  /// No description provided for @cameraPrescriptionScanned.
  ///
  /// In en, this message translates to:
  /// **'Prescription scanned successfully'**
  String get cameraPrescriptionScanned;

  /// No description provided for @cameraLabReportProcessed.
  ///
  /// In en, this message translates to:
  /// **'Lab report processed successfully'**
  String get cameraLabReportProcessed;

  /// No description provided for @cameraMedicationExtracted.
  ///
  /// In en, this message translates to:
  /// **'Medication information extracted'**
  String get cameraMedicationExtracted;

  /// No description provided for @cameraConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Document Scanning'**
  String get cameraConsentTitle;

  /// No description provided for @cameraConsentBody.
  ///
  /// In en, this message translates to:
  /// **'The camera helps scan medical documents like prescriptions and lab reports.\n\n• Camera is used only when you choose to scan\n• Images are processed securely and deleted from your phone\n• Photos are never saved to your device gallery\n\nWould you like to proceed?'**
  String get cameraConsentBody;

  /// No description provided for @cameraConsentNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get cameraConsentNotNow;

  /// No description provided for @cameraConsentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Scan'**
  String get cameraConsentConfirm;

  /// No description provided for @cameraSectionPrescriptionDetails.
  ///
  /// In en, this message translates to:
  /// **'Prescription Details'**
  String get cameraSectionPrescriptionDetails;

  /// No description provided for @cameraLabelMedication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get cameraLabelMedication;

  /// No description provided for @cameraValueLisinopril.
  ///
  /// In en, this message translates to:
  /// **'Lisinopril'**
  String get cameraValueLisinopril;

  /// No description provided for @cameraLabelDosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get cameraLabelDosage;

  /// No description provided for @cameraValue10mg.
  ///
  /// In en, this message translates to:
  /// **'10mg'**
  String get cameraValue10mg;

  /// No description provided for @cameraLabelFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get cameraLabelFrequency;

  /// No description provided for @cameraValueOnceDaily.
  ///
  /// In en, this message translates to:
  /// **'Once daily'**
  String get cameraValueOnceDaily;

  /// No description provided for @cameraLabelQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get cameraLabelQuantity;

  /// No description provided for @cameraValue90Tablets.
  ///
  /// In en, this message translates to:
  /// **'90 tablets'**
  String get cameraValue90Tablets;

  /// No description provided for @cameraLabelRefills.
  ///
  /// In en, this message translates to:
  /// **'Refills'**
  String get cameraLabelRefills;

  /// No description provided for @cameraValue3Remaining.
  ///
  /// In en, this message translates to:
  /// **'3 remaining'**
  String get cameraValue3Remaining;

  /// No description provided for @cameraSectionPrescriberInfo.
  ///
  /// In en, this message translates to:
  /// **'Prescriber Information'**
  String get cameraSectionPrescriberInfo;

  /// No description provided for @cameraLabelDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get cameraLabelDoctor;

  /// No description provided for @cameraValueDrSarahJohnson.
  ///
  /// In en, this message translates to:
  /// **'Dr. Sarah Johnson'**
  String get cameraValueDrSarahJohnson;

  /// No description provided for @cameraLabelLicense.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get cameraLabelLicense;

  /// No description provided for @cameraValueLicenseId.
  ///
  /// In en, this message translates to:
  /// **'MD123456'**
  String get cameraValueLicenseId;

  /// No description provided for @cameraLabelDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get cameraLabelDate;

  /// No description provided for @cameraValueDec122024.
  ///
  /// In en, this message translates to:
  /// **'Dec 12, 2024'**
  String get cameraValueDec122024;

  /// No description provided for @cameraSectionPharmacyInfo.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy Information'**
  String get cameraSectionPharmacyInfo;

  /// No description provided for @cameraLabelPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get cameraLabelPharmacy;

  /// No description provided for @cameraValueCityMedicalPharmacy.
  ///
  /// In en, this message translates to:
  /// **'City Medical Pharmacy'**
  String get cameraValueCityMedicalPharmacy;

  /// No description provided for @cameraLabelPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get cameraLabelPhone;

  /// No description provided for @cameraValuePhoneSample.
  ///
  /// In en, this message translates to:
  /// **'(555) 123-4567'**
  String get cameraValuePhoneSample;

  /// No description provided for @cameraLabelAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get cameraLabelAddress;

  /// No description provided for @cameraValuePharmacyAddress.
  ///
  /// In en, this message translates to:
  /// **'123 Main St, City, ST 12345'**
  String get cameraValuePharmacyAddress;

  /// No description provided for @cameraSectionPatientInfo.
  ///
  /// In en, this message translates to:
  /// **'Patient Information'**
  String get cameraSectionPatientInfo;

  /// No description provided for @cameraLabelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get cameraLabelName;

  /// No description provided for @cameraValueJohnDoe.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get cameraValueJohnDoe;

  /// No description provided for @cameraLabelDob.
  ///
  /// In en, this message translates to:
  /// **'DOB'**
  String get cameraLabelDob;

  /// No description provided for @cameraValueDobSample.
  ///
  /// In en, this message translates to:
  /// **'01/15/1985'**
  String get cameraValueDobSample;

  /// No description provided for @cameraLabelId.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get cameraLabelId;

  /// No description provided for @cameraValuePatientId.
  ///
  /// In en, this message translates to:
  /// **'P123456789'**
  String get cameraValuePatientId;

  /// No description provided for @cameraSectionTestResults.
  ///
  /// In en, this message translates to:
  /// **'Test Results'**
  String get cameraSectionTestResults;

  /// No description provided for @cameraLabelCholesterolTotal.
  ///
  /// In en, this message translates to:
  /// **'Cholesterol (Total)'**
  String get cameraLabelCholesterolTotal;

  /// No description provided for @cameraValueCholesterolTotal.
  ///
  /// In en, this message translates to:
  /// **'185 mg/dL'**
  String get cameraValueCholesterolTotal;

  /// No description provided for @cameraRefCholesterolTotal.
  ///
  /// In en, this message translates to:
  /// **'Normal: <200'**
  String get cameraRefCholesterolTotal;

  /// No description provided for @cameraLabelHdlCholesterol.
  ///
  /// In en, this message translates to:
  /// **'HDL Cholesterol'**
  String get cameraLabelHdlCholesterol;

  /// No description provided for @cameraValueHdl.
  ///
  /// In en, this message translates to:
  /// **'45 mg/dL'**
  String get cameraValueHdl;

  /// No description provided for @cameraRefHdl.
  ///
  /// In en, this message translates to:
  /// **'Normal: >40'**
  String get cameraRefHdl;

  /// No description provided for @cameraLabelLdlCholesterol.
  ///
  /// In en, this message translates to:
  /// **'LDL Cholesterol'**
  String get cameraLabelLdlCholesterol;

  /// No description provided for @cameraValueLdl.
  ///
  /// In en, this message translates to:
  /// **'120 mg/dL'**
  String get cameraValueLdl;

  /// No description provided for @cameraRefLdl.
  ///
  /// In en, this message translates to:
  /// **'Normal: <130'**
  String get cameraRefLdl;

  /// No description provided for @cameraLabelTriglycerides.
  ///
  /// In en, this message translates to:
  /// **'Triglycerides'**
  String get cameraLabelTriglycerides;

  /// No description provided for @cameraValueTriglycerides.
  ///
  /// In en, this message translates to:
  /// **'150 mg/dL'**
  String get cameraValueTriglycerides;

  /// No description provided for @cameraRefTriglycerides.
  ///
  /// In en, this message translates to:
  /// **'Normal: <150'**
  String get cameraRefTriglycerides;

  /// No description provided for @cameraSectionLabInfo.
  ///
  /// In en, this message translates to:
  /// **'Lab Information'**
  String get cameraSectionLabInfo;

  /// No description provided for @cameraLabelLab.
  ///
  /// In en, this message translates to:
  /// **'Lab'**
  String get cameraLabelLab;

  /// No description provided for @cameraValueCityMedicalLabs.
  ///
  /// In en, this message translates to:
  /// **'City Medical Labs'**
  String get cameraValueCityMedicalLabs;

  /// No description provided for @cameraLabelReportDate.
  ///
  /// In en, this message translates to:
  /// **'Report Date'**
  String get cameraLabelReportDate;

  /// No description provided for @cameraValueDec102024.
  ///
  /// In en, this message translates to:
  /// **'Dec 10, 2024'**
  String get cameraValueDec102024;

  /// No description provided for @cameraLabelCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get cameraLabelCollected;

  /// No description provided for @cameraValueDec092024.
  ///
  /// In en, this message translates to:
  /// **'Dec 9, 2024'**
  String get cameraValueDec092024;

  /// No description provided for @cameraSectionMedicationInfo.
  ///
  /// In en, this message translates to:
  /// **'Medication Information'**
  String get cameraSectionMedicationInfo;

  /// No description provided for @cameraLabelStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get cameraLabelStrength;

  /// No description provided for @cameraLabelForm.
  ///
  /// In en, this message translates to:
  /// **'Form'**
  String get cameraLabelForm;

  /// No description provided for @cameraValueTablet.
  ///
  /// In en, this message translates to:
  /// **'Tablet'**
  String get cameraValueTablet;

  /// No description provided for @cameraSectionUsageInstructions.
  ///
  /// In en, this message translates to:
  /// **'Usage Instructions'**
  String get cameraSectionUsageInstructions;

  /// No description provided for @cameraLabelDirections.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get cameraLabelDirections;

  /// No description provided for @cameraValueDirectionsSample.
  ///
  /// In en, this message translates to:
  /// **'Take one tablet by mouth once daily'**
  String get cameraValueDirectionsSample;

  /// No description provided for @cameraLabelPurpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get cameraLabelPurpose;

  /// No description provided for @cameraValuePurposeSample.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure management'**
  String get cameraValuePurposeSample;

  /// No description provided for @cameraLabelStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get cameraLabelStorage;

  /// No description provided for @cameraValueStorageSample.
  ///
  /// In en, this message translates to:
  /// **'Store at room temperature'**
  String get cameraValueStorageSample;

  /// No description provided for @cameraSectionAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get cameraSectionAdditionalInfo;

  /// No description provided for @cameraLabelManufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get cameraLabelManufacturer;

  /// No description provided for @cameraValueManufacturerSample.
  ///
  /// In en, this message translates to:
  /// **'Generic Pharmaceuticals'**
  String get cameraValueManufacturerSample;

  /// No description provided for @cameraLabelLotNumber.
  ///
  /// In en, this message translates to:
  /// **'Lot Number'**
  String get cameraLabelLotNumber;

  /// No description provided for @cameraValueLotNumberSample.
  ///
  /// In en, this message translates to:
  /// **'LP2024001'**
  String get cameraValueLotNumberSample;

  /// No description provided for @cameraLabelExpiration.
  ///
  /// In en, this message translates to:
  /// **'Expiration'**
  String get cameraLabelExpiration;

  /// No description provided for @cameraValueExpirationSample.
  ///
  /// In en, this message translates to:
  /// **'06/2026'**
  String get cameraValueExpirationSample;

  /// No description provided for @accountDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get accountDetailsTitle;

  /// No description provided for @accountDetailsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get accountDetailsNameLabel;

  /// No description provided for @accountDetailsEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get accountDetailsEmailLabel;

  /// No description provided for @accountDetailsAccountTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountDetailsAccountTypeLabel;

  /// No description provided for @accountDetailsAccountTypePatient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get accountDetailsAccountTypePatient;

  /// No description provided for @accountDetailsAccountTypeCaregiver.
  ///
  /// In en, this message translates to:
  /// **'Caregiver'**
  String get accountDetailsAccountTypeCaregiver;

  /// No description provided for @accountDetailsNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get accountDetailsNotSet;

  /// No description provided for @accountDetailsPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get accountDetailsPhoneLabel;

  /// No description provided for @accountDetailsPhoneEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get accountDetailsPhoneEdit;

  /// No description provided for @accountDetailsPhoneAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get accountDetailsPhoneAdd;

  /// No description provided for @accountDetailsPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get accountDetailsPlanLabel;

  /// No description provided for @accountDetailsPlanFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get accountDetailsPlanFree;

  /// No description provided for @accountDetailsPlanPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get accountDetailsPlanPremium;

  /// No description provided for @accountDetailsPlanUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get accountDetailsPlanUpgrade;

  /// No description provided for @accountDetailsPlanManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get accountDetailsPlanManage;

  /// No description provided for @accountDetailsUsageLabel.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get accountDetailsUsageLabel;

  /// No description provided for @accountDetailsUsageFreePlan.
  ///
  /// In en, this message translates to:
  /// **'Free plan — {used} / {limit} summaries used'**
  String accountDetailsUsageFreePlan(Object limit, Object used);

  /// No description provided for @accountDetailsUsageUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get accountDetailsUsageUnlimited;

  /// No description provided for @accountDetailsPhoneEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Phone Number'**
  String get accountDetailsPhoneEditTitle;

  /// No description provided for @accountDetailsPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+1 (555) 123-4567'**
  String get accountDetailsPhoneHint;

  /// No description provided for @accountDetailsPhoneMinLengthError.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be at least 8 characters long'**
  String get accountDetailsPhoneMinLengthError;

  /// No description provided for @accountDetailsPhoneUpdated.
  ///
  /// In en, this message translates to:
  /// **'Phone number updated successfully'**
  String get accountDetailsPhoneUpdated;

  /// No description provided for @accountDetailsPhoneUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update phone number: {error}'**
  String accountDetailsPhoneUpdateFailed(Object error);

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'de', 'en', 'es', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
