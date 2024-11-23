import 'package:flutter/material.dart';
import 'package:network_monitor/network/network_state.dart';

class NetworkUtils {
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
