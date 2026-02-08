// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'RemiMinder';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get profileSettings => 'إعدادات الملف الشخصي';

  @override
  String get commonSkip => 'تخطي';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageSpanish => 'الإسبانية';

  @override
  String get languageHindi => 'الهندية';

  @override
  String get languageMandarin => 'الماندرين';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageFrench => 'الفرنسية';

  @override
  String get languageGerman => 'الألمانية';

  @override
  String get countryUnitedStates => 'الولايات المتحدة';

  @override
  String get countryCanada => 'كندا';

  @override
  String get countryUnitedKingdom => 'المملكة المتحدة';

  @override
  String get countryGermany => 'ألمانيا';

  @override
  String get countryIndia => 'الهند';

  @override
  String get welcomeTitle => 'مرحبًا بك في RemiMinder';

  @override
  String get welcomeSubtitle => 'ذكاء اصطناعي ذكي لتنسيق الصحة والرعاية';

  @override
  String get welcomeDescription =>
      'رفيقك الذكي لتذكيرات الأدوية وتتبع المواعيد وتنسيق الرعاية. لا تفوّت أي لحظة صحية مهمة بعد الآن.';

  @override
  String get welcomeGetStarted => 'ابدأ';

  @override
  String get roleChooseYourRole => 'اختر سياقك';

  @override
  String get roleSelectHowYouUse => 'اختر كيفية استخدامك لـ RemiMinder';

  @override
  String get rolePatient => 'سياق المريض';

  @override
  String get rolePatientDescription => 'إدارة أدويتك ومواعيدك وسجلاتك الصحية';

  @override
  String get roleCaregiver => 'سياق مقدم الرعاية';

  @override
  String get roleCaregiverDescription =>
      'المساعدة في إدارة الأدوية ورعاية أفراد الأسرة أو المرضى';

  @override
  String get roleContinue => 'متابعة';

  @override
  String get onboardingAppLanguageTitle => 'اختر لغة التطبيق';

  @override
  String get onboardingAppLanguageSubtitle => 'يحدّث هذا لغة الواجهة.';

  @override
  String get onboardingCountryTitle => 'اختر بلدك أو منطقتك';

  @override
  String get onboardingCountrySubtitle => 'اختياري، يساعد على تخصيص التجربة.';

  @override
  String get onboardingTimezoneTitle => 'أكد منطقتك الزمنية';

  @override
  String onboardingTimezoneDetected(Object timezone) {
    return 'تم الكشف: $timezone';
  }

  @override
  String get onboardingTimezoneLabel => 'المنطقة الزمنية';

  @override
  String get onboardingTimezoneConfirm => 'تأكيد';

  @override
  String get onboardingVisitLanguageTitle => 'اختر لغة الزيارة';

  @override
  String get onboardingVisitLanguageSubtitle =>
      'ستُستخدم لتسجيل الزيارات وإنشاء الملخصات';

  @override
  String get loginBrandName => 'RemiMinder.ai';

  @override
  String get loginContinueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get loginContinueWithApple => 'المتابعة باستخدام Apple';

  @override
  String get loginContinueWithEmail => 'المتابعة بالبريد الإلكتروني';

  @override
  String get loginCreateAccount => 'إنشاء حساب';

  @override
  String get loginForgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get loginSignInWithEmailTitle => 'تسجيل الدخول بالبريد الإلكتروني';

  @override
  String get loginEmailLabel => 'البريد الإلكتروني';

  @override
  String get loginEmailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get loginPasswordLabel => 'كلمة المرور';

  @override
  String get loginPasswordHint => 'أدخل كلمة المرور';

  @override
  String get loginRememberMe => 'تذكرني';

  @override
  String get loginSignIn => 'تسجيل الدخول';

  @override
  String get loginFillAllFields => 'يرجى ملء جميع الحقول';

  @override
  String get loginAuthFailed => 'فشل التحقق. يرجى المحاولة مرة أخرى.';

  @override
  String get loginInvalidEmailOrPassword =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة. يرجى التحقق والمحاولة مرة أخرى.';

  @override
  String get loginEmailNotConfirmed =>
      'يرجى التحقق من بريدك الإلكتروني وتأكيد حسابك قبل تسجيل الدخول.';

  @override
  String get loginUserNotFound => 'لا يوجد حساب بهذا البريد الإلكتروني.';

  @override
  String get loginConnectionError =>
      'خطأ في الاتصال. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.';

  @override
  String get loginRequestTimedOut =>
      'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى.';

  @override
  String get loginSignInFailedGeneric =>
      'فشل تسجيل الدخول. يرجى المحاولة مرة أخرى أو التواصل مع الدعم إذا استمرت المشكلة.';

  @override
  String get loginGoogleSignInFailed => 'فشل تسجيل الدخول عبر Google';

  @override
  String loginGoogleSignInFailedWithError(Object error) {
    return 'فشل تسجيل الدخول عبر Google: $error';
  }

  @override
  String get loginAppleSignInComingSoon => 'تسجيل الدخول عبر Apple - قريبًا!';

  @override
  String get loginContinueWithoutSigningIn => 'المتابعة دون تسجيل الدخول';

  @override
  String get loginBypassPatient => 'مريض';

  @override
  String get loginBypassCaregiver => 'مقدم رعاية';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get registerSubtitle => 'انضم إلى RemiMinder للبدء';

  @override
  String get registerFirstNameLabel => 'الاسم الأول';

  @override
  String get registerFirstNameHint => 'أحمد';

  @override
  String get registerFirstNameRequired => 'يرجى إدخال الاسم الأول';

  @override
  String get registerLastNameLabel => 'اسم العائلة';

  @override
  String get registerLastNameHint => 'محمد';

  @override
  String get registerLastNameRequired => 'يرجى إدخال اسم العائلة';

  @override
  String get registerEmailLabel => 'البريد الإلكتروني';

  @override
  String get registerEmailHint => 'ahmed.mohammed@example.com';

  @override
  String get registerEmailRequired => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get registerEmailInvalid => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get registerPasswordLabel => 'كلمة المرور';

  @override
  String get registerPasswordHint => 'أنشئ كلمة مرور قوية';

  @override
  String get registerPasswordRequired => 'يرجى إدخال كلمة المرور';

  @override
  String get registerPasswordTooShort =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get registerConfirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get registerConfirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get registerConfirmPasswordRequired => 'يرجى تأكيد كلمة المرور';

  @override
  String get registerPasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get registerTermsIntro => 'بإنشاء حساب، فإنك توافق على ';

  @override
  String get registerTermsOfService => 'شروط الخدمة';

  @override
  String get registerAnd => ' و';

  @override
  String get registerPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get registerCreateAccountButton => 'إنشاء حساب';

  @override
  String get registerAlreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get registerSignIn => 'تسجيل الدخول';

  @override
  String get registerAcceptTermsError => 'يرجى قبول الشروط والأحكام';

  @override
  String get registerSelectRoleFirst => 'يرجى اختيار سياق أولاً';

  @override
  String get registerAccountCreatedTitle => 'تم إنشاء الحساب!';

  @override
  String get registerAccountCreatedMessage =>
      'تم إنشاء حسابك بنجاح. يمكنك الآن تسجيل الدخول باستخدام بريدك الإلكتروني وكلمة المرور.';

  @override
  String get registerGoToSignIn => 'الانتقال لتسجيل الدخول';

  @override
  String get registerTermsTitle => 'شروط الخدمة';

  @override
  String get registerTermsBody =>
      'شروط خدمة RemiMinder\n\n1. قبول الشروط\nباستخدام RemiMinder، فإنك توافق على هذه الشروط.\n\n2. استخدام الخدمة\nتم تصميم RemiMinder للمساعدة في إدارة الرعاية الصحية وتذكيرات الأدوية.\n\n3. الخصوصية\nخصوصيتك مهمة لنا. يتم التعامل مع جميع البيانات الصحية بأمان.\n\n4. مسؤولية الحساب\nأنت مسؤول عن الحفاظ على سرية حسابك.\n\n5. حدود المسؤولية\nRemiMinder ليس بديلاً عن الاستشارة الطبية المهنية.\n\nللاطلاع على شروط الخدمة كاملةً، يرجى زيارة موقعنا الإلكتروني.';

  @override
  String get registerPrivacyTitle => 'سياسة الخصوصية';

  @override
  String get registerPrivacyBody =>
      'سياسة الخصوصية لـ RemiMinder\n\n1. المعلومات التي نجمعها\nنجمع المعلومات التي تقدمها وبيانات الاستخدام لتحسين خدمتنا.\n\n2. كيف نستخدم المعلومات\nتستخدم المعلومات لتقديم خدمات إدارة الرعاية الصحية وتحسين تجربة المستخدم.\n\n3. مشاركة المعلومات\nلا نبيع معلوماتك الشخصية. يتم مشاركة البيانات فقط مع مقدمي الرعاية الصحية الذين تفوضهم.\n\n4. أمن البيانات\nنطبق تدابير أمنية بمعايير الصناعة لحماية بياناتك الصحية.\n\n5. حقوقك\nلك الحق في الوصول إلى معلوماتك الشخصية أو تصحيحها أو حذفها.\n\nللاطلاع على سياسة الخصوصية كاملةً، يرجى زيارة موقعنا الإلكتروني.';

  @override
  String get registerAccountExists =>
      'يوجد حساب بهذا البريد الإلكتروني. يرجى تسجيل الدخول بدلاً من ذلك.';

  @override
  String get registerWeakPassword =>
      'كلمة المرور ضعيفة جدًا. استخدم 8 أحرف على الأقل مع حروف وأرقام.';

  @override
  String get registerConnectionError =>
      'خطأ في الاتصال. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.';

  @override
  String get registerRequestTimedOut =>
      'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى.';

  @override
  String get registerFailedGeneric =>
      'فشل التسجيل. يرجى المحاولة مرة أخرى أو التواصل مع الدعم إذا استمرت المشكلة.';

  @override
  String get forgotPasswordTitle => 'هل نسيت كلمة المرور؟';

  @override
  String get forgotPasswordSubtitle =>
      'لا تقلق! أدخل بريدك الإلكتروني وسنرسل لك تعليمات إعادة الضبط.';

  @override
  String get forgotPasswordEmailHint => 'أدخل عنوان بريدك الإلكتروني';

  @override
  String get forgotPasswordEmailRequired => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get forgotPasswordEmailInvalid => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get forgotPasswordSendInstructions => 'إرسال تعليمات إعادة الضبط';

  @override
  String get forgotPasswordRememberPassword => 'تتذكر كلمة المرور؟';

  @override
  String get forgotPasswordBackToLogin => 'العودة لتسجيل الدخول';

  @override
  String get forgotPasswordSuccessMessage =>
      'إذا كان هناك حساب بهذا البريد الإلكتروني، فقد أرسلنا تعليمات إعادة الضبط.';

  @override
  String get forgotPasswordSendFailed =>
      'فشل إرسال رسالة إعادة الضبط. يرجى التحقق من البريد والمحاولة مرة أخرى.';

  @override
  String get forgotPasswordNotAvailable =>
      'إعادة تعيين كلمة المرور غير متاحة لهذا الحساب.';

  @override
  String get forgotPasswordTooManyRequests =>
      'طلبات كثيرة جدًا. يرجى المحاولة لاحقًا.';

  @override
  String get forgotPasswordNetworkError =>
      'خطأ في الشبكة. يرجى التحقق من اتصال الإنترنت.';

  @override
  String get patientHomeGreetingMorning => 'صباح الخير';

  @override
  String get patientHomeGreetingAfternoon => 'مساء الخير';

  @override
  String get patientHomeGreetingEvening => 'مساء الخير';

  @override
  String get patientHomeGreetingNight => 'تصبح على خير';

  @override
  String get patientHomeFeelingToday => 'كيف تشعر اليوم؟';

  @override
  String get patientHomeTodaysSchedule => 'جدول اليوم';

  @override
  String get patientHomeTodoList => 'قائمة المهام';

  @override
  String get patientHomeUpNext => 'التالي';

  @override
  String get patientHomeNoUpcomingReminders => 'لا توجد تذكيرات قادمة';

  @override
  String get patientHomeMarkedAsTaken => 'تم التعليم كتم تناولها!';

  @override
  String get patientHomeTakeNow => 'تناول الآن';

  @override
  String get patientHomeReminderSnoozed => 'تم تأجيل التذكير لمدة ساعة';

  @override
  String get patientHomeNothingScheduled => 'لا شيء مجدول اليوم';

  @override
  String get patientHomeViewAll => 'عرض الكل';

  @override
  String get patientHomeAddItem => 'إضافة عنصر';

  @override
  String get patientHomeNoTasksYet => 'لا توجد مهام بعد';

  @override
  String get patientHomeAddTask => 'إضافة مهمة';

  @override
  String get patientHomeAddedRecently => 'أضيفت مؤخرًا';

  @override
  String patientHomeAddedDate(Object date) {
    return 'أضيفت في $date';
  }

  @override
  String get patientHomeUpcoming => 'قادمة';

  @override
  String get patientHomeDueNow => 'مستحقة الآن';

  @override
  String patientHomeDueInMinutes(Object minutes) {
    return 'مستحقة خلال $minutes دقيقة';
  }

  @override
  String patientHomeDueInHours(Object hours) {
    return 'مستحقة خلال $hours ساعة';
  }

  @override
  String patientHomeDueInDays(Object days) {
    return 'مستحقة خلال $days يومًا';
  }

  @override
  String patientHomeDueOnDate(Object date) {
    return 'مستحقة في $date';
  }

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get caregiverPatientsTitle => 'مرضاي';

  @override
  String get caregiverPatientsSearchHint =>
      'ابحث عن المرضى بالاسم أو العلاقة أو الحالة...';

  @override
  String get caregiverPatientsClearFilter => 'مسح الفلتر';

  @override
  String caregiverPatientsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# مرضى',
      one: '# مريض',
    );
    return '$_temp0';
  }

  @override
  String get caregiverPatientsFilterAll => 'الكل';

  @override
  String get caregiverPatientsFilterActive => 'نشط';

  @override
  String get caregiverPatientsFilterAttention => 'يتطلب الانتباه';

  @override
  String get caregiverPatientsFilterCritical => 'حرج';

  @override
  String get caregiverPatientsFilterDialogTitle => 'تصفية المرضى';

  @override
  String get caregiverPatientsEmptyNoMatch => 'لا توجد نتائج مطابقة لبحثك';

  @override
  String get caregiverPatientsEmptyNone => 'لا يوجد مرضى';

  @override
  String get caregiverPatientsEmptyAdjustSearch => 'جرّب تعديل كلمات البحث';

  @override
  String get caregiverPatientsEmptyAddPatients => 'أضف مرضى لبدء إدارة رعايتهم';

  @override
  String get caregiverPatientsAddFirstComingSoon => 'إضافة أول مريض - قريبًا!';

  @override
  String get caregiverPatientsAddPatientButton => 'إضافة مريض';

  @override
  String get caregiverPatientsLoadFailed => 'فشل تحميل المرضى';

  @override
  String get caregiverPatientsAddNewComingSoon => 'إضافة مريض جديد - قريبًا!';

  @override
  String caregiverPatientsRelationshipAge(Object age, Object relationship) {
    return '$relationship • العمر $age';
  }

  @override
  String get caregiverPatientsStatAdherence => 'الالتزام';

  @override
  String get caregiverPatientsStatAppointments => 'المواعيد';

  @override
  String get caregiverPatientsStatLastVisit => 'آخر زيارة';

  @override
  String caregiverPatientsViewAlerts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عرض # تنبيهات',
      one: 'عرض تنبيه #',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsViewAppointments(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# مواعيد',
      one: '# موعد',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsViewAlertsComingSoon(Object name) {
    return 'عرض تنبيهات $name - قريبًا!';
  }

  @override
  String caregiverPatientsViewAppointmentsComingSoon(Object name) {
    return 'عرض مواعيد $name - قريبًا!';
  }

  @override
  String get caregiverPatientsLastVisitToday => 'اليوم';

  @override
  String get caregiverPatientsLastVisitYesterday => 'أمس';

  @override
  String caregiverPatientsLastVisitDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ # أيام',
      one: 'منذ # يوم',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsLastVisitWeeks(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ # أسابيع',
      one: 'منذ # أسبوع',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsLastVisitMonths(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ # أشهر',
      one: 'منذ # شهر',
    );
    return '$_temp0';
  }

  @override
  String get caregiverPatientOverviewTitle => 'نظرة عامة على المريض';

  @override
  String get caregiverPatientOverviewTabVisits => 'الزيارات';

  @override
  String get caregiverPatientOverviewTabReminders => 'التذكيرات';

  @override
  String get caregiverPatientOverviewTabNotes => 'الملاحظات';

  @override
  String get caregiverPatientOverviewNoVisits => 'لا توجد زيارات متاحة';

  @override
  String get caregiverPatientOverviewNoReminders => 'لا توجد تذكيرات متاحة';

  @override
  String get caregiverPatientOverviewNoNotes => 'لا توجد ملاحظات متاحة';

  @override
  String get caregiverPatientOverviewEditComingSoon => 'تعديل المريض - قريبًا!';

  @override
  String get caregiverPatientOverviewCallPatient => 'الاتصال بالمريض';

  @override
  String get caregiverPatientOverviewSendMessage => 'إرسال رسالة';

  @override
  String get caregiverPatientOverviewEmergencyContact => 'جهة اتصال للطوارئ';

  @override
  String get caregiverPatientOverviewSharePatientInfo =>
      'مشاركة معلومات المريض';

  @override
  String get caregiverPatientOverviewScheduleAppointment =>
      'جدولة موعد جديد - قريبًا!';

  @override
  String get caregiverPatientOverviewAddReminder =>
      'إضافة تذكير جديد - قريبًا!';

  @override
  String get caregiverPatientOverviewAddNote => 'إضافة ملاحظة جديدة - قريبًا!';

  @override
  String caregiverPatientOverviewViewVisitDetails(Object type) {
    return 'عرض تفاصيل $type - قريبًا!';
  }

  @override
  String caregiverPatientOverviewViewReminderDetails(Object title) {
    return 'عرض تفاصيل $title - قريبًا!';
  }

  @override
  String caregiverPatientOverviewViewNoteDetails(Object title) {
    return 'عرض تفاصيل $title - قريبًا!';
  }

  @override
  String get caregiverPatientOverviewMissingPatientId => 'معرّف المريض مفقود';

  @override
  String get caregiverPatientOverviewOverdue => 'متأخر';

  @override
  String caregiverPatientOverviewInHours(Object hours) {
    return 'خلال $hours ساعة';
  }

  @override
  String get caregiverPatientOverviewDefaultRelationship => 'فريق الرعاية';

  @override
  String get caregiverPatientOverviewDefaultCondition => 'وصول مصرح';

  @override
  String get caregiverAlertsTitle => 'تنبيهات';

  @override
  String get caregiverAlertsFilterAll => 'الكل';

  @override
  String get caregiverAlertsFilterUnread => 'غير مقروء';

  @override
  String get caregiverAlertsFilterRead => 'مقروء';

  @override
  String get caregiverAlertsFilterHighPriority => 'أولوية عالية';

  @override
  String get caregiverAlertsFilterActionRequired => 'يتطلب إجراء';

  @override
  String get caregiverAlertsClearFilter => 'مسح الفلتر';

  @override
  String caregiverAlertsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# تنبيهات',
      one: '# تنبيه',
    );
    return '$_temp0';
  }

  @override
  String get caregiverAlertsMarkAllReadTooltip => 'تحديد الكل كمقروء';

  @override
  String get caregiverAlertsActionRequired => 'يتطلب إجراء';

  @override
  String get caregiverAlertsMarkRead => 'تحديد كمقروء';

  @override
  String get caregiverAlertsTakeAction => 'اتخاذ إجراء';

  @override
  String get caregiverAlertsEmptyAllTitle => 'لا توجد تنبيهات حاليًا';

  @override
  String get caregiverAlertsEmptyAllSubtitle => 'جميع أنشطة المرضى تسير بسلاسة';

  @override
  String get caregiverAlertsEmptyFilteredTitle =>
      'لا توجد تنبيهات تطابق هذا الفلتر';

  @override
  String get caregiverAlertsEmptyFilteredSubtitle =>
      'جرّب تعديل الفلتر لرؤية المزيد من التنبيهات';

  @override
  String get caregiverAlertsViewAll => 'عرض جميع التنبيهات';

  @override
  String get caregiverAlertsMarkedRead => 'تم تحديد التنبيه كمقروء';

  @override
  String get caregiverAlertsMarkedUnread => 'تم تحديد التنبيه كغير مقروء';

  @override
  String get caregiverAlertsAllAlreadyRead => 'جميع التنبيهات مقروءة بالفعل';

  @override
  String caregiverAlertsMarkedAllRead(Object count) {
    return 'تم تحديد $count تنبيهات كمقروءة';
  }

  @override
  String caregiverAlertsTakingAction(Object type) {
    return 'جارٍ اتخاذ إجراء على تنبيه $type';
  }

  @override
  String caregiverAlertsViewDetails(Object type) {
    return 'عرض تفاصيل تنبيه $type';
  }

  @override
  String get caregiverInvitationsTitle => 'دعوات مقدمي الرعاية';

  @override
  String get caregiverInvitationsRetry => 'إعادة المحاولة';

  @override
  String get caregiverInvitationsEmpty => 'لا توجد دعوات معلقة';

  @override
  String caregiverInvitationsRole(Object role) {
    return 'الدور: $role';
  }

  @override
  String caregiverInvitationsPermission(Object permission) {
    return 'الإذن: $permission';
  }

  @override
  String get caregiverInvitationsAccept => 'قبول';

  @override
  String get caregiverInvitationsMissingToken => 'رمز الدعوة مفقود';

  @override
  String get caregiverInvitationsAccepted => 'تم قبول الدعوة';

  @override
  String get caregiverInvitationsPatientFallback => 'مريض';

  @override
  String get commonDelete => 'حذف';

  @override
  String get overviewTitle => 'نظرة عامة';

  @override
  String get overviewSearchHint => 'ابحث عن الملخصات...';

  @override
  String get overviewTabSummaries => 'الملخصات';

  @override
  String get overviewTabLabResults => 'نتائج المختبر';

  @override
  String get overviewTabScannedDocs => 'مستندات ممسوحة';

  @override
  String get overviewNewSummaryTitle => '🎉 ملخص زيارتك جاهز!';

  @override
  String get overviewNewSummaryPrompt => 'هل ترغب في عرضه الآن؟';

  @override
  String get overviewNewSummaryLater => 'لاحقًا';

  @override
  String get overviewNewSummaryView => 'عرض الملخص';

  @override
  String get overviewSelectAtLeastOne => 'اختر ملخصًا واحدًا على الأقل';

  @override
  String get overviewDeleteSummaryTitleSingular => 'حذف الملخص؟';

  @override
  String get overviewDeleteSummaryTitlePlural => 'حذف الملخصات؟';

  @override
  String get overviewDeleteSummaryConfirmSingular =>
      'هل أنت متأكد أنك تريد حذف هذا الملخص؟ لا يمكن التراجع عن ذلك.';

  @override
  String overviewDeleteSummaryConfirmPlural(Object count) {
    return 'هل أنت متأكد أنك تريد حذف $count ملخصات؟ لا يمكن التراجع عن ذلك.';
  }

  @override
  String get overviewAuthError =>
      'خطأ في المصادقة. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String overviewDeleteSuccess(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# ملخصات',
      one: '# ملخص',
    );
    return 'تم حذف $_temp0 بنجاح';
  }

  @override
  String get overviewDeleteFailed =>
      'فشل حذف الملخصات. يرجى المحاولة مرة أخرى.';

  @override
  String get overviewNoCaregiver => 'لم تتم إضافة مقدم رعاية بعد';

  @override
  String get overviewShareTitleShare => 'مشاركة الملخص؟';

  @override
  String get overviewShareTitleStop => 'إيقاف المشاركة؟';

  @override
  String get overviewShareConfirmShare =>
      'أنت على وشك مشاركة هذا الملخص مع مقدمي الرعاية لديك. سيتمكنون من عرض ملخص الزيارة هذا.';

  @override
  String get overviewShareConfirmStop =>
      'لن يتمكن مقدمو الرعاية من عرض هذا الملخص بعد الآن.';

  @override
  String get overviewShareAction => 'مشاركة';

  @override
  String get overviewStopShareAction => 'إيقاف المشاركة';

  @override
  String get overviewSharingEnabled => 'تم تمكين مشاركة مقدم الرعاية';

  @override
  String get overviewSharingDisabled => 'تم تعطيل مشاركة مقدم الرعاية';

  @override
  String get overviewSummariesLoadFailed => 'فشل تحميل الملخصات';

  @override
  String get overviewNoSummariesTitle => 'لا توجد ملخصات بعد';

  @override
  String get overviewNoSummariesSubtitle => 'ستظهر ملخصات الزيارة هنا';

  @override
  String get overviewProcessingTitle => '🕒 تتم معالجة زيارتك الأخيرة';

  @override
  String get overviewProcessingSubtitle => 'سنخطرك عندما يصبح جاهزًا.';

  @override
  String get overviewLabResultsComingSoon => 'نتائج المختبر - قريبًا';

  @override
  String get overviewScannedDocsComingSoon => 'مستندات ممسوحة - قريبًا';

  @override
  String get overviewShareLabel => 'مشاركة';

  @override
  String get overviewDoctorVisit => 'زيارة طبيب';

  @override
  String overviewDoctorPrefix(Object name) {
    return 'د. $name';
  }

  @override
  String overviewMinutesAgo(Object count) {
    return 'قبل $count دقيقة';
  }

  @override
  String overviewTodayAt(Object time) {
    return 'اليوم، $time';
  }

  @override
  String overviewYesterdayAt(Object time) {
    return 'أمس، $time';
  }

  @override
  String get remindersTitle => 'التذكيرات';

  @override
  String get remindersTabAll => 'الكل';

  @override
  String get remindersTabToday => 'اليوم';

  @override
  String get remindersTabPending => 'قيد الانتظار';

  @override
  String get remindersTabCompleted => 'مكتمل';

  @override
  String get remindersSearchHint => 'ابحث عن التذكيرات...';

  @override
  String get remindersDeleteTitle => 'حذف التذكير';

  @override
  String get remindersDeleteConfirm => 'هل أنت متأكد أنك تريد حذف هذا التذكير؟';

  @override
  String get remindersMarkDone => 'تحديد كمكتمل';

  @override
  String get remindersSnooze => 'غفوة';

  @override
  String get remindersCreateButton => 'إنشاء تذكير';

  @override
  String get remindersCreateComingSoon => 'إنشاء تذكير جديد - قريبًا!';

  @override
  String remindersEditComingSoon(Object title) {
    return 'تعديل $title - قريبًا!';
  }

  @override
  String get remindersMarkedCompleted => 'تم تحديد التذكير كمكتمل!';

  @override
  String get remindersSnoozedForHour => 'تم تأجيل التذكير لمدة ساعة';

  @override
  String get remindersDeleted => 'تم حذف التذكير';

  @override
  String get remindersEmptyTitle => 'لا توجد تذكيرات';

  @override
  String get remindersEmptySearchTitle => 'لا توجد تذكيرات تطابق بحثك';

  @override
  String get remindersEmptySubtitle => 'أنشئ أول تذكير لتبدأ';

  @override
  String get remindersEmptySearchSubtitle => 'جرّب تعديل كلمات البحث';

  @override
  String remindersSnoozedUntil(Object time) {
    return 'مؤجل حتى $time';
  }

  @override
  String get remindersStatusDone => 'مكتمل';

  @override
  String get remindersStatusPending => 'قيد الانتظار';

  @override
  String get remindersStatusSnoozed => 'مؤجل';

  @override
  String get remindersStatusUnknown => 'غير معروف';

  @override
  String remindersTimeHoursAgo(Object count) {
    return 'قبل $count ساعة';
  }

  @override
  String remindersTimeMinutesAgo(Object count) {
    return 'قبل $count دقيقة';
  }

  @override
  String remindersTimeInHours(Object count) {
    return 'خلال $count ساعة';
  }

  @override
  String remindersTimeInMinutes(Object count) {
    return 'خلال $count دقيقة';
  }

  @override
  String get remindersTimeNow => 'الآن';

  @override
  String get remindersAdherenceTitle => 'الالتزام بالأدوية';

  @override
  String get remindersAdherenceThisWeek => 'هذا الأسبوع';

  @override
  String get remindersAdherenceThisMonth => 'هذا الشهر';

  @override
  String get remindersAdherenceOverall => 'إجمالي';

  @override
  String get remindersAdherenceByMedication => 'حسب الدواء';

  @override
  String get remindersAdherenceTipsTitle => 'نصائح الالتزام';

  @override
  String get remindersAdherenceTipsBody =>
      '• اضبط تذكيرات الهاتف لمواعيد الأدوية\n• احتفظ بالأدوية في مكان واضح\n• استخدم منظم حبوب للجرعات اليومية\n• تتبع تقدمك للبقاء متحفزًا';

  @override
  String get visitRecordingTitle => 'تسجيل الزيارة';

  @override
  String get visitRecordingSave => 'حفظ';

  @override
  String get visitRecordingGenerateSummary => 'إنشاء ملخص';

  @override
  String get visitRecordingDiscardRecording => 'حذف التسجيل';

  @override
  String get visitRecordingCompleted => 'اكتمل التسجيل!';

  @override
  String get visitRecordingSaveFailed => 'فشل حفظ التسجيل';

  @override
  String get visitRecordingDiscarded => 'تم حذف التسجيل';

  @override
  String get visitRecordingNoRecording => 'لا يوجد تسجيل متاح';

  @override
  String get visitRecordingUploadingAudio => 'جارٍ تحميل الصوت...';

  @override
  String get visitRecordingProcessingTitle => '✅ تتم معالجة زيارتك';

  @override
  String get visitRecordingGoToHome => 'اذهب إلى الرئيسية';

  @override
  String visitRecordingUploadFailed(Object error) {
    return 'فشل تحميل الصوت: $error';
  }

  @override
  String get visitRecordingStopTitle => 'إيقاف التسجيل؟';

  @override
  String get visitRecordingContinue => 'متابعة التسجيل';

  @override
  String get visitRecordingStopAndDiscard => 'إيقاف وحذف';

  @override
  String get visitRecordingAudioPermissionTitle => 'تسجيل الصوت';

  @override
  String get visitRecordingNotNow => 'ليس الآن';

  @override
  String get visitRecordingYesRecord => 'نعم، سجّل';

  @override
  String get visitRecordingStatusReady => 'جاهز للتسجيل';

  @override
  String get visitRecordingStatusRecording => 'جارٍ التسجيل...';

  @override
  String get visitRecordingStatusComplete => 'اكتمل التسجيل';

  @override
  String get visitRecordingInstructionIdle =>
      'اضغط لبدء تسجيل زيارتك\nيظل تسجيلك خاصًا وآمنًا';

  @override
  String get visitRecordingInstructionRecording => 'التسجيل جارٍ...';

  @override
  String get visitRecordingInstructionComplete =>
      'اكتمل التسجيل!\nاضغط على إنشاء لمعالجة ملخص زيارتك';

  @override
  String get visitRecordingMicPermission =>
      'مطلوب إذن الميكروفون. يرجى تمكينه في Settings > RemiMinder > Microphone.';

  @override
  String get visitRecordingProcessingBody =>
      'قد يستغرق هذا نحو 30–60 ثانية.\nيمكنك متابعة استخدام التطبيق. سنخطرك عندما يكون جاهزًا.';

  @override
  String get visitRecordingStopConfirm =>
      'هل أنت متأكد من إيقاف التسجيل؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get visitRecordingAudioConsentBody =>
      'يساعد التسجيل على إنشاء ملاحظات الزيارة والملخصات والتذكيرات.\n\n• يتم تسجيل الصوت فقط عندما تضغط على تسجيل\n• تتم معالجة التسجيلات بشكل آمن ويتم حذفها من هاتفك\n• يمكنك إيقاف التسجيل في أي وقت\n\nهل ترغب في المتابعة؟';

  @override
  String get visitDetailsTitle => 'تفاصيل الزيارة';

  @override
  String get visitDetailsSummaryCardTitle => 'ملخص زيارة صحية';

  @override
  String get visitDetailsRefreshTooltip => 'تحديث الملخص';

  @override
  String get visitDetailsProcessingTitle => 'جارٍ إعداد ملخص الزيارة...';

  @override
  String get visitDetailsProcessingSubtitle => 'قد يستغرق هذا دقيقة.';

  @override
  String get visitDetailsLoadFailed => 'تعذر تحميل ملخص الزيارة';

  @override
  String get visitDetailsRetry => 'إعادة المحاولة';

  @override
  String get visitDetailsUnavailable => 'ملخص الزيارة غير متاح';

  @override
  String get visitDetailsSummarySection => 'ملخص الزيارة';

  @override
  String get visitDetailsFinalSummarySection => 'ملخص الزيارة';

  @override
  String get visitRecordingSaved =>
      'تم حفظ التسجيل بنجاح! يمكنك الآن إنشاء ملخص.';

  @override
  String get visitDetailsDecisionsSection => 'القرارات السريرية';

  @override
  String get visitDetailsMedicationsSection => 'الأدوية';

  @override
  String get visitDetailsActionsSection => 'الخطوات التالية';

  @override
  String get historyTitle => 'السجل';

  @override
  String get historySearchHint => 'ابحث في الأحداث والمستندات والزيارات...';

  @override
  String get historyTabAll => 'الكل';

  @override
  String get historyTabScannedDocs => 'مستندات ممسوحة';

  @override
  String get historyTabLabResults => 'نتائج المختبر';

  @override
  String get historyLoadFailed => 'فشل تحميل السجل';

  @override
  String get historyRetry => 'إعادة المحاولة';

  @override
  String get historyVisitSummaryFallback => 'ملخص الزيارة';

  @override
  String get historyNoSummary => 'لا يوجد ملخص متاح';

  @override
  String get historyUnknownDate => 'تاريخ غير معروف';

  @override
  String get historyUnknownTime => 'وقت غير معروف';

  @override
  String get historyNoScannedDocs => 'لا توجد مستندات ممسوحة بعد';

  @override
  String get historyNoScannedDocsSubtitle =>
      'ستظهر الوصفات والمستندات الممسوحة هنا';

  @override
  String get historyNoLabResults => 'لا توجد نتائج مختبر بعد';

  @override
  String get historyNoLabResultsSubtitle =>
      'ستظهر نتائج المختبر وتقارير الفحوصات هنا';

  @override
  String historyNoEventsSearch(Object query) {
    return 'لم يتم العثور على أحداث لـ \"$query\"';
  }

  @override
  String get historyNoEvents => 'لا توجد أحداث بعد';

  @override
  String get historyDocumentViewerSoon => 'عارض المستندات قريبًا';

  @override
  String get historyFeatureSoon => 'ميزة قريبة';

  @override
  String get notificationSettingsTitle => 'الإشعارات';

  @override
  String get notificationSectionTypes => 'أنواع الإشعارات';

  @override
  String get notificationMedicationTitle => 'تذكيرات الأدوية';

  @override
  String get notificationMedicationSubtitle =>
      'احصل على إشعار عندما يحين وقت تناول أدويتك';

  @override
  String get notificationAppointmentTitle => 'تذكيرات المواعيد';

  @override
  String get notificationAppointmentSubtitle =>
      'تذكيرات للزيارات الطبية والاختبارات القادمة';

  @override
  String get notificationHealthTipsTitle => 'نصائح صحية';

  @override
  String get notificationHealthTipsSubtitle =>
      'نصائح يومية لإدارة حالاتك الصحية';

  @override
  String get notificationCaregiverUpdatesTitle => 'تحديثات مقدم الرعاية';

  @override
  String get notificationCaregiverUpdatesSubtitle =>
      'إشعارات عندما يعرض مقدمو الرعاية معلوماتك';

  @override
  String get notificationEmergencyAlertsTitle => 'تنبيهات الطوارئ';

  @override
  String get notificationEmergencyAlertsSubtitle =>
      'تنبيهات صحية حرجة وإشعارات طارئة';

  @override
  String get notificationDailySummaryTitle => 'الملخص اليومي';

  @override
  String get notificationDailySummarySubtitle =>
      'ملخص مسائي لأنشطة صحتك اليومية';

  @override
  String get notificationSectionTiming => 'تفضيلات التوقيت';

  @override
  String get notificationMorningReminder => 'وقت تذكير الصباح';

  @override
  String get notificationEveningReminder => 'وقت تذكير المساء';

  @override
  String get notificationAdvanceTime => 'وقت التنبيه المسبق';

  @override
  String get notificationAdvance5Min => '5 دقائق';

  @override
  String get notificationAdvance10Min => '10 دقائق';

  @override
  String get notificationAdvance15Min => '15 دقيقة';

  @override
  String get notificationAdvance30Min => '30 دقيقة';

  @override
  String get notificationAdvance60Min => 'ساعة واحدة';

  @override
  String get notificationSectionSound => 'الصوت والتنبيهات';

  @override
  String get notificationSoundTitle => 'إشعارات صوتية';

  @override
  String get notificationVibrationTitle => 'اهتزاز';

  @override
  String get notificationVolumeTitle => 'مستوى الصوت';

  @override
  String get notificationSectionTest => 'اختبار الإشعارات';

  @override
  String get notificationSendTest => 'إرسال إشعار تجريبي';

  @override
  String get notificationTestSent => 'تم إرسال الإشعار التجريبي!';

  @override
  String get languageSettingsChooseApp => 'اختر لغة التطبيق';

  @override
  String get languageSettingsChooseVisit => 'اختر لغة الزيارة';

  @override
  String get languageSettingsAppLabel => 'لغة التطبيق';

  @override
  String get languageSettingsVisitLabel => 'لغة الزيارة';

  @override
  String get languageSettingsSave => 'حفظ الإعدادات';

  @override
  String get languageSettingsInfo =>
      'تغيير لغة الزيارة يؤثر على التعرف على الكلام وملخصات الذكاء الاصطناعي.';

  @override
  String get languageSettingsLoadFailed => 'فشل تحميل تفضيلات اللغة';

  @override
  String get languageSettingsSaveSuccess => 'تم حفظ إعدادات اللغة';

  @override
  String get languageSettingsSaveFailed => 'فشل حفظ إعدادات اللغة';

  @override
  String get changePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get changePasswordSubtitle =>
      'قم بتحديث كلمة المرور للحفاظ على أمان حسابك.';

  @override
  String get changePasswordCurrentLabel => 'كلمة المرور الحالية';

  @override
  String get changePasswordCurrentHint => 'أدخل كلمة المرور الحالية';

  @override
  String get changePasswordNewLabel => 'كلمة المرور الجديدة';

  @override
  String get changePasswordNewHint => 'أدخل كلمة المرور الجديدة';

  @override
  String get changePasswordConfirmLabel => 'تأكيد كلمة المرور الجديدة';

  @override
  String get changePasswordConfirmHint => 'أعد إدخال كلمة المرور الجديدة';

  @override
  String get changePasswordUpdateButton => 'تحديث كلمة المرور';

  @override
  String get changePasswordCurrentRequired => 'يرجى إدخال كلمة المرور الحالية';

  @override
  String get changePasswordNewRequired => 'يرجى إدخال كلمة مرور جديدة';

  @override
  String get changePasswordTooShort =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get changePasswordConfirmRequired => 'يرجى تأكيد كلمة المرور الجديدة';

  @override
  String get changePasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get changePasswordSuccess => 'تم تحديث كلمة المرور بنجاح';

  @override
  String get changePasswordNotAuthenticated => 'المستخدم غير مصادق عليه';

  @override
  String get changePasswordFailed => 'فشل تحديث كلمة المرور';

  @override
  String get changePasswordWrongPassword => 'كلمة المرور الحالية غير صحيحة';

  @override
  String get changePasswordWeakPassword => 'كلمة المرور ضعيفة جدًا';

  @override
  String get changePasswordRecentLogin =>
      'يرجى تسجيل الدخول مرة أخرى والمحاولة';

  @override
  String get changePasswordCheckConnection => 'تحقق من اتصال الإنترنت';

  @override
  String get accountSecurityTitle => 'أمان الحساب';

  @override
  String get accountSecurityChangePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get accountSecurityChangePasswordSubtitle =>
      'حدّث كلمة مرور حسابك للأمان';

  @override
  String get accountSecurityChangePasswordButton => 'تغيير كلمة المرور';

  @override
  String get accountSecurityPrivacyTitle => 'إعدادات الخصوصية';

  @override
  String get accountSecurityPrivacySubtitle => 'إدارة تفضيلات مشاركة البيانات';

  @override
  String get accountSecurityPrivacyButton => 'إدارة الخصوصية';

  @override
  String get accountSecurityDialogTitle => 'تغيير كلمة المرور';

  @override
  String accountSecurityDialogBody(Object provider) {
    return 'لقد سجّلت الدخول باستخدام $provider. يرجى تغيير كلمة المرور في حساب $provider الخاص بك.';
  }

  @override
  String get accountSecurityDialogOk => 'موافق';

  @override
  String get profileAccountDetailsTitle => 'تفاصيل الحساب';

  @override
  String get profileAccountDetailsSubtitle => 'عرض معلومات ملفك الشخصي';

  @override
  String get profileAccountSecurityTitle => 'أمان الحساب';

  @override
  String get profileAccountSecuritySubtitle => 'إدارة كلمة المرور والخصوصية';

  @override
  String get profileAppLanguageLabel => 'لغة التطبيق';

  @override
  String get profilePreferredSummaryLanguageLabel => 'لغة الملخص المفضلة';

  @override
  String get profileDefaultVisitLanguageLabel => 'لغة الزيارة الافتراضية';

  @override
  String get profileTimezoneLabel => 'المنطقة الزمنية';

  @override
  String get profileCountryOptionalLabel => 'الدولة (اختياري)';

  @override
  String get profileCountryOrRegionLabel => 'الدولة أو المنطقة';

  @override
  String get profileNotificationsTitle => 'الإشعارات';

  @override
  String get profileNotificationsMobile => 'الهاتف المحمول';

  @override
  String get profileNotificationsEmail => 'البريد الإلكتروني';

  @override
  String get profileUpgrade => 'ترقية';

  @override
  String get profileSignOut => 'تسجيل الخروج';

  @override
  String get profileNotSet => 'غير محدد';

  @override
  String profileSignOutFailed(Object error) {
    return 'فشل تسجيل الخروج: $error';
  }

  @override
  String get upgradeBenefitsTitle => 'مزايا الترقية';

  @override
  String get upgradeUnlockTitle => 'افتح رعاية مميزة';

  @override
  String get upgradeSubtitle => 'احصل على مزيد من راحة البال.';

  @override
  String get upgradeBenefitUnlimitedCaregivers => 'مقدمو رعاية غير محدودين';

  @override
  String get upgradeBenefitHealthTrends => 'اتجاهات صحية متقدمة';

  @override
  String get upgradeBenefitPrioritySupport => 'دعم ذو أولوية';

  @override
  String get upgradeMonthlyPlan => 'الخطة الشهرية';

  @override
  String get upgradeAnnualPlan => 'الخطة السنوية';

  @override
  String get upgradePerMonth => '/ شهر';

  @override
  String get upgradePerYear => '/ سنة';

  @override
  String get upgradeCancelAnytime => 'إلغاء في أي وقت';

  @override
  String get upgradeContinuePayment => 'متابعة إلى الدفع';

  @override
  String get upgradePaymentComingSoon => 'سير الدفع قريبًا';

  @override
  String get caregiversTitle => 'مقدمو الرعاية';

  @override
  String get caregiversMyCaregivers => 'مقدمو رعايتي';

  @override
  String get caregiversEmptyTitle => 'لا يوجد مقدمو رعاية بعد';

  @override
  String get caregiversEmptySubtitle =>
      'ادعُ أفراد العائلة أو الأصدقاء\nللمساعدة في إدارة رعايتك الصحية';

  @override
  String get caregiversInviteFirst => 'ادعُ أول مقدم رعاية';

  @override
  String get caregiversLoadFailed => 'فشل تحميل مقدمي الرعاية';

  @override
  String get caregiversResendInvite => 'إعادة إرسال الدعوة';

  @override
  String get caregiversCancel => 'إلغاء';

  @override
  String get caregiversActiveLabel => 'مقدم رعاية نشط';

  @override
  String caregiversPermissionsCount(Object count) {
    return '$count أذونات';
  }

  @override
  String caregiversActivityCount(Object count) {
    return '$count نشاط';
  }

  @override
  String caregiversLastActive(Object time) {
    return 'آخر نشاط: $time';
  }

  @override
  String get caregiversStatusActive => 'نشط';

  @override
  String get caregiversStatusPending => 'قيد الانتظار';

  @override
  String get caregiversStatusDeclined => 'مرفوض';

  @override
  String get caregiversStatusUnknown => 'غير معروف';

  @override
  String get caregiversInviteTitle => 'دعوة مقدم رعاية';

  @override
  String get caregiversFullNameLabel => 'الاسم الكامل';

  @override
  String get caregiversFullNameHint => 'أدخل الاسم الكامل لمقدم الرعاية';

  @override
  String get caregiversFullNameRequired => 'يرجى إدخال الاسم';

  @override
  String get caregiversEmailLabel => 'عنوان البريد الإلكتروني';

  @override
  String get caregiversEmailHint => 'caregiver@example.com';

  @override
  String get caregiversEmailRequired => 'يرجى إدخال البريد الإلكتروني';

  @override
  String get caregiversEmailInvalid => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get caregiversRelationshipLabel => 'العلاقة';

  @override
  String get caregiversSendInvitation => 'إرسال الدعوة';

  @override
  String caregiversInvitationSent(Object email) {
    return 'تم إرسال الدعوة إلى $email';
  }

  @override
  String caregiversInvitationResent(Object email) {
    return 'تمت إعادة إرسال الدعوة إلى $email';
  }

  @override
  String get caregiversCancelInvitationTitle => 'إلغاء الدعوة';

  @override
  String get caregiversCancelInvitationConfirm =>
      'هل أنت متأكد أنك تريد إلغاء هذه الدعوة؟';

  @override
  String get caregiversKeep => 'احتفظ';

  @override
  String get caregiversCancelInvitationAction => 'إلغاء الدعوة';

  @override
  String get caregiversDone => 'تم';

  @override
  String get caregiversAccessRemoved => 'تمت إزالة الوصول';

  @override
  String caregiversPermissionTitle(Object name) {
    return 'أذونات $name';
  }

  @override
  String get caregiversPermissionViewMedications => 'عرض الأدوية';

  @override
  String get caregiversPermissionViewMedicationsDesc =>
      'يمكنه رؤية جداول الأدوية والسجل';

  @override
  String get caregiversPermissionViewVisits => 'عرض سجلات الزيارة';

  @override
  String get caregiversPermissionViewVisitsDesc =>
      'يمكنه الوصول إلى ملخصات الزيارة والنصوص';

  @override
  String get caregiversPermissionViewHealthData => 'عرض البيانات الصحية';

  @override
  String get caregiversPermissionViewHealthDataDesc =>
      'يمكنه رؤية المؤشرات الصحية والاتجاهات';

  @override
  String get caregiversPermissionEditMedications => 'تعديل الأدوية';

  @override
  String get caregiversPermissionEditMedicationsDesc =>
      'يمكنه تعديل جداول الأدوية';

  @override
  String get caregiversPermissionManageEmergency =>
      'إدارة جهات الاتصال للطوارئ';

  @override
  String get caregiversPermissionManageEmergencyDesc =>
      'يمكنه تعديل إعدادات جهات اتصال الطوارئ';

  @override
  String get caregiversPermissionReceiveAlerts => 'استلام التنبيهات';

  @override
  String get caregiversPermissionReceiveAlertsDesc =>
      'يتلقى إشعارات بالأحداث الصحية المهمة';

  @override
  String get caregiversRelationshipFamily => 'أحد أفراد العائلة';

  @override
  String get caregiversRelationshipFriend => 'صديق';

  @override
  String get caregiversRelationshipSpouse => 'زوج/شريك';

  @override
  String get caregiversRelationshipParent => 'والد/والدة';

  @override
  String get caregiversRelationshipChild => 'طفل';

  @override
  String get caregiversRelationshipHealthcare => 'مختص رعاية صحية';

  @override
  String get caregiversRelationshipCaregiver => 'مقدم رعاية';

  @override
  String get caregiversRelationshipOther => 'أخرى';

  @override
  String caregiversLastActiveDays(Object count) {
    return 'قبل $count يومًا';
  }

  @override
  String caregiversLastActiveHours(Object count) {
    return 'قبل $count ساعة';
  }

  @override
  String caregiversLastActiveMinutes(Object count) {
    return 'قبل $count دقيقة';
  }

  @override
  String get caregiversLastActiveJustNow => 'الآن';

  @override
  String commonComingSoon(Object feature) {
    return '$feature قريبًا';
  }

  @override
  String get privacyTitle => 'إعدادات الخصوصية';

  @override
  String get privacyDataSharing => 'مشاركة البيانات';

  @override
  String get privacyNoCaregiver => 'لم تتم إضافة مقدم رعاية بعد';

  @override
  String get privacyAllowCaregiverSummaries =>
      'السماح لمقدم الرعاية بعرض الملخصات';

  @override
  String get privacyAllowCaregiverMedications =>
      'السماح لمقدم الرعاية بعرض الأدوية';

  @override
  String get privacyAllowCaregiverReminders =>
      'السماح لمقدم الرعاية بعرض التذكيرات';

  @override
  String get privacyAllowAiImprove =>
      'السماح للذكاء الاصطناعي باستخدام بياناتي لتحسين المنتج';

  @override
  String get privacyCaregiverSharingEnabled => 'تم تمكين مشاركة مقدم الرعاية';

  @override
  String get privacyCaregiverSharingDisabled => 'تم تعطيل مشاركة مقدم الرعاية';

  @override
  String get privacyCommunicationConsent => 'التواصل والموافقة';

  @override
  String get privacyAllowEmailNotifications =>
      'السماح بإشعارات البريد الإلكتروني';

  @override
  String get privacyAllowSmsNotifications => 'السماح بإشعارات الرسائل النصية';

  @override
  String get privacyAllowPushNotifications => 'السماح بإشعارات الدفع';

  @override
  String get privacyDataControl => 'التحكم بالبيانات';

  @override
  String get privacyExportData => 'تصدير بياناتي';

  @override
  String get privacyDataExportLabel => 'تصدير البيانات';

  @override
  String get privacyDeleteRecords => 'حذف جميع سجلاتي الطبية';

  @override
  String get privacyDeleteRecordsTitle => 'حذف السجلات الطبية';

  @override
  String get privacyDeleteRecordsBody =>
      'سيؤدي هذا إلى حذف جميع سجلاتك الطبية نهائيًا. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get privacyDeleteRecordsAction => 'حذف السجلات';

  @override
  String get privacyDeleteAccount => 'حذف حسابي';

  @override
  String get privacyDeleteAccountTitle => 'حذف الحساب';

  @override
  String get privacyDeleteAccountBody =>
      'سيؤدي هذا إلى حذف حسابك وجميع البيانات المرتبطة به نهائيًا. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get privacyDeleteAccountAction => 'حذف الحساب';

  @override
  String get privacyLegal => 'القانوني';

  @override
  String get privacyViewPolicy => 'عرض سياسة الخصوصية';

  @override
  String get privacyViewTerms => 'عرض شروط الخدمة';

  @override
  String get privacyTermsTitle => 'شروط الخدمة';

  @override
  String get privacyTermsBody =>
      'شروط خدمة RemiMinder\n\n1. قبول الشروط\nباستخدام RemiMinder، فإنك توافق على هذه الشروط.\n\n2. استخدام الخدمة\nتم تصميم RemiMinder للمساعدة في إدارة الرعاية الصحية وتذكيرات الأدوية.\n\n3. الخصوصية\nخصوصيتك مهمة لنا. يتم التعامل مع جميع البيانات الصحية بأمان.\n\nللاطلاع على شروط الخدمة كاملةً، يرجى زيارة موقعنا الإلكتروني.';

  @override
  String get privacyPolicyTitle => 'سياسة الخصوصية';

  @override
  String get privacyPolicyBody =>
      'سياسة الخصوصية لـ RemiMinder\n\n1. المعلومات التي نجمعها\nنجمع المعلومات التي تقدمها وبيانات الاستخدام لتحسين خدمتنا.\n\n2. كيف نستخدم المعلومات\nتستخدم المعلومات لتقديم خدمات إدارة الرعاية الصحية.\n\n3. مشاركة المعلومات\nلا نبيع معلوماتك الشخصية.\n\nللاطلاع على سياسة الخصوصية كاملةً، يرجى زيارة موقعنا الإلكتروني.';

  @override
  String get healthDashboardTitle => 'لوحة الصحة';

  @override
  String get healthDashboardLast7Days => 'آخر 7 أيام';

  @override
  String get healthDashboardLast30Days => 'آخر 30 يومًا';

  @override
  String get healthDashboardLast90Days => 'آخر 90 يومًا';

  @override
  String get healthDashboardBloodPressure => 'ضغط الدم';

  @override
  String get healthDashboardWeightTrend => 'اتجاه الوزن';

  @override
  String get healthDashboardMedicationAdherence => 'الالتزام بالأدوية';

  @override
  String get healthDashboardKeyMetrics => 'المقاييس الرئيسية';

  @override
  String get healthDashboardUnitMmhg => 'mmHg';

  @override
  String get healthDashboardBpTrend => '+2 نقطة هذا الأسبوع';

  @override
  String get healthDashboardWeight => 'الوزن';

  @override
  String get healthDashboardUnitLbs => 'lbs';

  @override
  String get healthDashboardWeightTrendText => '-1.4 lbs هذا الأسبوع';

  @override
  String get healthDashboardMedAdherence => 'الالتزام بالأدوية';

  @override
  String get healthDashboardThisWeek => 'هذا الأسبوع';

  @override
  String get healthDashboardGoodProgress => 'تقدّم جيد';

  @override
  String get healthDashboardHeartRate => 'معدل ضربات القلب';

  @override
  String get healthDashboardUnitBpm => 'bpm';

  @override
  String get healthDashboardRestingAverage => 'متوسط الراحة';

  @override
  String get healthDashboardInsightsTitle => 'رؤى صحية';

  @override
  String get healthDashboardInsightBpTitle => 'اتجاه ضغط الدم';

  @override
  String get healthDashboardInsightBpBody =>
      'ضغطك الانقباضي مستقر مع اتجاه طفيف للانخفاض. استمر في العمل الجيد!';

  @override
  String get healthDashboardInsightWeightTitle => 'إدارة الوزن';

  @override
  String get healthDashboardInsightWeightBody =>
      'فقدان وزن ثابت بمقدار 1.4 lbs هذا الأسبوع. أنت على المسار الصحيح لهدفك!';

  @override
  String get healthDashboardInsightAdherenceTitle => 'الالتزام بالأدوية';

  @override
  String get healthDashboardInsightAdherenceBody =>
      'نسبة الالتزام هذا الأسبوع 86%. فكّر في ضبط تذكيرات الأدوية للوصول إلى 100%.';

  @override
  String get healthDashboardInsightCheckupTitle => 'الفحص القادم';

  @override
  String get healthDashboardInsightCheckupBody =>
      'موعدك القادم لدى طبيب القلب بعد 3 أشهر. جدوله قريبًا.';

  @override
  String get healthDashboardRecentMeasurements => 'القياسات الأخيرة';

  @override
  String get healthDashboardRecentBpValue => '126/81 mmHg';

  @override
  String get healthDashboardRecentBpTime => 'اليوم، 8:30 AM';

  @override
  String get healthDashboardRecentWeightValue => '163.8 lbs';

  @override
  String get healthDashboardRecentWeightTime => 'اليوم، 7:45 AM';

  @override
  String get healthDashboardRecentHeartRateValue => '72 bpm';

  @override
  String get healthDashboardRecentHeartRateTime => 'أمس، 8:15 AM';

  @override
  String get healthDashboardAddMeasurement => 'إضافة قياس';

  @override
  String get healthDashboardAddMeasurementSoon => 'أضف قياسًا جديدًا - قريبًا!';

  @override
  String get emergencyContactsTitle => 'جهات اتصال الطوارئ';

  @override
  String get emergencySosLabel => 'طوارئ SOS';

  @override
  String get emergencySosSubtitle => 'اتصل بجميع جهات اتصال الطوارئ';

  @override
  String get emergencyMedicalAlertTitle => 'معلومات التنبيه الطبي';

  @override
  String get emergencyMedicalAlertBody =>
      'مريض قلبي، لديه حساسية من البنسلين، يتناول أدوية يومية';

  @override
  String get emergencySosDialogTitle => 'طوارئ SOS';

  @override
  String get emergencySosDialogBody =>
      'سيقوم هذا بالاتصال بجميع جهات اتصال الطوارئ في الوقت نفسه. هل أنت متأكد؟';

  @override
  String get emergencySosDialogNote =>
      'سيتم الاتصال بجهات اتصال الطوارئ حسب أولوية الترتيب';

  @override
  String get emergencySosDialogAction => 'اتصل بجهات اتصال الطوارئ';

  @override
  String get emergencySosActivated =>
      'تم تفعيل طوارئ SOS! يتم الاتصال بجميع جهات الاتصال...';

  @override
  String emergencyCallingContact(Object name) {
    return 'جارٍ الاتصال بـ $name...';
  }

  @override
  String get emergencyAddContactTitle => 'إضافة جهة اتصال للطوارئ';

  @override
  String get emergencyContactFullNameLabel => 'الاسم الكامل';

  @override
  String get emergencyContactFullNameHint => 'أدخل اسم جهة الاتصال';

  @override
  String get emergencyContactPhoneLabel => 'رقم الهاتف';

  @override
  String get emergencyContactPhoneHint => '(555) 123-4567';

  @override
  String get emergencyContactTypeLabel => 'نوع جهة الاتصال';

  @override
  String get emergencyContactRelationshipLabel => 'العلاقة';

  @override
  String get emergencyContactRelationshipHint =>
      'زوج/زوجة، طفل، والد/والدة، إلخ';

  @override
  String get emergencyAddContactAction => 'إضافة جهة اتصال';

  @override
  String emergencyEditContactComingSoon(Object name) {
    return 'تعديل $name - قريبًا!';
  }

  @override
  String get emergencyDeleteContactTitle => 'حذف جهة الاتصال';

  @override
  String emergencyDeleteContactBody(Object name) {
    return 'هل أنت متأكد أنك تريد إزالة $name من جهات اتصال الطوارئ؟';
  }

  @override
  String get emergencyContactRemoved => 'تمت إزالة جهة الاتصال';

  @override
  String emergencyContactAdded(Object name) {
    return 'تمت إضافة $name إلى جهات اتصال الطوارئ';
  }

  @override
  String get emergencyEditMedicalInfoComingSoon =>
      'تعديل المعلومات الطبية - قريبًا!';

  @override
  String get emergencyContactTypeFamily => 'العائلة';

  @override
  String get emergencyContactTypeMedical => 'طبي';

  @override
  String get emergencyContactTypeFriend => 'صديق';

  @override
  String get emergencyContactTypeOther => 'أخرى';

  @override
  String get commonEdit => 'تحرير';

  @override
  String get careTeamTitle => 'فريق الرعاية';

  @override
  String get careTeamSubtitle => 'أنت المتحكم. راجع أذونات المشاركة أدناه.';

  @override
  String get careTeamEmptyCaregivers => 'لم تتم إضافة مقدمي رعاية بعد';

  @override
  String get careTeamActiveCaregivers => 'مقدمو رعاية نشطون';

  @override
  String get careTeamPendingInvitations => 'دعوات معلقة';

  @override
  String get careTeamInviteTitle => 'دعوة مقدم رعاية';

  @override
  String get careTeamInviteNameLabel => 'الاسم';

  @override
  String get careTeamInviteNameHint => 'أدخل الاسم الكامل لمقدم الرعاية';

  @override
  String get careTeamInviteEmailLabel => 'البريد الإلكتروني';

  @override
  String get careTeamInviteEmailHint => 'أدخل عنوان بريد مقدم الرعاية';

  @override
  String get careTeamInviteRelationshipLabel => 'العلاقة';

  @override
  String get careTeamInviteRelationshipHint => 'مثلًا: ابن، ابنة، صديق، ممرضة';

  @override
  String get careTeamInviteRequiredFields => 'البريد الإلكتروني والدور مطلوبان';

  @override
  String get careTeamInviteSend => 'إرسال الدعوة';

  @override
  String get careTeamAccessUpdated => 'تم تحديث الوصول بنجاح';

  @override
  String get careTeamAccessUpdateFailed =>
      'فشل تحديث الوصول. يرجى المحاولة مرة أخرى.';

  @override
  String get careTeamRemoveTitle => 'إزالة مقدم الرعاية؟';

  @override
  String get careTeamRemoveBody =>
      'هل أنت متأكد أنك تريد إزالة مقدم الرعاية هذا؟ سيفقد الوصول فورًا.';

  @override
  String get careTeamRemoveConfirm => 'إزالة';

  @override
  String get careTeamRemoving => 'جارٍ إزالة مقدم الرعاية...';

  @override
  String get careTeamRemoveFailed =>
      'فشل إزالة مقدم الرعاية. يرجى المحاولة مرة أخرى.';

  @override
  String get careTeamManageAccessTitle => 'إدارة الوصول';

  @override
  String get careTeamManageAccessSubtitle =>
      'حدّث أذونات مقدم الرعاية أو أزل الوصول.';

  @override
  String get careTeamUpdatingAccess => 'جارٍ تحديث الوصول...';

  @override
  String get careTeamAccessView => 'عرض الوصول';

  @override
  String get careTeamAccessFull => 'وصول كامل';

  @override
  String get careTeamAccessViewOnly => 'عرض فقط';

  @override
  String get careTeamResendingInvite => 'جارٍ إعادة إرسال الدعوة...';

  @override
  String get careTeamInviteResent => 'تمت إعادة إرسال الدعوة';

  @override
  String get careTeamInviteResendFailed => 'فشل إعادة إرسال الدعوة';

  @override
  String get careTeamCancelingInvite => 'جارٍ إلغاء الدعوة...';

  @override
  String get careTeamInviteCanceled => 'تم إلغاء الدعوة';

  @override
  String get careTeamInviteCancelFailed => 'فشل إلغاء الدعوة';

  @override
  String get careTeamInvitationPending => 'دعوة معلقة';

  @override
  String get careTeamResend => 'إعادة إرسال';

  @override
  String get careTeamManageButton => 'إدارة';

  @override
  String get careTeamInviteTileTitle => 'دعوة مقدم رعاية';

  @override
  String get careTeamInviteTileSubtitle => 'شارك الوصول إلى معلوماتك الصحية';

  @override
  String get cameraSave => 'حفظ';

  @override
  String get cameraModeRx => 'Rx';

  @override
  String get cameraModeLab => 'Lab';

  @override
  String get cameraModeMed => 'Med';

  @override
  String get cameraTapToCapture => 'اضغط لالتقاط الصورة';

  @override
  String get cameraProcessingShort => 'جارٍ المعالجة...';

  @override
  String get cameraProcessingImage => 'جارٍ معالجة الصورة...';

  @override
  String get cameraScanSuccessful => 'تم المسح بنجاح!';

  @override
  String get cameraShare => 'مشاركة';

  @override
  String get cameraNotReady => 'الكاميرا غير جاهزة. يرجى المحاولة مرة أخرى.';

  @override
  String cameraCaptureFailed(Object error) {
    return 'فشل التقاط الصورة: $error';
  }

  @override
  String get cameraUploadSuccess => 'تم تحميل الصورة بنجاح!';

  @override
  String cameraUploadFailed(Object error) {
    return 'فشل تحميل الصورة: $error';
  }

  @override
  String get cameraScanSaved => 'تم حفظ المسح بنجاح!';

  @override
  String get cameraShareComingSoon => 'ميزة المشاركة - قريبًا!';

  @override
  String get cameraPrescriptionScanned => 'تم مسح الوصفة الطبية بنجاح';

  @override
  String get cameraLabReportProcessed => 'تمت معالجة تقرير المختبر بنجاح';

  @override
  String get cameraMedicationExtracted => 'تم استخراج معلومات الدواء';

  @override
  String get cameraConsentTitle => 'مسح المستندات';

  @override
  String get cameraConsentBody =>
      'تساعد الكاميرا في مسح المستندات الطبية مثل الوصفات الطبية وتقارير المختبر.\n\n• تُستخدم الكاميرا فقط عند اختيارك المسح\n• تُعالج الصور بأمان ويتم حذفها من هاتفك\n• لا يتم حفظ الصور في معرض جهازك أبدًا\n\nهل ترغب في المتابعة؟';

  @override
  String get cameraConsentNotNow => 'ليس الآن';

  @override
  String get cameraConsentConfirm => 'نعم، امسح';

  @override
  String get cameraSectionPrescriptionDetails => 'تفاصيل الوصفة الطبية';

  @override
  String get cameraLabelMedication => 'الدواء';

  @override
  String get cameraValueLisinopril => 'ليسينوبريل';

  @override
  String get cameraLabelDosage => 'الجرعة';

  @override
  String get cameraValue10mg => '10mg';

  @override
  String get cameraLabelFrequency => 'الوتيرة';

  @override
  String get cameraValueOnceDaily => 'مرة يوميًا';

  @override
  String get cameraLabelQuantity => 'الكمية';

  @override
  String get cameraValue90Tablets => '90 قرصًا';

  @override
  String get cameraLabelRefills => 'إعادات الصرف';

  @override
  String get cameraValue3Remaining => 'متبقي 3';

  @override
  String get cameraSectionPrescriberInfo => 'معلومات الواصف الطبي';

  @override
  String get cameraLabelDoctor => 'الطبيب';

  @override
  String get cameraValueDrSarahJohnson => 'د. سارة جونسون';

  @override
  String get cameraLabelLicense => 'الترخيص';

  @override
  String get cameraValueLicenseId => 'MD123456';

  @override
  String get cameraLabelDate => 'التاريخ';

  @override
  String get cameraValueDec122024 => '12 ديسمبر 2024';

  @override
  String get cameraSectionPharmacyInfo => 'معلومات الصيدلية';

  @override
  String get cameraLabelPharmacy => 'الصيدلية';

  @override
  String get cameraValueCityMedicalPharmacy => 'صيدلية سيتي الطبية';

  @override
  String get cameraLabelPhone => 'الهاتف';

  @override
  String get cameraValuePhoneSample => '(555) 123-4567';

  @override
  String get cameraLabelAddress => 'العنوان';

  @override
  String get cameraValuePharmacyAddress => '123 شارع مين، المدينة، ST 12345';

  @override
  String get cameraSectionPatientInfo => 'معلومات المريض';

  @override
  String get cameraLabelName => 'الاسم';

  @override
  String get cameraValueJohnDoe => 'جون دو';

  @override
  String get cameraLabelDob => 'تاريخ الميلاد';

  @override
  String get cameraValueDobSample => '01/15/1985';

  @override
  String get cameraLabelId => 'المعرّف';

  @override
  String get cameraValuePatientId => 'P123456789';

  @override
  String get cameraSectionTestResults => 'نتائج الفحوصات';

  @override
  String get cameraLabelCholesterolTotal => 'الكوليسترول (الإجمالي)';

  @override
  String get cameraValueCholesterolTotal => '185 mg/dL';

  @override
  String get cameraRefCholesterolTotal => 'الطبيعي: <200';

  @override
  String get cameraLabelHdlCholesterol => 'كوليسترول HDL';

  @override
  String get cameraValueHdl => '45 mg/dL';

  @override
  String get cameraRefHdl => 'الطبيعي: >40';

  @override
  String get cameraLabelLdlCholesterol => 'كوليسترول LDL';

  @override
  String get cameraValueLdl => '120 mg/dL';

  @override
  String get cameraRefLdl => 'الطبيعي: <130';

  @override
  String get cameraLabelTriglycerides => 'الدهون الثلاثية';

  @override
  String get cameraValueTriglycerides => '150 mg/dL';

  @override
  String get cameraRefTriglycerides => 'الطبيعي: <150';

  @override
  String get cameraSectionLabInfo => 'معلومات المختبر';

  @override
  String get cameraLabelLab => 'المختبر';

  @override
  String get cameraValueCityMedicalLabs => 'مختبرات سيتي الطبية';

  @override
  String get cameraLabelReportDate => 'تاريخ التقرير';

  @override
  String get cameraValueDec102024 => '10 ديسمبر 2024';

  @override
  String get cameraLabelCollected => 'تاريخ السحب';

  @override
  String get cameraValueDec092024 => '9 ديسمبر 2024';

  @override
  String get cameraSectionMedicationInfo => 'معلومات الدواء';

  @override
  String get cameraLabelStrength => 'التركيز';

  @override
  String get cameraLabelForm => 'الشكل';

  @override
  String get cameraValueTablet => 'قرص';

  @override
  String get cameraSectionUsageInstructions => 'تعليمات الاستخدام';

  @override
  String get cameraLabelDirections => 'التعليمات';

  @override
  String get cameraValueDirectionsSample =>
      'تناول قرصًا واحدًا عن طريق الفم مرة يوميًا';

  @override
  String get cameraLabelPurpose => 'الغرض';

  @override
  String get cameraValuePurposeSample => 'إدارة ضغط الدم';

  @override
  String get cameraLabelStorage => 'التخزين';

  @override
  String get cameraValueStorageSample => 'يحفظ في درجة حرارة الغرفة';

  @override
  String get cameraSectionAdditionalInfo => 'معلومات إضافية';

  @override
  String get cameraLabelManufacturer => 'الشركة المصنعة';

  @override
  String get cameraValueManufacturerSample => 'جينيريك فارماسيوتيكالز';

  @override
  String get cameraLabelLotNumber => 'رقم الدفعة';

  @override
  String get cameraValueLotNumberSample => 'LP2024001';

  @override
  String get cameraLabelExpiration => 'تاريخ الانتهاء';

  @override
  String get cameraValueExpirationSample => '06/2026';

  @override
  String get accountDetailsTitle => 'تفاصيل الحساب';

  @override
  String get accountDetailsNameLabel => 'الاسم';

  @override
  String get accountDetailsEmailLabel => 'البريد الإلكتروني';

  @override
  String get accountDetailsAccountTypeLabel => 'نوع الحساب';

  @override
  String get accountDetailsAccountTypePatient => 'مريض';

  @override
  String get accountDetailsAccountTypeCaregiver => 'مقدم رعاية';

  @override
  String get accountDetailsNotSet => 'غير محدد';

  @override
  String get accountDetailsPhoneLabel => 'الهاتف';

  @override
  String get accountDetailsPhoneEdit => 'تحرير';

  @override
  String get accountDetailsPhoneAdd => 'إضافة';

  @override
  String get accountDetailsPlanLabel => 'الخطة';

  @override
  String get accountDetailsPlanFree => 'مجانية';

  @override
  String get accountDetailsPlanPremium => 'مميزة';

  @override
  String get accountDetailsPlanUpgrade => 'ترقية';

  @override
  String get accountDetailsPlanManage => 'إدارة';

  @override
  String get accountDetailsUsageLabel => 'الاستخدام';

  @override
  String accountDetailsUsageFreePlan(Object limit, Object used) {
    return 'الخطة المجانية — تم استخدام $used / $limit ملخص';
  }

  @override
  String get accountDetailsUsageUnlimited => 'غير محدود';

  @override
  String get accountDetailsPhoneEditTitle => 'تحرير رقم الهاتف';

  @override
  String get accountDetailsPhoneHint => '+1 (555) 123-4567';

  @override
  String get accountDetailsPhoneMinLengthError =>
      'يجب أن يكون رقم الهاتف مكونًا من 8 أحرف على الأقل';

  @override
  String get accountDetailsPhoneUpdated => 'تم تحديث رقم الهاتف بنجاح';

  @override
  String accountDetailsPhoneUpdateFailed(Object error) {
    return 'فشل تحديث رقم الهاتف: $error';
  }

  @override
  String get commonSave => 'حفظ';
}
