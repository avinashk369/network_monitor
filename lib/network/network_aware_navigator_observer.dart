import 'package:flutter/material.dart';
import 'package:network_monitor_cp/network/network_state.dart';
import 'package:network_monitor_cp/network/widget/overlay_widget.dart';
import 'network_monitor.dart';

/// Enum representing the type of error display.
enum ErrorType {
  /// Display the error as an overlay.
  overlay,

  /// Display the error as a widget.
  widget,
}

/// A custom [NavigatorObserver] that displays a widget or overlay when the
/// device's network connection changes.
///
/// This observer listens to changes in the network state using [NetworkMonitor]
/// and displays a custom widget or overlay when the connection is lost.  It
/// supports two modes of operation, controlled by the [errorType] property:
/// displaying an overlay or displaying a widget.
class NetworkAwareNavigatorObserver extends NavigatorObserver {
  /// The [OverlayEntry] used to display the network status overlay.
  OverlayEntry? _networkOverlay;

  /// The widget to display when the network connection is lost and
  /// [errorType] is [ErrorType.widget].
  ///
  /// This property is required when [errorType] is set to [ErrorType.widget].
  final Widget? networkStatusScreen;

  /// The type of error display to use.
  final ErrorType errorType;

  NetworkAwareNavigatorObserver._internal(
      this.networkStatusScreen, this.errorType) {
    if (errorType == ErrorType.widget) {
      assert(networkStatusScreen != null,
          'networkStatusScreen must be provided when errorType is ErrorType.widget.');
    }
  }

  static NetworkAwareNavigatorObserver? _instance;

  /// Factory constructor for creating the singleton instance of
  /// [NetworkAwareNavigatorObserver].
  ///
  /// The [networkStatusScreen] parameter is required when [errorType] is
  /// [ErrorType.widget]. The [errorType] parameter defaults to [ErrorType.overlay].
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

  /// Called after a route has been pushed.
  ///
  /// This method is overridden to check the network status and display the
  /// appropriate widget or overlay if the connection is lost.
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _checkNetworkStatus();
  }

  /// Called after a route has been popped.
  ///
  /// This method is overridden to check the network status and hide the
  /// overlay or widget if the connection has been restored.
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _checkNetworkStatus();
  }

  /// Checks the current network status and displays or hides the network
  /// status screen accordingly.
  ///
  /// This method listens to changes in the network state using [NetworkMonitor]
  /// and calls [_showNetworkStatusScreen] or [_hideNetworkStatusScreen] based
  /// on the current state.
  void _checkNetworkStatus() {
    try {
      NetworkMonitor().state.distinct().listen((state) {
        if (state != NetworkState.connected) {
          _showNetworkStatusScreen(state, errorType);
        } else {
          _hideNetworkStatusScreen();
        }
      });
    } catch (_) {}
  }

  /// Displays the network status screen.
  ///
  /// If [errorType] is [ErrorType.overlay], an [OverlayEntry] is created and
  /// inserted into the navigator's overlay. If [errorType] is [ErrorType.widget],
  /// the provided [networkStatusScreen] widget is used.
  void _showNetworkStatusScreen(NetworkState state, ErrorType errorType) {
    if (_networkOverlay == null) {
      _networkOverlay = OverlayEntry(
        builder: (context) => errorType == ErrorType.overlay
            ? OverlayWidget(state: state)
            : networkStatusScreen!,
      );

      navigator?.overlay?.insert(_networkOverlay!);
    }
  }

  /// Hides the network status screen.
  ///
  /// This method removes the [_networkOverlay] from the navigator's overlay
  /// and sets it to null.
  void _hideNetworkStatusScreen() {
    _networkOverlay?.remove();
    _networkOverlay = null;
  }

  /// Disposes of the [NetworkAwareNavigatorObserver].
  ///
  /// This method hides the network status screen if it is currently visible.
  void dispose() {
    _hideNetworkStatusScreen();
  }
}
