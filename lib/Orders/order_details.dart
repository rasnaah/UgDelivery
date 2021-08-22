import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as https;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List orders = [];
  bool isLoading = false;

  acceptDelivery(String action, orderId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'action': action, 'orderId': orderId};
    var jsonResponse;

    var response = await https.post(
        Uri.parse(
            "https://forge.dev.ugbazaar.com/api/dashboard/v1/delivery/action"),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer 23971|muZUEgVzfgnN4L85gXrh3yiMle9h3as8C0kDj2FY',
        },
        body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (jsonResponse != null) {
        setState(() {
          isLoading = false;
        });
        sharedPreferences.setString('BearerToken', 'token');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print(response.body);
    }
  }

  Future<void> DeliverSuccess() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            content: new Text(
              'Congratulations! You have successfully accepted the order to deliver.',
              style:
                  TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '*Please mark the order as done after successful delivery in accepted orders section!*',
                  style:
                      TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepPurpleAccent[100]),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.deepPurpleAccent)))),
                child: Text('Okay',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  //Orders();
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchOrder();
  }

  fetchOrder() async {
    var response = await https.get(
        Uri.parse(
            "https://forge.dev.ugbazaar.com/api/dashboard/v1/delivery/orders"),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer 23971|muZUEgVzfgnN4L85gXrh3yiMle9h3as8C0kDj2FY',
        });
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'];
      setState(() {
        orders = items;
      });

      // print(items);
    } else {
      setState(() {
        orders = [];
      });
    }
  }

  void customLaunch(command) async {
    print(command);
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print('could not launch $command');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white70,
        body: getOrders(),
      ),
    );
  }

  Future<Null> refreshList() async {
    setState(() {
      OrderList();
      //this.fetchOrder();
    });
    return null;
  }

  Widget getOrders() {
    return RefreshIndicator(
      onRefresh: refreshList,
      child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return getCard(orders[index]);
          }),
    );
  }

  Widget getCard(item) {
    var id = item['id'];
    var surprise = item['isSurprise'];
    var date = item['date'];
    var time = item['time'];
    var amount = item['amount'];
    var customer = item['customer'];
    var phone = item['phone'];
    var secondaryPhone = item['secondaryPhone'];
    var location =
        item['location']['name'] + ', ' + item['location']['landmark'];
    var photoUrl = item['items'];
    var productName = item['items'];
    var sku = item['items'];
    var status = item['status'];
    var notice = item['notice'];

    Future<void> ConfirmAlert() async {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              title: Text(
                'Are you sure you want to deliver this item?',
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.deepPurpleAccent[100]),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side:
                                  BorderSide(color: Colors.deepPurpleAccent)))),
                  child: Text('Yes',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  onPressed: () {
                    acceptDelivery('start', id.toString());
                    DeliverSuccess();
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white70)))),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurpleAccent),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    return Column(
      children: [
        if (status.toString() == 'assigned') ...[
          Padding(
            padding: const EdgeInsets.all(4),
            child: Card(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 500.0,
                              height: 100,
                              //height: double.maxFinite,
                              child: PageView.builder(
                                // shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: photoUrl.length,
                                itemBuilder: (context, index) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              photoUrl[index]["image"],
                                              fit: BoxFit.fill,
                                              height: 100.0,
                                              width: 100.0,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.0),
                                          ),
                                          Column(
                                            children: [
                                              SingleChildScrollView(
                                                child: Container(
                                                  width: 147,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        sku[index]["name"],
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5)),
                                              SingleChildScrollView(
                                                child: Container(
                                                  width: 147,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        sku[index]["sku"],
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Text(
                              'ORDER#${id.toString()}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  decoration: TextDecoration.underline,
                                  fontSize: 18),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SingleChildScrollView(
                                      child: Container(
                                        width: 290,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Delivery Date ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              date.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 4.0),
                                    ),
                                    SingleChildScrollView(
                                      child: Container(
                                        width: 290,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Delivery Time',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                )),
                                            Text(time.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 4.0),
                                    ),
                                    SingleChildScrollView(
                                      child: Container(
                                        width: 290,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Customer Name',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              customer.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 4.0),
                                    ),
                                    Column(
                                      children: [
                                        if (amount.toString() == "0") ...[
                                          Container(
                                            /*decoration: BoxDecoration(
                                              color: Colors.lightGreen,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),*/
                                            child: SingleChildScrollView(
                                              child: Container(
                                                width: 290,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Amount',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Text('NPR 0, Paid',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ] else ...[
                                          SingleChildScrollView(
                                            child: Container(
                                              width: 290,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Amount',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  Text(
                                                    'NPR ${amount.toString()}, COD',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 4.0),
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            )),
                                            backgroundColor:
                                                MaterialStateProperty.all(Colors
                                                    .deepPurpleAccent[200]),
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            ConfirmAlert();
                                            //acceptDelivery('start', id.toString());
                                          },
                                          child: Text(
                                            'Accept Delivery',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.0),
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    side: BorderSide(
                                                        color: Colors.green))),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.green),
                                          ),
                                          onPressed: () {
                                            customLaunch('tel: ${phone}');
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.call),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3.0),
                                              ),
                                              Text(
                                                'Call',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.0),
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    side: BorderSide(
                                                        color: Colors.red))),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.redAccent),
                                          ),
                                          onPressed: () {
                                            customLaunch(
                                                'https://www.google.com/maps/place/Urban+Girl/@27.6981085,85.3374017,17z/data=!3m1!4b1!4m5!3m4!1s0x39eb1996fb217af5:0xd6c169195d6f5785!8m2!3d27.6981082!4d85.3374016');
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.location_on),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              20))),
                                              context: context,
                                              builder: (context) => Container(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Divider(
                                                            thickness: 10,
                                                          ),
                                                          Text(
                                                            notice.toString(),
                                                            style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 22),
                                                            textAlign: TextAlign
                                                                .justify,
                                                          ),
                                                          Divider(
                                                            thickness: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4.0),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Is it Surprise? ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Column(
                                                          children: [
                                                            // ignore: unrelated_type_equality_checks
                                                            if (surprise
                                                                    .toString() ==
                                                                false) ...[
                                                              Text('Yes'),
                                                            ] else ...[
                                                              Text('No'),
                                                            ],
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4.0),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Location: ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(location
                                                            .toString()),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4.0),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Status: ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(status.toString()),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4.0),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .green))),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .green),
                                                        ),
                                                        onPressed: () {
                                                          customLaunch(
                                                              'tel: ${secondaryPhone}');
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.call),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          3.0),
                                                            ),
                                                            Text(
                                                              'Call on Secondary Phone',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 100.0),
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "See More",
                                                    style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Icon(Icons
                                                      .arrow_drop_down_rounded)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ] else
          ...[]
      ],
    );
  }
}
