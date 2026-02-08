// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'RemiMinder';

  @override
  String get login => 'लॉग इन';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get profileSettings => 'प्रोफ़ाइल सेटिंग्स';

  @override
  String get commonSkip => 'छोड़ें';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonClose => 'बंद करें';

  @override
  String get languageEnglish => 'अंग्रेज़ी';

  @override
  String get languageSpanish => 'स्पेनिश';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get languageMandarin => 'मैंडरिन';

  @override
  String get languageArabic => 'अरबी';

  @override
  String get languageFrench => 'फ़्रेंच';

  @override
  String get languageGerman => 'जर्मन';

  @override
  String get countryUnitedStates => 'संयुक्त राज्य';

  @override
  String get countryCanada => 'कनाडा';

  @override
  String get countryUnitedKingdom => 'यूनाइटेड किंगडम';

  @override
  String get countryGermany => 'जर्मनी';

  @override
  String get countryIndia => 'भारत';

  @override
  String get welcomeTitle => 'RemiMinder में आपका स्वागत है';

  @override
  String get welcomeSubtitle => 'स्वास्थ्य और देखभाल समन्वय के लिए स्मार्ट एआई';

  @override
  String get welcomeDescription =>
      'दवा रिमाइंडर, अपॉइंटमेंट ट्रैकिंग और देखभाल समन्वय के लिए आपका स्मार्ट साथी। किसी महत्वपूर्ण स्वास्थ्य क्षण को फिर से न चूकें।';

  @override
  String get welcomeGetStarted => 'शुरू करें';

  @override
  String get roleChooseYourRole => 'अपना संदर्भ चुनें';

  @override
  String get roleSelectHowYouUse =>
      'बताएँ कि आप RemiMinder का उपयोग कैसे करना चाहते हैं';

  @override
  String get rolePatient => 'रोगी संदर्भ';

  @override
  String get rolePatientDescription =>
      'अपनी दवाएँ, अपॉइंटमेंट और स्वास्थ्य रिकॉर्ड प्रबंधित करें';

  @override
  String get roleCaregiver => 'देखभालकर्ता संदर्भ';

  @override
  String get roleCaregiverDescription =>
      'परिवार के सदस्यों या मरीजों की देखभाल और दवाओं का प्रबंधन करें';

  @override
  String get roleContinue => 'जारी रखें';

  @override
  String get onboardingAppLanguageTitle => 'अपनी ऐप भाषा चुनें';

  @override
  String get onboardingAppLanguageSubtitle => 'यह UI भाषा अपडेट करता है।';

  @override
  String get onboardingCountryTitle => 'अपना देश या क्षेत्र चुनें';

  @override
  String get onboardingCountrySubtitle =>
      'वैकल्पिक, अनुभव को अनुकूल बनाने में मदद करता है।';

  @override
  String get onboardingTimezoneTitle => 'अपना समय क्षेत्र पुष्टि करें';

  @override
  String onboardingTimezoneDetected(Object timezone) {
    return 'हमने पाया: $timezone';
  }

  @override
  String get onboardingTimezoneLabel => 'समय क्षेत्र';

  @override
  String get onboardingTimezoneConfirm => 'पुष्टि करें';

  @override
  String get onboardingVisitLanguageTitle => 'अपनी विज़िट भाषा चुनें';

  @override
  String get onboardingVisitLanguageSubtitle =>
      'यह विज़िट रिकॉर्डिंग और सारांश बनाने के लिए उपयोग होगी';

  @override
  String get loginBrandName => 'RemiMinder.ai';

  @override
  String get loginContinueWithGoogle => 'Google के साथ जारी रखें';

  @override
  String get loginContinueWithApple => 'Apple के साथ जारी रखें';

  @override
  String get loginContinueWithEmail => 'ईमेल के साथ जारी रखें';

  @override
  String get loginCreateAccount => 'खाता बनाएं';

  @override
  String get loginForgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get loginSignInWithEmailTitle => 'ईमेल से साइन इन करें';

  @override
  String get loginEmailLabel => 'ईमेल';

  @override
  String get loginEmailHint => 'अपना ईमेल दर्ज करें';

  @override
  String get loginPasswordLabel => 'पासवर्ड';

  @override
  String get loginPasswordHint => 'अपना पासवर्ड दर्ज करें';

  @override
  String get loginRememberMe => 'मुझे याद रखें';

  @override
  String get loginSignIn => 'साइन इन';

  @override
  String get loginFillAllFields => 'कृपया सभी फ़ील्ड भरें';

  @override
  String get loginAuthFailed => 'प्रमाणीकरण विफल। कृपया फिर से प्रयास करें।';

  @override
  String get loginInvalidEmailOrPassword =>
      'अमान्य ईमेल या पासवर्ड। कृपया अपनी जानकारी जांचें और फिर से प्रयास करें।';

  @override
  String get loginEmailNotConfirmed =>
      'कृपया अपना ईमेल जांचें और साइन इन करने से पहले अपना खाता पुष्टि करें।';

  @override
  String get loginUserNotFound => 'इस ईमेल से कोई खाता नहीं मिला।';

  @override
  String get loginConnectionError =>
      'कनेक्शन त्रुटि। कृपया अपना इंटरनेट कनेक्शन जांचें और फिर से प्रयास करें।';

  @override
  String get loginRequestTimedOut =>
      'अनुरोध का समय समाप्त हो गया। कृपया फिर से प्रयास करें।';

  @override
  String get loginSignInFailedGeneric =>
      'साइन इन विफल। कृपया फिर से प्रयास करें या समस्या बनी रहे तो सपोर्ट से संपर्क करें।';

  @override
  String get loginGoogleSignInFailed => 'Google साइन इन विफल';

  @override
  String loginGoogleSignInFailedWithError(Object error) {
    return 'Google साइन इन विफल: $error';
  }

  @override
  String get loginAppleSignInComingSoon => 'Apple साइन इन - जल्द आ रहा है!';

  @override
  String get loginContinueWithoutSigningIn => 'बिना साइन इन किए जारी रखें';

  @override
  String get loginBypassPatient => 'मरीज';

  @override
  String get loginBypassCaregiver => 'देखभालकर्ता';

  @override
  String get registerTitle => 'खाता बनाएं';

  @override
  String get registerSubtitle => 'शुरू करने के लिए RemiMinder से जुड़ें';

  @override
  String get registerFirstNameLabel => 'पहला नाम';

  @override
  String get registerFirstNameHint => 'राहुल';

  @override
  String get registerFirstNameRequired => 'कृपया अपना पहला नाम दर्ज करें';

  @override
  String get registerLastNameLabel => 'अंतिम नाम';

  @override
  String get registerLastNameHint => 'शर्मा';

  @override
  String get registerLastNameRequired => 'कृपया अपना अंतिम नाम दर्ज करें';

  @override
  String get registerEmailLabel => 'ईमेल';

  @override
  String get registerEmailHint => 'rahul.sharma@example.com';

  @override
  String get registerEmailRequired => 'कृपया अपना ईमेल दर्ज करें';

  @override
  String get registerEmailInvalid => 'कृपया मान्य ईमेल दर्ज करें';

  @override
  String get registerPasswordLabel => 'पासवर्ड';

  @override
  String get registerPasswordHint => 'एक मजबूत पासवर्ड बनाएं';

  @override
  String get registerPasswordRequired => 'कृपया पासवर्ड दर्ज करें';

  @override
  String get registerPasswordTooShort =>
      'पासवर्ड कम से कम 8 अक्षरों का होना चाहिए';

  @override
  String get registerConfirmPasswordLabel => 'पासवर्ड पुष्टि करें';

  @override
  String get registerConfirmPasswordHint => 'अपना पासवर्ड फिर से दर्ज करें';

  @override
  String get registerConfirmPasswordRequired =>
      'कृपया अपना पासवर्ड पुष्टि करें';

  @override
  String get registerPasswordMismatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get registerTermsIntro => 'खाता बनाकर, आप हमारी ';

  @override
  String get registerTermsOfService => 'सेवा की शर्तें';

  @override
  String get registerAnd => ' और ';

  @override
  String get registerPrivacyPolicy => 'गोपनीयता नीति';

  @override
  String get registerCreateAccountButton => 'खाता बनाएं';

  @override
  String get registerAlreadyHaveAccount => 'क्या आपके पास पहले से खाता है? ';

  @override
  String get registerSignIn => 'साइन इन';

  @override
  String get registerAcceptTermsError => 'कृपया नियम और शर्तें स्वीकार करें';

  @override
  String get registerSelectRoleFirst => 'कृपया पहले एक संदर्भ चुनें';

  @override
  String get registerAccountCreatedTitle => 'खाता बन गया!';

  @override
  String get registerAccountCreatedMessage =>
      'आपका खाता सफलतापूर्वक बन गया है। अब आप अपने ईमेल और पासवर्ड से साइन इन कर सकते हैं।';

  @override
  String get registerGoToSignIn => 'साइन इन पर जाएँ';

  @override
  String get registerTermsTitle => 'सेवा की शर्तें';

  @override
  String get registerTermsBody =>
      'RemiMinder के लिए सेवा की शर्तें\n\n1. शर्तों की स्वीकृति\nRemiMinder का उपयोग करके, आप इन शर्तों से सहमत होते हैं।\n\n2. सेवा का उपयोग\nRemiMinder स्वास्थ्य देखभाल और दवा रिमाइंडर प्रबंधन में सहायता के लिए बनाया गया है।\n\n3. गोपनीयता\nआपकी गोपनीयता हमारे लिए महत्वपूर्ण है। सभी स्वास्थ्य डेटा सुरक्षित रूप से संभाला जाता है।\n\n4. खाता जिम्मेदारी\nअपने खाते की गोपनीयता बनाए रखना आपकी जिम्मेदारी है।\n\n5. देयता की सीमा\nRemiMinder पेशेवर चिकित्सकीय सलाह का विकल्प नहीं है।\n\nपूर्ण सेवा शर्तों के लिए हमारी वेबसाइट देखें।';

  @override
  String get registerPrivacyTitle => 'गोपनीयता नीति';

  @override
  String get registerPrivacyBody =>
      'RemiMinder के लिए गोपनीयता नीति\n\n1. हम कौन-सी जानकारी एकत्र करते हैं\nहम आपके द्वारा दी गई जानकारी और उपयोग डेटा एकत्र करते हैं ताकि सेवा बेहतर हो।\n\n2. जानकारी का उपयोग कैसे करते हैं\nजानकारी का उपयोग स्वास्थ्य प्रबंधन सेवाएँ प्रदान करने और उपयोगकर्ता अनुभव बेहतर करने के लिए किया जाता है।\n\n3. जानकारी साझा करना\nहम आपकी व्यक्तिगत जानकारी नहीं बेचते। डेटा केवल आपके द्वारा अधिकृत स्वास्थ्य प्रदाताओं के साथ साझा किया जाता है।\n\n4. डेटा सुरक्षा\nहम आपके स्वास्थ्य डेटा की सुरक्षा के लिए उद्योग-मानक उपाय लागू करते हैं।\n\n5. आपके अधिकार\nआपको अपनी व्यक्तिगत जानकारी तक पहुंच, उसे सुधारने या हटाने का अधिकार है।\n\nपूर्ण गोपनीयता नीति के लिए हमारी वेबसाइट देखें।';

  @override
  String get registerAccountExists =>
      'इस ईमेल से एक खाता पहले से मौजूद है। कृपया साइन इन करें।';

  @override
  String get registerWeakPassword =>
      'पासवर्ड बहुत कमजोर है। कृपया कम से कम 8 अक्षरों का पासवर्ड उपयोग करें जिसमें अक्षर और संख्या हों।';

  @override
  String get registerConnectionError =>
      'कनेक्शन त्रुटि। कृपया इंटरनेट कनेक्शन जांचें और फिर से प्रयास करें।';

  @override
  String get registerRequestTimedOut =>
      'अनुरोध का समय समाप्त हो गया। कृपया फिर से प्रयास करें।';

  @override
  String get registerFailedGeneric =>
      'पंजीकरण विफल। कृपया फिर से प्रयास करें या समस्या बनी रहे तो सपोर्ट से संपर्क करें।';

  @override
  String get forgotPasswordTitle => 'पासवर्ड भूल गए?';

  @override
  String get forgotPasswordSubtitle =>
      'कोई बात नहीं! अपना ईमेल दर्ज करें, हम रीसेट निर्देश भेजेंगे।';

  @override
  String get forgotPasswordEmailHint => 'अपना ईमेल पता दर्ज करें';

  @override
  String get forgotPasswordEmailRequired => 'कृपया अपना ईमेल दर्ज करें';

  @override
  String get forgotPasswordEmailInvalid => 'कृपया मान्य ईमेल दर्ज करें';

  @override
  String get forgotPasswordSendInstructions => 'रीसेट निर्देश भेजें';

  @override
  String get forgotPasswordRememberPassword => 'पासवर्ड याद है?';

  @override
  String get forgotPasswordBackToLogin => 'लॉग इन पर वापस';

  @override
  String get forgotPasswordSuccessMessage =>
      'यदि इस ईमेल से खाता मौजूद है, तो हमने रीसेट निर्देश भेज दिए हैं।';

  @override
  String get forgotPasswordSendFailed =>
      'रीसेट ईमेल भेजने में विफल। कृपया ईमेल जांचें और फिर से प्रयास करें।';

  @override
  String get forgotPasswordNotAvailable =>
      'इस खाते के लिए पासवर्ड रीसेट उपलब्ध नहीं है।';

  @override
  String get forgotPasswordTooManyRequests =>
      'बहुत अधिक अनुरोध। कृपया बाद में प्रयास करें।';

  @override
  String get forgotPasswordNetworkError =>
      'नेटवर्क त्रुटि। कृपया अपना इंटरनेट कनेक्शन जांचें।';

  @override
  String get patientHomeGreetingMorning => 'सुप्रभात';

  @override
  String get patientHomeGreetingAfternoon => 'शुभ दोपहर';

  @override
  String get patientHomeGreetingEvening => 'शुभ संध्या';

  @override
  String get patientHomeGreetingNight => 'शुभ रात्रि';

  @override
  String get patientHomeFeelingToday => 'आज आप कैसा महसूस कर रहे हैं?';

  @override
  String get patientHomeTodaysSchedule => 'आज की योजना';

  @override
  String get patientHomeTodoList => 'करने की सूची';

  @override
  String get patientHomeUpNext => 'आगे';

  @override
  String get patientHomeNoUpcomingReminders => 'कोई आगामी रिमाइंडर नहीं';

  @override
  String get patientHomeMarkedAsTaken => 'ले लिया गया के रूप में चिह्नित!';

  @override
  String get patientHomeTakeNow => 'अभी लें';

  @override
  String get patientHomeReminderSnoozed =>
      'रिमाइंडर 1 घंटे के लिए स्नूज़ किया गया';

  @override
  String get patientHomeNothingScheduled => 'आज के लिए कुछ निर्धारित नहीं है';

  @override
  String get patientHomeViewAll => 'सभी देखें';

  @override
  String get patientHomeAddItem => 'आइटम जोड़ें';

  @override
  String get patientHomeNoTasksYet => 'अभी कोई कार्य नहीं';

  @override
  String get patientHomeAddTask => 'कार्य जोड़ें';

  @override
  String get patientHomeAddedRecently => 'हाल ही में जोड़े गए';

  @override
  String patientHomeAddedDate(Object date) {
    return 'जोड़ा गया $date';
  }

  @override
  String get patientHomeUpcoming => 'आगामी';

  @override
  String get patientHomeDueNow => 'अब देय';

  @override
  String patientHomeDueInMinutes(Object minutes) {
    return '$minutes मिनट में देय';
  }

  @override
  String patientHomeDueInHours(Object hours) {
    return '$hours घंटों में देय';
  }

  @override
  String patientHomeDueInDays(Object days) {
    return '$days दिनों में देय';
  }

  @override
  String patientHomeDueOnDate(Object date) {
    return '$date को देय';
  }

  @override
  String get commonRetry => 'पुनः प्रयास करें';

  @override
  String get caregiverPatientsTitle => 'मेरे मरीज';

  @override
  String get caregiverPatientsSearchHint =>
      'नाम, संबंध या स्थिति से मरीज खोजें...';

  @override
  String get caregiverPatientsClearFilter => 'फ़िल्टर साफ़ करें';

  @override
  String caregiverPatientsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# मरीज',
      one: '# मरीज',
    );
    return '$_temp0';
  }

  @override
  String get caregiverPatientsFilterAll => 'सभी';

  @override
  String get caregiverPatientsFilterActive => 'सक्रिय';

  @override
  String get caregiverPatientsFilterAttention => 'ध्यान आवश्यक';

  @override
  String get caregiverPatientsFilterCritical => 'गंभीर';

  @override
  String get caregiverPatientsFilterDialogTitle => 'मरीज फ़िल्टर करें';

  @override
  String get caregiverPatientsEmptyNoMatch => 'आपकी खोज से कोई मरीज नहीं मिला';

  @override
  String get caregiverPatientsEmptyNone => 'कोई मरीज नहीं मिला';

  @override
  String get caregiverPatientsEmptyAdjustSearch =>
      'अपने खोज शब्द समायोजित करें';

  @override
  String get caregiverPatientsEmptyAddPatients =>
      'देखभाल प्रबंधन शुरू करने के लिए मरीज जोड़ें';

  @override
  String get caregiverPatientsAddFirstComingSoon =>
      'पहला मरीज जोड़ें - जल्द आ रहा है!';

  @override
  String get caregiverPatientsAddPatientButton => 'मरीज जोड़ें';

  @override
  String get caregiverPatientsLoadFailed => 'मरीज लोड करने में विफल';

  @override
  String get caregiverPatientsAddNewComingSoon =>
      'नया मरीज जोड़ें - जल्द आ रहा है!';

  @override
  String caregiverPatientsRelationshipAge(Object age, Object relationship) {
    return '$relationship • आयु $age';
  }

  @override
  String get caregiverPatientsStatAdherence => 'अनुपालन';

  @override
  String get caregiverPatientsStatAppointments => 'अपॉइंटमेंट';

  @override
  String get caregiverPatientsStatLastVisit => 'पिछली विज़िट';

  @override
  String caregiverPatientsViewAlerts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# अलर्ट देखें',
      one: '# अलर्ट देखें',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsViewAppointments(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# अपॉइंटमेंट',
      one: '# अपॉइंटमेंट',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsViewAlertsComingSoon(Object name) {
    return '$name के अलर्ट देखें - जल्द आ रहा है!';
  }

  @override
  String caregiverPatientsViewAppointmentsComingSoon(Object name) {
    return '$name के अपॉइंटमेंट देखें - जल्द आ रहा है!';
  }

  @override
  String get caregiverPatientsLastVisitToday => 'आज';

  @override
  String get caregiverPatientsLastVisitYesterday => 'कल';

  @override
  String caregiverPatientsLastVisitDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# दिन पहले',
      one: '# दिन पहले',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsLastVisitWeeks(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# सप्ताह पहले',
      one: '# सप्ताह पहले',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsLastVisitMonths(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# माह पहले',
      one: '# माह पहले',
    );
    return '$_temp0';
  }

  @override
  String get caregiverPatientOverviewTitle => 'मरीज अवलोकन';

  @override
  String get caregiverPatientOverviewTabVisits => 'विज़िट';

  @override
  String get caregiverPatientOverviewTabReminders => 'रिमाइंडर';

  @override
  String get caregiverPatientOverviewTabNotes => 'नोट्स';

  @override
  String get caregiverPatientOverviewNoVisits => 'कोई विज़िट उपलब्ध नहीं';

  @override
  String get caregiverPatientOverviewNoReminders => 'कोई रिमाइंडर उपलब्ध नहीं';

  @override
  String get caregiverPatientOverviewNoNotes => 'कोई नोट्स उपलब्ध नहीं';

  @override
  String get caregiverPatientOverviewEditComingSoon =>
      'मरीज संपादित करें - जल्द आ रहा है!';

  @override
  String get caregiverPatientOverviewCallPatient => 'मरीज को कॉल करें';

  @override
  String get caregiverPatientOverviewSendMessage => 'संदेश भेजें';

  @override
  String get caregiverPatientOverviewEmergencyContact => 'आपातकालीन संपर्क';

  @override
  String get caregiverPatientOverviewSharePatientInfo =>
      'मरीज जानकारी साझा करें';

  @override
  String get caregiverPatientOverviewScheduleAppointment =>
      'नया अपॉइंटमेंट शेड्यूल करें - जल्द आ रहा है!';

  @override
  String get caregiverPatientOverviewAddReminder =>
      'नया रिमाइंडर जोड़ें - जल्द आ रहा है!';

  @override
  String get caregiverPatientOverviewAddNote =>
      'नया नोट जोड़ें - जल्द आ रहा है!';

  @override
  String caregiverPatientOverviewViewVisitDetails(Object type) {
    return '$type विवरण देखें - जल्द आ रहा है!';
  }

  @override
  String caregiverPatientOverviewViewReminderDetails(Object title) {
    return '$title विवरण देखें - जल्द आ रहा है!';
  }

  @override
  String caregiverPatientOverviewViewNoteDetails(Object title) {
    return '$title विवरण देखें - जल्द आ रहा है!';
  }

  @override
  String get caregiverPatientOverviewMissingPatientId => 'patientId गायब है';

  @override
  String get caregiverPatientOverviewOverdue => 'ओवरड्यू';

  @override
  String caregiverPatientOverviewInHours(Object hours) {
    return '$hours घंटों में';
  }

  @override
  String get caregiverPatientOverviewDefaultRelationship => 'केयर टीम';

  @override
  String get caregiverPatientOverviewDefaultCondition => 'अधिकृत पहुँच';

  @override
  String get caregiverAlertsTitle => 'अलर्ट';

  @override
  String get caregiverAlertsFilterAll => 'सभी';

  @override
  String get caregiverAlertsFilterUnread => 'अपठित';

  @override
  String get caregiverAlertsFilterRead => 'पढ़े हुए';

  @override
  String get caregiverAlertsFilterHighPriority => 'उच्च प्राथमिकता';

  @override
  String get caregiverAlertsFilterActionRequired => 'कार्रवाई आवश्यक';

  @override
  String get caregiverAlertsClearFilter => 'फ़िल्टर साफ़ करें';

  @override
  String caregiverAlertsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# अलर्ट',
      one: '# अलर्ट',
    );
    return '$_temp0';
  }

  @override
  String get caregiverAlertsMarkAllReadTooltip =>
      'सभी को पढ़ा हुआ चिह्नित करें';

  @override
  String get caregiverAlertsActionRequired => 'कार्रवाई आवश्यक';

  @override
  String get caregiverAlertsMarkRead => 'पढ़ा हुआ चिह्नित करें';

  @override
  String get caregiverAlertsTakeAction => 'कार्रवाई करें';

  @override
  String get caregiverAlertsEmptyAllTitle => 'इस समय कोई अलर्ट नहीं';

  @override
  String get caregiverAlertsEmptyAllSubtitle =>
      'सभी मरीज गतिविधियाँ सामान्य हैं';

  @override
  String get caregiverAlertsEmptyFilteredTitle =>
      'इस फ़िल्टर से कोई अलर्ट नहीं मिला';

  @override
  String get caregiverAlertsEmptyFilteredSubtitle =>
      'अधिक अलर्ट देखने के लिए फ़िल्टर समायोजित करें';

  @override
  String get caregiverAlertsViewAll => 'सभी अलर्ट देखें';

  @override
  String get caregiverAlertsMarkedRead => 'अलर्ट को पढ़ा हुआ चिह्नित किया गया';

  @override
  String get caregiverAlertsMarkedUnread => 'अलर्ट को अपठित चिह्नित किया गया';

  @override
  String get caregiverAlertsAllAlreadyRead => 'सभी अलर्ट पहले से पढ़े हुए हैं';

  @override
  String caregiverAlertsMarkedAllRead(Object count) {
    return '$count अलर्ट पढ़े हुए चिह्नित किए गए';
  }

  @override
  String caregiverAlertsTakingAction(Object type) {
    return '$type अलर्ट पर कार्रवाई की जा रही है';
  }

  @override
  String caregiverAlertsViewDetails(Object type) {
    return '$type अलर्ट का विवरण देखें';
  }

  @override
  String get caregiverInvitationsTitle => 'देखभालकर्ता आमंत्रण';

  @override
  String get caregiverInvitationsRetry => 'पुनः प्रयास करें';

  @override
  String get caregiverInvitationsEmpty => 'कोई लंबित आमंत्रण नहीं';

  @override
  String caregiverInvitationsRole(Object role) {
    return 'भूमिका: $role';
  }

  @override
  String caregiverInvitationsPermission(Object permission) {
    return 'अनुमति: $permission';
  }

  @override
  String get caregiverInvitationsAccept => 'स्वीकार करें';

  @override
  String get caregiverInvitationsMissingToken => 'आमंत्रण टोकन गायब है';

  @override
  String get caregiverInvitationsAccepted => 'आमंत्रण स्वीकार किया गया';

  @override
  String get caregiverInvitationsPatientFallback => 'मरीज';

  @override
  String get commonDelete => 'हटाएँ';

  @override
  String get overviewTitle => 'अवलोकन';

  @override
  String get overviewSearchHint => 'सारांश खोजें...';

  @override
  String get overviewTabSummaries => 'सारांश';

  @override
  String get overviewTabLabResults => 'लैब परिणाम';

  @override
  String get overviewTabScannedDocs => 'स्कैन किए दस्तावेज़';

  @override
  String get overviewNewSummaryTitle => '🎉 आपका विज़िट सारांश तैयार है!';

  @override
  String get overviewNewSummaryPrompt => 'क्या आप अभी देखना चाहेंगे?';

  @override
  String get overviewNewSummaryLater => 'बाद में';

  @override
  String get overviewNewSummaryView => 'सारांश देखें';

  @override
  String get overviewSelectAtLeastOne => 'कम से कम एक सारांश चुनें';

  @override
  String get overviewDeleteSummaryTitleSingular => 'सारांश हटाएँ?';

  @override
  String get overviewDeleteSummaryTitlePlural => 'सारांश हटाएँ?';

  @override
  String get overviewDeleteSummaryConfirmSingular =>
      'क्या आप वाकई इस सारांश को हटाना चाहते हैं? यह वापस नहीं किया जा सकता।';

  @override
  String overviewDeleteSummaryConfirmPlural(Object count) {
    return 'क्या आप वाकई $count सारांश हटाना चाहते हैं? यह वापस नहीं किया जा सकता।';
  }

  @override
  String get overviewAuthError =>
      'प्रमाणीकरण त्रुटि। कृपया फिर से लॉग इन करें।';

  @override
  String overviewDeleteSuccess(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# सारांश',
      one: '# सारांश',
    );
    return '$_temp0 सफलतापूर्वक हटाए गए';
  }

  @override
  String get overviewDeleteFailed =>
      'सारांश हटाने में विफल। कृपया फिर से प्रयास करें।';

  @override
  String get overviewNoCaregiver => 'अभी कोई देखभालकर्ता नहीं जोड़ा गया';

  @override
  String get overviewShareTitleShare => 'सारांश साझा करें?';

  @override
  String get overviewShareTitleStop => 'साझा करना रोकें?';

  @override
  String get overviewShareConfirmShare =>
      'आप यह सारांश अपने देखभालकर्ताओं के साथ साझा करने वाले हैं। वे इस विज़िट सारांश को देख सकेंगे।';

  @override
  String get overviewShareConfirmStop =>
      'देखभालकर्ता अब इस सारांश को नहीं देख सकेंगे।';

  @override
  String get overviewShareAction => 'साझा करें';

  @override
  String get overviewStopShareAction => 'साझा करना रोकें';

  @override
  String get overviewSharingEnabled => 'देखभालकर्ता साझा सक्षम';

  @override
  String get overviewSharingDisabled => 'देखभालकर्ता साझा अक्षम';

  @override
  String get overviewSummariesLoadFailed => 'सारांश लोड करने में विफल';

  @override
  String get overviewNoSummariesTitle => 'अभी कोई सारांश नहीं';

  @override
  String get overviewNoSummariesSubtitle =>
      'आपके विज़िट सारांश यहाँ दिखाई देंगे';

  @override
  String get overviewProcessingTitle =>
      '🕒 आपकी नवीनतम विज़िट प्रोसेस हो रही है';

  @override
  String get overviewProcessingSubtitle => 'तैयार होने पर हम सूचित करेंगे।';

  @override
  String get overviewLabResultsComingSoon => 'लैब परिणाम - जल्द आ रहा है';

  @override
  String get overviewScannedDocsComingSoon =>
      'स्कैन किए दस्तावेज़ - जल्द आ रहे हैं';

  @override
  String get overviewShareLabel => 'साझा करें';

  @override
  String get overviewDoctorVisit => 'डॉक्टर विज़िट';

  @override
  String overviewDoctorPrefix(Object name) {
    return 'डॉ. $name';
  }

  @override
  String overviewMinutesAgo(Object count) {
    return '$count मिनट पहले';
  }

  @override
  String overviewTodayAt(Object time) {
    return 'आज, $time';
  }

  @override
  String overviewYesterdayAt(Object time) {
    return 'कल, $time';
  }

  @override
  String get remindersTitle => 'रिमाइंडर';

  @override
  String get remindersTabAll => 'सभी';

  @override
  String get remindersTabToday => 'आज';

  @override
  String get remindersTabPending => 'लंबित';

  @override
  String get remindersTabCompleted => 'पूर्ण';

  @override
  String get remindersSearchHint => 'रिमाइंडर खोजें...';

  @override
  String get remindersDeleteTitle => 'रिमाइंडर हटाएँ';

  @override
  String get remindersDeleteConfirm =>
      'क्या आप वाकई इस रिमाइंडर को हटाना चाहते हैं?';

  @override
  String get remindersMarkDone => 'पूर्ण चिह्नित करें';

  @override
  String get remindersSnooze => 'स्नूज़';

  @override
  String get remindersCreateButton => 'रिमाइंडर बनाएं';

  @override
  String get remindersCreateComingSoon => 'नया रिमाइंडर बनाएं - जल्द आ रहा है!';

  @override
  String remindersEditComingSoon(Object title) {
    return '$title संपादित करें - जल्द आ रहा है!';
  }

  @override
  String get remindersMarkedCompleted => 'रिमाइंडर को पूर्ण चिह्नित किया गया!';

  @override
  String get remindersSnoozedForHour =>
      'रिमाइंडर 1 घंटे के लिए स्नूज़ किया गया';

  @override
  String get remindersDeleted => 'रिमाइंडर हटाया गया';

  @override
  String get remindersEmptyTitle => 'कोई रिमाइंडर नहीं मिले';

  @override
  String get remindersEmptySearchTitle => 'आपकी खोज से कोई रिमाइंडर नहीं मिला';

  @override
  String get remindersEmptySubtitle =>
      'शुरू करने के लिए अपना पहला रिमाइंडर बनाएं';

  @override
  String get remindersEmptySearchSubtitle => 'अपने खोज शब्द समायोजित करें';

  @override
  String remindersSnoozedUntil(Object time) {
    return '$time तक स्नूज़';
  }

  @override
  String get remindersStatusDone => 'पूर्ण';

  @override
  String get remindersStatusPending => 'लंबित';

  @override
  String get remindersStatusSnoozed => 'स्नूज़';

  @override
  String get remindersStatusUnknown => 'अज्ञात';

  @override
  String remindersTimeHoursAgo(Object count) {
    return '$count घंटे पहले';
  }

  @override
  String remindersTimeMinutesAgo(Object count) {
    return '$count मिनट पहले';
  }

  @override
  String remindersTimeInHours(Object count) {
    return '$count घंटे में';
  }

  @override
  String remindersTimeInMinutes(Object count) {
    return '$count मिनट में';
  }

  @override
  String get remindersTimeNow => 'अभी';

  @override
  String get remindersAdherenceTitle => 'दवा अनुपालन';

  @override
  String get remindersAdherenceThisWeek => 'इस सप्ताह';

  @override
  String get remindersAdherenceThisMonth => 'इस माह';

  @override
  String get remindersAdherenceOverall => 'कुल मिलाकर';

  @override
  String get remindersAdherenceByMedication => 'दवा के अनुसार';

  @override
  String get remindersAdherenceTipsTitle => 'अनुपालन सुझाव';

  @override
  String get remindersAdherenceTipsBody =>
      '• दवा समय के लिए फोन रिमाइंडर सेट करें\n• दवाओं को दिखाई देने वाली जगह रखें\n• दैनिक खुराक के लिए पिल ऑर्गेनाइज़र का उपयोग करें\n• प्रगति ट्रैक करें ताकि प्रेरित रहें';

  @override
  String get visitRecordingTitle => 'विज़िट रिकॉर्ड करें';

  @override
  String get visitRecordingSave => 'सहेजें';

  @override
  String get visitRecordingGenerateSummary => 'सारांश बनाएँ';

  @override
  String get visitRecordingDiscardRecording => 'रिकॉर्डिंग त्यागें';

  @override
  String get visitRecordingCompleted => 'रिकॉर्डिंग पूर्ण हुई!';

  @override
  String get visitRecordingSaveFailed => 'रिकॉर्डिंग सहेजने में विफल';

  @override
  String get visitRecordingDiscarded => 'रिकॉर्डिंग त्याग दी गई';

  @override
  String get visitRecordingNoRecording => 'कोई रिकॉर्डिंग उपलब्ध नहीं';

  @override
  String get visitRecordingUploadingAudio => 'ऑडियो अपलोड हो रहा है...';

  @override
  String get visitRecordingProcessingTitle => '✅ आपकी विज़िट प्रोसेस हो रही है';

  @override
  String get visitRecordingGoToHome => 'होम जाएँ';

  @override
  String visitRecordingUploadFailed(Object error) {
    return 'ऑडियो अपलोड करने में विफल: $error';
  }

  @override
  String get visitRecordingStopTitle => 'रिकॉर्डिंग रोकें?';

  @override
  String get visitRecordingContinue => 'रिकॉर्डिंग जारी रखें';

  @override
  String get visitRecordingStopAndDiscard => 'रोकें और त्यागें';

  @override
  String get visitRecordingAudioPermissionTitle => 'ऑडियो रिकॉर्डिंग';

  @override
  String get visitRecordingNotNow => 'अभी नहीं';

  @override
  String get visitRecordingYesRecord => 'हाँ, रिकॉर्ड करें';

  @override
  String get visitRecordingStatusReady => 'रिकॉर्ड करने के लिए तैयार';

  @override
  String get visitRecordingStatusRecording => 'रिकॉर्डिंग चल रही है...';

  @override
  String get visitRecordingStatusComplete => 'रिकॉर्डिंग पूर्ण';

  @override
  String get visitRecordingInstructionIdle =>
      'अपनी विज़िट रिकॉर्ड करने के लिए टैप करें\nआपकी रिकॉर्डिंग निजी और सुरक्षित रहती है';

  @override
  String get visitRecordingInstructionRecording => 'रिकॉर्डिंग प्रगति में...';

  @override
  String get visitRecordingInstructionComplete =>
      'रिकॉर्डिंग पूरी हुई!\nअपनी विज़िट सारांश प्रोसेस करने के लिए जनरेट पर टैप करें';

  @override
  String get visitRecordingMicPermission =>
      'माइक्रोफ़ोन अनुमति आवश्यक है। कृपया Settings > RemiMinder > Microphone में सक्षम करें।';

  @override
  String get visitRecordingProcessingBody =>
      'यह ~30–60 सेकंड लग सकते हैं.\nआप ऐप का उपयोग जारी रख सकते हैं। हम तैयार होने पर सूचित करेंगे।';

  @override
  String get visitRecordingStopConfirm =>
      'क्या आप रिकॉर्डिंग रोकना चाहते हैं? यह कार्रवाई वापस नहीं की जा सकती।';

  @override
  String get visitRecordingAudioConsentBody =>
      'रिकॉर्डिंग विज़िट नोट्स, सारांश और रिमाइंडर बनाने में मदद करती है.\n\n• ऑडियो केवल तब रिकॉर्ड होता है जब आप रिकॉर्ड पर टैप करते हैं\n• रिकॉर्डिंग सुरक्षित रूप से प्रोसेस होती है और आपके फोन से हटाई जाती है\n• आप कभी भी रिकॉर्डिंग रोक सकते हैं\n\nक्या आप जारी रखना चाहते हैं?';

  @override
  String get visitDetailsTitle => 'विज़िट विवरण';

  @override
  String get visitDetailsSummaryCardTitle => 'स्वास्थ्य विज़िट सारांश';

  @override
  String get visitDetailsRefreshTooltip => 'सारांश ताज़ा करें';

  @override
  String get visitDetailsProcessingTitle => 'विज़िट सारांश तैयार हो रहा है...';

  @override
  String get visitDetailsProcessingSubtitle => 'इसमें एक मिनट लग सकता है।';

  @override
  String get visitDetailsLoadFailed => 'विज़िट सारांश लोड नहीं हो सका';

  @override
  String get visitDetailsRetry => 'पुनः प्रयास करें';

  @override
  String get visitDetailsUnavailable => 'विज़िट सारांश उपलब्ध नहीं है';

  @override
  String get visitDetailsSummarySection => 'विज़िट सारांश';

  @override
  String get visitDetailsFinalSummarySection => 'विज़िट सारांश';

  @override
  String get visitRecordingSaved =>
      'रिकॉर्डिंग सफलतापूर्वक सहेजी गई! अब आप सारांश जनरेट कर सकते हैं।';

  @override
  String get visitDetailsDecisionsSection => 'क्लिनिकल निर्णय';

  @override
  String get visitDetailsMedicationsSection => 'दवाएँ';

  @override
  String get visitDetailsActionsSection => 'अगले कदम';

  @override
  String get historyTitle => 'इतिहास';

  @override
  String get historySearchHint => 'घटनाएँ, दस्तावेज़, विज़िट खोजें...';

  @override
  String get historyTabAll => 'सभी';

  @override
  String get historyTabScannedDocs => 'स्कैन किए दस्तावेज़';

  @override
  String get historyTabLabResults => 'लैब परिणाम';

  @override
  String get historyLoadFailed => 'इतिहास लोड करने में विफल';

  @override
  String get historyRetry => 'पुनः प्रयास करें';

  @override
  String get historyVisitSummaryFallback => 'विज़िट सारांश';

  @override
  String get historyNoSummary => 'कोई सारांश उपलब्ध नहीं';

  @override
  String get historyUnknownDate => 'अज्ञात तिथि';

  @override
  String get historyUnknownTime => 'अज्ञात समय';

  @override
  String get historyNoScannedDocs => 'अभी कोई स्कैन किए दस्तावेज़ नहीं';

  @override
  String get historyNoScannedDocsSubtitle =>
      'स्कैन किए प्रिस्क्रिप्शन और दस्तावेज़ यहाँ दिखाई देंगे';

  @override
  String get historyNoLabResults => 'अभी कोई लैब परिणाम नहीं';

  @override
  String get historyNoLabResultsSubtitle =>
      'लैब परिणाम और परीक्षण रिपोर्ट यहाँ दिखाई देंगी';

  @override
  String historyNoEventsSearch(Object query) {
    return '\"$query\" के लिए कोई घटनाएँ नहीं मिलीं';
  }

  @override
  String get historyNoEvents => 'अभी कोई इवेंट नहीं';

  @override
  String get historyDocumentViewerSoon => 'दस्तावेज़ दर्शक जल्द आ रहा है';

  @override
  String get historyFeatureSoon => 'फीचर जल्द आ रहा है';

  @override
  String get notificationSettingsTitle => 'सूचनाएँ';

  @override
  String get notificationSectionTypes => 'सूचना प्रकार';

  @override
  String get notificationMedicationTitle => 'दवा रिमाइंडर';

  @override
  String get notificationMedicationSubtitle =>
      'दवा लेने का समय होने पर सूचित किया जाएगा';

  @override
  String get notificationAppointmentTitle => 'अपॉइंटमेंट रिमाइंडर';

  @override
  String get notificationAppointmentSubtitle =>
      'आगामी डॉक्टर विज़िट और परीक्षणों के लिए रिमाइंडर';

  @override
  String get notificationHealthTipsTitle => 'स्वास्थ्य सुझाव';

  @override
  String get notificationHealthTipsSubtitle =>
      'अपनी स्वास्थ्य स्थितियों को प्रबंधित करने के लिए दैनिक सुझाव';

  @override
  String get notificationCaregiverUpdatesTitle => 'देखभालकर्ता अपडेट';

  @override
  String get notificationCaregiverUpdatesSubtitle =>
      'जब देखभालकर्ता आपकी जानकारी देखें तब सूचनाएँ';

  @override
  String get notificationEmergencyAlertsTitle => 'आपातकालीन अलर्ट';

  @override
  String get notificationEmergencyAlertsSubtitle =>
      'गंभीर स्वास्थ्य अलर्ट और आपातकालीन सूचनाएँ';

  @override
  String get notificationDailySummaryTitle => 'दैनिक सारांश';

  @override
  String get notificationDailySummarySubtitle =>
      'दिन की स्वास्थ्य गतिविधियों का शाम का सारांश';

  @override
  String get notificationSectionTiming => 'समय संबंधी प्राथमिकताएँ';

  @override
  String get notificationMorningReminder => 'सुबह रिमाइंडर समय';

  @override
  String get notificationEveningReminder => 'शाम रिमाइंडर समय';

  @override
  String get notificationAdvanceTime => 'रिमाइंडर पूर्व समय';

  @override
  String get notificationAdvance5Min => '5 मिनट';

  @override
  String get notificationAdvance10Min => '10 मिनट';

  @override
  String get notificationAdvance15Min => '15 मिनट';

  @override
  String get notificationAdvance30Min => '30 मिनट';

  @override
  String get notificationAdvance60Min => '1 घंटे';

  @override
  String get notificationSectionSound => 'ध्वनि और अलर्ट';

  @override
  String get notificationSoundTitle => 'ध्वनि सूचनाएँ';

  @override
  String get notificationVibrationTitle => 'कंपन';

  @override
  String get notificationVolumeTitle => 'वॉल्यूम स्तर';

  @override
  String get notificationSectionTest => 'टेस्ट सूचनाएँ';

  @override
  String get notificationSendTest => 'टेस्ट सूचना भेजें';

  @override
  String get notificationTestSent => 'टेस्ट सूचना भेजी गई!';

  @override
  String get languageSettingsChooseApp => 'ऐप भाषा चुनें';

  @override
  String get languageSettingsChooseVisit => 'विज़िट भाषा चुनें';

  @override
  String get languageSettingsAppLabel => 'ऐप भाषा';

  @override
  String get languageSettingsVisitLabel => 'विज़िट भाषा';

  @override
  String get languageSettingsSave => 'सेटिंग्स सहेजें';

  @override
  String get languageSettingsInfo =>
      'विज़िट भाषा बदलने से स्पीच रिकॉग्निशन और एआई सारांश प्रभावित होते हैं।';

  @override
  String get languageSettingsLoadFailed => 'भाषा प्राथमिकताएँ लोड नहीं हो सकीं';

  @override
  String get languageSettingsSaveSuccess => 'भाषा सेटिंग्स सहेजी गईं';

  @override
  String get languageSettingsSaveFailed => 'भाषा सेटिंग्स सहेजने में विफल';

  @override
  String get changePasswordTitle => 'पासवर्ड बदलें';

  @override
  String get changePasswordSubtitle =>
      'अपने खाते को सुरक्षित रखने के लिए पासवर्ड अपडेट करें।';

  @override
  String get changePasswordCurrentLabel => 'वर्तमान पासवर्ड';

  @override
  String get changePasswordCurrentHint => 'अपना वर्तमान पासवर्ड दर्ज करें';

  @override
  String get changePasswordNewLabel => 'नया पासवर्ड';

  @override
  String get changePasswordNewHint => 'अपना नया पासवर्ड दर्ज करें';

  @override
  String get changePasswordConfirmLabel => 'नया पासवर्ड पुष्टि करें';

  @override
  String get changePasswordConfirmHint => 'अपना नया पासवर्ड फिर से दर्ज करें';

  @override
  String get changePasswordUpdateButton => 'पासवर्ड अपडेट करें';

  @override
  String get changePasswordCurrentRequired =>
      'कृपया अपना वर्तमान पासवर्ड दर्ज करें';

  @override
  String get changePasswordNewRequired => 'कृपया नया पासवर्ड दर्ज करें';

  @override
  String get changePasswordTooShort =>
      'पासवर्ड कम से कम 8 अक्षरों का होना चाहिए';

  @override
  String get changePasswordConfirmRequired =>
      'कृपया अपने नए पासवर्ड की पुष्टि करें';

  @override
  String get changePasswordMismatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get changePasswordSuccess => 'पासवर्ड सफलतापूर्वक अपडेट हुआ';

  @override
  String get changePasswordNotAuthenticated => 'उपयोगकर्ता प्रमाणित नहीं है';

  @override
  String get changePasswordFailed => 'पासवर्ड अपडेट करने में विफल';

  @override
  String get changePasswordWrongPassword => 'वर्तमान पासवर्ड गलत है';

  @override
  String get changePasswordWeakPassword => 'पासवर्ड बहुत कमजोर है';

  @override
  String get changePasswordRecentLogin =>
      'कृपया फिर से लॉग इन करें और प्रयास करें';

  @override
  String get changePasswordCheckConnection => 'अपना इंटरनेट कनेक्शन जांचें';

  @override
  String get accountSecurityTitle => 'खाता सुरक्षा';

  @override
  String get accountSecurityChangePasswordTitle => 'पासवर्ड बदलें';

  @override
  String get accountSecurityChangePasswordSubtitle =>
      'सुरक्षा के लिए खाते का पासवर्ड अपडेट करें';

  @override
  String get accountSecurityChangePasswordButton => 'पासवर्ड बदलें';

  @override
  String get accountSecurityPrivacyTitle => 'गोपनीयता सेटिंग्स';

  @override
  String get accountSecurityPrivacySubtitle =>
      'अपने डेटा साझाकरण प्राथमिकताएँ प्रबंधित करें';

  @override
  String get accountSecurityPrivacyButton => 'गोपनीयता प्रबंधित करें';

  @override
  String get accountSecurityDialogTitle => 'पासवर्ड बदलें';

  @override
  String accountSecurityDialogBody(Object provider) {
    return 'आपने $provider के साथ साइन इन किया है। कृपया अपने $provider खाते में पासवर्ड बदलें।';
  }

  @override
  String get accountSecurityDialogOk => 'ठीक है';

  @override
  String get profileAccountDetailsTitle => 'खाता विवरण';

  @override
  String get profileAccountDetailsSubtitle => 'अपने प्रोफ़ाइल जानकारी देखें';

  @override
  String get profileAccountSecurityTitle => 'खाता सुरक्षा';

  @override
  String get profileAccountSecuritySubtitle =>
      'पासवर्ड और गोपनीयता प्रबंधित करें';

  @override
  String get profileAppLanguageLabel => 'ऐप भाषा';

  @override
  String get profilePreferredSummaryLanguageLabel => 'पसंदीदा सारांश भाषा';

  @override
  String get profileDefaultVisitLanguageLabel => 'डिफ़ॉल्ट विज़िट भाषा';

  @override
  String get profileTimezoneLabel => 'समय क्षेत्र';

  @override
  String get profileCountryOptionalLabel => 'देश (वैकल्पिक)';

  @override
  String get profileCountryOrRegionLabel => 'देश या क्षेत्र';

  @override
  String get profileNotificationsTitle => 'सूचनाएँ';

  @override
  String get profileNotificationsMobile => 'मोबाइल';

  @override
  String get profileNotificationsEmail => 'ईमेल';

  @override
  String get profileUpgrade => 'अपग्रेड';

  @override
  String get profileSignOut => 'साइन आउट';

  @override
  String get profileNotSet => 'सेट नहीं';

  @override
  String profileSignOutFailed(Object error) {
    return 'साइन आउट विफल: $error';
  }

  @override
  String get upgradeBenefitsTitle => 'अपग्रेड लाभ';

  @override
  String get upgradeUnlockTitle => 'प्रीमियम केयर अनलॉक करें';

  @override
  String get upgradeSubtitle => 'अधिक मानसिक शांति पाएँ।';

  @override
  String get upgradeBenefitUnlimitedCaregivers => 'असीमित देखभालकर्ता';

  @override
  String get upgradeBenefitHealthTrends => 'उन्नत स्वास्थ्य रुझान';

  @override
  String get upgradeBenefitPrioritySupport => 'प्राथमिकता समर्थन';

  @override
  String get upgradeMonthlyPlan => 'मासिक योजना';

  @override
  String get upgradeAnnualPlan => 'वार्षिक योजना';

  @override
  String get upgradePerMonth => '/ माह';

  @override
  String get upgradePerYear => '/ वर्ष';

  @override
  String get upgradeCancelAnytime => 'कभी भी रद्द करें';

  @override
  String get upgradeContinuePayment => 'भुगतान पर जारी रखें';

  @override
  String get upgradePaymentComingSoon => 'भुगतान फ्लो जल्द आ रहा है';

  @override
  String get caregiversTitle => 'देखभालकर्ता';

  @override
  String get caregiversMyCaregivers => 'मेरे देखभालकर्ता';

  @override
  String get caregiversEmptyTitle => 'अभी कोई देखभालकर्ता नहीं';

  @override
  String get caregiversEmptySubtitle =>
      'अपने स्वास्थ्य की देखभाल में मदद के लिए\nपरिवार या मित्रों को आमंत्रित करें';

  @override
  String get caregiversInviteFirst => 'पहला देखभालकर्ता आमंत्रित करें';

  @override
  String get caregiversLoadFailed => 'देखभालकर्ताओं को लोड करने में विफल';

  @override
  String get caregiversResendInvite => 'निमंत्रण पुनः भेजें';

  @override
  String get caregiversCancel => 'रद्द करें';

  @override
  String get caregiversActiveLabel => 'सक्रिय देखभालकर्ता';

  @override
  String caregiversPermissionsCount(Object count) {
    return '$count अनुमतियाँ';
  }

  @override
  String caregiversActivityCount(Object count) {
    return '$count गतिविधियाँ';
  }

  @override
  String caregiversLastActive(Object time) {
    return 'अंतिम सक्रिय: $time';
  }

  @override
  String get caregiversStatusActive => 'सक्रिय';

  @override
  String get caregiversStatusPending => 'लंबित';

  @override
  String get caregiversStatusDeclined => 'अस्वीकृत';

  @override
  String get caregiversStatusUnknown => 'अज्ञात';

  @override
  String get caregiversInviteTitle => 'देखभालकर्ता आमंत्रित करें';

  @override
  String get caregiversFullNameLabel => 'पूरा नाम';

  @override
  String get caregiversFullNameHint => 'देखभालकर्ता का पूरा नाम दर्ज करें';

  @override
  String get caregiversFullNameRequired => 'कृपया नाम दर्ज करें';

  @override
  String get caregiversEmailLabel => 'ईमेल पता';

  @override
  String get caregiversEmailHint => 'caregiver@example.com';

  @override
  String get caregiversEmailRequired => 'कृपया ईमेल दर्ज करें';

  @override
  String get caregiversEmailInvalid => 'कृपया मान्य ईमेल दर्ज करें';

  @override
  String get caregiversRelationshipLabel => 'संबंध';

  @override
  String get caregiversSendInvitation => 'निमंत्रण भेजें';

  @override
  String caregiversInvitationSent(Object email) {
    return '$email को निमंत्रण भेजा गया';
  }

  @override
  String caregiversInvitationResent(Object email) {
    return '$email को निमंत्रण पुनः भेजा गया';
  }

  @override
  String get caregiversCancelInvitationTitle => 'निमंत्रण रद्द करें';

  @override
  String get caregiversCancelInvitationConfirm =>
      'क्या आप वाकई इस निमंत्रण को रद्द करना चाहते हैं?';

  @override
  String get caregiversKeep => 'रखें';

  @override
  String get caregiversCancelInvitationAction => 'निमंत्रण रद्द करें';

  @override
  String get caregiversDone => 'हो गया';

  @override
  String get caregiversAccessRemoved => 'पहुँच हटाई गई';

  @override
  String caregiversPermissionTitle(Object name) {
    return '$name के लिए अनुमतियाँ';
  }

  @override
  String get caregiversPermissionViewMedications => 'दवाएँ देखें';

  @override
  String get caregiversPermissionViewMedicationsDesc =>
      'दवा समय-सारिणी और इतिहास देख सकते हैं';

  @override
  String get caregiversPermissionViewVisits => 'विज़िट रिकॉर्ड देखें';

  @override
  String get caregiversPermissionViewVisitsDesc =>
      'विज़िट सारांश और प्रतिलेखों तक पहुंच सकते हैं';

  @override
  String get caregiversPermissionViewHealthData => 'स्वास्थ्य डेटा देखें';

  @override
  String get caregiversPermissionViewHealthDataDesc =>
      'स्वास्थ्य मेट्रिक्स और रुझान देख सकते हैं';

  @override
  String get caregiversPermissionEditMedications => 'दवाएँ संपादित करें';

  @override
  String get caregiversPermissionEditMedicationsDesc =>
      'दवा समय-सारिणी संशोधित कर सकते हैं';

  @override
  String get caregiversPermissionManageEmergency =>
      'आपातकालीन संपर्क प्रबंधित करें';

  @override
  String get caregiversPermissionManageEmergencyDesc =>
      'आपातकालीन संपर्क सेटिंग्स संशोधित कर सकते हैं';

  @override
  String get caregiversPermissionReceiveAlerts => 'अलर्ट प्राप्त करें';

  @override
  String get caregiversPermissionReceiveAlertsDesc =>
      'महत्वपूर्ण स्वास्थ्य घटनाओं की सूचनाएँ मिलती हैं';

  @override
  String get caregiversRelationshipFamily => 'परिवार का सदस्य';

  @override
  String get caregiversRelationshipFriend => 'मित्र';

  @override
  String get caregiversRelationshipSpouse => 'पति/पत्नी/साथी';

  @override
  String get caregiversRelationshipParent => 'माता-पिता';

  @override
  String get caregiversRelationshipChild => 'बच्चा';

  @override
  String get caregiversRelationshipHealthcare => 'स्वास्थ्य पेशेवर';

  @override
  String get caregiversRelationshipCaregiver => 'देखभालकर्ता';

  @override
  String get caregiversRelationshipOther => 'अन्य';

  @override
  String caregiversLastActiveDays(Object count) {
    return '$count दिन पहले';
  }

  @override
  String caregiversLastActiveHours(Object count) {
    return '$count घंटे पहले';
  }

  @override
  String caregiversLastActiveMinutes(Object count) {
    return '$count मिनट पहले';
  }

  @override
  String get caregiversLastActiveJustNow => 'अभी';

  @override
  String commonComingSoon(Object feature) {
    return '$feature जल्द आ रहा है';
  }

  @override
  String get privacyTitle => 'गोपनीयता सेटिंग्स';

  @override
  String get privacyDataSharing => 'डेटा साझाकरण';

  @override
  String get privacyNoCaregiver => 'अभी कोई देखभालकर्ता नहीं जोड़ा गया';

  @override
  String get privacyAllowCaregiverSummaries =>
      'देखभालकर्ता को सारांश देखने दें';

  @override
  String get privacyAllowCaregiverMedications =>
      'देखभालकर्ता को दवाएँ देखने दें';

  @override
  String get privacyAllowCaregiverReminders =>
      'देखभालकर्ता को रिमाइंडर देखने दें';

  @override
  String get privacyAllowAiImprove =>
      'एआई को उत्पाद सुधार के लिए मेरा डेटा उपयोग करने दें';

  @override
  String get privacyCaregiverSharingEnabled => 'देखभालकर्ता साझा सक्षम';

  @override
  String get privacyCaregiverSharingDisabled => 'देखभालकर्ता साझा अक्षम';

  @override
  String get privacyCommunicationConsent => 'संचार और सहमति';

  @override
  String get privacyAllowEmailNotifications => 'ईमेल सूचनाएँ अनुमति दें';

  @override
  String get privacyAllowSmsNotifications => 'SMS सूचनाएँ अनुमति दें';

  @override
  String get privacyAllowPushNotifications => 'पुश सूचनाएँ अनुमति दें';

  @override
  String get privacyDataControl => 'डेटा नियंत्रण';

  @override
  String get privacyExportData => 'मेरा डेटा निर्यात करें';

  @override
  String get privacyDataExportLabel => 'डेटा निर्यात';

  @override
  String get privacyDeleteRecords => 'मेरे सभी चिकित्सा रिकॉर्ड हटाएँ';

  @override
  String get privacyDeleteRecordsTitle => 'चिकित्सा रिकॉर्ड हटाएँ';

  @override
  String get privacyDeleteRecordsBody =>
      'यह आपके सभी चिकित्सा रिकॉर्ड स्थायी रूप से हटा देगा। यह कार्रवाई वापस नहीं की जा सकती।';

  @override
  String get privacyDeleteRecordsAction => 'रिकॉर्ड हटाएँ';

  @override
  String get privacyDeleteAccount => 'मेरा खाता हटाएँ';

  @override
  String get privacyDeleteAccountTitle => 'खाता हटाएँ';

  @override
  String get privacyDeleteAccountBody =>
      'यह आपका खाता और संबंधित सभी डेटा स्थायी रूप से हटा देगा। यह कार्रवाई वापस नहीं की जा सकती।';

  @override
  String get privacyDeleteAccountAction => 'खाता हटाएँ';

  @override
  String get privacyLegal => 'कानूनी';

  @override
  String get privacyViewPolicy => 'गोपनीयता नीति देखें';

  @override
  String get privacyViewTerms => 'सेवा की शर्तें देखें';

  @override
  String get privacyTermsTitle => 'सेवा की शर्तें';

  @override
  String get privacyTermsBody =>
      'RemiMinder के लिए सेवा की शर्तें\n\n1. शर्तों की स्वीकृति\nRemiMinder का उपयोग करके, आप इन शर्तों से सहमत होते हैं।\n\n2. सेवा का उपयोग\nRemiMinder स्वास्थ्य देखभाल और दवा रिमाइंडर प्रबंधित करने में सहायता के लिए बनाया गया है।\n\n3. गोपनीयता\nआपकी गोपनीयता हमारे लिए महत्वपूर्ण है। सभी स्वास्थ्य डेटा सुरक्षित रूप से संभाला जाता है।\n\nपूर्ण सेवा की शर्तों के लिए, कृपया हमारी वेबसाइट देखें।';

  @override
  String get privacyPolicyTitle => 'गोपनीयता नीति';

  @override
  String get privacyPolicyBody =>
      'RemiMinder के लिए गोपनीयता नीति\n\n1. हम कौन-सी जानकारी एकत्र करते हैं\nहम आपके द्वारा प्रदान की गई जानकारी और उपयोग डेटा को सेवा सुधारने के लिए एकत्र करते हैं।\n\n2. जानकारी का उपयोग कैसे करते हैं\nजानकारी का उपयोग स्वास्थ्य देखभाल प्रबंधन सेवाएँ प्रदान करने के लिए किया जाता है।\n\n3. जानकारी साझा करना\nहम आपकी व्यक्तिगत जानकारी नहीं बेचते हैं।\n\nपूर्ण गोपनीयता नीति के लिए, कृपया हमारी वेबसाइट देखें।';

  @override
  String get healthDashboardTitle => 'स्वास्थ्य डैशबोर्ड';

  @override
  String get healthDashboardLast7Days => 'पिछले 7 दिन';

  @override
  String get healthDashboardLast30Days => 'पिछले 30 दिन';

  @override
  String get healthDashboardLast90Days => 'पिछले 90 दिन';

  @override
  String get healthDashboardBloodPressure => 'रक्तचाप';

  @override
  String get healthDashboardWeightTrend => 'वज़न रुझान';

  @override
  String get healthDashboardMedicationAdherence => 'दवा अनुपालन';

  @override
  String get healthDashboardKeyMetrics => 'मुख्य मेट्रिक्स';

  @override
  String get healthDashboardUnitMmhg => 'mmHg';

  @override
  String get healthDashboardBpTrend => 'इस सप्ताह +2 अंक';

  @override
  String get healthDashboardWeight => 'वज़न';

  @override
  String get healthDashboardUnitLbs => 'lbs';

  @override
  String get healthDashboardWeightTrendText => 'इस सप्ताह -1.4 lbs';

  @override
  String get healthDashboardMedAdherence => 'दवा अनुपालन';

  @override
  String get healthDashboardThisWeek => 'इस सप्ताह';

  @override
  String get healthDashboardGoodProgress => 'अच्छी प्रगति';

  @override
  String get healthDashboardHeartRate => 'हृदय गति';

  @override
  String get healthDashboardUnitBpm => 'bpm';

  @override
  String get healthDashboardRestingAverage => 'विश्राम औसत';

  @override
  String get healthDashboardInsightsTitle => 'स्वास्थ्य अंतर्दृष्टि';

  @override
  String get healthDashboardInsightBpTitle => 'रक्तचाप रुझान';

  @override
  String get healthDashboardInsightBpBody =>
      'आपका सिस्टोलिक दबाव स्थिर रहा है और थोड़ा घटने की प्रवृत्ति है। अच्छा काम जारी रखें!';

  @override
  String get healthDashboardInsightWeightTitle => 'वज़न प्रबंधन';

  @override
  String get healthDashboardInsightWeightBody =>
      'इस सप्ताह 1.4 lbs की लगातार कमी। आप अपने लक्ष्य के लिए सही मार्ग पर हैं!';

  @override
  String get healthDashboardInsightAdherenceTitle => 'दवा अनुपालन';

  @override
  String get healthDashboardInsightAdherenceBody =>
      'इस सप्ताह 86% अनुपालन। 100% तक पहुँचने के लिए दवा रिमाइंडर सेट करने पर विचार करें।';

  @override
  String get healthDashboardInsightCheckupTitle => 'अगली जांच';

  @override
  String get healthDashboardInsightCheckupBody =>
      'आपकी अगली कार्डियोलॉजी अपॉइंटमेंट 3 महीनों में देय है। जल्द शेड्यूल करें।';

  @override
  String get healthDashboardRecentMeasurements => 'हाल के माप';

  @override
  String get healthDashboardRecentBpValue => '126/81 mmHg';

  @override
  String get healthDashboardRecentBpTime => 'आज, 8:30 AM';

  @override
  String get healthDashboardRecentWeightValue => '163.8 lbs';

  @override
  String get healthDashboardRecentWeightTime => 'आज, 7:45 AM';

  @override
  String get healthDashboardRecentHeartRateValue => '72 bpm';

  @override
  String get healthDashboardRecentHeartRateTime => 'कल, 8:15 AM';

  @override
  String get healthDashboardAddMeasurement => 'माप जोड़ें';

  @override
  String get healthDashboardAddMeasurementSoon =>
      'नया माप जोड़ें - जल्द आ रहा है!';

  @override
  String get emergencyContactsTitle => 'आपातकालीन संपर्क';

  @override
  String get emergencySosLabel => 'आपातकालीन SOS';

  @override
  String get emergencySosSubtitle => 'सभी आपातकालीन संपर्कों को कॉल करें';

  @override
  String get emergencyMedicalAlertTitle => 'चिकित्सीय अलर्ट जानकारी';

  @override
  String get emergencyMedicalAlertBody =>
      'हृदय रोगी, पेनिसिलिन से एलर्जी, रोज़ाना दवाएँ लेते हैं';

  @override
  String get emergencySosDialogTitle => 'आपातकालीन SOS';

  @override
  String get emergencySosDialogBody =>
      'यह सभी आपातकालीन संपर्कों को एक साथ कॉल करेगा। क्या आप सुनिश्चित हैं?';

  @override
  String get emergencySosDialogNote =>
      'आपातकालीन संपर्क प्राथमिकता क्रम में कॉल किए जाएंगे';

  @override
  String get emergencySosDialogAction => 'आपातकालीन संपर्कों को कॉल करें';

  @override
  String get emergencySosActivated =>
      'आपातकालीन SOS सक्रिय! सभी संपर्कों को कॉल किया जा रहा है...';

  @override
  String emergencyCallingContact(Object name) {
    return '$name को कॉल किया जा रहा है...';
  }

  @override
  String get emergencyAddContactTitle => 'आपातकालीन संपर्क जोड़ें';

  @override
  String get emergencyContactFullNameLabel => 'पूरा नाम';

  @override
  String get emergencyContactFullNameHint => 'संपर्क का नाम दर्ज करें';

  @override
  String get emergencyContactPhoneLabel => 'फोन नंबर';

  @override
  String get emergencyContactPhoneHint => '(555) 123-4567';

  @override
  String get emergencyContactTypeLabel => 'संपर्क प्रकार';

  @override
  String get emergencyContactRelationshipLabel => 'संबंध';

  @override
  String get emergencyContactRelationshipHint =>
      'पति/पत्नी, बच्चा, माता-पिता, आदि';

  @override
  String get emergencyAddContactAction => 'संपर्क जोड़ें';

  @override
  String emergencyEditContactComingSoon(Object name) {
    return '$name संपादित करें - जल्द आ रहा है!';
  }

  @override
  String get emergencyDeleteContactTitle => 'संपर्क हटाएँ';

  @override
  String emergencyDeleteContactBody(Object name) {
    return 'क्या आप $name को आपातकालीन संपर्कों से हटाना चाहते हैं?';
  }

  @override
  String get emergencyContactRemoved => 'संपर्क हटाया गया';

  @override
  String emergencyContactAdded(Object name) {
    return '$name को आपातकालीन संपर्कों में जोड़ा गया';
  }

  @override
  String get emergencyEditMedicalInfoComingSoon =>
      'चिकित्सीय जानकारी संपादित करें - जल्द आ रहा है!';

  @override
  String get emergencyContactTypeFamily => 'परिवार';

  @override
  String get emergencyContactTypeMedical => 'चिकित्सीय';

  @override
  String get emergencyContactTypeFriend => 'मित्र';

  @override
  String get emergencyContactTypeOther => 'अन्य';

  @override
  String get commonEdit => 'संपादित करें';

  @override
  String get careTeamTitle => 'केयर टीम';

  @override
  String get careTeamSubtitle =>
      'आप नियंत्रण में हैं। नीचे अपनी साझा करने की अनुमतियाँ समीक्षा करें।';

  @override
  String get careTeamEmptyCaregivers => 'अभी कोई देखभालकर्ता नहीं जोड़े गए';

  @override
  String get careTeamActiveCaregivers => 'सक्रिय देखभालकर्ता';

  @override
  String get careTeamPendingInvitations => 'लंबित निमंत्रण';

  @override
  String get careTeamInviteTitle => 'देखभालकर्ता आमंत्रित करें';

  @override
  String get careTeamInviteNameLabel => 'नाम';

  @override
  String get careTeamInviteNameHint => 'देखभालकर्ता का पूरा नाम दर्ज करें';

  @override
  String get careTeamInviteEmailLabel => 'ईमेल';

  @override
  String get careTeamInviteEmailHint => 'देखभालकर्ता का ईमेल पता दर्ज करें';

  @override
  String get careTeamInviteRelationshipLabel => 'संबंध';

  @override
  String get careTeamInviteRelationshipHint => 'जैसे, बेटा, बेटी, मित्र, नर्स';

  @override
  String get careTeamInviteRequiredFields => 'ईमेल और भूमिका आवश्यक हैं';

  @override
  String get careTeamInviteSend => 'निमंत्रण भेजें';

  @override
  String get careTeamAccessUpdated => 'पहुँच सफलतापूर्वक अपडेट हुई';

  @override
  String get careTeamAccessUpdateFailed =>
      'पहुँच अपडेट करने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get careTeamRemoveTitle => 'देखभालकर्ता हटाएँ?';

  @override
  String get careTeamRemoveBody =>
      'क्या आप निश्चित हैं कि आप इस देखभालकर्ता को हटाना चाहते हैं? उनकी पहुँच तुरंत समाप्त हो जाएगी।';

  @override
  String get careTeamRemoveConfirm => 'हटाएँ';

  @override
  String get careTeamRemoving => 'देखभालकर्ता हटाया जा रहा है...';

  @override
  String get careTeamRemoveFailed =>
      'देखभालकर्ता हटाने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get careTeamManageAccessTitle => 'पहुँच प्रबंधित करें';

  @override
  String get careTeamManageAccessSubtitle =>
      'देखभालकर्ता अनुमतियाँ अपडेट करें या पहुँच हटाएँ।';

  @override
  String get careTeamUpdatingAccess => 'पहुँच अपडेट हो रही है...';

  @override
  String get careTeamAccessView => 'देखने की पहुँच';

  @override
  String get careTeamAccessFull => 'पूर्ण पहुँच';

  @override
  String get careTeamAccessViewOnly => 'केवल देखें';

  @override
  String get careTeamResendingInvite => 'निमंत्रण पुनः भेजा जा रहा है...';

  @override
  String get careTeamInviteResent => 'निमंत्रण पुनः भेजा गया';

  @override
  String get careTeamInviteResendFailed => 'निमंत्रण पुनः भेजने में विफल';

  @override
  String get careTeamCancelingInvite => 'निमंत्रण रद्द किया जा रहा है...';

  @override
  String get careTeamInviteCanceled => 'निमंत्रण रद्द किया गया';

  @override
  String get careTeamInviteCancelFailed => 'निमंत्रण रद्द करने में विफल';

  @override
  String get careTeamInvitationPending => 'निमंत्रण लंबित';

  @override
  String get careTeamResend => 'पुनः भेजें';

  @override
  String get careTeamManageButton => 'प्रबंधित करें';

  @override
  String get careTeamInviteTileTitle => 'देखभालकर्ता आमंत्रित करें';

  @override
  String get careTeamInviteTileSubtitle =>
      'अपने स्वास्थ्य जानकारी तक पहुँच साझा करें';

  @override
  String get cameraSave => 'सहेजें';

  @override
  String get cameraModeRx => 'Rx';

  @override
  String get cameraModeLab => 'Lab';

  @override
  String get cameraModeMed => 'Med';

  @override
  String get cameraTapToCapture => 'कैप्चर करने के लिए टैप करें';

  @override
  String get cameraProcessingShort => 'प्रोसेसिंग...';

  @override
  String get cameraProcessingImage => 'छवि प्रोसेस हो रही है...';

  @override
  String get cameraScanSuccessful => 'स्कैन सफल!';

  @override
  String get cameraShare => 'शेयर';

  @override
  String get cameraNotReady => 'कैमरा तैयार नहीं है। कृपया पुनः प्रयास करें।';

  @override
  String cameraCaptureFailed(Object error) {
    return 'छवि कैप्चर करने में विफल: $error';
  }

  @override
  String get cameraUploadSuccess => 'छवि सफलतापूर्वक अपलोड हुई!';

  @override
  String cameraUploadFailed(Object error) {
    return 'छवि अपलोड करने में विफल: $error';
  }

  @override
  String get cameraScanSaved => 'स्कैन सफलतापूर्वक सहेजा गया!';

  @override
  String get cameraShareComingSoon => 'शेयर सुविधा - जल्द आ रही है!';

  @override
  String get cameraPrescriptionScanned =>
      'प्रिस्क्रिप्शन सफलतापूर्वक स्कैन हुआ';

  @override
  String get cameraLabReportProcessed => 'लैब रिपोर्ट सफलतापूर्वक प्रोसेस हुई';

  @override
  String get cameraMedicationExtracted => 'दवा जानकारी निकाली गई';

  @override
  String get cameraConsentTitle => 'दस्तावेज़ स्कैनिंग';

  @override
  String get cameraConsentBody =>
      'कैमरा प्रिस्क्रिप्शन और लैब रिपोर्ट जैसे चिकित्सा दस्तावेज़ों को स्कैन करने में मदद करता है.\n\n• कैमरा केवल तभी उपयोग होता है जब आप स्कैन चुनते हैं\n• छवियाँ सुरक्षित रूप से प्रोसेस होती हैं और आपके फोन से हटाई जाती हैं\n• फोटो कभी भी आपकी डिवाइस गैलरी में सहेजे नहीं जाते\n\nक्या आप जारी रखना चाहते हैं?';

  @override
  String get cameraConsentNotNow => 'अभी नहीं';

  @override
  String get cameraConsentConfirm => 'हाँ, स्कैन करें';

  @override
  String get cameraSectionPrescriptionDetails => 'प्रिस्क्रिप्शन विवरण';

  @override
  String get cameraLabelMedication => 'दवा';

  @override
  String get cameraValueLisinopril => 'लिसिनोप्रिल';

  @override
  String get cameraLabelDosage => 'खुराक';

  @override
  String get cameraValue10mg => '10mg';

  @override
  String get cameraLabelFrequency => 'आवृत्ति';

  @override
  String get cameraValueOnceDaily => 'दिन में एक बार';

  @override
  String get cameraLabelQuantity => 'मात्रा';

  @override
  String get cameraValue90Tablets => '90 टैबलेट';

  @override
  String get cameraLabelRefills => 'रिफ़िल';

  @override
  String get cameraValue3Remaining => '3 शेष';

  @override
  String get cameraSectionPrescriberInfo => 'प्रिस्क्राइबर जानकारी';

  @override
  String get cameraLabelDoctor => 'डॉक्टर';

  @override
  String get cameraValueDrSarahJohnson => 'डॉ. सारा जॉनसन';

  @override
  String get cameraLabelLicense => 'लाइसेंस';

  @override
  String get cameraValueLicenseId => 'MD123456';

  @override
  String get cameraLabelDate => 'तारीख';

  @override
  String get cameraValueDec122024 => '12 दिसम्बर, 2024';

  @override
  String get cameraSectionPharmacyInfo => 'फ़ार्मेसी जानकारी';

  @override
  String get cameraLabelPharmacy => 'फ़ार्मेसी';

  @override
  String get cameraValueCityMedicalPharmacy => 'सिटी मेडिकल फ़ार्मेसी';

  @override
  String get cameraLabelPhone => 'फ़ोन';

  @override
  String get cameraValuePhoneSample => '(555) 123-4567';

  @override
  String get cameraLabelAddress => 'पता';

  @override
  String get cameraValuePharmacyAddress => '123 मेन स्ट्रीट, सिटी, ST 12345';

  @override
  String get cameraSectionPatientInfo => 'मरीज जानकारी';

  @override
  String get cameraLabelName => 'नाम';

  @override
  String get cameraValueJohnDoe => 'जॉन डो';

  @override
  String get cameraLabelDob => 'जन्म तिथि';

  @override
  String get cameraValueDobSample => '01/15/1985';

  @override
  String get cameraLabelId => 'आईडी';

  @override
  String get cameraValuePatientId => 'P123456789';

  @override
  String get cameraSectionTestResults => 'परीक्षण परिणाम';

  @override
  String get cameraLabelCholesterolTotal => 'कोलेस्ट्रॉल (कुल)';

  @override
  String get cameraValueCholesterolTotal => '185 mg/dL';

  @override
  String get cameraRefCholesterolTotal => 'सामान्य: <200';

  @override
  String get cameraLabelHdlCholesterol => 'HDL कोलेस्ट्रॉल';

  @override
  String get cameraValueHdl => '45 mg/dL';

  @override
  String get cameraRefHdl => 'सामान्य: >40';

  @override
  String get cameraLabelLdlCholesterol => 'LDL कोलेस्ट्रॉल';

  @override
  String get cameraValueLdl => '120 mg/dL';

  @override
  String get cameraRefLdl => 'सामान्य: <130';

  @override
  String get cameraLabelTriglycerides => 'ट्राइग्लिसराइड्स';

  @override
  String get cameraValueTriglycerides => '150 mg/dL';

  @override
  String get cameraRefTriglycerides => 'सामान्य: <150';

  @override
  String get cameraSectionLabInfo => 'लैब जानकारी';

  @override
  String get cameraLabelLab => 'लैब';

  @override
  String get cameraValueCityMedicalLabs => 'सिटी मेडिकल लैब्स';

  @override
  String get cameraLabelReportDate => 'रिपोर्ट तारीख';

  @override
  String get cameraValueDec102024 => '10 दिसम्बर, 2024';

  @override
  String get cameraLabelCollected => 'संग्रहित';

  @override
  String get cameraValueDec092024 => '9 दिसम्बर, 2024';

  @override
  String get cameraSectionMedicationInfo => 'दवा जानकारी';

  @override
  String get cameraLabelStrength => 'ताकत';

  @override
  String get cameraLabelForm => 'रूप';

  @override
  String get cameraValueTablet => 'टैबलेट';

  @override
  String get cameraSectionUsageInstructions => 'उपयोग निर्देश';

  @override
  String get cameraLabelDirections => 'निर्देश';

  @override
  String get cameraValueDirectionsSample =>
      'दिन में एक बार मुंह से एक टैबलेट लें';

  @override
  String get cameraLabelPurpose => 'उद्देश्य';

  @override
  String get cameraValuePurposeSample => 'रक्तचाप प्रबंधन';

  @override
  String get cameraLabelStorage => 'भंडारण';

  @override
  String get cameraValueStorageSample => 'कमरे के तापमान पर रखें';

  @override
  String get cameraSectionAdditionalInfo => 'अतिरिक्त जानकारी';

  @override
  String get cameraLabelManufacturer => 'निर्माता';

  @override
  String get cameraValueManufacturerSample => 'जेनेरिक फ़ार्मास्यूटिकल्स';

  @override
  String get cameraLabelLotNumber => 'लॉट नंबर';

  @override
  String get cameraValueLotNumberSample => 'LP2024001';

  @override
  String get cameraLabelExpiration => 'समाप्ति';

  @override
  String get cameraValueExpirationSample => '06/2026';

  @override
  String get accountDetailsTitle => 'खाता विवरण';

  @override
  String get accountDetailsNameLabel => 'नाम';

  @override
  String get accountDetailsEmailLabel => 'ईमेल';

  @override
  String get accountDetailsAccountTypeLabel => 'खाता प्रकार';

  @override
  String get accountDetailsAccountTypePatient => 'मरीज';

  @override
  String get accountDetailsAccountTypeCaregiver => 'देखभालकर्ता';

  @override
  String get accountDetailsNotSet => 'सेट नहीं';

  @override
  String get accountDetailsPhoneLabel => 'फोन';

  @override
  String get accountDetailsPhoneEdit => 'संपादित करें';

  @override
  String get accountDetailsPhoneAdd => 'जोड़ें';

  @override
  String get accountDetailsPlanLabel => 'योजना';

  @override
  String get accountDetailsPlanFree => 'मुफ़्त';

  @override
  String get accountDetailsPlanPremium => 'प्रीमियम';

  @override
  String get accountDetailsPlanUpgrade => 'अपग्रेड';

  @override
  String get accountDetailsPlanManage => 'प्रबंधित करें';

  @override
  String get accountDetailsUsageLabel => 'उपयोग';

  @override
  String accountDetailsUsageFreePlan(Object limit, Object used) {
    return 'मुफ़्त योजना — $used / $limit सारांश उपयोग किए गए';
  }

  @override
  String get accountDetailsUsageUnlimited => 'असीमित';

  @override
  String get accountDetailsPhoneEditTitle => 'फोन नंबर संपादित करें';

  @override
  String get accountDetailsPhoneHint => '+1 (555) 123-4567';

  @override
  String get accountDetailsPhoneMinLengthError =>
      'फोन नंबर कम से कम 8 अक्षरों का होना चाहिए';

  @override
  String get accountDetailsPhoneUpdated => 'फोन नंबर सफलतापूर्वक अपडेट हुआ';

  @override
  String accountDetailsPhoneUpdateFailed(Object error) {
    return 'फोन नंबर अपडेट करने में विफल: $error';
  }

  @override
  String get commonSave => 'सहेजें';
}
