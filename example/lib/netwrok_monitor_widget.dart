import 'package:flutter/material.dart';
import 'package:network_monitor/network/mixins/network_aware_mixin.dart';
import 'package:network_monitor/network/network_state.dart';

class NetworkMonitorWidget extends StatefulWidget {
  const NetworkMonitorWidget({super.key});

  @override
  State<NetworkMonitorWidget> createState() => _NetworkMonitorWidgetState();
}

class _NetworkMonitorWidgetState extends State<NetworkMonitorWidget>
    with NetworkAwareMixin {
  @override
  void initState() {
    super.initState();
    initializeNetworkMonitoring((state) {
      switch (state) {
        case NetworkState.connected:
          debugPrint("connection state connected");

          break;
        case NetworkState.disconnected:
          debugPrint("connection state disconnected");

          break;
        case NetworkState.noInternet:
          debugPrint("connection state no internet");

          break;

        default:
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    disposeNetworkMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network Mixin')),
      body: const Text('Network status using mixin'),
    );
  }
}
