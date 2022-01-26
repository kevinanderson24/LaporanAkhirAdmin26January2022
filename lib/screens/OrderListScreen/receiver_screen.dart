import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Receiver extends StatefulWidget {
  const Receiver({Key key}) : super(key: key);
  static const routeName = '/receiver';
  @override
  State<Receiver> createState() => _ReceiverState();
}

class _ReceiverState extends State<Receiver> {
  @override
  Widget build(BuildContext context) {
    String roomNumber;
    bool visibility = true;
    String uid;
    String time;
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('Cart').snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotCart) {
          if (!snapshotCart.hasData) {
            return Center(
              child: Text('No Order yet'),
            );
          }
          if (snapshotCart.data.documents.isEmpty) {
            return Center(
              child: Text('No Order yet'),
            );
          }
          return Column(
            children: [
              AppBar(
                title: Text('Current Orders'),
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
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: snapshotCart.data.documents.map((doc) {
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
                                    'Ordered at: ' + time.toString(),
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
