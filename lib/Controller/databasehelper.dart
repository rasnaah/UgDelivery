import 'package:http/http.dart' as https;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class DatabaseHelper {
  String loginUrl = "https://forge.dev.ugbazaar.com/api/V2/login/user";
  String logoutUrl = "https://forge.dev.ugbazaar.com/api/V2/user-logout";
  String orderUrl =
      "https://forge.dev.ugbazaar.com/api/dashboard/v1/delivery/orders";

  var status;
  var token;

  //creating function for login
  loginData(String email, String password, String source) async {
    //String myUrl = "$loginUrl";
    final response = await https.post(
        Uri.parse("https://forge.dev.ugbazaar.com/api/V2/login/user"),
        headers: {
          'Accept': 'application/json'
        },
        body: {
          "email": "$email",
          "password": "$password",
          "source": "$source"
        });

    status = response.body.contains('error');

    var data = json.decode(response.body);
    print(data);

    if (status) {
      print('data: ${data["error"]}');
    } else {
      print('data: ${data["token"]}');
      _save(data["token"]);
    }
  }

  //function for save
  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  //function read
  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }

  //////////////////
//get userdata
  Future<dynamic> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    print(token);
    var url = 'https://forge.dev.ugbazaar.com/api/V2/login/user';
    https.Response response = await https.get(
      Uri.parse("https://forge.dev.ugbazaar.com/api/V2/login/user"),
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );
    if (response.statusCode == 200) {
      String data = response.body;

      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }

  //create function for displaying orders
  Future<List> getDataOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    https.Response response = await https.get(
        Uri.parse(
            'https://forge.dev.ugbazaar.com/api/dashboard/v1/delivery/orders'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $value'
        });
    return json.decode(response.body);
  }

//--currentUser
  Future<List> getDataCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    https.Response response = await https.get(
        Uri.parse("https://forge.dev.ugbazaar.com/api/V2/login/user"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $value'
        });
    return json.decode(response.body);
  }

  //function for posting the action(status) of order
  void addStatusData(String _action, String _orderId) async {
    String myUrl =
        "https://forge.dev.ugbazaar.com/api/dashboard/v1/delivery/action";
    final response = await https.post(Uri.parse(myUrl), headers: {
      HttpHeaders.authorizationHeader:
          'Bearer 23971|muZUEgVzfgnN4L85gXrh3yiMle9h3as8C0kDj2FY',
    }, body: {
      "action": "$_action",
      "orderId": "$_orderId",
    });
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["token"]}');
      _save(data["token"]);
    }
  }

  //function for update
  void editStatusData(String action, String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl =
        "https://forge.dev.ugbazaar.com/api/dashboard/v1/delivery/action";
    https.put(Uri.parse(myUrl), headers: {
      HttpHeaders.authorizationHeader:
          'Bearer 23971|muZUEgVzfgnN4L85gXrh3yiMle9h3as8C0kDj2FY',
    }, body: {
      "name": "$action",
      "address": "$orderId"
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body: ${response.body}');
    });
  }

  //get data
  Future<List> getStatusData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl =
        "https://forge.dev.ugbazaar.com/api/dashboard/v1/delivery/action";
    https.Response response = await https.get(Uri.parse(myUrl), headers: {
      HttpHeaders.authorizationHeader:
          'Bearer 23971|muZUEgVzfgnN4L85gXrh3yiMle9h3as8C0kDj2FY',
    });
    return json.decode(response.body);
  }
}
