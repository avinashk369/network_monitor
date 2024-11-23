import 'dart:async';

import 'package:network_monitor_cp/network/network_monitor.dart';
import 'package:network_monitor_cp/network/network_state.dart';

mixin NetworkAwareMixin {
  StreamSubscription<NetworkState>? _subscription;

  void initializeNetworkMonitoring(void Function(NetworkState) onStateChanged) {
    _subscription = NetworkMonitor().state.listen(onStateChanged);
  }

  void disposeNetworkMonitoring() {
    _subscription?.cancel();
    _subscription = null;
  }
}
