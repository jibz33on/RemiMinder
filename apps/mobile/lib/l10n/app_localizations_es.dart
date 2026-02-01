// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'RemiMinder';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get profileSettings => 'Configuración de perfil';

  @override
  String get commonSkip => 'Saltar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languageMandarin => 'Mandarín';

  @override
  String get languageArabic => 'Árabe';

  @override
  String get languageFrench => 'Francés';

  @override
  String get languageGerman => 'Alemán';

  @override
  String get countryUnitedStates => 'Estados Unidos';

  @override
  String get countryCanada => 'Canadá';

  @override
  String get countryUnitedKingdom => 'Reino Unido';

  @override
  String get countryGermany => 'Alemania';

  @override
  String get countryIndia => 'India';

  @override
  String get welcomeTitle => 'Bienvenido a RemiMinder';

  @override
  String get welcomeSubtitle =>
      'IA inteligente para salud y coordinación de cuidados';

  @override
  String get welcomeDescription =>
      'Tu compañero inteligente para recordatorios de medicación, seguimiento de citas y coordinación de cuidados. Nunca más te pierdas un momento importante de salud.';

  @override
  String get welcomeGetStarted => 'Comenzar';

  @override
  String get roleChooseYourRole => 'Elige tu contexto';

  @override
  String get roleSelectHowYouUse => 'Selecciona cómo quieres usar RemiMinder';

  @override
  String get rolePatient => 'Contexto de paciente';

  @override
  String get rolePatientDescription =>
      'Gestiona tus medicamentos, citas y registros de salud';

  @override
  String get roleCaregiver => 'Contexto de cuidador';

  @override
  String get roleCaregiverDescription =>
      'Ayuda a gestionar medicamentos y cuidar a familiares o pacientes';

  @override
  String get roleContinue => 'Continuar';

  @override
  String get onboardingAppLanguageTitle => 'Elige el idioma de la app';

  @override
  String get onboardingAppLanguageSubtitle =>
      'Esto actualiza el idioma de la interfaz.';

  @override
  String get onboardingCountryTitle => 'Selecciona tu país o región';

  @override
  String get onboardingCountrySubtitle =>
      'Opcional, ayuda a personalizar la experiencia.';

  @override
  String get onboardingTimezoneTitle => 'Confirma tu zona horaria';

  @override
  String onboardingTimezoneDetected(Object timezone) {
    return 'Detectamos: $timezone';
  }

  @override
  String get onboardingTimezoneLabel => 'Zona horaria';

  @override
  String get onboardingTimezoneConfirm => 'Confirmar';

  @override
  String get onboardingVisitLanguageTitle => 'Elige el idioma de la visita';

  @override
  String get onboardingVisitLanguageSubtitle =>
      'Se usará para grabar visitas y generar resúmenes';

  @override
  String get loginBrandName => 'RemiMinder.ai';

  @override
  String get loginContinueWithGoogle => 'Continuar con Google';

  @override
  String get loginContinueWithApple => 'Continuar con Apple';

  @override
  String get loginContinueWithEmail => 'Continuar con correo';

  @override
  String get loginCreateAccount => 'Crear una cuenta';

  @override
  String get loginForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get loginSignInWithEmailTitle => 'Inicia sesión con correo';

  @override
  String get loginEmailLabel => 'Correo electrónico';

  @override
  String get loginEmailHint => 'Introduce tu correo';

  @override
  String get loginPasswordLabel => 'Contraseña';

  @override
  String get loginPasswordHint => 'Introduce tu contraseña';

  @override
  String get loginRememberMe => 'Recordarme';

  @override
  String get loginSignIn => 'Iniciar sesión';

  @override
  String get loginFillAllFields => 'Completa todos los campos';

  @override
  String get loginAuthFailed => 'La autenticación falló. Inténtalo de nuevo.';

  @override
  String get loginInvalidEmailOrPassword =>
      'Correo o contraseña inválidos. Verifica tus credenciales y vuelve a intentarlo.';

  @override
  String get loginEmailNotConfirmed =>
      'Revisa tu correo y confirma tu cuenta antes de iniciar sesión.';

  @override
  String get loginUserNotFound => 'No se encontró una cuenta con este correo.';

  @override
  String get loginConnectionError =>
      'Error de conexión. Revisa tu internet e inténtalo de nuevo.';

  @override
  String get loginRequestTimedOut => 'La solicitud expiró. Inténtalo de nuevo.';

  @override
  String get loginSignInFailedGeneric =>
      'El inicio de sesión falló. Inténtalo de nuevo o contacta soporte si el problema persiste.';

  @override
  String get loginGoogleSignInFailed => 'Falló el inicio con Google';

  @override
  String loginGoogleSignInFailedWithError(Object error) {
    return 'Falló el inicio con Google: $error';
  }

  @override
  String get loginAppleSignInComingSoon => 'Inicio con Apple - ¡Próximamente!';

  @override
  String get loginContinueWithoutSigningIn => 'Continuar sin iniciar sesión';

  @override
  String get loginBypassPatient => 'Paciente';

  @override
  String get loginBypassCaregiver => 'Cuidador';

  @override
  String get registerTitle => 'Crear cuenta';

  @override
  String get registerSubtitle => 'Únete a RemiMinder para comenzar';

  @override
  String get registerFirstNameLabel => 'Nombre';

  @override
  String get registerFirstNameHint => 'John';

  @override
  String get registerFirstNameRequired => 'Ingresa tu nombre';

  @override
  String get registerLastNameLabel => 'Apellido';

  @override
  String get registerLastNameHint => 'Doe';

  @override
  String get registerLastNameRequired => 'Ingresa tu apellido';

  @override
  String get registerEmailLabel => 'Correo electrónico';

  @override
  String get registerEmailHint => 'john.doe@example.com';

  @override
  String get registerEmailRequired => 'Ingresa tu correo';

  @override
  String get registerEmailInvalid => 'Ingresa un correo válido';

  @override
  String get registerPasswordLabel => 'Contraseña';

  @override
  String get registerPasswordHint => 'Crea una contraseña segura';

  @override
  String get registerPasswordRequired => 'Ingresa una contraseña';

  @override
  String get registerPasswordTooShort =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get registerConfirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get registerConfirmPasswordHint => 'Vuelve a ingresar tu contraseña';

  @override
  String get registerConfirmPasswordRequired => 'Confirma tu contraseña';

  @override
  String get registerPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get registerTermsIntro => 'Al crear una cuenta, aceptas nuestros ';

  @override
  String get registerTermsOfService => 'Términos de servicio';

  @override
  String get registerAnd => ' y ';

  @override
  String get registerPrivacyPolicy => 'Política de privacidad';

  @override
  String get registerCreateAccountButton => 'Crear cuenta';

  @override
  String get registerAlreadyHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get registerSignIn => 'Iniciar sesión';

  @override
  String get registerAcceptTermsError => 'Acepta los términos y condiciones';

  @override
  String get registerSelectRoleFirst => 'Selecciona un contexto primero';

  @override
  String get registerAccountCreatedTitle => '¡Cuenta creada!';

  @override
  String get registerAccountCreatedMessage =>
      'Tu cuenta se creó correctamente. Ahora puedes iniciar sesión con tu correo y contraseña.';

  @override
  String get registerGoToSignIn => 'Ir a iniciar sesión';

  @override
  String get registerTermsTitle => 'Términos de servicio';

  @override
  String get registerTermsBody =>
      'Términos de servicio de RemiMinder\n\n1. Aceptación de términos\nAl usar RemiMinder, aceptas estos términos.\n\n2. Uso del servicio\nRemiMinder está diseñado para ayudar a gestionar la salud y los recordatorios de medicación.\n\n3. Privacidad\nTu privacidad es importante para nosotros. Todos los datos de salud se gestionan de forma segura.\n\n4. Responsabilidad de la cuenta\nEres responsable de mantener la confidencialidad de tu cuenta.\n\n5. Limitación de responsabilidad\nRemiMinder no sustituye el consejo médico profesional.\n\nPara consultar los términos completos, visita nuestro sitio web.';

  @override
  String get registerPrivacyTitle => 'Política de privacidad';

  @override
  String get registerPrivacyBody =>
      'Política de privacidad de RemiMinder\n\n1. Información que recopilamos\nRecopilamos la información que proporcionas y datos de uso para mejorar el servicio.\n\n2. Cómo usamos la información\nLa información se usa para brindar servicios de gestión de salud y mejorar la experiencia.\n\n3. Compartir información\nNo vendemos tu información personal. Los datos solo se comparten con proveedores autorizados.\n\n4. Seguridad de datos\nImplementamos medidas de seguridad estándar para proteger tus datos de salud.\n\n5. Tus derechos\nTienes derecho a acceder, corregir o eliminar tu información personal.\n\nPara consultar la política completa, visita nuestro sitio web.';

  @override
  String get registerAccountExists =>
      'Ya existe una cuenta con este correo. Inicia sesión.';

  @override
  String get registerWeakPassword =>
      'La contraseña es muy débil. Usa al menos 8 caracteres con letras y números.';

  @override
  String get registerConnectionError =>
      'Error de conexión. Revisa tu internet e inténtalo de nuevo.';

  @override
  String get registerRequestTimedOut =>
      'La solicitud expiró. Inténtalo de nuevo.';

  @override
  String get registerFailedGeneric =>
      'El registro falló. Inténtalo de nuevo o contacta soporte si el problema persiste.';

  @override
  String get forgotPasswordTitle => '¿Olvidaste tu contraseña?';

  @override
  String get forgotPasswordSubtitle =>
      '¡No te preocupes! Ingresa tu correo y te enviaremos instrucciones.';

  @override
  String get forgotPasswordEmailHint => 'Introduce tu correo electrónico';

  @override
  String get forgotPasswordEmailRequired => 'Ingresa tu correo';

  @override
  String get forgotPasswordEmailInvalid => 'Ingresa un correo válido';

  @override
  String get forgotPasswordSendInstructions =>
      'Enviar instrucciones de restablecimiento';

  @override
  String get forgotPasswordRememberPassword => '¿Recuerdas tu contraseña?';

  @override
  String get forgotPasswordBackToLogin => 'Volver a iniciar sesión';

  @override
  String get forgotPasswordSuccessMessage =>
      'Si existe una cuenta para este correo, enviamos instrucciones de restablecimiento.';

  @override
  String get forgotPasswordSendFailed =>
      'No se pudo enviar el correo de restablecimiento. Verifica el correo y vuelve a intentarlo.';

  @override
  String get forgotPasswordNotAvailable =>
      'El restablecimiento de contraseña no está disponible para esta cuenta.';

  @override
  String get forgotPasswordTooManyRequests =>
      'Demasiadas solicitudes. Inténtalo más tarde.';

  @override
  String get forgotPasswordNetworkError => 'Error de red. Revisa tu internet.';

  @override
  String get patientHomeGreetingMorning => 'Buenos días';

  @override
  String get patientHomeGreetingAfternoon => 'Buenas tardes';

  @override
  String get patientHomeGreetingEvening => 'Buenas noches';

  @override
  String get patientHomeGreetingNight => 'Buenas noches';

  @override
  String get patientHomeFeelingToday => '¿Cómo te sientes hoy?';

  @override
  String get patientHomeTodaysSchedule => 'Agenda de hoy';

  @override
  String get patientHomeTodoList => 'Lista de tareas';

  @override
  String get patientHomeUpNext => 'Siguiente';

  @override
  String get patientHomeNoUpcomingReminders => 'No hay recordatorios próximos';

  @override
  String get patientHomeMarkedAsTaken => '¡Marcado como tomado!';

  @override
  String get patientHomeTakeNow => 'Tomar ahora';

  @override
  String get patientHomeReminderSnoozed => 'Recordatorio pospuesto por 1 hora';

  @override
  String get patientHomeNothingScheduled => 'Nada programado para hoy';

  @override
  String get patientHomeViewAll => 'Ver todo';

  @override
  String get patientHomeAddItem => 'Agregar elemento';

  @override
  String get patientHomeNoTasksYet => 'Aún no hay tareas';

  @override
  String get patientHomeAddTask => 'Agregar tarea';

  @override
  String get patientHomeAddedRecently => 'Agregado recientemente';

  @override
  String patientHomeAddedDate(Object date) {
    return 'Agregado $date';
  }

  @override
  String get patientHomeUpcoming => 'Próximo';

  @override
  String get patientHomeDueNow => 'Vence ahora';

  @override
  String patientHomeDueInMinutes(Object minutes) {
    return 'Vence en $minutes min';
  }

  @override
  String patientHomeDueInHours(Object hours) {
    return 'Vence en $hours horas';
  }

  @override
  String patientHomeDueInDays(Object days) {
    return 'Vence en $days días';
  }

  @override
  String patientHomeDueOnDate(Object date) {
    return 'Vence $date';
  }

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get caregiverPatientsTitle => 'Mis pacientes';

  @override
  String get caregiverPatientsSearchHint =>
      'Busca pacientes por nombre, relación o condición...';

  @override
  String get caregiverPatientsClearFilter => 'Quitar filtro';

  @override
  String caregiverPatientsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# pacientes',
      one: '# paciente',
    );
    return '$_temp0';
  }

  @override
  String get caregiverPatientsFilterAll => 'Todos';

  @override
  String get caregiverPatientsFilterActive => 'Activo';

  @override
  String get caregiverPatientsFilterAttention => 'Atención';

  @override
  String get caregiverPatientsFilterCritical => 'Crítico';

  @override
  String get caregiverPatientsFilterDialogTitle => 'Filtrar pacientes';

  @override
  String get caregiverPatientsEmptyNoMatch =>
      'Ningún paciente coincide con tu búsqueda';

  @override
  String get caregiverPatientsEmptyNone => 'No se encontraron pacientes';

  @override
  String get caregiverPatientsEmptyAdjustSearch =>
      'Prueba ajustando los términos de búsqueda';

  @override
  String get caregiverPatientsEmptyAddPatients =>
      'Agrega pacientes para comenzar a gestionar su cuidado';

  @override
  String get caregiverPatientsAddFirstComingSoon =>
      'Agregar primer paciente - ¡Próximamente!';

  @override
  String get caregiverPatientsAddPatientButton => 'Agregar paciente';

  @override
  String get caregiverPatientsLoadFailed =>
      'No se pudieron cargar los pacientes';

  @override
  String get caregiverPatientsAddNewComingSoon =>
      'Agregar nuevo paciente - ¡Próximamente!';

  @override
  String caregiverPatientsRelationshipAge(Object age, Object relationship) {
    return '$relationship • Edad $age';
  }

  @override
  String get caregiverPatientsStatAdherence => 'Adherencia';

  @override
  String get caregiverPatientsStatAppointments => 'Citas';

  @override
  String get caregiverPatientsStatLastVisit => 'Última visita';

  @override
  String caregiverPatientsViewAlerts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ver # alertas',
      one: 'Ver # alerta',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsViewAppointments(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# citas',
      one: '# cita',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsViewAlertsComingSoon(Object name) {
    return 'Ver alertas de $name - ¡Próximamente!';
  }

  @override
  String caregiverPatientsViewAppointmentsComingSoon(Object name) {
    return 'Ver citas de $name - ¡Próximamente!';
  }

  @override
  String get caregiverPatientsLastVisitToday => 'Hoy';

  @override
  String get caregiverPatientsLastVisitYesterday => 'Ayer';

  @override
  String caregiverPatientsLastVisitDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace # días',
      one: 'hace # día',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsLastVisitWeeks(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace # semanas',
      one: 'hace # semana',
    );
    return '$_temp0';
  }

  @override
  String caregiverPatientsLastVisitMonths(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace # meses',
      one: 'hace # mes',
    );
    return '$_temp0';
  }

  @override
  String get caregiverPatientOverviewTitle => 'Resumen del paciente';

  @override
  String get caregiverPatientOverviewTabVisits => 'Visitas';

  @override
  String get caregiverPatientOverviewTabReminders => 'Recordatorios';

  @override
  String get caregiverPatientOverviewTabNotes => 'Notas';

  @override
  String get caregiverPatientOverviewNoVisits => 'No hay visitas disponibles';

  @override
  String get caregiverPatientOverviewNoReminders =>
      'No hay recordatorios disponibles';

  @override
  String get caregiverPatientOverviewNoNotes => 'No hay notas disponibles';

  @override
  String get caregiverPatientOverviewEditComingSoon =>
      'Editar paciente - ¡Próximamente!';

  @override
  String get caregiverPatientOverviewCallPatient => 'Llamar al paciente';

  @override
  String get caregiverPatientOverviewSendMessage => 'Enviar mensaje';

  @override
  String get caregiverPatientOverviewEmergencyContact =>
      'Contacto de emergencia';

  @override
  String get caregiverPatientOverviewSharePatientInfo =>
      'Compartir información del paciente';

  @override
  String get caregiverPatientOverviewScheduleAppointment =>
      'Programar nueva cita - ¡Próximamente!';

  @override
  String get caregiverPatientOverviewAddReminder =>
      'Agregar nuevo recordatorio - ¡Próximamente!';

  @override
  String get caregiverPatientOverviewAddNote =>
      'Agregar nueva nota - ¡Próximamente!';

  @override
  String caregiverPatientOverviewViewVisitDetails(Object type) {
    return 'Ver detalles de $type - ¡Próximamente!';
  }

  @override
  String caregiverPatientOverviewViewReminderDetails(Object title) {
    return 'Ver detalles de $title - ¡Próximamente!';
  }

  @override
  String caregiverPatientOverviewViewNoteDetails(Object title) {
    return 'Ver detalles de $title - ¡Próximamente!';
  }

  @override
  String get caregiverPatientOverviewMissingPatientId => 'Falta patientId';

  @override
  String get caregiverPatientOverviewOverdue => 'Atrasado';

  @override
  String caregiverPatientOverviewInHours(Object hours) {
    return 'En $hours horas';
  }

  @override
  String get caregiverPatientOverviewDefaultRelationship => 'Equipo de cuidado';

  @override
  String get caregiverPatientOverviewDefaultCondition => 'Acceso autorizado';

  @override
  String get caregiverAlertsTitle => 'Alertas';

  @override
  String get caregiverAlertsFilterAll => 'Todas';

  @override
  String get caregiverAlertsFilterUnread => 'No leídas';

  @override
  String get caregiverAlertsFilterRead => 'Leídas';

  @override
  String get caregiverAlertsFilterHighPriority => 'Alta prioridad';

  @override
  String get caregiverAlertsFilterActionRequired => 'Acción requerida';

  @override
  String get caregiverAlertsClearFilter => 'Quitar filtro';

  @override
  String caregiverAlertsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# alertas',
      one: '# alerta',
    );
    return '$_temp0';
  }

  @override
  String get caregiverAlertsMarkAllReadTooltip => 'Marcar todas como leídas';

  @override
  String get caregiverAlertsActionRequired => 'Acción requerida';

  @override
  String get caregiverAlertsMarkRead => 'Marcar como leída';

  @override
  String get caregiverAlertsTakeAction => 'Tomar acción';

  @override
  String get caregiverAlertsEmptyAllTitle => 'No hay alertas en este momento';

  @override
  String get caregiverAlertsEmptyAllSubtitle =>
      'Todas las actividades de pacientes van sin problemas';

  @override
  String get caregiverAlertsEmptyFilteredTitle =>
      'Ninguna alerta coincide con este filtro';

  @override
  String get caregiverAlertsEmptyFilteredSubtitle =>
      'Prueba ajustar el filtro para ver más alertas';

  @override
  String get caregiverAlertsViewAll => 'Ver todas las alertas';

  @override
  String get caregiverAlertsMarkedRead => 'Alerta marcada como leída';

  @override
  String get caregiverAlertsMarkedUnread => 'Alerta marcada como no leída';

  @override
  String get caregiverAlertsAllAlreadyRead =>
      'Todas las alertas ya están leídas';

  @override
  String caregiverAlertsMarkedAllRead(Object count) {
    return 'Marcadas $count alertas como leídas';
  }

  @override
  String caregiverAlertsTakingAction(Object type) {
    return 'Tomando acción sobre la alerta de $type';
  }

  @override
  String caregiverAlertsViewDetails(Object type) {
    return 'Ver detalles de la alerta de $type';
  }

  @override
  String get caregiverInvitationsTitle => 'Invitaciones de cuidador';

  @override
  String get caregiverInvitationsRetry => 'Reintentar';

  @override
  String get caregiverInvitationsEmpty => 'No hay invitaciones pendientes';

  @override
  String caregiverInvitationsRole(Object role) {
    return 'Rol: $role';
  }

  @override
  String caregiverInvitationsPermission(Object permission) {
    return 'Permiso: $permission';
  }

  @override
  String get caregiverInvitationsAccept => 'Aceptar';

  @override
  String get caregiverInvitationsMissingToken => 'Falta el token de invitación';

  @override
  String get caregiverInvitationsAccepted => 'Invitación aceptada';

  @override
  String get caregiverInvitationsPatientFallback => 'Paciente';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get overviewTitle => 'Resumen';

  @override
  String get overviewSearchHint => 'Buscar resúmenes...';

  @override
  String get overviewTabSummaries => 'RESÚMENES';

  @override
  String get overviewTabLabResults => 'RESULTADOS DE LAB';

  @override
  String get overviewTabScannedDocs => 'DOCS ESCANEADOS';

  @override
  String get overviewNewSummaryTitle => '🎉 ¡Tu resumen de visita está listo!';

  @override
  String get overviewNewSummaryPrompt => '¿Quieres verlo ahora?';

  @override
  String get overviewNewSummaryLater => 'Más tarde';

  @override
  String get overviewNewSummaryView => 'Ver resumen';

  @override
  String get overviewSelectAtLeastOne => 'Selecciona al menos un resumen';

  @override
  String get overviewDeleteSummaryTitleSingular => '¿Eliminar resumen?';

  @override
  String get overviewDeleteSummaryTitlePlural => '¿Eliminar resúmenes?';

  @override
  String get overviewDeleteSummaryConfirmSingular =>
      '¿Seguro que quieres eliminar este resumen? Esto no se puede deshacer.';

  @override
  String overviewDeleteSummaryConfirmPlural(Object count) {
    return '¿Seguro que quieres eliminar $count resúmenes? Esto no se puede deshacer.';
  }

  @override
  String get overviewAuthError =>
      'Error de autenticación. Inicia sesión de nuevo.';

  @override
  String overviewDeleteSuccess(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# resúmenes',
      one: '# resumen',
    );
    return 'Se eliminaron correctamente $_temp0';
  }

  @override
  String get overviewDeleteFailed =>
      'No se pudieron eliminar los resúmenes. Inténtalo de nuevo.';

  @override
  String get overviewNoCaregiver => 'Aún no hay cuidador agregado';

  @override
  String get overviewShareTitleShare => '¿Compartir resumen?';

  @override
  String get overviewShareTitleStop => '¿Dejar de compartir?';

  @override
  String get overviewShareConfirmShare =>
      'Estás a punto de compartir este resumen con tus cuidadores. Podrán ver este resumen de visita.';

  @override
  String get overviewShareConfirmStop =>
      'Los cuidadores ya no podrán ver este resumen.';

  @override
  String get overviewShareAction => 'Compartir';

  @override
  String get overviewStopShareAction => 'Dejar de compartir';

  @override
  String get overviewSharingEnabled => 'Compartir con cuidador habilitado';

  @override
  String get overviewSharingDisabled => 'Compartir con cuidador deshabilitado';

  @override
  String get overviewSummariesLoadFailed =>
      'No se pudieron cargar los resúmenes';

  @override
  String get overviewNoSummariesTitle => 'Aún no hay resúmenes';

  @override
  String get overviewNoSummariesSubtitle =>
      'Tus resúmenes de visitas aparecerán aquí';

  @override
  String get overviewProcessingTitle =>
      '🕒 Tu visita más reciente se está procesando';

  @override
  String get overviewProcessingSubtitle => 'Te avisaremos cuando esté listo.';

  @override
  String get overviewLabResultsComingSoon =>
      'Resultados de laboratorio - ¡Próximamente!';

  @override
  String get overviewScannedDocsComingSoon =>
      'Documentos escaneados - ¡Próximamente!';

  @override
  String get overviewShareLabel => 'Compartir';

  @override
  String get overviewDoctorVisit => 'Visita médica';

  @override
  String overviewDoctorPrefix(Object name) {
    return 'Dr. $name';
  }

  @override
  String overviewMinutesAgo(Object count) {
    return 'hace $count min';
  }

  @override
  String overviewTodayAt(Object time) {
    return 'Hoy, $time';
  }

  @override
  String overviewYesterdayAt(Object time) {
    return 'Ayer, $time';
  }

  @override
  String get remindersTitle => 'Recordatorios';

  @override
  String get remindersTabAll => 'Todos';

  @override
  String get remindersTabToday => 'Hoy';

  @override
  String get remindersTabPending => 'Pendientes';

  @override
  String get remindersTabCompleted => 'Completados';

  @override
  String get remindersSearchHint => 'Buscar recordatorios...';

  @override
  String get remindersDeleteTitle => 'Eliminar recordatorio';

  @override
  String get remindersDeleteConfirm =>
      '¿Seguro que quieres eliminar este recordatorio?';

  @override
  String get remindersMarkDone => 'Marcar como hecho';

  @override
  String get remindersSnooze => 'Posponer';

  @override
  String get remindersCreateButton => 'Crear recordatorio';

  @override
  String get remindersCreateComingSoon =>
      'Crear nuevo recordatorio - ¡Próximamente!';

  @override
  String remindersEditComingSoon(Object title) {
    return 'Editar $title - ¡Próximamente!';
  }

  @override
  String get remindersMarkedCompleted =>
      '¡Recordatorio marcado como completado!';

  @override
  String get remindersSnoozedForHour => 'Recordatorio pospuesto por 1 hora';

  @override
  String get remindersDeleted => 'Recordatorio eliminado';

  @override
  String get remindersEmptyTitle => 'No se encontraron recordatorios';

  @override
  String get remindersEmptySearchTitle =>
      'Ningún recordatorio coincide con tu búsqueda';

  @override
  String get remindersEmptySubtitle =>
      'Crea tu primer recordatorio para comenzar';

  @override
  String get remindersEmptySearchSubtitle =>
      'Prueba ajustando los términos de búsqueda';

  @override
  String remindersSnoozedUntil(Object time) {
    return 'Pospuesto hasta $time';
  }

  @override
  String get remindersStatusDone => 'Hecho';

  @override
  String get remindersStatusPending => 'Pendiente';

  @override
  String get remindersStatusSnoozed => 'Pospuesto';

  @override
  String get remindersStatusUnknown => 'Desconocido';

  @override
  String remindersTimeHoursAgo(Object count) {
    return 'hace $count horas';
  }

  @override
  String remindersTimeMinutesAgo(Object count) {
    return 'hace $count minutos';
  }

  @override
  String remindersTimeInHours(Object count) {
    return 'En $count horas';
  }

  @override
  String remindersTimeInMinutes(Object count) {
    return 'En $count minutos';
  }

  @override
  String get remindersTimeNow => 'Ahora';

  @override
  String get remindersAdherenceTitle => 'Adherencia a medicamentos';

  @override
  String get remindersAdherenceThisWeek => 'Esta semana';

  @override
  String get remindersAdherenceThisMonth => 'Este mes';

  @override
  String get remindersAdherenceOverall => 'General';

  @override
  String get remindersAdherenceByMedication => 'Por medicamento';

  @override
  String get remindersAdherenceTipsTitle => 'Consejos de adherencia';

  @override
  String get remindersAdherenceTipsBody =>
      '• Configura recordatorios en el teléfono para las medicinas\n• Mantén las medicinas en un lugar visible\n• Usa un pastillero para las dosis diarias\n• Lleva un seguimiento para mantener la motivación';

  @override
  String get visitRecordingTitle => 'Grabar visita';

  @override
  String get visitRecordingSave => 'Guardar';

  @override
  String get visitRecordingGenerateSummary => 'Generar resumen';

  @override
  String get visitRecordingDiscardRecording => 'Descartar grabación';

  @override
  String get visitRecordingCompleted => '¡Grabación completada!';

  @override
  String get visitRecordingSaveFailed => 'No se pudo guardar la grabación';

  @override
  String get visitRecordingDiscarded => 'Grabación descartada';

  @override
  String get visitRecordingNoRecording => 'No hay grabación disponible';

  @override
  String get visitRecordingUploadingAudio => 'Subiendo audio...';

  @override
  String get visitRecordingProcessingTitle => '✅ Tu visita se está procesando';

  @override
  String get visitRecordingGoToHome => 'Ir a inicio';

  @override
  String visitRecordingUploadFailed(Object error) {
    return 'No se pudo subir el audio: $error';
  }

  @override
  String get visitRecordingStopTitle => '¿Detener grabación?';

  @override
  String get visitRecordingContinue => 'Continuar grabación';

  @override
  String get visitRecordingStopAndDiscard => 'Detener y descartar';

  @override
  String get visitRecordingAudioPermissionTitle => 'Grabación de audio';

  @override
  String get visitRecordingNotNow => 'Ahora no';

  @override
  String get visitRecordingYesRecord => 'Sí, grabar';

  @override
  String get visitRecordingStatusReady => 'Listo para grabar';

  @override
  String get visitRecordingStatusRecording => 'Grabando...';

  @override
  String get visitRecordingStatusComplete => 'Grabación completa';

  @override
  String get visitRecordingInstructionIdle =>
      'Toca para iniciar la grabación de tu visita\nTu grabación se mantiene privada y segura';

  @override
  String get visitRecordingInstructionRecording => 'Grabación en progreso...';

  @override
  String get visitRecordingInstructionComplete =>
      '¡Grabación completa!\nToca Generar para procesar el resumen de tu visita';

  @override
  String get visitRecordingMicPermission =>
      'Se requiere permiso del micrófono. Actívalo en Configuración > RemiMinder > Micrófono.';

  @override
  String get visitRecordingProcessingBody =>
      'Esto puede tardar ~30–60 segundos.\nPuedes seguir usando la app. Te avisaremos cuando esté listo.';

  @override
  String get visitRecordingStopConfirm =>
      '¿Seguro que quieres detener la grabación? Esta acción no se puede deshacer.';

  @override
  String get visitRecordingAudioConsentBody =>
      'La grabación ayuda a crear notas, resúmenes y recordatorios de la visita.\n\n• El audio se graba solo cuando tocas Grabar\n• Las grabaciones se procesan de forma segura y se eliminan del teléfono\n• Puedes detener la grabación en cualquier momento\n\n¿Deseas continuar?';

  @override
  String get visitDetailsTitle => 'Detalles de la visita';

  @override
  String get visitDetailsSummaryCardTitle => 'Resumen de visita de salud';

  @override
  String get visitDetailsRefreshTooltip => 'Actualizar resumen';

  @override
  String get visitDetailsProcessingTitle =>
      'Preparando resumen de la visita...';

  @override
  String get visitDetailsProcessingSubtitle => 'Esto puede tardar un minuto.';

  @override
  String get visitDetailsLoadFailed =>
      'No se pudo cargar el resumen de la visita';

  @override
  String get visitDetailsRetry => 'Reintentar';

  @override
  String get visitDetailsUnavailable =>
      'El resumen de la visita no está disponible';

  @override
  String get visitDetailsSummarySection => 'Resumen de la visita';

  @override
  String get visitDetailsDecisionsSection => 'Decisiones clínicas';

  @override
  String get visitDetailsMedicationsSection => 'Medicamentos';

  @override
  String get visitDetailsActionsSection => 'Próximos pasos';

  @override
  String get historyTitle => 'Historial';

  @override
  String get historySearchHint => 'Buscar eventos, documentos, visitas...';

  @override
  String get historyTabAll => 'TODO';

  @override
  String get historyTabScannedDocs => 'DOCS ESCANEADOS';

  @override
  String get historyTabLabResults => 'RESULTADOS DE LAB';

  @override
  String get historyLoadFailed => 'No se pudo cargar el historial';

  @override
  String get historyRetry => 'Reintentar';

  @override
  String get historyVisitSummaryFallback => 'Resumen de visita';

  @override
  String get historyNoSummary => 'No hay resumen disponible';

  @override
  String get historyUnknownDate => 'Fecha desconocida';

  @override
  String get historyUnknownTime => 'Hora desconocida';

  @override
  String get historyNoScannedDocs => 'Aún no hay documentos escaneados';

  @override
  String get historyNoScannedDocsSubtitle =>
      'Las recetas y documentos escaneados aparecerán aquí';

  @override
  String get historyNoLabResults => 'Aún no hay resultados de laboratorio';

  @override
  String get historyNoLabResultsSubtitle =>
      'Los resultados de laboratorio y reportes aparecerán aquí';

  @override
  String historyNoEventsSearch(Object query) {
    return 'No se encontraron eventos para \"$query\"';
  }

  @override
  String get historyNoEvents => 'Aún no hay eventos';

  @override
  String get historyDocumentViewerSoon =>
      'Visor de documentos - ¡Próximamente!';

  @override
  String get historyFeatureSoon => 'Función - ¡Próximamente!';

  @override
  String get notificationSettingsTitle => 'Notificaciones';

  @override
  String get notificationSectionTypes => 'Tipos de notificación';

  @override
  String get notificationMedicationTitle => 'Recordatorios de medicación';

  @override
  String get notificationMedicationSubtitle =>
      'Recibe avisos cuando sea hora de tomar tus medicamentos';

  @override
  String get notificationAppointmentTitle => 'Recordatorios de citas';

  @override
  String get notificationAppointmentSubtitle =>
      'Recordatorios de próximas visitas y pruebas';

  @override
  String get notificationHealthTipsTitle => 'Consejos de salud';

  @override
  String get notificationHealthTipsSubtitle =>
      'Consejos diarios para manejar tus condiciones de salud';

  @override
  String get notificationCaregiverUpdatesTitle =>
      'Actualizaciones del cuidador';

  @override
  String get notificationCaregiverUpdatesSubtitle =>
      'Notificaciones cuando los cuidadores vean tu información';

  @override
  String get notificationEmergencyAlertsTitle => 'Alertas de emergencia';

  @override
  String get notificationEmergencyAlertsSubtitle =>
      'Alertas críticas y notificaciones de emergencia';

  @override
  String get notificationDailySummaryTitle => 'Resumen diario';

  @override
  String get notificationDailySummarySubtitle =>
      'Resumen nocturno de tus actividades de salud';

  @override
  String get notificationSectionTiming => 'Preferencias de horario';

  @override
  String get notificationMorningReminder => 'Hora del recordatorio matutino';

  @override
  String get notificationEveningReminder => 'Hora del recordatorio nocturno';

  @override
  String get notificationAdvanceTime => 'Anticipación del recordatorio';

  @override
  String get notificationAdvance5Min => '5 min';

  @override
  String get notificationAdvance10Min => '10 min';

  @override
  String get notificationAdvance15Min => '15 min';

  @override
  String get notificationAdvance30Min => '30 min';

  @override
  String get notificationAdvance60Min => '1 hora';

  @override
  String get notificationSectionSound => 'Sonido y alertas';

  @override
  String get notificationSoundTitle => 'Notificaciones de sonido';

  @override
  String get notificationVibrationTitle => 'Vibración';

  @override
  String get notificationVolumeTitle => 'Nivel de volumen';

  @override
  String get notificationSectionTest => 'Notificaciones de prueba';

  @override
  String get notificationSendTest => 'Enviar notificación de prueba';

  @override
  String get notificationTestSent => '¡Notificación de prueba enviada!';

  @override
  String get languageSettingsChooseApp => 'Elegir idioma de la app';

  @override
  String get languageSettingsChooseVisit => 'Elegir idioma de la visita';

  @override
  String get languageSettingsAppLabel => 'Idioma de la app';

  @override
  String get languageSettingsVisitLabel => 'Idioma de la visita';

  @override
  String get languageSettingsSave => 'Guardar configuración';

  @override
  String get languageSettingsInfo =>
      'Cambiar el idioma de la visita afecta el reconocimiento de voz y los resúmenes con IA.';

  @override
  String get languageSettingsLoadFailed =>
      'No se pudieron cargar las preferencias de idioma';

  @override
  String get languageSettingsSaveSuccess => 'Configuración de idioma guardada';

  @override
  String get languageSettingsSaveFailed =>
      'No se pudo guardar la configuración de idioma';

  @override
  String get changePasswordTitle => 'Cambiar contraseña';

  @override
  String get changePasswordSubtitle =>
      'Actualiza tu contraseña para mantener tu cuenta segura.';

  @override
  String get changePasswordCurrentLabel => 'Contraseña actual';

  @override
  String get changePasswordCurrentHint => 'Ingresa tu contraseña actual';

  @override
  String get changePasswordNewLabel => 'Nueva contraseña';

  @override
  String get changePasswordNewHint => 'Ingresa tu nueva contraseña';

  @override
  String get changePasswordConfirmLabel => 'Confirmar nueva contraseña';

  @override
  String get changePasswordConfirmHint =>
      'Vuelve a ingresar tu nueva contraseña';

  @override
  String get changePasswordUpdateButton => 'Actualizar contraseña';

  @override
  String get changePasswordCurrentRequired => 'Ingresa tu contraseña actual';

  @override
  String get changePasswordNewRequired => 'Ingresa una nueva contraseña';

  @override
  String get changePasswordTooShort =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get changePasswordConfirmRequired => 'Confirma tu nueva contraseña';

  @override
  String get changePasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get changePasswordSuccess => 'Contraseña actualizada correctamente';

  @override
  String get changePasswordNotAuthenticated => 'Usuario no autenticado';

  @override
  String get changePasswordFailed => 'No se pudo actualizar la contraseña';

  @override
  String get changePasswordWrongPassword =>
      'La contraseña actual es incorrecta';

  @override
  String get changePasswordWeakPassword => 'La contraseña es muy débil';

  @override
  String get changePasswordRecentLogin =>
      'Inicia sesión nuevamente e inténtalo';

  @override
  String get changePasswordCheckConnection => 'Verifica tu conexión a internet';

  @override
  String get accountSecurityTitle => 'Seguridad de la cuenta';

  @override
  String get accountSecurityChangePasswordTitle => 'Cambiar contraseña';

  @override
  String get accountSecurityChangePasswordSubtitle =>
      'Actualiza tu contraseña para mayor seguridad';

  @override
  String get accountSecurityChangePasswordButton => 'Cambiar contraseña';

  @override
  String get accountSecurityPrivacyTitle => 'Configuración de privacidad';

  @override
  String get accountSecurityPrivacySubtitle =>
      'Administra tus preferencias de uso de datos';

  @override
  String get accountSecurityPrivacyButton => 'Administrar privacidad';

  @override
  String get accountSecurityDialogTitle => 'Cambiar contraseña';

  @override
  String accountSecurityDialogBody(Object provider) {
    return 'Iniciaste sesión con $provider. Cambia tu contraseña en tu cuenta de $provider.';
  }

  @override
  String get accountSecurityDialogOk => 'OK';

  @override
  String get profileAccountDetailsTitle => 'Detalles de la cuenta';

  @override
  String get profileAccountDetailsSubtitle => 'Ver tu información de perfil';

  @override
  String get profileAccountSecurityTitle => 'Seguridad de la cuenta';

  @override
  String get profileAccountSecuritySubtitle =>
      'Gestiona contraseña y privacidad';

  @override
  String get profileAppLanguageLabel => 'Idioma de la app';

  @override
  String get profilePreferredSummaryLanguageLabel =>
      'Idioma preferido del resumen';

  @override
  String get profileDefaultVisitLanguageLabel =>
      'Idioma predeterminado de la visita';

  @override
  String get profileTimezoneLabel => 'Zona horaria';

  @override
  String get profileCountryOptionalLabel => 'País (opcional)';

  @override
  String get profileCountryOrRegionLabel => 'País o región';

  @override
  String get profileNotificationsTitle => 'Notificaciones';

  @override
  String get profileNotificationsMobile => 'Móvil';

  @override
  String get profileNotificationsEmail => 'Correo';

  @override
  String get profileUpgrade => 'Mejorar';

  @override
  String get profileSignOut => 'Cerrar sesión';

  @override
  String get profileNotSet => 'No establecido';

  @override
  String profileSignOutFailed(Object error) {
    return 'Error al cerrar sesión: $error';
  }

  @override
  String get upgradeBenefitsTitle => 'Beneficios de mejora';

  @override
  String get upgradeUnlockTitle => 'Desbloquea atención premium';

  @override
  String get upgradeSubtitle => 'Más tranquilidad.';

  @override
  String get upgradeBenefitUnlimitedCaregivers => 'Cuidadores ilimitados';

  @override
  String get upgradeBenefitHealthTrends => 'Tendencias de salud avanzadas';

  @override
  String get upgradeBenefitPrioritySupport => 'Soporte prioritario';

  @override
  String get upgradeMonthlyPlan => 'Plan mensual';

  @override
  String get upgradeAnnualPlan => 'Plan anual';

  @override
  String get upgradePerMonth => '/ mes';

  @override
  String get upgradePerYear => '/ año';

  @override
  String get upgradeCancelAnytime => 'Cancela en cualquier momento';

  @override
  String get upgradeContinuePayment => 'Continuar al pago';

  @override
  String get upgradePaymentComingSoon => 'Flujo de pago próximamente';

  @override
  String get caregiversTitle => 'Cuidadores';

  @override
  String get caregiversMyCaregivers => 'Mis cuidadores';

  @override
  String get caregiversEmptyTitle => 'Aún no hay cuidadores';

  @override
  String get caregiversEmptySubtitle =>
      'Invita familiares o amigos\npara ayudar a gestionar tu salud';

  @override
  String get caregiversInviteFirst => 'Invitar primer cuidador';

  @override
  String get caregiversLoadFailed => 'No se pudieron cargar los cuidadores';

  @override
  String get caregiversResendInvite => 'Reenviar invitación';

  @override
  String get caregiversCancel => 'Cancelar';

  @override
  String get caregiversActiveLabel => 'Cuidador activo';

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
    return 'Última actividad: $time';
  }

  @override
  String get caregiversStatusActive => 'Activo';

  @override
  String get caregiversStatusPending => 'Pendiente';

  @override
  String get caregiversStatusDeclined => 'Rechazada';

  @override
  String get caregiversStatusUnknown => 'Desconocido';

  @override
  String get caregiversInviteTitle => 'Invitar cuidador';

  @override
  String get caregiversFullNameLabel => 'Nombre completo';

  @override
  String get caregiversFullNameHint =>
      'Ingresa el nombre completo del cuidador';

  @override
  String get caregiversFullNameRequired => 'Ingresa un nombre';

  @override
  String get caregiversEmailLabel => 'Correo electrónico';

  @override
  String get caregiversEmailHint => 'cuidador@ejemplo.com';

  @override
  String get caregiversEmailRequired => 'Ingresa un correo';

  @override
  String get caregiversEmailInvalid => 'Ingresa un correo válido';

  @override
  String get caregiversRelationshipLabel => 'Relación';

  @override
  String get caregiversSendInvitation => 'Enviar invitación';

  @override
  String caregiversInvitationSent(Object email) {
    return 'Invitación enviada a $email';
  }

  @override
  String caregiversInvitationResent(Object email) {
    return 'Invitación reenviada a $email';
  }

  @override
  String get caregiversCancelInvitationTitle => 'Cancelar invitación';

  @override
  String get caregiversCancelInvitationConfirm =>
      '¿Seguro que quieres cancelar esta invitación?';

  @override
  String get caregiversKeep => 'Mantener';

  @override
  String get caregiversCancelInvitationAction => 'Cancelar invitación';

  @override
  String get caregiversDone => 'Listo';

  @override
  String get caregiversAccessRemoved => 'Acceso eliminado';

  @override
  String caregiversPermissionTitle(Object name) {
    return 'Permisos de $name';
  }

  @override
  String get caregiversPermissionViewMedications => 'Ver medicaciones';

  @override
  String get caregiversPermissionViewMedicationsDesc =>
      'Puede ver horarios e historial de medicación';

  @override
  String get caregiversPermissionViewVisits => 'Ver registros de visitas';

  @override
  String get caregiversPermissionViewVisitsDesc =>
      'Puede acceder a resúmenes y transcripciones';

  @override
  String get caregiversPermissionViewHealthData => 'Ver datos de salud';

  @override
  String get caregiversPermissionViewHealthDataDesc =>
      'Puede ver métricas y tendencias de salud';

  @override
  String get caregiversPermissionEditMedications => 'Editar medicaciones';

  @override
  String get caregiversPermissionEditMedicationsDesc =>
      'Puede modificar horarios de medicación';

  @override
  String get caregiversPermissionManageEmergency =>
      'Gestionar contactos de emergencia';

  @override
  String get caregiversPermissionManageEmergencyDesc =>
      'Puede modificar contactos de emergencia';

  @override
  String get caregiversPermissionReceiveAlerts => 'Recibir alertas';

  @override
  String get caregiversPermissionReceiveAlertsDesc =>
      'Recibe notificaciones de eventos importantes';

  @override
  String get caregiversRelationshipFamily => 'Familiar';

  @override
  String get caregiversRelationshipFriend => 'Amigo';

  @override
  String get caregiversRelationshipSpouse => 'Cónyuge/Pareja';

  @override
  String get caregiversRelationshipParent => 'Padre/Madre';

  @override
  String get caregiversRelationshipChild => 'Hijo/a';

  @override
  String get caregiversRelationshipHealthcare => 'Profesional de la salud';

  @override
  String get caregiversRelationshipCaregiver => 'Cuidador';

  @override
  String get caregiversRelationshipOther => 'Otro';

  @override
  String caregiversLastActiveDays(Object count) {
    return 'hace ${count}d';
  }

  @override
  String caregiversLastActiveHours(Object count) {
    return 'hace ${count}h';
  }

  @override
  String caregiversLastActiveMinutes(Object count) {
    return 'hace ${count}m';
  }

  @override
  String get caregiversLastActiveJustNow => 'Justo ahora';

  @override
  String commonComingSoon(Object feature) {
    return '$feature próximamente';
  }

  @override
  String get privacyTitle => 'Configuración de privacidad';

  @override
  String get privacyDataSharing => 'Compartir datos';

  @override
  String get privacyNoCaregiver => 'Aún no se ha añadido ningún cuidador';

  @override
  String get privacyAllowCaregiverSummaries =>
      'Permitir al cuidador ver resúmenes';

  @override
  String get privacyAllowCaregiverMedications =>
      'Permitir al cuidador ver medicamentos';

  @override
  String get privacyAllowCaregiverReminders =>
      'Permitir al cuidador ver recordatorios';

  @override
  String get privacyAllowAiImprove =>
      'Permitir a la IA usar mis datos para mejorar el producto';

  @override
  String get privacyCaregiverSharingEnabled =>
      'Compartir con cuidador habilitado';

  @override
  String get privacyCaregiverSharingDisabled =>
      'Compartir con cuidador deshabilitado';

  @override
  String get privacyCommunicationConsent => 'Comunicación y consentimiento';

  @override
  String get privacyAllowEmailNotifications =>
      'Permitir notificaciones por correo electrónico';

  @override
  String get privacyAllowSmsNotifications => 'Permitir notificaciones por SMS';

  @override
  String get privacyAllowPushNotifications => 'Permitir notificaciones push';

  @override
  String get privacyDataControl => 'Control de datos';

  @override
  String get privacyExportData => 'Exportar mis datos';

  @override
  String get privacyDataExportLabel => 'Exportación de datos';

  @override
  String get privacyDeleteRecords => 'Eliminar todos mis registros médicos';

  @override
  String get privacyDeleteRecordsTitle => 'Eliminar registros médicos';

  @override
  String get privacyDeleteRecordsBody =>
      'Esto eliminará permanentemente todos tus registros médicos. Esta acción no se puede deshacer.';

  @override
  String get privacyDeleteRecordsAction => 'Eliminar registros';

  @override
  String get privacyDeleteAccount => 'Eliminar mi cuenta';

  @override
  String get privacyDeleteAccountTitle => 'Eliminar cuenta';

  @override
  String get privacyDeleteAccountBody =>
      'Esto eliminará permanentemente tu cuenta y todos los datos asociados. Esta acción no se puede deshacer.';

  @override
  String get privacyDeleteAccountAction => 'Eliminar cuenta';

  @override
  String get privacyLegal => 'Legal';

  @override
  String get privacyViewPolicy => 'Ver política de privacidad';

  @override
  String get privacyViewTerms => 'Ver términos de servicio';

  @override
  String get privacyTermsTitle => 'Términos de servicio';

  @override
  String get privacyTermsBody =>
      'Términos de servicio para RemiMinder\n\n1. Aceptación de los Términos\nAl usar RemiMinder, aceptas estos términos.\n\n2. Uso del Servicio\nRemiMinder está diseñado para ayudar a gestionar la atención médica y los recordatorios de medicación.\n\n3. Privacidad\nTu privacidad es importante para nosotros. Todos los datos de salud se manejan de forma segura.\n\nPara consultar los Términos de servicio completos, visita nuestro sitio web.';

  @override
  String get privacyPolicyTitle => 'Política de privacidad';

  @override
  String get privacyPolicyBody =>
      'Política de privacidad para RemiMinder\n\n1. Información que recopilamos\nRecopilamos la información que proporcionas y los datos de uso para mejorar nuestro servicio.\n\n2. Cómo usamos la información\nLa información se utiliza para proporcionar servicios de gestión de atención médica.\n\n3. Compartir información\nNo vendemos tu información personal.\n\nPara consultar la Política de privacidad completa, visita nuestro sitio web.';

  @override
  String get healthDashboardTitle => 'Panel de salud';

  @override
  String get healthDashboardLast7Days => 'Últimos 7 días';

  @override
  String get healthDashboardLast30Days => 'Últimos 30 días';

  @override
  String get healthDashboardLast90Days => 'Últimos 90 días';

  @override
  String get healthDashboardBloodPressure => 'Presión arterial';

  @override
  String get healthDashboardWeightTrend => 'Tendencia de peso';

  @override
  String get healthDashboardMedicationAdherence => 'Adherencia a la medicación';

  @override
  String get healthDashboardKeyMetrics => 'Métricas clave';

  @override
  String get healthDashboardUnitMmhg => 'mmHg';

  @override
  String get healthDashboardBpTrend => '+2 pts esta semana';

  @override
  String get healthDashboardWeight => 'Peso';

  @override
  String get healthDashboardUnitLbs => 'libras';

  @override
  String get healthDashboardWeightTrendText => '-1.4 libras esta semana';

  @override
  String get healthDashboardMedAdherence => 'Adherencia a la medicación';

  @override
  String get healthDashboardThisWeek => 'esta semana';

  @override
  String get healthDashboardGoodProgress => 'Buen progreso';

  @override
  String get healthDashboardHeartRate => 'Frecuencia cardíaca';

  @override
  String get healthDashboardUnitBpm => 'ppm';

  @override
  String get healthDashboardRestingAverage => 'Promedio en reposo';

  @override
  String get healthDashboardInsightsTitle => 'Información de salud';

  @override
  String get healthDashboardInsightBpTitle =>
      'Tendencia de la presión arterial';

  @override
  String get healthDashboardInsightBpBody =>
      'Tu presión sistólica se ha mantenido estable con una ligera tendencia a la baja. ¡Sigue así!';

  @override
  String get healthDashboardInsightWeightTitle => 'Control de peso';

  @override
  String get healthDashboardInsightWeightBody =>
      'Pérdida de peso constante de 1.4 libras esta semana. ¡Estás en camino de alcanzar tu objetivo!';

  @override
  String get healthDashboardInsightAdherenceTitle =>
      'Adherencia a la medicación';

  @override
  String get healthDashboardInsightAdherenceBody =>
      '86% de adherencia esta semana. Considera establecer recordatorios de medicación para alcanzar el 100%.';

  @override
  String get healthDashboardInsightCheckupTitle => 'Próximo chequeo';

  @override
  String get healthDashboardInsightCheckupBody =>
      'Tu próxima cita de cardiología vence en 3 meses. Prográmala pronto.';

  @override
  String get healthDashboardRecentMeasurements => 'Mediciones recientes';

  @override
  String get healthDashboardRecentBpValue => '126/81 mmHg';

  @override
  String get healthDashboardRecentBpTime => 'Hoy, 8:30 AM';

  @override
  String get healthDashboardRecentWeightValue => '163.8 libras';

  @override
  String get healthDashboardRecentWeightTime => 'Hoy, 7:45 AM';

  @override
  String get healthDashboardRecentHeartRateValue => '72 ppm';

  @override
  String get healthDashboardRecentHeartRateTime => 'Ayer, 8:15 AM';

  @override
  String get healthDashboardAddMeasurement => 'Añadir medición';

  @override
  String get healthDashboardAddMeasurementSoon =>
      'Añadir nueva medición - ¡Próximamente!';

  @override
  String get emergencyContactsTitle => 'Contactos de emergencia';

  @override
  String get emergencySosLabel => 'SOS DE EMERGENCIA';

  @override
  String get emergencySosSubtitle =>
      'Llamar a todos los contactos de emergencia';

  @override
  String get emergencyMedicalAlertTitle => 'Información de alerta médica';

  @override
  String get emergencyMedicalAlertBody =>
      'Paciente cardíaco, alérgico a la penicilina, toma medicamentos diarios';

  @override
  String get emergencySosDialogTitle => 'SOS de emergencia';

  @override
  String get emergencySosDialogBody =>
      'Esto llamará a TODOS los contactos de emergencia simultáneamente. ¿Estás seguro?';

  @override
  String get emergencySosDialogNote =>
      'Los contactos de emergencia se llamarán en orden de prioridad';

  @override
  String get emergencySosDialogAction => 'Llamar a contactos de emergencia';

  @override
  String get emergencySosActivated =>
      '¡SOS de emergencia activado! Llamando a todos los contactos...';

  @override
  String emergencyCallingContact(Object name) {
    return 'Llamando a $name...';
  }

  @override
  String get emergencyAddContactTitle => 'Añadir contacto de emergencia';

  @override
  String get emergencyContactFullNameLabel => 'Nombre completo';

  @override
  String get emergencyContactFullNameHint => 'Introduce el nombre del contacto';

  @override
  String get emergencyContactPhoneLabel => 'Número de teléfono';

  @override
  String get emergencyContactPhoneHint => '(555) 123-4567';

  @override
  String get emergencyContactTypeLabel => 'Tipo de contacto';

  @override
  String get emergencyContactRelationshipLabel => 'Relación';

  @override
  String get emergencyContactRelationshipHint => 'Cónyuge, hijo, padre, etc.';

  @override
  String get emergencyAddContactAction => 'Añadir contacto';

  @override
  String emergencyEditContactComingSoon(Object name) {
    return 'Editar $name - ¡Próximamente!';
  }

  @override
  String get emergencyDeleteContactTitle => 'Eliminar contacto';

  @override
  String emergencyDeleteContactBody(Object name) {
    return '¿Estás seguro de que quieres eliminar a $name de los contactos de emergencia?';
  }

  @override
  String get emergencyContactRemoved => 'Contacto eliminado';

  @override
  String emergencyContactAdded(Object name) {
    return '$name añadido a contactos de emergencia';
  }

  @override
  String get emergencyEditMedicalInfoComingSoon =>
      'Editar información médica - ¡Próximamente!';

  @override
  String get emergencyContactTypeFamily => 'Familia';

  @override
  String get emergencyContactTypeMedical => 'Médico';

  @override
  String get emergencyContactTypeFriend => 'Amigo';

  @override
  String get emergencyContactTypeOther => 'Otro';

  @override
  String get commonEdit => 'Editar';

  @override
  String get careTeamTitle => 'Equipo de atención';

  @override
  String get careTeamSubtitle =>
      'Tienes el control. Revisa tus permisos para compartir a continuación.';

  @override
  String get careTeamEmptyCaregivers => 'Aún no se han añadido cuidadores';

  @override
  String get careTeamActiveCaregivers => 'Cuidadores activos';

  @override
  String get careTeamPendingInvitations => 'Invitaciones pendientes';

  @override
  String get careTeamInviteTitle => 'Invitar cuidador';

  @override
  String get careTeamInviteNameLabel => 'Nombre';

  @override
  String get careTeamInviteNameHint =>
      'Introduce el nombre completo del cuidador';

  @override
  String get careTeamInviteEmailLabel => 'Correo electrónico';

  @override
  String get careTeamInviteEmailHint =>
      'Introduce la dirección de correo electrónico del cuidador';

  @override
  String get careTeamInviteRelationshipLabel => 'Relación';

  @override
  String get careTeamInviteRelationshipHint =>
      'p. ej., Hijo, Hija, Amigo, Enfermero';

  @override
  String get careTeamInviteRequiredFields =>
      'El correo electrónico y el rol son obligatorios';

  @override
  String get careTeamInviteSend => 'Enviar invitación';

  @override
  String get careTeamAccessUpdated => 'Acceso actualizado correctamente';

  @override
  String get careTeamAccessUpdateFailed =>
      'Error al actualizar el acceso. Por favor, inténtalo de nuevo.';

  @override
  String get careTeamRemoveTitle => '¿Eliminar cuidador?';

  @override
  String get careTeamRemoveBody =>
      '¿Estás seguro de que quieres eliminar a este cuidador? Perderá el acceso inmediatamente.';

  @override
  String get careTeamRemoveConfirm => 'Eliminar';

  @override
  String get careTeamRemoving => 'Eliminando cuidador...';

  @override
  String get careTeamRemoveFailed =>
      'Error al eliminar cuidador. Por favor, inténtalo de nuevo.';

  @override
  String get careTeamManageAccessTitle => 'Gestionar acceso';

  @override
  String get careTeamManageAccessSubtitle =>
      'Actualizar permiso de cuidador o eliminar acceso.';

  @override
  String get careTeamUpdatingAccess => 'Actualizando acceso...';

  @override
  String get careTeamAccessView => 'Ver acceso';

  @override
  String get careTeamAccessFull => 'Acceso completo';

  @override
  String get careTeamAccessViewOnly => 'Solo ver';

  @override
  String get careTeamResendingInvite => 'Reenviando invitación...';

  @override
  String get careTeamInviteResent => 'Invitación reenviada';

  @override
  String get careTeamInviteResendFailed => 'Error al reenviar invitación';

  @override
  String get careTeamCancelingInvite => 'Cancelando invitación...';

  @override
  String get careTeamInviteCanceled => 'Invitación cancelada';

  @override
  String get careTeamInviteCancelFailed => 'Error al cancelar invitación';

  @override
  String get careTeamInvitationPending => 'Invitación pendiente';

  @override
  String get careTeamResend => 'Reenviar';

  @override
  String get careTeamManageButton => 'Gestionar';

  @override
  String get careTeamInviteTileTitle => 'Invitar cuidador';

  @override
  String get careTeamInviteTileSubtitle =>
      'Compartir acceso a tu información de salud';

  @override
  String get cameraSave => 'Guardar';

  @override
  String get cameraModeRx => 'Receta';

  @override
  String get cameraModeLab => 'Laboratorio';

  @override
  String get cameraModeMed => 'Medicina';

  @override
  String get cameraTapToCapture => 'Toca para capturar';

  @override
  String get cameraProcessingShort => 'Procesando...';

  @override
  String get cameraProcessingImage => 'Procesando imagen...';

  @override
  String get cameraScanSuccessful => '¡Escaneo exitoso!';

  @override
  String get cameraShare => 'Compartir';

  @override
  String get cameraNotReady =>
      'Cámara no lista. Por favor, inténtalo de nuevo.';

  @override
  String cameraCaptureFailed(Object error) {
    return 'Error al capturar imagen: $error';
  }

  @override
  String get cameraUploadSuccess => '¡Imagen subida correctamente!';

  @override
  String cameraUploadFailed(Object error) {
    return 'Error al subir imagen: $error';
  }

  @override
  String get cameraScanSaved => '¡Escaneo guardado correctamente!';

  @override
  String get cameraShareComingSoon =>
      'Funcionalidad de compartir - ¡Próximamente!';

  @override
  String get cameraPrescriptionScanned => 'Receta escaneada correctamente';

  @override
  String get cameraLabReportProcessed =>
      'Informe de laboratorio procesado correctamente';

  @override
  String get cameraMedicationExtracted => 'Información de medicación extraída';

  @override
  String get cameraConsentTitle => 'Escaneo de documentos';

  @override
  String get cameraConsentBody =>
      'La cámara ayuda a escanear documentos médicos como recetas e informes de laboratorio.\n\n• La cámara se usa solo cuando eliges escanear\n• Las imágenes se procesan de forma segura y se eliminan de tu teléfono\n• Las fotos nunca se guardan en la galería de tu dispositivo\n\n¿Te gustaría continuar?';

  @override
  String get cameraConsentNotNow => 'Ahora no';

  @override
  String get cameraConsentConfirm => 'Sí, escanear';

  @override
  String get cameraSectionPrescriptionDetails => 'Detalles de la receta';

  @override
  String get cameraLabelMedication => 'Medicación';

  @override
  String get cameraValueLisinopril => 'Lisinopril';

  @override
  String get cameraLabelDosage => 'Dosis';

  @override
  String get cameraValue10mg => '10mg';

  @override
  String get cameraLabelFrequency => 'Frecuencia';

  @override
  String get cameraValueOnceDaily => 'Una vez al día';

  @override
  String get cameraLabelQuantity => 'Cantidad';

  @override
  String get cameraValue90Tablets => '90 tabletas';

  @override
  String get cameraLabelRefills => 'Recargas';

  @override
  String get cameraValue3Remaining => '3 restantes';

  @override
  String get cameraSectionPrescriberInfo => 'Información del prescriptor';

  @override
  String get cameraLabelDoctor => 'Doctor';

  @override
  String get cameraValueDrSarahJohnson => 'Dra. Sarah Johnson';

  @override
  String get cameraLabelLicense => 'Licencia';

  @override
  String get cameraValueLicenseId => 'MD123456';

  @override
  String get cameraLabelDate => 'Fecha';

  @override
  String get cameraValueDec122024 => '12 de dic. de 2024';

  @override
  String get cameraSectionPharmacyInfo => 'Información de la farmacia';

  @override
  String get cameraLabelPharmacy => 'Farmacia';

  @override
  String get cameraValueCityMedicalPharmacy => 'Farmacia City Medical';

  @override
  String get cameraLabelPhone => 'Teléfono';

  @override
  String get cameraValuePhoneSample => '(555) 123-4567';

  @override
  String get cameraLabelAddress => 'Dirección';

  @override
  String get cameraValuePharmacyAddress => '123 Main St, Ciudad, ST 12345';

  @override
  String get cameraSectionPatientInfo => 'Información del paciente';

  @override
  String get cameraLabelName => 'Nombre';

  @override
  String get cameraValueJohnDoe => 'John Doe';

  @override
  String get cameraLabelDob => 'Fecha de nacimiento';

  @override
  String get cameraValueDobSample => '15/01/1985';

  @override
  String get cameraLabelId => 'ID';

  @override
  String get cameraValuePatientId => 'P123456789';

  @override
  String get cameraSectionTestResults => 'Resultados de la prueba';

  @override
  String get cameraLabelCholesterolTotal => 'Colesterol (Total)';

  @override
  String get cameraValueCholesterolTotal => '185 mg/dL';

  @override
  String get cameraRefCholesterolTotal => 'Normal: <200';

  @override
  String get cameraLabelHdlCholesterol => 'Colesterol HDL';

  @override
  String get cameraValueHdl => '45 mg/dL';

  @override
  String get cameraRefHdl => 'Normal: >40';

  @override
  String get cameraLabelLdlCholesterol => 'Colesterol LDL';

  @override
  String get cameraValueLdl => '120 mg/dL';

  @override
  String get cameraRefLdl => 'Normal: <130';

  @override
  String get cameraLabelTriglycerides => 'Triglicéridos';

  @override
  String get cameraValueTriglycerides => '150 mg/dL';

  @override
  String get cameraRefTriglycerides => 'Normal: <150';

  @override
  String get cameraSectionLabInfo => 'Información del laboratorio';

  @override
  String get cameraLabelLab => 'Laboratorio';

  @override
  String get cameraValueCityMedicalLabs => 'Laboratorios City Medical';

  @override
  String get cameraLabelReportDate => 'Fecha del informe';

  @override
  String get cameraValueDec102024 => '10 de dic. de 2024';

  @override
  String get cameraLabelCollected => 'Recopilado';

  @override
  String get cameraValueDec092024 => '9 de dic. de 2024';

  @override
  String get cameraSectionMedicationInfo => 'Información de la medicación';

  @override
  String get cameraLabelStrength => 'Concentración';

  @override
  String get cameraLabelForm => 'Forma';

  @override
  String get cameraValueTablet => 'Tableta';

  @override
  String get cameraSectionUsageInstructions => 'Instrucciones de uso';

  @override
  String get cameraLabelDirections => 'Indicaciones';

  @override
  String get cameraValueDirectionsSample =>
      'Tomar una tableta por vía oral una vez al día';

  @override
  String get cameraLabelPurpose => 'Propósito';

  @override
  String get cameraValuePurposeSample => 'Control de la presión arterial';

  @override
  String get cameraLabelStorage => 'Almacenamiento';

  @override
  String get cameraValueStorageSample => 'Almacenar a temperatura ambiente';

  @override
  String get cameraSectionAdditionalInfo => 'Información adicional';

  @override
  String get cameraLabelManufacturer => 'Fabricante';

  @override
  String get cameraValueManufacturerSample =>
      'Productos farmacéuticos genéricos';

  @override
  String get cameraLabelLotNumber => 'Número de lote';

  @override
  String get cameraValueLotNumberSample => 'LP2024001';

  @override
  String get cameraLabelExpiration => 'Caducidad';

  @override
  String get cameraValueExpirationSample => '06/2026';

  @override
  String get accountDetailsTitle => 'Detalles de la cuenta';

  @override
  String get accountDetailsNameLabel => 'Nombre';

  @override
  String get accountDetailsEmailLabel => 'Correo electrónico';

  @override
  String get accountDetailsAccountTypeLabel => 'Tipo de cuenta';

  @override
  String get accountDetailsAccountTypePatient => 'Paciente';

  @override
  String get accountDetailsAccountTypeCaregiver => 'Cuidador';

  @override
  String get accountDetailsNotSet => 'No establecido';

  @override
  String get accountDetailsPhoneLabel => 'Teléfono';

  @override
  String get accountDetailsPhoneEdit => 'Editar';

  @override
  String get accountDetailsPhoneAdd => 'Añadir';

  @override
  String get accountDetailsPlanLabel => 'Plan';

  @override
  String get accountDetailsPlanFree => 'Gratis';

  @override
  String get accountDetailsPlanPremium => 'Premium';

  @override
  String get accountDetailsPlanUpgrade => 'Actualizar';

  @override
  String get accountDetailsPlanManage => 'Gestionar';

  @override
  String get accountDetailsUsageLabel => 'Uso';

  @override
  String accountDetailsUsageFreePlan(Object limit, Object used) {
    return 'Plan gratuito — $used / $limit resúmenes usados';
  }

  @override
  String get accountDetailsUsageUnlimited => 'Ilimitado';

  @override
  String get accountDetailsPhoneEditTitle => 'Editar número de teléfono';

  @override
  String get accountDetailsPhoneHint => '+1 (555) 123-4567';

  @override
  String get accountDetailsPhoneMinLengthError =>
      'El número de teléfono debe tener al menos 8 caracteres';

  @override
  String get accountDetailsPhoneUpdated =>
      'Número de teléfono actualizado correctamente';

  @override
  String accountDetailsPhoneUpdateFailed(Object error) {
    return 'Error al actualizar el número de teléfono: $error';
  }

  @override
  String get commonSave => 'Guardar';
}
