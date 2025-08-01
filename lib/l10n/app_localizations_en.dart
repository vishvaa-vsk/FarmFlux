// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FarmFlux';

  @override
  String get welcomeMessage => 'Welcome to FarmFlux!';

  @override
  String get selectLanguage => 'Select Preferred Language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'Hindi';

  @override
  String get tamil => 'Tamil';

  @override
  String get telugu => 'Telugu';

  @override
  String get malayalam => 'Malayalam';

  @override
  String get home => 'Home';

  @override
  String get harvestBot => 'FluxCore';

  @override
  String get yourFarmingCompanion => 'Your farming companion';

  @override
  String get editProfileSettings => 'Edit Profile Settings';

  @override
  String get logout => 'Logout';

  @override
  String get loading => 'Loading...';

  @override
  String get errorLoadingUserData => 'Error loading user data';

  @override
  String get weatherForecast => 'Weather Forecast';

  @override
  String feelsLike(Object value) {
    return 'Feels Like: $value°C';
  }

  @override
  String wind(Object speed, Object dir) {
    return 'Wind: $speed km/h ($dir)';
  }

  @override
  String pressure(Object value) {
    return 'Pressure: $value mb';
  }

  @override
  String humidity(Object value) {
    return 'Humidity: $value%';
  }

  @override
  String visibility(Object value) {
    return 'Visibility: $value km';
  }

  @override
  String uvIndex(Object value) {
    return 'UV Index: $value';
  }

  @override
  String cloudCover(Object value) {
    return 'Cloud Cover: $value%';
  }

  @override
  String get threeDayForecast => '3-Day Forecast';

  @override
  String get thirtyDayForecast => '30-Day Forecast';

  @override
  String weatherForecastCalendar(Object startDate, Object endDate) {
    return 'Weather Forecast: $startDate - $endDate';
  }

  @override
  String get viewMore => 'View More';

  @override
  String get failedToLoadWeather => 'Failed to load weather data';

  @override
  String get farmingTip => 'Farming Tip';

  @override
  String get noFarmingTip => 'No farming tip available';

  @override
  String get recommendedCrop => 'Recommended Crop';

  @override
  String get noCropRecommendation => 'No crop recommendation available';

  @override
  String get locationServicesRequired => 'Location services are required to use this app.';

  @override
  String get failedToLoadInsights => 'Failed to load insights';

  @override
  String get sendOTP => 'Send OTP';

  @override
  String get verifyOTP => 'Verify OTP';

  @override
  String get name => 'Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterOTP => 'Enter OTP';

  @override
  String get pleaseEnterNameAndPhone => 'Please enter your name and phone number';

  @override
  String get invalidOTP => 'Invalid OTP';

  @override
  String get failedToSendOTP => 'Failed to send OTP. Please try again.';

  @override
  String get failedToSignIn => 'Failed to sign in';

  @override
  String get enableLocationServices => 'Enable Location Services';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get cancel => 'Cancel';

  @override
  String get nextContinue => 'CONTINUE';

  @override
  String get proceed => 'PROCEED';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get talkToHarvestBot => 'Talk to FluxCore';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get checkConnectionAndTryAgain => 'Please check your connection and try again';

  @override
  String get tryAgain => 'Try again';

  @override
  String get currentWeather => 'Current Weather';

  @override
  String get upcomingForecast => 'Upcoming Forecast';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get minTemperature => 'Min:';

  @override
  String get rain => 'Rain';

  @override
  String get viewAll => 'View All >';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get sunday => 'Sun';

  @override
  String get monday => 'Mon';

  @override
  String get tuesday => 'Tue';

  @override
  String get wednesday => 'Wed';

  @override
  String get thursday => 'Thu';

  @override
  String get friday => 'Fri';

  @override
  String get saturday => 'Sat';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get notifications => 'Notifications';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get about => 'About';

  @override
  String get helpAndSupportTitle => 'Help & Support';

  @override
  String get appFeaturesTitle => 'App Features';

  @override
  String get gettingStartedTitle => 'Getting Started';

  @override
  String get featuresAndUsageTitle => 'Features & Usage';

  @override
  String get contactSupportTitle => 'Contact Support';

  @override
  String get weatherUpdatesFeature => 'Weather Updates';

  @override
  String get weatherUpdatesDesc => 'Get real-time weather information including temperature, humidity, wind speed, and 3-day forecasts to plan your farming activities.';

  @override
  String get aiChatFeature => 'FluxCore AI Assistant';

  @override
  String get aiChatDesc => 'Chat with our AI-powered farming expert for personalized advice, crop recommendations, and answers to your agricultural questions.';

  @override
  String get multiLanguageFeature => 'Multi-Language Support';

  @override
  String get multiLanguageDesc => 'Use the app in your preferred language with support for English, Hindi, Tamil, Telugu, and Malayalam.';

  @override
  String get profileManagementFeature => 'Profile Management';

  @override
  String get profileManagementDesc => 'Manage your personal information, crop preferences, and location settings for personalized recommendations.';

  @override
  String get gettingStartedStep1 => '1. Set up your profile with your location and crop preferences';

  @override
  String get gettingStartedStep2 => '2. Allow location access for accurate weather updates';

  @override
  String get gettingStartedStep3 => '3. Explore weather forecasts and farming insights on the home screen';

  @override
  String get gettingStartedStep4 => '4. Chat with FluxCore for personalized farming advice';

  @override
  String get weatherUsageTitle => 'Using Weather Features';

  @override
  String get weatherUsageDesc => 'View current weather conditions, 3-day forecasts, and 30-day extended forecasts. Tap \'View All\' to see detailed calendar view.';

  @override
  String get aiChatUsageTitle => 'Using FluxCore';

  @override
  String get aiChatUsageDesc => 'Ask questions about crops, diseases, fertilizers, or any farming topic. The AI provides context-aware responses based on your conversation.';

  @override
  String get troubleshootingTitle => 'Troubleshooting';

  @override
  String get locationIssues => 'Location Issues';

  @override
  String get locationIssuesDesc => 'Ensure location services are enabled in your device settings for accurate weather data.';

  @override
  String get weatherNotLoading => 'Weather Not Loading';

  @override
  String get weatherNotLoadingDesc => 'Check your internet connection and location permissions. Pull down to refresh the home screen.';

  @override
  String get aiNotResponding => 'AI Not Responding';

  @override
  String get aiNotRespondingDesc => 'Ensure you have a stable internet connection. Try rephrasing your question if the AI doesn\'t understand.';

  @override
  String get contactSupportDesc => 'For additional help or to report issues, you can:';

  @override
  String get emailSupport => 'Email us at: support@farmflux.com';

  @override
  String get reportIssue => 'Report issues through the app feedback';

  @override
  String get visitWebsite => 'Visit our website: www.farmflux.com';

  @override
  String get appVersion => 'App Version: 2.0.1';

  @override
  String get lastUpdated => 'Last Updated: June 2025';

  @override
  String get uploadPlantImage => 'Upload Plant Image';

  @override
  String get uploadPlantImageDesc => 'Take a clear photo of your plant leaves or upload from gallery to detect pests and diseases.';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get analyzingForecast => 'Analyzing 30-day forecast...';

  @override
  String get analyzeImage => 'Analyze Image';

  @override
  String get detectionResults => 'Detection Results';

  @override
  String get noImageSelected => 'No image selected';

  @override
  String get uploadImageToGetStarted => 'Upload an image to get started';

  @override
  String get analysisComplete => 'Analysis Complete';

  @override
  String get noPestsDetected => 'No pests detected in this image';

  @override
  String get cropsHealthyMessage => 'Your crops appear healthy! Continue with regular monitoring and maintain good agricultural practices.';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get confidence => 'Confidence';

  @override
  String get diagnosis => 'Diagnosis';

  @override
  String get causalAgent => 'Causal Agent';

  @override
  String get analysisError => 'Analysis Error';

  @override
  String get analysisErrorDesc => 'Unable to analyze the image. Please try again with a clearer photo.';

  @override
  String get readyToAnalyze => 'Ready to analyze';

  @override
  String get uploadImageAndAnalyze => 'Upload an image and tap \"Analyze\" to detect pests and get recommendations';

  @override
  String get scanAgain => 'Scan Again';

  @override
  String get saveResult => 'Save Result';

  @override
  String get resultSaved => 'Result saved';

  @override
  String get uploadImageFirst => 'Upload an image first';

  @override
  String get tapAnalyzeToStart => 'Tap the analyze button to start detection';

  @override
  String get selectImageFromCameraOrGallery => 'Select an image from camera or gallery';

  @override
  String get failedToAnalyzeImage => 'Failed to analyze image';

  @override
  String get howToUse => 'How to use';

  @override
  String get takeClearPhotos => 'Take clear, well-lit photos of plant leaves';

  @override
  String get focusOnAffectedAreas => 'Focus on affected areas with visible symptoms';

  @override
  String get avoidBlurryImages => 'Avoid blurry or dark images';

  @override
  String get includeMultipleLeaves => 'Include multiple leaves if possible';

  @override
  String get gotIt => 'Got it';

  @override
  String get basedOn30DayForecast => 'Based on 30-day weather forecast';

  @override
  String get basedOnCurrentConditions => 'Based on current weather conditions';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get updateYourProfileDetails => 'Update your profile details';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterYourFullName => 'Enter your full name';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get enterYourEmailAddress => 'Enter your email address';

  @override
  String get enterYourPhoneNumber => 'Enter your phone number';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get changeProfilePicture => 'Change Profile Picture';

  @override
  String get remove => 'Remove';

  @override
  String get profileUpdatedSuccessfully => 'Your profile has been updated successfully.';

  @override
  String get mobileNumberUpdatedSuccessfully => 'Your mobile number has been updated successfully.';

  @override
  String get pleaseEnterVerificationCode => 'Please enter the verification code sent to your phone';

  @override
  String get otpAutoFilledSuccessfully => 'OTP auto-filled successfully!';

  @override
  String get otpWillBeFilledAutomatically => 'OTP will be filled automatically when SMS is received';

  @override
  String get didntReceiveOTP => 'Didn\'t receive OTP? ';

  @override
  String get resend => 'Resend';

  @override
  String resendInSeconds(Object seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get otpResentSuccessfully => 'OTP resent successfully';
}
