import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:order_delivery/Models/OrderModel.dart';
import 'package:order_delivery/Screen/orders.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Future<OrderModel> fetchOrderModel() async {
  final response = await https.get(
      Uri.parse(
          "https://forge.dev.ugbazaar.com/api/dashboard/v1/delivery/orders"),
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer 23971|muZUEgVzfgnN4L85gXrh3yiMle9h3as8C0kDj2FY',
      });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return OrderModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load OrderModel');
  }
}

class AssignedOrders extends StatefulWidget {
  const AssignedOrders({Key? key}) : super(key: key);

  @override
  _AssignedOrdersState createState() => _AssignedOrdersState();
}

class _AssignedOrdersState extends State<AssignedOrders> {
  late Future<OrderModel> futureOrderModel;
  bool isLoading = false;

  //
  //AlertDialog Boxes
  statusDelivery(String action, orderId) async {
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

  //alert dialog box for order delivery cancellation
  Future<void> deliverAccept() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            content: new Text(
              'You have accepted this order for delivering.',
              style:
                  TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.redAccent[100]),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.redAccent)))),
                child: Text('Okay',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new Orders()));
                },
              )
            ],
          );
        });
  }

  Future<void> confirmDeliverAcceptAlert(int id) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            title: Text(
              'Are you sure you want to deliver this order?',
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.green)))),
                child: Text('Yes',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                onPressed: () {
                  statusDelivery('start', id.toString());
                  deliverAccept();
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
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
  //

  @override
  void initState() {
    super.initState();
    futureOrderModel = fetchOrderModel();
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
    return Scaffold(
      body: Center(
        child: FutureBuilder<OrderModel>(
          future: futureOrderModel,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: refreshOrders,
                child: ListView.builder(
                  itemCount: snapshot.data!.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Column(
                        children: [
                          if (snapshot.data!.data![index].status ==
                              'assigned') ...[
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 300.0,
                                      height: 100,
                                      child: PageView.builder(
                                        //shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot
                                            .data!.data![index].items!.length,
                                        itemBuilder: (context, i) {
                                          return SingleChildScrollView(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.network(
                                                      snapshot
                                                          .data!
                                                          .data![index]
                                                          .items![i]
                                                          .image!,
                                                      fit: BoxFit.fill,
                                                      height: 100.0,
                                                      width: 100.0,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  /*Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 2.0),
                                                  ),*/
                                                  Column(
                                                    children: [
                                                      SingleChildScrollView(
                                                        child: Container(
                                                          width: 147,
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                snapshot
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .items![i]
                                                                    .sku!,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5)),
                                                      SingleChildScrollView(
                                                        child: Container(
                                                          width: 147,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  snapshot
                                                                      .data!
                                                                      .data![
                                                                          index]
                                                                      .items![i]
                                                                      .name!,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15,
                                                                  ),
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
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          'ORDER#${snapshot.data!.data![index].id}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 18),
                                        ),
                                        Padding(padding: EdgeInsets.all(10)),
                                        Row(
                                          children: [
                                            Text(
                                              'Delivery Date ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              snapshot.data!.data![index].date!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                                fontSize: 15,
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Delivery Time ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              snapshot.data!.data![index].time!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                                fontSize: 15,
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Customer Name ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              snapshot
                                                  .data!.data![index].customer!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                                fontSize: 15,
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'Amount',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Spacer(),
                                            if (snapshot.data!.data![index]
                                                    .amount ==
                                                0) ...[
                                              Text(
                                                'NPR 0, PAID',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                  fontSize: 15,
                                                ),
                                              )
                                            ] else ...[
                                              Text(
                                                'NPR ${snapshot.data!.data![index].amount}, COD',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                ),
                                              )
                                            ],
                                          ],
                                        )
                                      ],
                                    ),
                                    Divider(
                                      thickness: 2,
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
                                                MaterialStateProperty.all(
                                                    Colors.pinkAccent),
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            confirmDeliverAcceptAlert(snapshot
                                                .data!.data![index].id!);
                                            // ConfirmCancelAlert();
                                            //acceptDelivery('start', id.toString());
                                          },
                                          child: Text(
                                            'Accept Delivery',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                        Spacer(),
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
                                            customLaunch(
                                                'tel: ${snapshot.data!.data![index].phone}');
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.call,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3.0),
                                              ),
                                              Text(
                                                'Call',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
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
                                              builder: (BuildContext context) =>
                                                  Container(
                                                      child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            snapshot
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .notice ??
                                                                'No Urgent Message',
                                                            style: TextStyle(
                                                                fontSize: 22),
                                                            textAlign: TextAlign
                                                                .justify,
                                                          ),
                                                          Divider(
                                                            thickness: 1,
                                                            color: Colors.black,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Location',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              Text(
                                                                snapshot
                                                                        .data!
                                                                        .data![
                                                                            index]
                                                                        .location!
                                                                        .landmark! +
                                                                    ', ' +
                                                                    snapshot
                                                                        .data!
                                                                        .data![
                                                                            index]
                                                                        .location!
                                                                        .name!,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Surprise Status',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              if (snapshot
                                                                      .data!
                                                                      .data![
                                                                          index]
                                                                      .isSurprise! ==
                                                                  true) ...[
                                                                Text(
                                                                  'Yes',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              ] else ...[
                                                                Text(
                                                                  'No',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                )
                                                              ]
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Remarks',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              Text(
                                                                snapshot
                                                                        .data!
                                                                        .data![
                                                                            index]
                                                                        .remarks ??
                                                                    'No remarks',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Divider(
                                                            thickness: 1,
                                                            color: Colors.black,
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              if (snapshot
                                                                      .data!
                                                                      .data![
                                                                          index]
                                                                      .secondaryPhone ==
                                                                  null)
                                                                ...[]
                                                              else ...[
                                                                Text(
                                                                  'Secondary Phone',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10)),
                                                                ElevatedButton(
                                                                    style:
                                                                        ButtonStyle(
                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              10.0),
                                                                          side:
                                                                              BorderSide(color: Colors.green))),
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all(
                                                                              Colors.green),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      customLaunch(
                                                                          'tel: ${snapshot.data!.data![index].secondaryPhone}');
                                                                    },
                                                                    child: Text(snapshot
                                                                            .data!
                                                                            .data![index]
                                                                            .secondaryPhone ??
                                                                        'null')),
                                                              ]
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                130, 0, 0, 0),
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "View More",
                                                    textAlign: TextAlign.center,
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
                              ),
                            ),
                          ] else
                            ...[]
                        ],
                      ),
                    );
                  },
                ),
              );
              // Text(snapshot.data!.meta);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  //pull to refresh
  Future<Null> refreshOrders() async {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => new Orders()));

      //this.fetchOrder();
    });
    return null;
  }
}
