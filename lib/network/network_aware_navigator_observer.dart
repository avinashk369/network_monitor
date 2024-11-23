import 'package:flutter/material.dart';
import 'package:network_monitor_cp/network/network_state.dart';
import 'package:network_monitor_cp/network/widget/overlay_widget.dart';
import 'network_monitor.dart';

enum ErrorType { overlay, widget }

class NetworkAwareNavigatorObserver extends NavigatorObserver {
  OverlayEntry? _networkOverlay;
  final Widget? networkStatusScreen;
  final ErrorType errorType;

  NetworkAwareNavigatorObserver._internal(
      this.networkStatusScreen, this.errorType) {
    if (errorType == ErrorType.widget) {
      assert(networkStatusScreen != null,
          'networkStatusScreen must be provided when errorType is ErrorType.widget.');
    }
  }

  static NetworkAwareNavigatorObserver? _instance;

  factory NetworkAwareNavigatorObserver(
      {Widget? networkStatusScreen, ErrorType errorType = ErrorType.overlay}) {
    // Enforce the widget requirement for `ErrorType.widget` during runtime
    if (errorType == ErrorType.widget) {
      assert(networkStatusScreen != null,
          'networkStatusScreen is required when errorType is ErrorType.widget.');
    }
    _instance ??=
        NetworkAwareNavigatorObserver._internal(networkStatusScreen, errorType);
    return _instance!;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _checkNetworkStatus();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _checkNetworkStatus();
  }

  void _checkNetworkStatus() {
    try {
      NetworkMonitor().state.listen((state) {
        if (state != NetworkState.connected) {
          _showNetworkStatusScreen(state, errorType);
        } else {
          _hideNetworkStatusScreen();
        }
      });
    } catch (_) {}
  }

  void _showNetworkStatusScreen(NetworkState state, ErrorType errorType) {
    if (_networkOverlay == null) {
      _networkOverlay = OverlayEntry(
        builder: (context) => errorType == ErrorType.overlay
            ? OverlayWidget(state: state)
            : networkStatusScreen!,
      );

      if (navigator != null && navigator!.overlay != null) {
        navigator!.overlay!.insert(_networkOverlay!);
      }
    }
  }

  void _hideNetworkStatusScreen() {
    _networkOverlay?.remove();
    _networkOverlay = null;
  }

  void dispose() {
    _hideNetworkStatusScreen();
  }
}
