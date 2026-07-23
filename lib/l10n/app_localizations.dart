import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Lift Log'**
  String get appName;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skipOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Skip Onboarding'**
  String get skipOnboarding;

  /// No description provided for @alreadyHaveAccountLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log In'**
  String get alreadyHaveAccountLogin;

  /// No description provided for @onboardingPhaseOne.
  ///
  /// In en, this message translates to:
  /// **'PHASE 01'**
  String get onboardingPhaseOne;

  /// No description provided for @onboardingTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Every Machine.'**
  String get onboardingTrackTitle;

  /// No description provided for @onboardingTrackDescription.
  ///
  /// In en, this message translates to:
  /// **'Map your gym floor, save machine settings, and keep every lift easy to repeat.'**
  String get onboardingTrackDescription;

  /// No description provided for @onboardingPerfectTitle.
  ///
  /// In en, this message translates to:
  /// **'Perfect Every Rep'**
  String get onboardingPerfectTitle;

  /// No description provided for @onboardingPerfectDescription.
  ///
  /// In en, this message translates to:
  /// **'Attach form notes and tutorial clips so every machine setup feels familiar.'**
  String get onboardingPerfectDescription;

  /// No description provided for @onboardingGainsTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Your Gains'**
  String get onboardingGainsTitle;

  /// No description provided for @onboardingGainsDescription.
  ///
  /// In en, this message translates to:
  /// **'Record every set with precision and watch your estimated strength evolve.'**
  String get onboardingGainsDescription;

  /// No description provided for @onboardingContinueToInsights.
  ///
  /// In en, this message translates to:
  /// **'Continue to Insights'**
  String get onboardingContinueToInsights;

  /// No description provided for @onboardingStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Journey Starts Now'**
  String get onboardingStartTitle;

  /// No description provided for @onboardingStartDescription.
  ///
  /// In en, this message translates to:
  /// **'Precision tracking for peak performance. Join the community of dedicated athletes.'**
  String get onboardingStartDescription;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingProperDeadliftForm.
  ///
  /// In en, this message translates to:
  /// **'Proper Deadlift Form'**
  String get onboardingProperDeadliftForm;

  /// No description provided for @onboardingFeatured.
  ///
  /// In en, this message translates to:
  /// **'FEATURED'**
  String get onboardingFeatured;

  /// No description provided for @onboardingBenchPress.
  ///
  /// In en, this message translates to:
  /// **'Bench Press'**
  String get onboardingBenchPress;

  /// No description provided for @onboardingCableRow.
  ///
  /// In en, this message translates to:
  /// **'Cable Row'**
  String get onboardingCableRow;

  /// No description provided for @onboardingPrecision.
  ///
  /// In en, this message translates to:
  /// **'Precision'**
  String get onboardingPrecision;

  /// No description provided for @onboardingPinPositions.
  ///
  /// In en, this message translates to:
  /// **'Pin positions'**
  String get onboardingPinPositions;

  /// No description provided for @onboardingHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get onboardingHistory;

  /// No description provided for @onboardingWeightLoads.
  ///
  /// In en, this message translates to:
  /// **'Weight loads'**
  String get onboardingWeightLoads;

  /// No description provided for @onboardingBarbellSquat.
  ///
  /// In en, this message translates to:
  /// **'Barbell Squat'**
  String get onboardingBarbellSquat;

  /// No description provided for @onboardingSets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get onboardingSets;

  /// No description provided for @onboardingReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get onboardingReps;

  /// No description provided for @onboardingEstimatedOneRm.
  ///
  /// In en, this message translates to:
  /// **'Estimated 1RM'**
  String get onboardingEstimatedOneRm;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
