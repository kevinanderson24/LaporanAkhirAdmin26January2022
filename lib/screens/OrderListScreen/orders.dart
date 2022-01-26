import 'package:ebutler/screens/OrderListScreen/receiver_screen.dart';
import 'package:ebutler/screens/OrderListScreen/scheduled_screen.dart';
import 'package:ebutler/screens/OrderListScreen/status_screen.dart';
import 'package:flutter/material.dart';

class Orders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Receiver.routeName);
                },
                child: Text('Order'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(StatusScreen.routeName);
                },
                child: Text('Current Order Status'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(ScheduledScreen.routeName);
                },
                child: Text('Scheduled Order'),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.of(context)
            //           .pushNamed(ScheduledStatusScreen.routeName);
            //     },
            //     child: Text('Scheduled Status'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
