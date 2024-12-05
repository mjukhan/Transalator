// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Translator`
  String get translation {
    return Intl.message(
      'Translator',
      name: 'translation',
      desc: '',
      args: [],
    );
  }

  /// `Conversation`
  String get conversation {
    return Intl.message(
      'Conversation',
      name: 'conversation',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message(
      'Upload',
      name: 'upload',
      desc: '',
      args: [],
    );
  }

  /// `Dictionary`
  String get dictionary {
    return Intl.message(
      'Dictionary',
      name: 'dictionary',
      desc: '',
      args: [],
    );
  }

  /// `File`
  String get file {
    return Intl.message(
      'File',
      name: 'file',
      desc: '',
      args: [],
    );
  }

  /// `Error in translation`
  String get errorInTranslation {
    return Intl.message(
      'Error in translation',
      name: 'errorInTranslation',
      desc: '',
      args: [],
    );
  }

  /// `savedTranslations`
  String get savedTranslations {
    return Intl.message(
      'savedTranslations',
      name: 'savedTranslations',
      desc: '',
      args: [],
    );
  }

  /// `Translation saved!`
  String get translationSaved {
    return Intl.message(
      'Translation saved!',
      name: 'translationSaved',
      desc: '',
      args: [],
    );
  }

  /// `Instance saved:`
  String get instanceSaved {
    return Intl.message(
      'Instance saved:',
      name: 'instanceSaved',
      desc: '',
      args: [],
    );
  }

  /// `Copied to clipboard!`
  String get copiedToClipboard {
    return Intl.message(
      'Copied to clipboard!',
      name: 'copiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Copied:`
  String get copied {
    return Intl.message(
      'Copied:',
      name: 'copied',
      desc: '',
      args: [],
    );
  }

  /// `Enter text`
  String get hintTextTranslation {
    return Intl.message(
      'Enter text',
      name: 'hintTextTranslation',
      desc: '',
      args: [],
    );
  }

  /// `Microphone permission is required.`
  String get micPermissionRequired {
    return Intl.message(
      'Microphone permission is required.',
      name: 'micPermissionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Error picking image from camera:`
  String get errorInPickImageFromCamera {
    return Intl.message(
      'Error picking image from camera:',
      name: 'errorInPickImageFromCamera',
      desc: '',
      args: [],
    );
  }

  /// `Error picking image from gallery:`
  String get errorInPickImageFromGallery {
    return Intl.message(
      'Error picking image from gallery:',
      name: 'errorInPickImageFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Upload Image`
  String get uploadImage {
    return Intl.message(
      'Upload Image',
      name: 'uploadImage',
      desc: '',
      args: [],
    );
  }

  /// `Take Picture`
  String get takePicture {
    return Intl.message(
      'Take Picture',
      name: 'takePicture',
      desc: '',
      args: [],
    );
  }

  /// `Translate to:`
  String get translateTo {
    return Intl.message(
      'Translate to:',
      name: 'translateTo',
      desc: '',
      args: [],
    );
  }

  /// `Translation result is empty.`
  String get translationResultEmpty {
    return Intl.message(
      'Translation result is empty.',
      name: 'translationResultEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Translation error occurred for line:`
  String get translationErrorInLine {
    return Intl.message(
      'Translation error occurred for line:',
      name: 'translationErrorInLine',
      desc: '',
      args: [],
    );
  }

  /// `Recent Words`
  String get recentSearches {
    return Intl.message(
      'Recent Words',
      name: 'recentSearches',
      desc: '',
      args: [],
    );
  }

  /// `Fine word by using the search`
  String get findWordBySearch {
    return Intl.message(
      'Fine word by using the search',
      name: 'findWordBySearch',
      desc: '',
      args: [],
    );
  }

  /// `Word of the day`
  String get wordOfTheDay {
    return Intl.message(
      'Word of the day',
      name: 'wordOfTheDay',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get hintTextForSearchWord {
    return Intl.message(
      'Search',
      name: 'hintTextForSearchWord',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching meaning`
  String get errorFetchingMeaning {
    return Intl.message(
      'Error fetching meaning',
      name: 'errorFetchingMeaning',
      desc: '',
      args: [],
    );
  }

  /// `No data found`
  String get noDataFound {
    return Intl.message(
      'No data found',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `German`
  String get german {
    return Intl.message(
      'German',
      name: 'german',
      desc: '',
      args: [],
    );
  }

  /// `Italian`
  String get italian {
    return Intl.message(
      'Italian',
      name: 'italian',
      desc: '',
      args: [],
    );
  }

  /// `French`
  String get french {
    return Intl.message(
      'French',
      name: 'french',
      desc: '',
      args: [],
    );
  }

  /// `Spanish`
  String get spanish {
    return Intl.message(
      'Spanish',
      name: 'spanish',
      desc: '',
      args: [],
    );
  }

  /// `Dutch`
  String get dutch {
    return Intl.message(
      'Dutch',
      name: 'dutch',
      desc: '',
      args: [],
    );
  }

  /// `Hungarian`
  String get hungarian {
    return Intl.message(
      'Hungarian',
      name: 'hungarian',
      desc: '',
      args: [],
    );
  }

  /// `Romanian`
  String get romanian {
    return Intl.message(
      'Romanian',
      name: 'romanian',
      desc: '',
      args: [],
    );
  }

  /// `Urdu`
  String get urdu {
    return Intl.message(
      'Urdu',
      name: 'urdu',
      desc: '',
      args: [],
    );
  }

  /// `Chinese`
  String get chinese {
    return Intl.message(
      'Chinese',
      name: 'chinese',
      desc: '',
      args: [],
    );
  }

  /// `Hindi`
  String get hindi {
    return Intl.message(
      'Hindi',
      name: 'hindi',
      desc: '',
      args: [],
    );
  }

  /// `Danish`
  String get danish {
    return Intl.message(
      'Danish',
      name: 'danish',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message(
      'Arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `Bengali`
  String get bengali {
    return Intl.message(
      'Bengali',
      name: 'bengali',
      desc: '',
      args: [],
    );
  }

  /// `Czech`
  String get czech {
    return Intl.message(
      'Czech',
      name: 'czech',
      desc: '',
      args: [],
    );
  }

  /// `Filipino`
  String get filipino {
    return Intl.message(
      'Filipino',
      name: 'filipino',
      desc: '',
      args: [],
    );
  }

  /// `Afrikaans`
  String get afrikaans {
    return Intl.message(
      'Afrikaans',
      name: 'afrikaans',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `Premium`
  String get premium {
    return Intl.message(
      'Premium',
      name: 'premium',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade to Pro`
  String get upgradeToPro {
    return Intl.message(
      'Upgrade to Pro',
      name: 'upgradeToPro',
      desc: '',
      args: [],
    );
  }

  /// `Choose Language`
  String get appLanguage {
    return Intl.message(
      'Choose Language',
      name: 'appLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Change your app language`
  String get changeAppLanguage {
    return Intl.message(
      'Change your app language',
      name: 'changeAppLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Manage Subscriptions`
  String get manageSubscriptions {
    return Intl.message(
      'Manage Subscriptions',
      name: 'manageSubscriptions',
      desc: '',
      args: [],
    );
  }

  /// `Check your purchase & billing`
  String get checkBilling {
    return Intl.message(
      'Check your purchase & billing',
      name: 'checkBilling',
      desc: '',
      args: [],
    );
  }

  /// `Favorite`
  String get favorite {
    return Intl.message(
      'Favorite',
      name: 'favorite',
      desc: '',
      args: [],
    );
  }

  /// `View all translations Favorites`
  String get viewAllFavorites {
    return Intl.message(
      'View all translations Favorites',
      name: 'viewAllFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Share App`
  String get shareApp {
    return Intl.message(
      'Share App',
      name: 'shareApp',
      desc: '',
      args: [],
    );
  }

  /// `Share with friends`
  String get shareWithFriends {
    return Intl.message(
      'Share with friends',
      name: 'shareWithFriends',
      desc: '',
      args: [],
    );
  }

  /// `Rate Us`
  String get rateUs {
    return Intl.message(
      'Rate Us',
      name: 'rateUs',
      desc: '',
      args: [],
    );
  }

  /// `Share your suggestion, feedback`
  String get shareFeedback {
    return Intl.message(
      'Share your suggestion, feedback',
      name: 'shareFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Read the apps privacy policy`
  String get readPrivacyPolicy {
    return Intl.message(
      'Read the apps privacy policy',
      name: 'readPrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message(
      'Continue',
      name: 'continueButton',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelButton {
    return Intl.message(
      'Cancel',
      name: 'cancelButton',
      desc: '',
      args: [],
    );
  }

  /// `Could not open the app store.`
  String get couldNotOpenAppStore {
    return Intl.message(
      'Could not open the app store.',
      name: 'couldNotOpenAppStore',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade to Premium`
  String get upgradeToPremium {
    return Intl.message(
      'Upgrade to Premium',
      name: 'upgradeToPremium',
      desc: '',
      args: [],
    );
  }

  /// `Remove ads and unlock all features`
  String get removeAdsUnlockFeatures {
    return Intl.message(
      'Remove ads and unlock all features',
      name: 'removeAdsUnlockFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Ads-free experience`
  String get adsFreeExperience {
    return Intl.message(
      'Ads-free experience',
      name: 'adsFreeExperience',
      desc: '',
      args: [],
    );
  }

  /// `Offline Translation`
  String get offlineTranslation {
    return Intl.message(
      'Offline Translation',
      name: 'offlineTranslation',
      desc: '',
      args: [],
    );
  }

  /// `Phrase Book Access`
  String get phraseBookAccess {
    return Intl.message(
      'Phrase Book Access',
      name: 'phraseBookAccess',
      desc: '',
      args: [],
    );
  }

  /// `Voice Conversation`
  String get voiceConversation {
    return Intl.message(
      'Voice Conversation',
      name: 'voiceConversation',
      desc: '',
      args: [],
    );
  }

  /// `Camera Translation`
  String get cameraTranslation {
    return Intl.message(
      'Camera Translation',
      name: 'cameraTranslation',
      desc: '',
      args: [],
    );
  }

  /// `3 days free trial, PKR - Rs 7,500.00/Yearly`
  String get threeDaysFreeTrial {
    return Intl.message(
      '3 days free trial, PKR - Rs 7,500.00/Yearly',
      name: 'threeDaysFreeTrial',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Anytime`
  String get cancelAnytime {
    return Intl.message(
      'Cancel Anytime',
      name: 'cancelAnytime',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Privacy`
  String get termsPrivacy {
    return Intl.message(
      'Terms & Privacy',
      name: 'termsPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Details`
  String get subscriptionDetails {
    return Intl.message(
      'Subscription Details',
      name: 'subscriptionDetails',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Details`
  String get subscriptionDialogTitle {
    return Intl.message(
      'Subscription Details',
      name: 'subscriptionDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `With a Language Translator VIP subscription, all ads will be removed.`
  String get subscriptionDetail1 {
    return Intl.message(
      'With a Language Translator VIP subscription, all ads will be removed.',
      name: 'subscriptionDetail1',
      desc: '',
      args: [],
    );
  }

  /// `Once the purchase is confirmed, the subscription will be charged through the Google Play Store.`
  String get subscriptionDetail2 {
    return Intl.message(
      'Once the purchase is confirmed, the subscription will be charged through the Google Play Store.',
      name: 'subscriptionDetail2',
      desc: '',
      args: [],
    );
  }

  /// `After cancellation, the subscription will continue until the end of the current month or year billing period.`
  String get subscriptionDetail3 {
    return Intl.message(
      'After cancellation, the subscription will continue until the end of the current month or year billing period.',
      name: 'subscriptionDetail3',
      desc: '',
      args: [],
    );
  }

  /// `Subscriptions will automatically renew unless auto-renew is turned off at least 24 hours before the end of the current period.`
  String get subscriptionDetail4 {
    return Intl.message(
      'Subscriptions will automatically renew unless auto-renew is turned off at least 24 hours before the end of the current period.',
      name: 'subscriptionDetail4',
      desc: '',
      args: [],
    );
  }

  /// `You can manage your subscription or disable automatic renewal in the Google Play Store account settings.`
  String get subscriptionDetail5 {
    return Intl.message(
      'You can manage your subscription or disable automatic renewal in the Google Play Store account settings.',
      name: 'subscriptionDetail5',
      desc: '',
      args: [],
    );
  }

  /// `Subscriptions canceled during the trial period will not be charged.`
  String get subscriptionDetail6 {
    return Intl.message(
      'Subscriptions canceled during the trial period will not be charged.',
      name: 'subscriptionDetail6',
      desc: '',
      args: [],
    );
  }

  /// `Language changed to`
  String get languageChangedTo {
    return Intl.message(
      'Language changed to',
      name: 'languageChangedTo',
      desc: '',
      args: [],
    );
  }

  /// `App Languages`
  String get appLanguages {
    return Intl.message(
      'App Languages',
      name: 'appLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Translation removed!`
  String get translationRemoved {
    return Intl.message(
      'Translation removed!',
      name: 'translationRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Favorite Translations`
  String get favoriteTranslations {
    return Intl.message(
      'Favorite Translations',
      name: 'favoriteTranslations',
      desc: '',
      args: [],
    );
  }

  /// `No saved translations`
  String get noSavedTranslations {
    return Intl.message(
      'No saved translations',
      name: 'noSavedTranslations',
      desc: '',
      args: [],
    );
  }

  /// `Delete this translation`
  String get deleteThisTranslation {
    return Intl.message(
      'Delete this translation',
      name: 'deleteThisTranslation',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicyTitle {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Imagination AI has developed the Language Translator - Speech to Text Translator app as a free app. This SERVICE is provided by Imagination AI at no cost and is intended for use as is.\n\nThis page is used to inform visitors about my policies regarding the collection, use, and disclosure of personal data if anyone decides to use my service.\n\nIf you choose to use my service, you agree to the collection and use of information in relation to this policy. The personal data I collect is used for providing and improving the service. I will not share or use your data except as described in this Privacy Policy.\n\nThe terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible through Language Translator - Speech to Text Translator unless otherwise defined in this Privacy Policy.\n`
  String get privacyPolicyIntro {
    return Intl.message(
      'Imagination AI has developed the Language Translator - Speech to Text Translator app as a free app. This SERVICE is provided by Imagination AI at no cost and is intended for use as is.\n\nThis page is used to inform visitors about my policies regarding the collection, use, and disclosure of personal data if anyone decides to use my service.\n\nIf you choose to use my service, you agree to the collection and use of information in relation to this policy. The personal data I collect is used for providing and improving the service. I will not share or use your data except as described in this Privacy Policy.\n\nThe terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible through Language Translator - Speech to Text Translator unless otherwise defined in this Privacy Policy.\n',
      name: 'privacyPolicyIntro',
      desc: '',
      args: [],
    );
  }

  /// `Information Collection and Use`
  String get informationCollectionAndUse {
    return Intl.message(
      'Information Collection and Use',
      name: 'informationCollectionAndUse',
      desc: '',
      args: [],
    );
  }

  /// `For a better experience while using our service, we may require you to provide certain personally identifiable information. The information that we request will be stored on your device and is not collected by us in any way.\nThe app uses third-party services that may collect information that can identify you.\nLink to the privacy policy of third-party services used in the app.`
  String get informationCollectionAndUseDetails {
    return Intl.message(
      'For a better experience while using our service, we may require you to provide certain personally identifiable information. The information that we request will be stored on your device and is not collected by us in any way.\nThe app uses third-party services that may collect information that can identify you.\nLink to the privacy policy of third-party services used in the app.',
      name: 'informationCollectionAndUseDetails',
      desc: '',
      args: [],
    );
  }

  /// `Log Data`
  String get logData {
    return Intl.message(
      'Log Data',
      name: 'logData',
      desc: '',
      args: [],
    );
  }

  /// `I want to inform you that whenever you use my service, in the case of an error in the app, data and information (through third-party products) may be collected on your phone which is called Log Data.\nThis Log Data may include information such as your device's IP address, device name, operating system version, the configuration of the app when utilizing my service, the time and date of your use of the service, and other statistics.`
  String get logDataDetails {
    return Intl.message(
      'I want to inform you that whenever you use my service, in the case of an error in the app, data and information (through third-party products) may be collected on your phone which is called Log Data.\nThis Log Data may include information such as your device\'s IP address, device name, operating system version, the configuration of the app when utilizing my service, the time and date of your use of the service, and other statistics.',
      name: 'logDataDetails',
      desc: '',
      args: [],
    );
  }

  /// `Cookies`
  String get cookies {
    return Intl.message(
      'Cookies',
      name: 'cookies',
      desc: '',
      args: [],
    );
  }

  /// `Cookies are files with a small amount of data, which may include an anonymous unique identifier. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.\n\nThis service does not explicitly use these “cookies.” However, the app may use code and third-party libraries that use “cookies” to collect information and improve their services. You have the option to either accept or decline these cookies, and know when a cookie is being sent to your device. If you decide to decline our cookies, you may not be able to use some portions of this service.`
  String get cookiesDetails {
    return Intl.message(
      'Cookies are files with a small amount of data, which may include an anonymous unique identifier. These are sent to your browser from the websites that you visit and are stored on your device\'s internal memory.\n\nThis service does not explicitly use these “cookies.” However, the app may use code and third-party libraries that use “cookies” to collect information and improve their services. You have the option to either accept or decline these cookies, and know when a cookie is being sent to your device. If you decide to decline our cookies, you may not be able to use some portions of this service.',
      name: 'cookiesDetails',
      desc: '',
      args: [],
    );
  }

  /// `Service Providers`
  String get serviceProviders {
    return Intl.message(
      'Service Providers',
      name: 'serviceProviders',
      desc: '',
      args: [],
    );
  }

  /// `I may employ third-party companies and individuals for the following reasons:\n\nTo facilitate our service;\nTo provide the service on our behalf;\nTo perform service-related tasks; or\nTo assist us in analyzing how our service is used.\n\nI want to inform users of this service that these third parties have access to their personal information. The reason is to perform these tasks on our behalf. However, they are obligated not to disclose or use the information for any other purpose.`
  String get serviceProvidersDetails {
    return Intl.message(
      'I may employ third-party companies and individuals for the following reasons:\n\nTo facilitate our service;\nTo provide the service on our behalf;\nTo perform service-related tasks; or\nTo assist us in analyzing how our service is used.\n\nI want to inform users of this service that these third parties have access to their personal information. The reason is to perform these tasks on our behalf. However, they are obligated not to disclose or use the information for any other purpose.',
      name: 'serviceProvidersDetails',
      desc: '',
      args: [],
    );
  }

  /// `Security`
  String get security {
    return Intl.message(
      'Security',
      name: 'security',
      desc: '',
      args: [],
    );
  }

  /// `I appreciate your trust in providing your personal information to us. We strive to use commercially acceptable means to protect it. However, please be aware that no method of transmission over the internet or method of electronic storage is 100% secure and reliable, and I cannot guarantee absolute security.`
  String get securityDetails {
    return Intl.message(
      'I appreciate your trust in providing your personal information to us. We strive to use commercially acceptable means to protect it. However, please be aware that no method of transmission over the internet or method of electronic storage is 100% secure and reliable, and I cannot guarantee absolute security.',
      name: 'securityDetails',
      desc: '',
      args: [],
    );
  }

  /// `Links to Other Sites`
  String get linksToOtherSites {
    return Intl.message(
      'Links to Other Sites',
      name: 'linksToOtherSites',
      desc: '',
      args: [],
    );
  }

  /// `This service may contain links to other websites. If you click on a third-party link, you will be directed to that site. Please note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.`
  String get linksToOtherSitesDetails {
    return Intl.message(
      'This service may contain links to other websites. If you click on a third-party link, you will be directed to that site. Please note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.',
      name: 'linksToOtherSitesDetails',
      desc: '',
      args: [],
    );
  }

  /// `Children's Privacy`
  String get childrenPrivacy {
    return Intl.message(
      'Children\'s Privacy',
      name: 'childrenPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `These Services are not intended for use by anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13. If I discover that a child under 13 has provided me with personal information, I will delete it immediately from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we can take the necessary actions.`
  String get childrenPrivacyDetails {
    return Intl.message(
      'These Services are not intended for use by anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13. If I discover that a child under 13 has provided me with personal information, I will delete it immediately from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we can take the necessary actions.',
      name: 'childrenPrivacyDetails',
      desc: '',
      args: [],
    );
  }

  /// `Changes to This Privacy Policy`
  String get changesToPrivacyPolicy {
    return Intl.message(
      'Changes to This Privacy Policy',
      name: 'changesToPrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `I may update our Privacy Policy from time to time. Therefore, I advise you to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately after they are posted on this page.`
  String get changesToPrivacyPolicyDetails {
    return Intl.message(
      'I may update our Privacy Policy from time to time. Therefore, I advise you to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately after they are posted on this page.',
      name: 'changesToPrivacyPolicyDetails',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message(
      'Contact Us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at `
  String get contactUsDetails {
    return Intl.message(
      'If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at ',
      name: 'contactUsDetails',
      desc: '',
      args: [],
    );
  }

  /// `apps@imaginationai.net`
  String get contactEmail {
    return Intl.message(
      'apps@imaginationai.net',
      name: 'contactEmail',
      desc: '',
      args: [],
    );
  }

  /// `Clip board is Empty`
  String get clipboardEmpty {
    return Intl.message(
      'Clip board is Empty',
      name: 'clipboardEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Permission Required`
  String get permissionRequired {
    return Intl.message(
      'Permission Required',
      name: 'permissionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Upload Successful`
  String get uploadSuccessful {
    return Intl.message(
      'Upload Successful',
      name: 'uploadSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `File has been uploaded successfully.`
  String get fileHasBeenUploaded {
    return Intl.message(
      'File has been uploaded successfully.',
      name: 'fileHasBeenUploaded',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Start Conversation`
  String get startConvo {
    return Intl.message(
      'Start Conversation',
      name: 'startConvo',
      desc: '',
      args: [],
    );
  }

  /// `Search Results`
  String get searchResult {
    return Intl.message(
      'Search Results',
      name: 'searchResult',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching lines with attributes: `
  String get errorFetchingLine {
    return Intl.message(
      'Error fetching lines with attributes: ',
      name: 'errorFetchingLine',
      desc: '',
      args: [],
    );
  }

  /// `Error uploading file: `
  String get errorUploadingFile {
    return Intl.message(
      'Error uploading file: ',
      name: 'errorUploadingFile',
      desc: '',
      args: [],
    );
  }

  /// `Text copied`
  String get textCopied {
    return Intl.message(
      'Text copied',
      name: 'textCopied',
      desc: '',
      args: [],
    );
  }

  /// `Translate`
  String get translate {
    return Intl.message(
      'Translate',
      name: 'translate',
      desc: '',
      args: [],
    );
  }

  /// `Translating... `
  String get translating {
    return Intl.message(
      'Translating... ',
      name: 'translating',
      desc: '',
      args: [],
    );
  }

  /// `Listening...`
  String get listening {
    return Intl.message(
      'Listening...',
      name: 'listening',
      desc: '',
      args: [],
    );
  }

  /// `Speak Now`
  String get speakNow {
    return Intl.message(
      'Speak Now',
      name: 'speakNow',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'af'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'cs'),
      Locale.fromSubtags(languageCode: 'da'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fil'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'it'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
