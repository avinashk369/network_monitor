import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'network_state.dart';

/// Singleton class to handle network connectivity monitoring
class NetworkMonitor {
  static final NetworkMonitor _instance = NetworkMonitor._internal();
  factory NetworkMonitor() => _instance;
  NetworkMonitor._internal();

  final _connectivity = Connectivity();
  final _controller = StreamController<NetworkState>.broadcast();
  final _lookupAddresses = [
    'google.com',
    'cloudflare.com',
    'apple.com',
  ];

  Stream<NetworkState> get state => _controller.stream;
  bool _isInitialized = false;

  /// Initialize the network monitor
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initial connectivity check
    _checkConnectivity();

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((result) {
      _checkConnectivity();
    });

    // Periodic internet check
    Timer.periodic(const Duration(seconds: 30), (_) {
      _checkConnectivity();
    });

    _isInitialized = true;
  }

  Future<void> _checkConnectivity() async {
    final connectivity = await _connectivity.checkConnectivity();

    if (connectivity.contains(ConnectivityResult.none)) {
      _controller.add(NetworkState.disconnected);
      return;
    }

    // Check for actual internet connectivity
    final hasInternet = await _checkInternet();
    _controller
        .add(hasInternet ? NetworkState.connected : NetworkState.noInternet);
  }

  Future<bool> _checkInternet() async {
    try {
      // Try multiple addresses for reliability
      for (final address in _lookupAddresses) {
        try {
          final result = await InternetAddress.lookup(address);
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          }
        } catch (_) {
          continue;
        }
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    _controller.close();
  }
}
