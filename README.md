<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

A tiny package to monitor network status on real time. This is wrapper package around connectivity_plus.

## Features

You can monitor network status at following level
 1. Global level
 2. Screen level
 3. Widget level

## Getting started

to use this in your flutter application. 
intialize NetworkMonitor in main method.

```
await NetworkMonitor().initialize();
```


## Usage

to use it at global level define navigatorObservers parameter inside the material app.

```
navigatorObservers: [
        NetworkAwareNavigatorObserver(
          networkStatusScreen: const NetworkStatusScreen(),
          errorType: ErrorType.widget,
        )
      ],
```

to use at screen level you can use the mixin class

```
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

```

To use at widget level you can use the streambuilder

```
StreamBuilder<NetworkState>(
              stream: NetworkMonitor().state,
              builder: (context, snapshot) {
                // Build based on connection state
                return Text('Network status check ${snapshot.data?.name}');
              },
            ),
```

## Additional information

Feel free to enhance the package by raising the PR and opening the issue.
