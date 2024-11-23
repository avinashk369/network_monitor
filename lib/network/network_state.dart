enum NetworkState {
  connected,
  disconnected,
  noInternet;

  bool get isConnected => this == NetworkState.connected;
}
