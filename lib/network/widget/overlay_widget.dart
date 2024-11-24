import 'package:flutter/material.dart';
import 'package:network_monitor_cp/network/network_state.dart';
import 'package:network_monitor_cp/network/network_utils.dart';

class OverlayWidget extends StatelessWidget {
  const OverlayWidget({super.key, required this.state});
  final NetworkState state;

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
