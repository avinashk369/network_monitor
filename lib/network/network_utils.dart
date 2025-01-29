import 'package:flutter/material.dart';
import 'package:network_monitor_cp/network/network_state.dart';

/// A utility class providing helper methods related to network status.
class NetworkUtils {
  /// Returns a user-friendly message corresponding to the given [NetworkState].
  ///
  /// This method provides a localized message that can be displayed to the user
  /// based on the current network connection status.
  ///
  /// Example:
  /// ```dart
  /// String message = NetworkUtils.networkMessage(NetworkState.disconnected);
  /// print(message); // Output: Internet disconnected
  /// ```
  static String networkMessage(NetworkState state) {
    switch (state) {
      case NetworkState.disconnected:
        return "Internet disconnected";
      case NetworkState.noInternet:
        return "No internet";
      default:
        return '';
    }
  }

  /// Returns an appropriate [IconData] representing the given [NetworkState].
  ///
  /// This method provides an icon that visually represents the current
  /// network connection status.  It can be used to display an icon in the UI
  /// to indicate the network state.
  ///
  /// Example:
  /// ```dart
  /// IconData icon = NetworkUtils.networkImage(NetworkState.connected);
  /// Icon(icon); // Displays the wifi icon
  /// ```
  static IconData networkImage(NetworkState state) {
    switch (state) {
      case NetworkState.disconnected:
        return Icons.signal_wifi_connected_no_internet_4;
      case NetworkState.noInternet:
        return Icons.signal_wifi_statusbar_connected_no_internet_4_rounded;
      default:
        return Icons.wifi;
    }
  }
}
