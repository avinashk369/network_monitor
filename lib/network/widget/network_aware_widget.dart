import 'package:flutter/material.dart';
import 'package:network_monitor/network/network_monitor.dart';
import 'package:network_monitor/network/network_state.dart';

class NetworkAwareWidget extends StatelessWidget {
  final Widget child;
  final Widget Function(BuildContext, NetworkState)? statusBuilder;

  const NetworkAwareWidget({
    super.key,
    required this.child,
    this.statusBuilder,
  });

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

  Widget _buildDefaultStatusBar(NetworkState state) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        child: Container(
          padding: const EdgeInsets.all(8),
          color: state == NetworkState.disconnected
              ? Colors.red.withOpacity(0.8)
              : Colors.orange.withOpacity(0.8),
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
