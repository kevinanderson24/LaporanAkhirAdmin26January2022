import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ScheduledScreen extends StatefulWidget {
  const ScheduledScreen({Key key}) : super(key: key);
  static const routeName = '/scheduled_screen';
  @override
  _ScheduledScreenState createState() => _ScheduledScreenState();
}

class _ScheduledScreenState extends State<ScheduledScreen> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String roomNumber;
    bool visibility = true;
    String uid;
    String time;

    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('Scheduled Cart').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshotScheduledCart) {
          if (!snapshotScheduledCart.hasData) {
            return Center(
              child: Text('FeelsWeirdMan'),
            );
          }
          if (snapshotScheduledCart.data.documents.isEmpty) {
            return Center(
              child: Text('No Scheduled Order yet'),
            );
          }

          return Column(
            children: [
              AppBar(
                title: Text('Scheduled Order'),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(30.0),
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: TextFormField(
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Input User ID'),
                        textAlign: TextAlign.center,
                        onChanged: (val) {
                          uid = val;
                        },
                        validator: (val) =>
                            val.isEmpty ? 'Enter User ID' : null,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Firestore.instance
                              .collection('Scheduled Cart')
                              .document(uid)
                              .delete();
                          Firestore.instance
                              .collection('Scheduled Status')
                              .document(uid)
                              .delete();
                          _formKey.currentState.reset();
                        }
                      },
                      child: const Text('Finish Order'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: snapshotScheduledCart.data.documents.map((doc) {
                    roomNumber = null;
                    uid = null;
                    time = null;

                    for (var i in doc.data.values) {
                      roomNumber = i['Room Number'].toString();
                      uid = i['User Id'].toString();
                      time = i['Time'].toString();

                      break;
                    }

                    if (roomNumber == null) {
                      visibility = false;
                    } else {
                      visibility = true;
                    }
                    return Visibility(
                      visible: visibility,
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                "Room: " + roomNumber.toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              subtitle: SelectableText(
                                uid ?? 'hi',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Column(
                              children: [
                                for (var i in doc.data.values)

                                  // width: MediaQuery.of(context).size.width,
                                  Text(
                                    i['Title'] +
                                        " x " +
                                        i['Quantity'].toString(),
                                    style: GoogleFonts.poppins(),
                                    textAlign: TextAlign.start,
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    'Scheduled for: ' + time.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
