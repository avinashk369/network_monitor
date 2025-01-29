import 'dart:async';

import 'package:network_monitor_cp/network/network_monitor.dart';
import 'package:network_monitor_cp/network/network_state.dart';

/// A mixin that provides network awareness capabilities to classes that use it.
///
/// This mixin simplifies the process of listening to network state changes
/// and provides convenient methods for initializing and disposing of the
/// network monitoring subscription.
mixin NetworkAwareMixin {
  /// A [StreamSubscription] that listens to changes in the network state.
  StreamSubscription<NetworkState>? _subscription;

  /// Initializes network monitoring and listens for changes in the network state.
  ///
  /// The [onStateChanged] callback function is called whenever the network
  /// state changes. This allows the class using the mixin to react to network
  /// connectivity changes in real-time.
  ///
  ///

  /// Example:
  /// ```dart
  /// class MyWidget extends StatefulWidget {
  ///   @override
  ///   _MyWidgetState createState() => _MyWidgetState();
  /// }
  ///
  /// class _MyWidgetState extends State<MyWidget> with NetworkAwareMixin {
  ///   @override
  ///   void initState() {
  ///     super.initState();
  ///     initializeNetworkMonitoring((NetworkState state) {
  ///       if (state == NetworkState.online) {
  ///         // Network is online, do something
  ///       } else {
  ///         // Network is offline, do something else
  ///       }
  ///     });
  ///   }
  ///
  ///   @override
  ///   void dispose() {
  ///     disposeNetworkMonitoring();
  ///     super.dispose();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     // ... your widget build method
  ///   }
  /// }
  /// ```
  ///
  /// See also:
  ///   * [NetworkState], the enum representing the current network state.
  ///   * [NetworkMonitor], the class responsible for monitoring network changes.

  void initializeNetworkMonitoring(void Function(NetworkState) onStateChanged) {
    _subscription = NetworkMonitor().state.listen(onStateChanged);
  }

  /// Disposes of the network monitoring subscription.
  ///
  /// This method cancels the [_subscription] to prevent memory leaks and ensure
  /// that the class no longer listens for network state changes.  It should
  /// be called when the class is no longer needed, typically in the `dispose`
  /// method of a StatefulWidget or equivalent lifecycle hook.
  void disposeNetworkMonitoring() {
    _subscription?.cancel();
    _subscription = null;
  }
}
