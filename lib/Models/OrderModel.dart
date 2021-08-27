class OrderModel {
  OrderModel({
    this.meta,
    this.data,
    this.message,
  });

  dynamic meta;
  List<SingleOrder>? data;
  String? message;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        meta: json["meta"],
        data: List<SingleOrder>.from(
            json["data"].map((x) => SingleOrder.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class SingleOrder {
  SingleOrder({
    this.id,
    this.isSurprise,
    this.date,
    this.time,
    this.amount,
    this.customer,
    this.phone,
    this.secondaryPhone,
    this.location,
    this.status,
    this.notice,
    this.remarks,
    this.items,
  });

  int? id;
  bool? isSurprise;
  String? date;
  String? time;
  int? amount;
  String? customer;
  String? phone;
  dynamic secondaryPhone;
  Location? location;
  String? notice;
  String? status;
  dynamic remarks;
  List<Item>? items;

  factory SingleOrder.fromJson(Map<String, dynamic> json) => SingleOrder(
        id: json["id"],
        isSurprise: json["isSurprise"],
        date: json["date"],
        time: json["time"],
        amount: json["amount"],
        customer: json["customer"],
        phone: json["phone"],
        secondaryPhone: json["secondaryPhone"],
        location: Location.fromJson(json["location"]),
        status: json["status"],
        notice: json["notice"] == null ? null : json["notice"],
        remarks: json["remarks"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isSurprise": isSurprise,
        "date": date,
        "time": time,
        "amount": amount,
        "customer": customer,
        "phone": phone,
        "secondaryPhone": secondaryPhone,
        "location": location!.toJson(),
        "status": status,
        "notice": notice == null ? null : notice,
        "remarks": remarks,
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    this.name,
    this.sku,
    this.image,
  });

  String? name;
  String? sku;
  String? image;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json["name"],
        sku: json["sku"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "sku": sku,
        "image": image,
      };
}

class Location {
  Location({
    this.name,
    this.landmark,
    this.map,
  });

  String? name;
  String? landmark;
  MapClass? map;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        name: json["name"],
        landmark: json["landmark"],
        map: MapClass.fromJson(json["map"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "landmark": landmark,
        "map": map!.toJson(),
      };
}

class MapClass {
  MapClass({
    this.xCoord,
    this.yCoord,
    this.name,
  });

  String? xCoord;
  String? yCoord;
  dynamic name;

  factory MapClass.fromJson(Map<String, dynamic> json) => MapClass(
        xCoord: json["xCoord"] == null ? null : json["xCoord"],
        yCoord: json["yCoord"] == null ? null : json["yCoord"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "xCoord": xCoord == null ? null : xCoord,
        "yCoord": yCoord == null ? null : yCoord,
        "name": name,
      };
}
