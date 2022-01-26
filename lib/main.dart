import 'package:ebutler/screens/OrderListScreen/orders.dart';
import 'package:ebutler/screens/OrderListScreen/receiver_screen.dart';
import 'package:ebutler/screens/OrderListScreen/scheduled_screen.dart';
import 'package:ebutler/screens/OrderListScreen/status_screen.dart';
import 'package:ebutler/screens/ProductScreen/newproduct.dart';
import 'package:ebutler/screens/UserScreen/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[900],
            title: Text(
              "Binus Hotel",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.list), text: 'ORDER'),
                Tab(
                  icon: Icon(Icons.list),
                  text: 'PRODUCT',
                ),
                Tab(
                  icon: Icon(Icons.people),
                  text: 'USER',
                ),
              ],
              unselectedLabelColor: Colors.black,
            ),
          ),
          body: TabBarView(
            children: [
              Orders(),
              NewProduct(),
              UserScreen(),
            ],
          ),
        ),
      ),
      routes: {
        ScheduledScreen.routeName: (ctx) => const ScheduledScreen(),
        StatusScreen.routeName: (ctx) => const StatusScreen(),
        Receiver.routeName: (ctx) => const Receiver(),
      },
    );
  }
}
