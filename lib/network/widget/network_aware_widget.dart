import 'package:flutter/material.dart';
import 'package:network_monitor_cp/network/network_monitor.dart';
import 'package:network_monitor_cp/network/network_state.dart';

/// A widget that displays its child and optionally a network status bar
/// based on the current network state.
///
/// This widget listens to changes in the network state using [NetworkMonitor]
/// and rebuilds itself when the network state changes.  It can display a
/// default status bar or use a custom builder function to create the status
/// display.
class NetworkAwareWidget extends StatelessWidget {
  /// The child widget to display.
  final Widget child;

  /// An optional builder function to create a custom network status widget.
  ///
  /// If this function is provided, it will be used to build the network status
  /// widget instead of the default status bar. The function takes the
  /// [BuildContext] and the current [NetworkState] as arguments.  It should
  /// return the widget to display for the given network state.
  final Widget Function(BuildContext, NetworkState)? statusBuilder;

  /// Creates a new [NetworkAwareWidget].
  ///
  /// The [child] parameter is required and represents the main content of the
  /// widget. The [statusBuilder] parameter is optional and allows for
  /// customizing the network status display.
  const NetworkAwareWidget({
    super.key,
    required this.child,
    this.statusBuilder,
  });

  /// Builds the widget based on the current network state.
  ///
  /// This method uses a [StreamBuilder] to listen to changes in the network
  /// state from [NetworkMonitor].  It then either uses the provided
  /// [statusBuilder] function or the default status bar widget to display
  /// the network status information.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NetworkState>(
      stream: NetworkMonitor().state,
      builder: (context, snapshot) {
        final state = snapshot.data ?? NetworkState.connected;

        if (statusBuilder != null) {
          return statusBuilder!(context, state);
        }

        return Stack(
          children: [
            child,
            if (state != NetworkState.connected) _buildDefaultStatusBar(state),
          ],
        );
      },
    );
  }

  /// Builds the default network status bar widget.
  ///
  /// This method creates a [Positioned] widget containing a [Material] widget
  /// with a colored container and a text message indicating the current
  /// network state.
  Widget _buildDefaultStatusBar(NetworkState state) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        child: Container(
          padding: const EdgeInsets.all(8),
          color: state == NetworkState.disconnected
              ? Colors.red.withValues(alpha: 0.8)
              : Colors.orange.withValues(alpha: 0.8),
          child: Text(
            state == NetworkState.disconnected
                ? 'No Network Connection'
                : 'No Internet Connection',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
