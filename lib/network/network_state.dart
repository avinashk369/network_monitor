/// Enum representing the different states of the network connection.
enum NetworkState {
  /// The device is connected to a network and has internet access.
  connected,

  /// The device is not connected to any network.
  disconnected,

  /// The device is connected to a network but has no internet access.
  noInternet;

  /// Returns `true` if the network state is [NetworkState.connected], `false` otherwise.
  bool get isConnected => this == NetworkState.connected;
}
