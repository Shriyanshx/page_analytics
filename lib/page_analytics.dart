library page_analytics;
// File: lib/src/page_analytics.dart

import 'package:flutter/material.dart';

typedef PageStartCallback = void Function(
    String pageName, Map<String, dynamic> pageData);
typedef PageStopCallback = void Function(
    String pageName, String timeSpent, Map<String, dynamic> pageData);
typedef RouteBuilder = Route<dynamic> Function(RouteSettings settings);

class PageAnalytics with WidgetsBindingObserver {
  final PageStartCallback onPageStart;
  final PageStopCallback onPageStop;
  final List<String> restrictedScreens;
  final RouteBuilder routeBuilder;

  DateTime? _pageStartTime;
  String? _currentPageName;
  String? _previousPageName;
  Map<String, dynamic> _currentPageData = {};

  PageAnalytics({
    required this.onPageStart,
    required this.onPageStop,
    required this.routeBuilder,
    this.restrictedScreens = const [],
  }) {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _stopCurrentPage(isAppPaused: true);
    } else if (state == AppLifecycleState.resumed) {
      _startNewPage(_currentPageName, _currentPageData);
    }
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final String routeName = settings.name ?? '';
    final Map<String, dynamic> arguments =
        settings.arguments as Map<String, dynamic>? ?? {};

    if (_shouldTrackPage(routeName)) {
      _stopCurrentPage();
      _startNewPage(routeName, arguments);
    }

    // Use the provided routeBuilder to generate and return the actual route
    return routeBuilder(settings);
  }

  void _startNewPage(String? pageName, Map<String, dynamic> pageData) {
    if (pageName == null) return;

    _previousPageName = _currentPageName;
    _currentPageName = pageName;
    _currentPageData = pageData;
    _pageStartTime = DateTime.now();

    onPageStart(_currentPageName!, _currentPageData);
  }

  void _stopCurrentPage({bool isAppPaused = false}) {
    if (_currentPageName == null || _pageStartTime == null) return;

    final stopTime = DateTime.now();
    final duration = stopTime.difference(_pageStartTime!);
    final timeSpent = duration.inSeconds.toString();

    onPageStop(
      isAppPaused
          ? _currentPageName!
          : (_previousPageName ?? _currentPageName!),
      timeSpent,
      _currentPageData,
    );

    if (!isAppPaused) {
      _pageStartTime = null;
      _previousPageName = _currentPageName;
    }
  }

  bool _shouldTrackPage(String routeName) {
    return !restrictedScreens.contains(routeName);
  }
}
