import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProduction extends StatefulWidget {
  const MyProduction({Key? key}) : super(key: key);

  @override
  _MyProductionState createState() => _MyProductionState();
}

class _MyProductionState extends State<MyProduction> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Donation for the Stethoecope to the Mboalab',
            style: TextStyle(color: Colors.blue),
          ),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 60, top: 80),
              child: Text(
                'Add Your Donation',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 35,
                        right: 35,
                      ),
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                labelText: "Donor name",
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                             TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 3, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                labelText: "Stethoecope name",
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                )),
                          ),
                            SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 3, color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: ' Amount of the Stetoescopes',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),

                              // this button is used to toggle the password visibility
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 3, color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colors.black,
                              labelText: 'Donate in cash',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),

                              // this button is used to toggle the password visibility
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 3, color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fillColor: Colors.white,
                              labelText: 'Date',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),

                              // this button is used to toggle the password visibility
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),Text(
                                  'Adding please wait....',
                                  style: const TextStyle(color: Colors.white),
                                ),
                          Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                              width: double.infinity,
                              child: ElevatedButton(
                                child: Text('Add Donation'),
                                onPressed: () {},
                              )),
                       Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
