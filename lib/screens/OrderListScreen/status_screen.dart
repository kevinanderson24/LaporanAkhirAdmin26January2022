import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({key}) : super(key: key);
  static const routeName = '/status';
  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    String uid;
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance.collection('Status').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshotStatus) {
            if (!snapshotStatus.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshotStatus.data.documents.isEmpty) {
              return Center(
                child: Text('No Order yet'),
              );
            }

            // print(snapshotStatus.data.documents.length);
            var statusData = snapshotStatus.data.documents
                .map((stat) => stat['Status'])
                .toList();
            var uidData = snapshotStatus.data.documents
                .map((stat) => stat['User Id'])
                .toList();
            var roomData = snapshotStatus.data.documents
                .map((stat) => stat['Room Number'])
                .toList();
            var timeData = snapshotStatus.data.documents
                .map(
                  (stat) => stat['Time'],
                )
                .toList();

            return ListView(
              children: [
                AppBar(
                  title: Text('Current Order Status'),
                ),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 34),
                      child: Text(
                        'Status Update',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
                              .collection('Status')
                              .document(uid)
                              .updateData({
                            'Status': 'Order is being prepared',
                          });
                          _formKey.currentState.reset();
                        }
                      },
                      child: const Text('Order is being prepared'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Firestore.instance
                                .collection('Status')
                                .document(uid)
                                .updateData({
                              'Status': 'Order is on the way',
                            });
                            _formKey.currentState.reset();
                          }
                        },
                        child: const Text('Order is on the way'),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue))),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Firestore.instance
                              .collection('Cart')
                              .document(uid)
                              .delete();
                          Firestore.instance
                              .collection('Status')
                              .document(uid)
                              .updateData({
                            'Status': 'Order is finished',
                          });
                          _formKey.currentState.reset();
                        }
                      },
                      child: const Text('Order finished'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green)),
                    ),
                    Column(
                      children: [
                        for (int i = 0;
                            i < snapshotStatus.data.documents.length;
                            i++)
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            width: 500,
                            child: Card(
                              child: Column(
                                children: [
                                  SelectableText(
                                    uidData[i].toString(),
                                    style: GoogleFonts.poppins(fontSize: 18),
                                  ),
                                  Text(roomData[i].toString(),
                                      style: GoogleFonts.poppins(fontSize: 18)),
                                  Text(statusData[i].toString(),
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text(timeData[i].toString(),
                                      style: GoogleFonts.poppins(fontSize: 18))
                                ],
                              ),
                            ),
                          )
                      ],
                    )
                  ]),
                ),
              ],
            );
          }),
    );
  }
}
