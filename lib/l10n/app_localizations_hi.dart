// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'हार्वेस्टहब';

  @override
  String get welcomeMessage => 'हार्वेस्टहब में आपका स्वागत है!';

  @override
  String get selectLanguage => 'पसंदीदा भाषा चुनें';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get hindi => 'हिंदी';

  @override
  String get tamil => 'तमिल';

  @override
  String get telugu => 'तेलुगु';

  @override
  String get malayalam => 'मलयालम';

  @override
  String get home => 'होम';

  @override
  String get harvestBot => 'फ्लक्सकोर';

  @override
  String get yourFarmingCompanion => 'आपका कृषि साथी';

  @override
  String get editProfileSettings => 'प्रोफ़ाइल सेटिंग्स संपादित करें';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get errorLoadingUserData => 'उपयोगकर्ता डेटा लोड करने में त्रुटि';

  @override
  String get weatherForecast => 'मौसम पूर्वानुमान';

  @override
  String feelsLike(Object value) {
    return 'महसूस होता है: $value°C';
  }

  @override
  String wind(Object speed, Object dir) {
    return 'हवा: $speed किमी/घंटा ($dir)';
  }

  @override
  String pressure(Object value) {
    return 'दबाव: $value mb';
  }

  @override
  String humidity(Object value) {
    return 'आर्द्रता: $value%';
  }

  @override
  String visibility(Object value) {
    return 'दृश्यता: $value किमी';
  }

  @override
  String uvIndex(Object value) {
    return 'यूवी इंडेक्स: $value';
  }

  @override
  String cloudCover(Object value) {
    return 'मेघ आवरण: $value%';
  }

  @override
  String get threeDayForecast => '3-दिन का पूर्वानुमान';

  @override
  String get thirtyDayForecast => '30-दिन का पूर्वानुमान';

  @override
  String weatherForecastCalendar(Object startDate, Object endDate) {
    return 'मौसम पूर्वानुमान: $startDate - $endDate';
  }

  @override
  String get viewMore => 'और देखें';

  @override
  String get failedToLoadWeather => 'मौसम डेटा लोड करने में विफल';

  @override
  String get farmingTip => 'कृषि टिप';

  @override
  String get noFarmingTip => 'कोई कृषि टिप उपलब्ध नहीं है';

  @override
  String get recommendedCrop => 'अनुशंसित फसल';

  @override
  String get noCropRecommendation => 'कोई फसल अनुशंसा उपलब्ध नहीं है';

  @override
  String get locationServicesRequired => 'इस ऐप का उपयोग करने के लिए स्थान सेवाएँ आवश्यक हैं।';

  @override
  String get failedToLoadInsights => 'अंतर्दृष्टि लोड करने में विफल';

  @override
  String get sendOTP => 'OTP भेजें';

  @override
  String get verifyOTP => 'OTP सत्यापित करें';

  @override
  String get name => 'नाम';

  @override
  String get phoneNumber => 'फोन नंबर';

  @override
  String get enterOTP => 'OTP दर्ज करें';

  @override
  String get pleaseEnterNameAndPhone => 'कृपया अपना नाम और फोन नंबर दर्ज करें';

  @override
  String get invalidOTP => 'अमान्य OTP';

  @override
  String get failedToSendOTP => 'OTP भेजने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get failedToSignIn => 'साइन इन करने में विफल';

  @override
  String get enableLocationServices => 'स्थान सेवाएँ सक्षम करें';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get nextContinue => 'जारी रखें';

  @override
  String get proceed => 'आगे बढ़ें';

  @override
  String get changeLanguage => 'भाषा बदलें';

  @override
  String get talkToHarvestBot => 'फ्लक्सकोर से बात करें';

  @override
  String get somethingWentWrong => 'कुछ गलत हो गया';

  @override
  String get checkConnectionAndTryAgain => 'कृपया अपना कनेक्शन जांचें और पुनः प्रयास करें';

  @override
  String get tryAgain => 'पुनः प्रयास करें';

  @override
  String get currentWeather => 'वर्तमान मौसम';

  @override
  String get upcomingForecast => 'आने वाला पूर्वानुमान';

  @override
  String get tomorrow => 'कल';

  @override
  String get minTemperature => 'न्यून:';

  @override
  String get rain => 'बारिश';

  @override
  String get viewAll => 'सभी देखें >';

  @override
  String get january => 'जनवरी';

  @override
  String get february => 'फरवरी';

  @override
  String get march => 'मार्च';

  @override
  String get april => 'अप्रैल';

  @override
  String get may => 'मई';

  @override
  String get june => 'जून';

  @override
  String get july => 'जुलाई';

  @override
  String get august => 'अगस्त';

  @override
  String get september => 'सितंबर';

  @override
  String get october => 'अक्टूबर';

  @override
  String get november => 'नवंबर';

  @override
  String get december => 'दिसंबर';

  @override
  String get sunday => 'रवि';

  @override
  String get monday => 'सोम';

  @override
  String get tuesday => 'मंगल';

  @override
  String get wednesday => 'बुध';

  @override
  String get thursday => 'गुरु';

  @override
  String get friday => 'शुक्र';

  @override
  String get saturday => 'शनि';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get helpSupport => 'सहायता और समर्थन';

  @override
  String get about => 'के बारे में';

  @override
  String get helpAndSupportTitle => 'सहायता और समर्थन';

  @override
  String get appFeaturesTitle => 'ऐप फीचर्स';

  @override
  String get gettingStartedTitle => 'शुरुआत करना';

  @override
  String get featuresAndUsageTitle => 'फीचर्स और उपयोग';

  @override
  String get contactSupportTitle => 'संपर्क सहायता';

  @override
  String get weatherUpdatesFeature => 'मौसम अपडेट';

  @override
  String get weatherUpdatesDesc => 'अपनी कृषि गतिविधियों की योजना बनाने के लिए तापमान, आर्द्रता, हवा की गति और 3-दिन के पूर्वानुमान सहित रीयल-टाइम मौसम जानकारी प्राप्त करें।';

  @override
  String get aiChatFeature => 'फ्लक्सकोर AI असिस्टेंट';

  @override
  String get aiChatDesc => 'व्यक्तिगत सलाह, फसल सिफारिशों और आपके कृषि प्रश्नों के उत्तर के लिए हमारे AI-संचालित कृषि विशेषज्ञ से चैट करें।';

  @override
  String get multiLanguageFeature => 'बहुभाषी समर्थन';

  @override
  String get multiLanguageDesc => 'अंग्रेजी, हिंदी, तमिल, तेलुगु और मलयालम के समर्थन के साथ अपनी पसंदीदा भाषा में ऐप का उपयोग करें।';

  @override
  String get profileManagementFeature => 'प्रोफाइल प्रबंधन';

  @override
  String get profileManagementDesc => 'व्यक्तिगत सिफारिशों के लिए अपनी व्यक्तिगत जानकारी, फसल प्राथमिकताओं और स्थान सेटिंग्स का प्रबंधन करें।';

  @override
  String get gettingStartedStep1 => '1. अपने स्थान और फसल प्राथमिकताओं के साथ अपना प्रोफाइल सेट करें';

  @override
  String get gettingStartedStep2 => '2. सटीक मौसम अपडेट के लिए स्थान पहुंच की अनुमति दें';

  @override
  String get gettingStartedStep3 => '3. होम स्क्रीन पर मौसम पूर्वानुमान और कृषि अंतर्दृष्टि देखें';

  @override
  String get gettingStartedStep4 => '4. व्यक्तिगत कृषि सलाह के लिए फ्लक्सकोर के साथ चैट करें';

  @override
  String get weatherUsageTitle => 'मौसम फीचर्स का उपयोग';

  @override
  String get weatherUsageDesc => 'वर्तमान मौसम स्थितियों, 3-दिन के पूर्वानुमान और 30-दिन के विस्तृत पूर्वानुमान देखें। विस्तृत कैलेंडर दृश्य देखने के लिए \'सभी देखें\' पर टैप करें।';

  @override
  String get aiChatUsageTitle => 'फ्लक्सकोर का उपयोग';

  @override
  String get aiChatUsageDesc => 'फसलों, बीमारियों, उर्वरकों या किसी भी कृषि विषय के बारे में प्रश्न पूछें। AI आपकी बातचीत के आधार पर संदर्भ-जागरूक उत्तर प्रदान करता है।';

  @override
  String get troubleshootingTitle => 'समस्या निवारण';

  @override
  String get locationIssues => 'स्थान समस्याएं';

  @override
  String get locationIssuesDesc => 'सटीक मौसम डेटा के लिए अपनी डिवाइस सेटिंग्स में स्थान सेवाएं सक्षम हैं यह सुनिश्चित करें।';

  @override
  String get weatherNotLoading => 'मौसम लोड नहीं हो रहा';

  @override
  String get weatherNotLoadingDesc => 'अपना इंटरनेट कनेक्शन और स्थान अनुमतियां जांचें। होम स्क्रीन को रीफ्रेश करने के लिए नीचे खींचें।';

  @override
  String get aiNotResponding => 'AI जवाब नहीं दे रहा';

  @override
  String get aiNotRespondingDesc => 'सुनिश्चित करें कि आपके पास स्थिर इंटरनेट कनेक्शन है। यदि AI समझ नहीं पाता तो अपना प्रश्न दोबारा तैयार करने का प्रयास करें।';

  @override
  String get contactSupportDesc => 'अतिरिक्त सहायता के लिए या समस्याओं की रिपोर्ट करने के लिए, आप कर सकते हैं:';

  @override
  String get emailSupport => 'हमें ईमेल करें: support@FarmFlux.com';

  @override
  String get reportIssue => 'ऐप फीडबैक के माध्यम से समस्याओं की रिपोर्ट करें';

  @override
  String get visitWebsite => 'हमारी वेबसाइट पर जाएं: www.FarmFlux.com';

  @override
  String get appVersion => 'ऐप संस्करण: 2.0.1';

  @override
  String get lastUpdated => 'अंतिम अपडेट: जून 2025';

  @override
  String get uploadPlantImage => 'पौधे की छवि अपलोड करें';

  @override
  String get uploadPlantImageDesc => 'कीट और बीमारियों का पता लगाने के लिए अपने पौधे की पत्तियों की स्पष्ट तस्वीर लें या गैलरी से अपलोड करें।';

  @override
  String get camera => 'कैमरा';

  @override
  String get gallery => 'गैलरी';

  @override
  String get analyzing => 'विश्लेषण कर रहे हैं...';

  @override
  String get analyzingForecast => '30-दिन का पूर्वानुमान का विश्लेषण...';

  @override
  String get analyzeImage => 'छवि का विश्लेषण करें';

  @override
  String get detectionResults => 'पहचान परिणाम';

  @override
  String get noImageSelected => 'कोई छवि चयनित नहीं';

  @override
  String get uploadImageToGetStarted => 'शुरू करने के लिए एक छवि अपलोड करें';

  @override
  String get analysisComplete => 'विश्लेषण पूर्ण';

  @override
  String get noPestsDetected => 'इस छवि में कोई कीट नहीं मिला';

  @override
  String get cropsHealthyMessage => 'आपकी फसलें स्वस्थ दिख रही हैं! नियमित निगरानी जारी रखें और अच्छी कृषि प्रथाओं को बनाए रखें।';

  @override
  String get recommendations => 'सिफारिशें';

  @override
  String get confidence => 'विश्वास';

  @override
  String get diagnosis => 'निदान';

  @override
  String get causalAgent => 'कारक एजेंट';

  @override
  String get analysisError => 'विश्लेषण त्रुटि';

  @override
  String get analysisErrorDesc => 'छवि का विश्लेषण करने में असमर्थ। कृपया एक स्पष्ट फोटो के साथ पुनः प्रयास करें।';

  @override
  String get readyToAnalyze => 'विश्लेषण के लिए तैयार';

  @override
  String get uploadImageAndAnalyze => 'छवि अपलोड करें और कीटों का पता लगाने और सिफारिशें प्राप्त करने के लिए \"विश्लेषण करें\" पर टैप करें';

  @override
  String get scanAgain => 'फिर से स्कैन करें';

  @override
  String get saveResult => 'परिणाम सहेजें';

  @override
  String get resultSaved => 'परिणाम सहेजा गया';

  @override
  String get uploadImageFirst => 'पहले एक छवि अपलोड करें';

  @override
  String get tapAnalyzeToStart => 'पहचान शुरू करने के लिए विश्लेषण बटन पर टैप करें';

  @override
  String get selectImageFromCameraOrGallery => 'कैमरा या गैलरी से छवि चुनें';

  @override
  String get failedToAnalyzeImage => 'छवि का विश्लेषण करने में विफल';

  @override
  String get howToUse => 'उपयोग कैसे करें';

  @override
  String get takeClearPhotos => 'पौधे की पत्तियों की स्पष्ट, अच्छी रोशनी वाली तस्वीरें लें';

  @override
  String get focusOnAffectedAreas => 'दिखाई देने वाले लक्षणों के साथ प्रभावित क्षेत्रों पर ध्यान दें';

  @override
  String get avoidBlurryImages => 'धुंधली या अंधेरी छवियों से बचें';

  @override
  String get includeMultipleLeaves => 'यदि संभव हो तो कई पत्तियों को शामिल करें';

  @override
  String get gotIt => 'समझ गया';

  @override
  String get basedOn30DayForecast => '30-दिन के मौसम पूर्वानुमान के आधार पर';

  @override
  String get basedOnCurrentConditions => 'वर्तमान मौसम की स्थिति के आधार पर';

  @override
  String get personalInformation => 'व्यक्तिगत जानकारी';

  @override
  String get updateYourProfileDetails => 'अपने प्रोफ़ाइल विवरण अपडेट करें';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get enterYourFullName => 'अपना पूरा नाम दर्ज करें';

  @override
  String get emailAddress => 'ईमेल पता';

  @override
  String get enterYourEmailAddress => 'अपना ईमेल पता दर्ज करें';

  @override
  String get enterYourPhoneNumber => 'अपना फोन नंबर दर्ज करें';

  @override
  String get saveChanges => 'परिवर्तन सहेजें';

  @override
  String get changeProfilePicture => 'प्रोफ़ाइल चित्र बदलें';

  @override
  String get remove => 'हटाएं';

  @override
  String get profileUpdatedSuccessfully => 'आपकी प्रोफ़ाइल सफलतापूर्वक अपडेट हो गई है।';

  @override
  String get mobileNumberUpdatedSuccessfully => 'आपका मोबाइल नंबर सफलतापूर्वक अपडेट हो गया है।';

  @override
  String get pleaseEnterVerificationCode => 'कृपया अपने फोन पर भेजे गए सत्यापन कोड को दर्ज करें';

  @override
  String get otpAutoFilledSuccessfully => 'OTP सफलतापूर्वक स्वत: भर गया!';

  @override
  String get otpWillBeFilledAutomatically => 'SMS प्राप्त होने पर OTP स्वचालित रूप से भर जाएगा';

  @override
  String get didntReceiveOTP => 'OTP नहीं मिला? ';

  @override
  String get resend => 'फिर से भेजें';

  @override
  String resendInSeconds(Object seconds) {
    return '${seconds}s में फिर से भेजें';
  }

  @override
  String get otpResentSuccessfully => 'OTP सफलतापूर्वक फिर से भेजा गया';
}
