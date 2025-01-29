import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'network_state.dart';

/// A singleton class responsible for monitoring the network connectivity status.
///
/// This class uses the `connectivity_plus` package to listen for changes in the
/// network connectivity and provides a stream of [NetworkState] values. It also
/// performs internet connectivity checks to differentiate between connected
/// to a network and having actual internet access.
class NetworkMonitor {
  static final NetworkMonitor _instance = NetworkMonitor._internal();

  /// Factory constructor to access the singleton instance.
  factory NetworkMonitor() => _instance;
  NetworkMonitor._internal();

  final _connectivity = Connectivity();

  /// A broadcast stream controller for emitting network state changes.
  ///
  /// This controller is used to notify listeners about changes in the
  /// [NetworkState]. It is initialized as a broadcast stream so that multiple
  /// widgets can listen to the stream simultaneously.
  StreamController<NetworkState>? _controller;

  /// List of lookup addresses used to check internet connectivity.
  ///
  /// These addresses are used to determine if the device has internet access
  /// even when connected to a network.
  final _lookupAddresses = ['google.com', 'cloudflare.com', 'apple.com'];

  /// Flag to prevent redundant internet connectivity checks.
  bool _isCheckingInternet = false;

  /// Timer used for debouncing network state changes.
  ///
  /// This timer is used to prevent rapid emissions of network state changes
  /// when the connectivity fluctuates quickly.
  Timer? _debounceTimer;

  /// The last emitted network state.
  NetworkState _lastState = NetworkState.connected;

  /// Stream of [NetworkState] values.
  ///
  /// This stream emits a new [NetworkState] value whenever the network
  /// connectivity changes.
  Stream<NetworkState> get state => _monitorNetwork();
  bool _isInitialized = false;

  /// Monitors the network connectivity and returns a stream of [NetworkState] values.
  ///
  /// This method initializes the [_controller] if it is null and sets up listeners
  /// for connectivity changes and internet connectivity checks.
  Stream<NetworkState> _monitorNetwork() {
    _controller ??= StreamController<NetworkState>.broadcast(
      onListen: () => _checkConnectivity(),
      onCancel: () => _stopListening(),
    );

    return _controller!.stream;
  }

  /// Stops listening to network connectivity changes and closes the stream controller.
  void _stopListening() {
    _controller?.close();
    _controller = null;
  }

  /// Initializes the network monitor.
  ///
  /// This method performs an initial connectivity check and sets up listeners
  /// for subsequent connectivity changes and periodic internet checks.
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

  /// Checks the current network connectivity and internet access.
  ///
  /// This method uses the `connectivity_plus` package to check the network
  /// connectivity and then performs internet connectivity checks using the
  /// [_checkInternet] method. It emits the appropriate [NetworkState] based
  /// on the results.
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

  /// Checks if the device is connected to a network and has internet access.
  static Future<bool> isConnected() async {
    final connectivity =
        await NetworkMonitor()._connectivity.checkConnectivity();
    return !connectivity.contains(ConnectivityResult.none) &&
        await NetworkMonitor()._checkInternet();
  }

  /// Checks for internet connectivity by attempting to resolve a list of addresses.
  ///
  /// This method tries to resolve each address in the [_lookupAddresses] list
  /// and returns true if at least one address can be resolved successfully.
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

  /// Emits the given network state to the stream controller.
  ///
  /// This method adds the given [state] to the [_controller] stream, but only if
  /// the state is different from the last emitted state. It also uses a debounce
  /// timer to prevent rapid emissions of the same state.
  void _emitState(NetworkState state) {
    if (_lastState == state) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _controller?.add(state);
      _lastState = state;
    });
  }

  /// Disposes of the network monitor, cancelling the debounce timer and closing the stream controller.
  void dispose() {
    _debounceTimer?.cancel();
    _controller?.close();
  }
}
