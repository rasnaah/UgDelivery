import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Order {
  String deliveryDate;
  int orderId;
  String itemName;
  int quantity;
  String brand;
  String address;
  String customerName;
  String contactNo;
  String pay;
  int amount;
  String remark;
  String surprise;
  String giftMessage;

  Order(
      {required this.deliveryDate,
      required this.orderId,
      required this.itemName,
      required this.quantity,
      required this.brand,
      required this.address,
      required this.customerName,
      required this.contactNo,
      required this.pay,
      required this.amount,
      required this.remark,
      required this.surprise,
      required this.giftMessage});
}

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Future<void> DeliverSuccess() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.pinkAccent,
            title: Text(
              'Congratulations! You have successfully delivered an item.',
              style:
                  TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: Text('Okay',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              )
            ],
          );
        });
  }

  Future<void> ConfirmAlert() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.pinkAccent,
            title: Text(
              'Are you sure you want to deliver this item?',
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: Text('Yes',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
                onPressed: () {
                  DeliverSuccess();
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: Text(
                  'Cancel',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  final List<Order> orders = [
    Order(
        deliveryDate: '19 Oct 2020, 09:00 AM',
        orderId: 1,
        itemName: 'Thermal Flask',
        quantity: 1,
        brand: 'Baltra',
        address: 'Naxal',
        customerName: 'Rasana Tamrakar',
        contactNo: '9810101010',
        pay: 'paid',
        amount: 2000,
        remark: 'Ready bhaisakyo',
        surprise: 'no',
        giftMessage: 'null'),
    Order(
        deliveryDate: '21 Dec 2020, 02:00 PM',
        orderId: 2,
        itemName: 'Table Fan',
        quantity: 1,
        brand: 'Panasonic',
        address: 'New Road',
        customerName: 'Urusha Shrestha',
        contactNo: '9820202020',
        pay: 'COD',
        amount: 5000,
        remark: 'abcde',
        surprise: 'no',
        giftMessage: 'null'),
    Order(
        deliveryDate: '10 Jan 2021, 04:00 PM',
        orderId: 3,
        itemName: 'Watch',
        quantity: 1,
        brand: 'Rolex',
        address: 'Mid Baneshwor',
        customerName: 'Samyush Maharjan',
        contactNo: '9830303030',
        pay: 'COD',
        amount: 20000,
        remark: 'null',
        surprise: 'yes',
        giftMessage: 'Happy Birthday'),
  ];
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    elevation: 4.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
//mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: 40.0,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    /*ListView(
                                        children: <Widget>[
                                          CarouselSlider(
                                            items: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/rolex.jpg'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            options: CarouselOptions(
                                              height: 180.0,
                                              enlargeCenterPage: true,
                                              autoPlay: true,
                                              aspectRatio: 16 / 9,
                                              autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                              enableInfiniteScroll: true,
                                              autoPlayAnimationDuration:
                                                  Duration(milliseconds: 800),
                                              viewportFraction: 0.8,
                                            ),
                                          )
                                        ],
                                      ),*/
                                    Image(
                                      image:
                                          AssetImage('assets/images/rolex.jpg'),
                                      height: 220,
                                      width: 250,
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                            Icons.keyboard_arrow_right_rounded))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Delivery Date: ',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      order.deliveryDate,
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Order ID: ',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${order.orderId}',
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                ),
                                Row(
                                  children: [
                                    Text('Product Name: ',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold)),
                                    Text(order.itemName,
                                        style: TextStyle(fontSize: 15.0)),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                ),
                                Row(
                                  children: [
                                    Text('Quantity: ',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold)),
                                    Text('${order.quantity}',
                                        style: TextStyle(fontSize: 15.0)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                    ),
                                    Text(
                                      'Amount: ',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Rs. ${order.amount}',
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                ),
                                Row(
                                  children: [
                                    Text('Customer Name: ',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold)),
                                    Text(order.customerName,
                                        style: TextStyle(fontSize: 15.0)),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                ),
                                Row(
                                  children: [
                                    Text('Payment Status: ',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.lightGreen,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(order.pay,
                                                  style: TextStyle(
                                                      fontSize: 15.0)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Remarks: ',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      order.remark,
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
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
                                                side: BorderSide(
                                                    color: Colors.deepPurple))),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.deepPurpleAccent),
                                      ),
                                      onPressed: () {
                                        ConfirmAlert();
                                      },
                                      child: Text(
                                        'Accept Order',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                side: BorderSide(
                                                    color: Colors.green))),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.green),
                                      ),
                                      onPressed: () {
                                        customLaunch('tel: ${order.contactNo}');
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
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
