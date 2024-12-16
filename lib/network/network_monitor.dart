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
  StreamController<NetworkState>? _controller;
  final _lookupAddresses = ['google.com', 'cloudflare.com', 'apple.com'];
  bool _isCheckingInternet = false; // Prevent redundant internet checks
  Timer? _debounceTimer;
  NetworkState _lastState = NetworkState.connected;

  Stream<NetworkState> get state => _monitorNetwork();
  bool _isInitialized = false;

  Stream<NetworkState> _monitorNetwork() {
    _controller ??= StreamController<NetworkState>.broadcast(
      onListen: () => _checkConnectivity(),
      onCancel: () => _stopListening(),
    );

    return _controller!.stream;
  }

  void _stopListening() {
    _controller?.close();
    _controller = null;
  }

  /// Initialize the network monitor
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initial connectivity check
    _checkConnectivity();

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((_) {
      _checkConnectivity();
    });

    // Periodic internet check
    // Timer.periodic(const Duration(seconds: 30), (_) {
    //   _checkConnectivity();
    // });

    _isInitialized = true;
  }

  Future<void> _checkConnectivity() async {
    if (_isCheckingInternet) return;

    _isCheckingInternet = true;
    final connectivity = await isConnected();

    if (!connectivity) {
      _emitState(NetworkState.disconnected);
    } else {
      // Check for actual internet connectivity
      final hasInternet = await _checkInternet();
      _emitState(
          hasInternet ? NetworkState.connected : NetworkState.noInternet);
    }

    _isCheckingInternet = false;
  }

  static Future<bool> isConnected() async {
    final connectivity =
        await NetworkMonitor()._connectivity.checkConnectivity();
    return !connectivity.contains(ConnectivityResult.none) &&
        await NetworkMonitor()._checkInternet();
  }

  Future<bool> _checkInternet() async {
    // Try multiple addresses for reliability
    for (final address in _lookupAddresses) {
      try {
        final result = await InternetAddress.lookup(address);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } on SocketException catch (_) {
        return false;
      } catch (_) {
        continue;
      }
    }
    return false;
  }

  void _emitState(NetworkState state) {
    if (_lastState == state) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _controller?.add(state);
      _lastState = state;
    });
  }

  void dispose() {
    _debounceTimer?.cancel();
    _controller?.close();
  }
}
