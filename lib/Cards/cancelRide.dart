import 'package:flutter/material.dart';

class CancelRide extends StatefulWidget {
  @override
  _CancelRideState createState() => _CancelRideState();
}

class _CancelRideState extends State<CancelRide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color(0xFF3366FF), width: 2.5),
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 10.0,
              shadowColor: Colors.grey,
              color: Colors.grey[200],
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.perm_identity,
                        color: Colors.white,
                      ),
                      radius: 25,
                    ),
                    title: Text('Name'),
                    subtitle: Text(
                      'Number',
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(18.0, 0.0, 0.0, 0.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.place,
                                color: Color(0xFF3366FF),
                                size: 24.0,
                              ),
                              Text('  ' 'Loaction1',
                                  style: TextStyle(
                                      color: Color(0xFF3366FF),
                                      fontSize: 18.0)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(18.0, 10.0, 0.0, 0.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.place,
                                color: Color(0xFF3366FF),
                                size: 24.0,
                              ),
                              Text('  ' 'Loaction1',
                                  style: TextStyle(
                                      color: Color(0xFF3366FF),
                                      fontSize: 18.0)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Date',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Text(
                                'Fair',
                                style: TextStyle(fontSize: 18.0),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Time',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Text(
                                'Seats',
                                style: TextStyle(fontSize: 18.0),
                              )
                            ],
                          )
                        ],
                      )),
                  SizedBox(
                    width: 200.0,
                    child: Padding(
                      padding: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                      child: OutlineButton(
                        borderSide: BorderSide(
                          color: Color(0xFF3366FF),
                          width: 1.5,
                        ),
                        textColor: Color(0xFF3366FF),
                        onPressed: () {},
                        child: Text(
                          'Cancel Ride',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
