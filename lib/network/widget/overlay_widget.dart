import 'package:flutter/material.dart';
import 'package:network_monitor_cp/network/network_state.dart';
import 'package:network_monitor_cp/network/network_utils.dart';

/// A widget that displays an overlay indicating the current network state.
///
/// This widget is typically used in conjunction with [NetworkAwareNavigatorObserver]
/// to display a notification to the user when the network connection changes. It
/// provides a visually appealing overlay with an icon and a message
/// corresponding to the current [NetworkState].
class OverlayWidget extends StatelessWidget {
  /// The current network state.
  final NetworkState state;

  /// Creates a new [OverlayWidget].
  ///
  /// The [state] parameter is required and represents the current network
  /// connection state.
  const OverlayWidget({super.key, required this.state});

  /// Builds the overlay widget.
  ///
  /// This method creates a [Positioned] widget that spans the bottom of the
  /// screen. It contains a [Material] widget with a semi-transparent background
  /// and an [AnimatedSlide] widget to provide a smooth entry animation. The
  /// content of the overlay is a [Container] with padding, background color
  /// based on the network state, and a [Row] containing an icon and a text
  /// message.
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 800),
          offset: const Offset(0, 0),
          curve: Curves.bounceIn,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            color:
                state == NetworkState.disconnected ? Colors.red : Colors.orange,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(NetworkUtils.networkImage(state), color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  NetworkUtils.networkMessage(state),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: state == NetworkState.disconnected ||
                            state == NetworkState.noInternet
                        ? Colors.white
                        : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
