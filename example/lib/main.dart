import 'package:example/network_status_screen.dart';
import 'package:example/netwrok_monitor_widget.dart';
import 'package:flutter/material.dart';
import 'package:network_monitor/network/network_aware_navigator_observer.dart';
import 'package:network_monitor/network/network_monitor.dart';
import 'package:network_monitor/network/network_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NetworkMonitor().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      /// manage network status gloabally use navigator observer
      navigatorObservers: [
        NetworkAwareNavigatorObserver(
          networkStatusScreen: const NetworkStatusScreen(),
          errorType: ErrorType.widget,
        )
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Network status demo'),
      // home: const NetworkMonitorWidget(), /// use this class to check the mixin uses
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// you can also monitor network state using stream builder
            StreamBuilder<NetworkState>(
              stream: NetworkMonitor().state,
              builder: (context, snapshot) {
                // Build based on connection state
                return Text('Network status check ${snapshot.data?.name}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
