import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:farmflux/l10n/app_localizations.dart';
import 'package:farmflux/main.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/weather_provider.dart';
import '../../../../utils/performance_utils.dart';
import '../../../../utils/navigation_performance_tracker.dart';
import '../../../../utils/frame_drop_monitor.dart';
import '../../../../core/utils/avatar_utils.dart';
import '../../../../utils/startup_performance.dart';
import '../../../auth/presentation/pages/edit_profile_page.dart';
import '../../../auth/presentation/pages/phone_auth_page.dart';
import 'ai_chat_page.dart';
import 'extended_forecast_page.dart';
import 'about_page.dart';

class FarmFluxApp extends StatelessWidget {
  const FarmFluxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.primaryGreen),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin, NavigationPerformanceMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;

  // Cached screen instances for performance
  Widget? _homeScreen;

  // Navigation throttling to prevent rapid taps
  bool _isNavigating = false;

  // Performance optimization: Lazy load screens only when needed
  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return _homeScreen ??= RepaintBoundary(
          key: const ValueKey('home'),
          child: const HomeScreen(),
        );
      default:
        return _homeScreen ??= RepaintBoundary(
          key: const ValueKey('home'),
          child: const HomeScreen(),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Start frame drop monitoring in debug mode
    if (kDebugMode) {
      FrameDropMonitor.startMonitoring();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();

    // Stop frame drop monitoring
    if (kDebugMode) {
      FrameDropMonitor.stopMonitoring();
      NavigationPerformanceTracker.printPerformanceSummary();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Set system UI style only once, not on every build
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _getScreen(0), // Home
        ],
      ),
      bottomNavigationBar: _buildOptimizedBottomNavigationBar(localizations),
    );
  }

  Widget _buildOptimizedBottomNavigationBar(AppLocalizations localizations) {
    return RepaintBoundary(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 25,
              offset: Offset(0, -8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 66, // Increased height to accommodate larger icons and text
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildOptimizedNavItem(
                    icon: Icons.home_filled,
                    label: localizations.home,
                    index: 0,
                    isSelected: _currentIndex == 0,
                  ),
                ),
                Expanded(
                  child: _buildOptimizedNavItem(
                    icon: Icons.smart_toy_rounded,
                    label: localizations.harvestBot,
                    index: 1,
                    isSelected: false, // Never selected since it navigates away
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptimizedNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return RepaintBoundary(
      child: InkWell(
        onTap: () {
          // Use navigation utility throttling for better performance
          if (NavigationUtils.canNavigate(
            throttleDuration: const Duration(milliseconds: 200),
          )) {
            _handleNavigation(index);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            minHeight: 54,
            maxHeight: 58, // Increased height constraint for larger content
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Remove Transform.scale to prevent overflow, use size change instead
              Icon(
                icon,
                color:
                    isSelected
                        ? AppConstants.primaryGreen
                        : const Color(0xFF9E9E9E),
                size:
                    isSelected
                        ? 26
                        : 24, // Increased icon sizes for better visibility
              ),
              const SizedBox(
                height: 3,
              ), // Slightly more spacing for better readability
              // Optimize text rendering with height constraint
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11, // Increased font size for better readability
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color:
                        isSelected
                            ? AppConstants.primaryGreen
                            : const Color(0xFF9E9E9E),
                    height: 1.1, // Slightly more relaxed line height
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  softWrap: false, // Prevent text wrapping
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    // Throttle navigation to prevent rapid taps and frame drops
    if (_isNavigating) return;

    // Track frame drops during navigation
    FrameDropMonitor.markHeavyOperation('Navigation tap to index $index');

    // Track navigation performance
    trackNavigation('navigation_tap', () {
      // Only handle FluxCore navigation since we only have Home screen
      if (index == 1) {
        // Handle FluxCore navigation separately
        _isNavigating = true;
        NavigationPerformanceTracker.startNavigation('fluxcore_navigation');

        Navigator.push(
          context,
          NavigationUtils.buildOptimizedRoute(const AIChatPage()),
        ).then((_) {
          NavigationPerformanceTracker.endNavigation('fluxcore_navigation');
          _isNavigating = false;
        });
        return;
      }

      // For any other index, ensure we stay on home (index 0)
      if (_currentIndex != 0) {
        _isNavigating = true;
        NavigationPerformanceTracker.startNavigation('tab_switch_0');

        // Track the setState operation that might cause frame drops
        FrameDropMonitor.trackOperation('setState_navigation', () {
          setState(() {
            _currentIndex = 0;
          });
        });

        // Release navigation lock after UI update completes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          NavigationPerformanceTracker.endNavigation('tab_switch_0');
          _isNavigating = false;
        });
      }
    });
  }
}

/// The home page of the FarmFlux application.
///
/// This page displays weather data, agricultural insights, and navigation
/// options. It also includes a drawer for accessing profile settings and
/// changing the app's language.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Added GlobalKey

  bool _isLocationEnabled = true;
  bool _hasRequestedLocationPermission = false;
  @override
  void initState() {
    super.initState();
    // Add app lifecycle observer
    WidgetsBinding.instance.addObserver(this);
    // Mark start of HomeScreen initialization
    StartupPerformance.markStart('HomeScreen.initState');

    // IMMEDIATE completion to prevent blocking - defer ALL operations
    StartupPerformance.markEnd('HomeScreen.initState');

    // Use EXTREME deferral to ensure UI renders first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Wait for UI to be fully rendered before starting ANY operations
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          // Only start after UI is completely stable
          _initializeLocationServicesBackground();
        }
      });
    });
  }

  /// Initialize location services completely in background to prevent any startup blocking
  void _initializeLocationServicesBackground() {
    // Run in background with extreme deferral
    Future.microtask(() {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          StartupPerformance.markStart('HomeScreen.locationServices');
          _checkLocationServicesAsync();
        }
      });
    });
  }

  @override
  void dispose() {
    // Remove app lifecycle observer
    WidgetsBinding.instance.removeObserver(this);
    // Cancel any ongoing operations or listeners here if needed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // When app resumes, check location services again
    if (state == AppLifecycleState.resumed) {
      _checkLocationServices();
    }
  }

  /// Async version of location services check to prevent blocking
  Future<void> _checkLocationServicesAsync() async {
    // Run in background microtask to avoid blocking UI
    Future.microtask(() async {
      try {
        await _checkLocationServices();
      } catch (e) {
        debugPrint('Location services check error: $e');
        if (mounted) {
          setState(() {
            _isLocationEnabled = false;
          });
        }
        StartupPerformance.markEnd('HomeScreen.locationServices');
      }
    });
  }

  Future<void> _checkLocationServices() async {
    try {
      // Batch all location checks together to reduce overhead
      final List<Future> locationChecks = [
        Geolocator.checkPermission(),
        Geolocator.isLocationServiceEnabled(),
      ];

      StartupPerformance.markStart('HomeScreen.locationPermissionCheck');
      final results = await Future.wait(locationChecks);
      StartupPerformance.markEnd('HomeScreen.locationPermissionCheck');

      var permission = results[0] as LocationPermission;
      final isServiceEnabled = results[1] as bool;

      // If permission is denied, request it
      if (permission == LocationPermission.denied) {
        if (!_hasRequestedLocationPermission) {
          _hasRequestedLocationPermission = true;
          permission = await Geolocator.requestPermission();
        }
      }

      // Check if permission is still denied after request
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _isLocationEnabled = false;
          });
        }
        // Show dialog to guide user to settings if permission is permanently denied
        if (permission == LocationPermission.deniedForever) {
          _showLocationPermissionDialog();
        }
        StartupPerformance.markEnd('HomeScreen.locationServices');
        return;
      }

      if (mounted) {
        setState(() {
          _isLocationEnabled =
              isServiceEnabled &&
              (permission == LocationPermission.always ||
                  permission == LocationPermission.whileInUse);
        });
      }
      if (_isLocationEnabled) {
        // Use extreme deferral to ensure weather fetching doesn't block startup
        Future.microtask(() {
          // Add significant delay to ensure UI is completely rendered
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              _fetchWeatherAndInsightsAsync();
            }
          });
        });
      } else if (!isServiceEnabled && mounted) {
        // Show dialog only after UI is ready - for location services
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            _showLocationServiceDialog();
          }
        });
      }
      StartupPerformance.markEnd('HomeScreen.locationServices');
    } catch (e) {
      // Handle errors gracefully
      debugPrint('Location services check error: $e');
      if (mounted) {
        setState(() {
          _isLocationEnabled = false;
        });
      }
      StartupPerformance.markEnd('HomeScreen.locationServices');
    }
  }

  void _showLocationPermissionDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(loc.enableLocationServices),
          content: Text(
            '${loc.locationServicesRequired}\n\nLocation permission is permanently denied. Please enable it in app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(loc.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Geolocator.openAppSettings();
              },
              child: Text(loc.openSettings),
            ),
          ],
        );
      },
    );
  }

  void _showLocationServiceDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(loc.enableLocationServices),
          content: Text(loc.locationServicesRequired),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(loc.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Geolocator.openLocationSettings();
              },
              child: Text(loc.openSettings),
            ),
          ],
        );
      },
    );
  }

  /// Completely async weather fetching to prevent any blocking
  Future<void> _fetchWeatherAndInsightsAsync() async {
    // Run in background with additional delay to avoid any potential blocking
    Future.microtask(() async {
      // Add another delay layer to ensure complete UI stability
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        StartupPerformance.markStart('HomeScreen.weatherFetch');
        final weatherProvider = Provider.of<WeatherProvider>(
          context,
          listen: false,
        );

        try {
          await weatherProvider.fetchWeatherAndInsights();
          StartupPerformance.markEnd('HomeScreen.weatherFetch');
        } catch (e) {
          debugPrint('Weather fetch error: $e');
          StartupPerformance.markEnd('HomeScreen.weatherFetch');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return RepaintBoundary(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppConstants.backgroundGray,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            loc.appTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryGreen,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black54),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: FutureBuilder<String>(
                future: AvatarUtils.getAvatarWithFallback(
                  userId:
                      FirebaseAuth.instance.currentUser?.phoneNumber ?? 'guest',
                ),
                builder: (context, avatarSnapshot) {
                  final avatarUrl =
                      avatarSnapshot.data ??
                      'https://avatar.iran.liara.run/public/1';

                  return GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppConstants.primaryGreen,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          avatarUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 40,
                              height: 40,
                              color: AppConstants.dividerGray,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppConstants.primaryGreen,
                                  ),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: AppConstants.primaryGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        drawer: _buildModernDrawer(context, loc),
        body:
            _isLocationEnabled
                ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWeatherCard(context),
                      const SizedBox(height: 16),
                      _buildInsightsSection(context),
                    ],
                  ),
                )
                : Center(
                  child: Text(
                    loc.locationServicesRequired,
                    textAlign: TextAlign.center,
                  ),
                ),
      ),
    );
  }

  Widget _buildWeatherCard(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        if (weatherProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final weather = weatherProvider.weatherData;
        if (weather == null) {
          return Center(child: Text(loc.failedToLoadWeather));
        }

        final current = weather['current'];
        final forecast = weather['forecast'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Weather Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppConstants.primaryGradient,
                borderRadius: BorderRadius.circular(
                  AppConstants.largeBorderRadius,
                ),
                boxShadow: AppConstants.primaryShadow,
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.currentWeather,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${current['temperature']}°C',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              current['condition'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _getWeatherIcon(current['condition']),
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 80,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.feelsLike(current['feelslike_c']),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              loc.humidity(current['humidity']),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              loc.cloudCover(current['cloud']),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              loc.pressure(current['pressure_mb']),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              loc.wind(
                                current['windSpeed'],
                                current['wind_dir'],
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              loc.uvIndex(current['uv']),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Upcoming Forecast Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    loc.upcomingForecast,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    // PERFORMANCE: Preload some forecast data before navigation
                    final weatherProvider = Provider.of<WeatherProvider>(
                      context,
                      listen: false,
                    );

                    // Start preloading 3-day forecast immediately for faster extended forecast page
                    if (weatherProvider.futureWeather == null ||
                        weatherProvider.futureWeather!.isEmpty) {
                      weatherProvider.fetchExtendedForecast('auto', 3);
                    }

                    // Navigate to extended forecast page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExtendedForecastPage(),
                      ),
                    );
                  },
                  child: Text(
                    loc.viewAll,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppConstants.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildForecast(context, forecast),
          ],
        );
      },
    );
  }

  Widget _buildForecast(BuildContext context, List<dynamic> forecast) {
    final loc = AppLocalizations.of(context)!;
    final today = DateTime.now();

    // Filter out today's data and show only future dates
    final todayDateOnly = DateTime(today.year, today.month, today.day);
    final futureForecasts =
        forecast.where((day) {
          try {
            final forecastDate = DateTime.parse(day['date']);
            final forecastDateOnly = DateTime(
              forecastDate.year,
              forecastDate.month,
              forecastDate.day,
            );
            return forecastDateOnly.isAfter(todayDateOnly);
          } catch (e) {
            return false;
          }
        }).toList();

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:
            futureForecasts.length > 3
                ? 3
                : futureForecasts.length, // Limit to 3 future days max
        itemBuilder: (context, index) {
          final day = futureForecasts[index];
          String dayName;

          try {
            final forecastDate = DateTime.parse(day['date']);
            final forecastDateOnly = DateTime(
              forecastDate.year,
              forecastDate.month,
              forecastDate.day,
            );
            final tomorrow = DateTime(today.year, today.month, today.day + 1);
            final tomorrowDateOnly = DateTime(
              tomorrow.year,
              tomorrow.month,
              tomorrow.day,
            );

            if (forecastDateOnly.isAtSameMomentAs(tomorrowDateOnly)) {
              dayName = loc.tomorrow;
            } else {
              // Get the month name and day
              final monthNumber = forecastDate.month;
              final dayNumber = forecastDate.day;
              final monthNames = [
                '',
                loc.january,
                loc.february,
                loc.march,
                loc.april,
                loc.may,
                loc.june,
                loc.july,
                loc.august,
                loc.september,
                loc.october,
                loc.november,
                loc.december,
              ];
              final monthName =
                  monthNumber <= 12 ? monthNames[monthNumber] : 'January';
              dayName = '$monthName ${dayNumber.toString().padLeft(2, '0')}';
            }
          } catch (e) {
            dayName = day['date'];
          }
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    dayName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${day['temperature']['max']}°C',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        day['rainChance'] > 50
                            ? Icons.water_drop
                            : Icons.wb_sunny,
                        size: 14,
                        color:
                            day['rainChance'] > 50
                                ? Colors.blue
                                : Colors.orange,
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          '${day['rainChance']}% ${loc.rain}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    '${loc.minTemperature} ${day['temperature']['min']}°C',
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInsightsSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        // Show loading only for main weather data, not for insights
        if (weatherProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final insights = weatherProvider.insights;
        final isInsightsLoading = weatherProvider.isInsightsLoading;

        // Show skeleton loading for insights while weather data is available
        if (insights == null && isInsightsLoading) {
          return _buildInsightsSkeletonLoader();
        }

        // Show error state only if insights failed and not loading
        if (insights == null && !isInsightsLoading) {
          return Column(
            children: [
              _buildInsightsSkeletonLoader(showError: true),
              const SizedBox(height: 8),
              Text(
                loc.failedToLoadInsights,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }

        return Column(
          children: [
            // Farming Tip Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryGreen.withValues(
                            alpha: 0.1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lightbulb,
                          color: AppConstants.primaryGreen,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        loc.farmingTip,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    insights?['farmingTip'] ?? loc.noFarmingTip,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16), // Recommended Crop Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryGreen.withValues(
                            alpha: 0.1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.eco,
                          color: AppConstants.primaryGreen,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.recommendedCrop,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              loc.basedOnCurrentConditions,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    insights?['cropRecommendation'] ?? loc.noCropRecommendation,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build skeleton loader for insights while AI is processing
  Widget _buildInsightsSkeletonLoader({bool showError = false}) {
    return Column(
      children: [
        // Farming Tip Skeleton
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          showError
                              ? Colors.red.withValues(alpha: 0.1)
                              : AppConstants.primaryGreen.withValues(
                                alpha: 0.1,
                              ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      showError ? Icons.error_outline : Icons.lightbulb,
                      color: showError ? Colors.red : AppConstants.primaryGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmer(height: 18, width: 120),
                        const SizedBox(height: 4),
                        _buildShimmer(height: 12, width: 200),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildShimmer(height: 16, width: double.infinity),
              const SizedBox(height: 6),
              _buildShimmer(height: 16, width: double.infinity),
              const SizedBox(height: 6),
              _buildShimmer(height: 16, width: 250),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Crop Recommendation Skeleton
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          showError
                              ? Colors.red.withValues(alpha: 0.1)
                              : AppConstants.materialGreen.withValues(
                                alpha: 0.1,
                              ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      showError ? Icons.error_outline : Icons.eco,
                      color:
                          showError ? Colors.red : AppConstants.materialGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmer(height: 18, width: 150),
                        const SizedBox(height: 4),
                        _buildShimmer(height: 12, width: 180),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildShimmer(height: 16, width: double.infinity),
              const SizedBox(height: 6),
              _buildShimmer(height: 16, width: double.infinity),
              const SizedBox(height: 6),
              _buildShimmer(height: 16, width: 280),
            ],
          ),
        ),
      ],
    );
  }

  /// Build shimmer effect for skeleton loading
  Widget _buildShimmer({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: const SizedBox(),
    );
  }

  // Helper function to get weather icon based on condition
  IconData _getWeatherIcon(String condition) {
    final conditionLower = condition.toLowerCase();

    if (conditionLower.contains('sunny') || conditionLower.contains('clear')) {
      return Icons.wb_sunny;
    } else if (conditionLower.contains('rain') ||
        conditionLower.contains('shower')) {
      return Icons.water_drop;
    } else if (conditionLower.contains('storm') ||
        conditionLower.contains('thunder')) {
      return Icons.thunderstorm;
    } else if (conditionLower.contains('snow') ||
        conditionLower.contains('blizzard')) {
      return Icons.ac_unit;
    } else if (conditionLower.contains('fog') ||
        conditionLower.contains('mist')) {
      return Icons.foggy;
    } else if (conditionLower.contains('wind')) {
      return Icons.air;
    } else if (conditionLower.contains('cloud') ||
        conditionLower.contains('overcast') ||
        conditionLower.contains('partly')) {
      return Icons.cloud;
    } else {
      return Icons.wb_cloudy; // Default icon
    }
  }

  Widget _buildModernDrawer(BuildContext context, AppLocalizations loc) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              // Profile Section
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: FutureBuilder<DocumentSnapshot>(
                  future:
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.phoneNumber)
                          .get(),
                  builder: (context, snapshot) {
                    String userName = 'Guest User';
                    String userPhone = '';

                    if (snapshot.hasData && snapshot.data!.exists) {
                      final userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      userName = userData['name'] ?? 'User';
                      userPhone = userData['phoneNumber'] ?? '';
                    }

                    // Use user's phone number as the seed for consistent avatar
                    final userId =
                        FirebaseAuth.instance.currentUser?.phoneNumber ??
                        'guest';

                    return Column(
                      children: [
                        // Avatar with green border matching reference
                        FutureBuilder<String>(
                          future: AvatarUtils.getAvatarWithFallback(
                            userId: userId,
                          ),
                          builder: (context, avatarSnapshot) {
                            final avatarUrl =
                                avatarSnapshot.data ??
                                'https://avatar.iran.liara.run/public/1';

                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppConstants.primaryGreen,
                                  width: 3,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.network(
                                  avatarUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      color: AppConstants.dividerGray,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppConstants.primaryGreen,
                                              ),
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      color: AppConstants.dividerGray,
                                      child: const Icon(
                                        Icons.person,
                                        size: 40,
                                        color: AppConstants.mediumGray,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        // Online indicator (green dot)
                        Transform.translate(
                          offset: const Offset(25, -25),
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppConstants.primaryGreen,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // User Name
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.textDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (userPhone.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            userPhone,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppConstants.textGray,
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ), // Divider
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: AppConstants.dividerGray,
              ),

              // Separator after Dark Mode
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                color: AppConstants.dividerGray,
              ),

              // Menu Items
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildSimpleDrawerItem(
                        icon: Icons.settings_outlined,
                        title: loc.editProfileSettings,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfilePage(),
                            ),
                          );
                        },
                      ),
                      _buildSimpleDrawerItem(
                        icon: Icons.language_outlined,
                        title: loc.changeLanguage,
                        onTap: () async {
                          Navigator.pop(context);
                          await _showLanguageSelector(context, loc);
                        },
                      ),
                      _buildSimpleDrawerItem(
                        icon: Icons.info_outline,
                        title: loc.about,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Separator line before logout
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(bottom: 16),
                        color: const Color(0xFFF0F0F0),
                      ),

                      _buildSimpleDrawerItem(
                        icon: Icons.logout,
                        title: loc.logout,
                        textColor: const Color(0xFFEF4444),
                        iconColor: const Color(0xFFEF4444),
                        onTap: () async {
                          try {
                            final navigator = Navigator.of(context);
                            await FirebaseAuth.instance.signOut();
                            if (mounted) {
                              navigator.pop();
                              navigator.pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const PhoneAuthPage(),
                                ),
                                (route) => false,
                              );
                            }
                          } catch (e) {
                            debugPrint('Error during logout: $e');
                          }
                        },
                      ),
                      const SizedBox(height: 24), // Extra bottom padding
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleDrawerItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
    Color? textColor,
    Color? iconColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: iconColor ?? textColor ?? const Color(0xFF6B7280),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor ?? const Color(0xFF1F1F1F),
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLanguageSelector(
    BuildContext context,
    AppLocalizations loc,
  ) async {
    // Store provider reference before any async operations
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    final languages = [
      {
        'code': 'en',
        'label': loc.english,
        'firstLetter': 'Aa',
        'fontFamily': 'Poppins',
      },
      {
        'code': 'hi',
        'label': loc.hindi,
        'firstLetter': 'हिं',
        'fontFamily': 'NotoSansDevanagari',
      },
      {
        'code': 'ta',
        'label': loc.tamil,
        'firstLetter': 'த',
        'fontFamily': 'NotoSansTamil',
      },
      {
        'code': 'te',
        'label': loc.telugu,
        'firstLetter': 'తె',
        'fontFamily': 'NotoSansTelugu',
      },
      {
        'code': 'ml',
        'label': loc.malayalam,
        'firstLetter': 'മ',
        'fontFamily': 'NotoSansMalayalam',
      },
    ];

    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final greyTile = const Color(0xFFF3F3F3);
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    loc.appTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 3, top: 2),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  loc.selectLanguage,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 2.2,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final lang in languages)
                    _LanguageTileModal(
                      label: lang['label'] as String,
                      firstLetter: lang['firstLetter'] as String,
                      fontFamily: lang['fontFamily'] as String,
                      onTap:
                          () => Navigator.pop(context, lang['code'] as String),
                      accent: AppConstants.primaryGreen,
                      grey: greyTile,
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      final rootState = farmFluxAppKey.currentState;
      if (rootState != null) {
        try {
          await (rootState as dynamic).setLocale(selected);
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              systemNavigationBarColor: Color(0xFFF6F8F7),
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
          );
          if (mounted) {
            await provider.fetchWeatherAndInsights();
          }
        } catch (e) {
          debugPrint('Error setting locale: $e');
        }
      }
    }
  }
}

class _LanguageTileModal extends StatelessWidget {
  final String label;
  final String firstLetter;
  final String fontFamily;
  final VoidCallback onTap;
  final Color accent;
  final Color grey;
  const _LanguageTileModal({
    required this.label,
    required this.firstLetter,
    required this.fontFamily,
    required this.onTap,
    required this.accent,
    required this.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: grey,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    firstLetter,
                    style: TextStyle(
                      color: accent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontFamily,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
