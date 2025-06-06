import 'dart:convert';

IngredientResorceModel ingredientResorceModelFromJson(String str) =>
    IngredientResorceModel.fromJson(jsonDecode(str));

String ingredientResorceModelToJson(IngredientResorceModel data) =>
    jsonEncode(data.toJson());

class IngredientResorceModel {
  String? message;
  List<Data>? data;

  IngredientResorceModel({this.message, this.data});

  IngredientResorceModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? description;
  String? price;
  String? unit;
  String? stock;
  String? imageUrl;
  String? createdAt;

  Data(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.unit,
      this.stock,
      this.imageUrl,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    unit = json['unit'];
    stock = json['stock'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['unit'] = this.unit;
    data['stock'] = this.stock;
    data['image_url'] = this.imageUrl;
    data['created_at'] = this.createdAt;
    return data;
  }
}
