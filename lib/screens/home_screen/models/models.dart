// To parse this JSON data, do
//
//     final categories = categoriesFromJson(jsonString);

import 'dart:convert';

List<Categories> categoriesFromJson(String str) => List<Categories>.from(json.decode(str).map((x) => Categories.fromJson(x)));

String categoriesToJson(List<Categories> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Categories {
    final int? id;
    final String? name;
    final String? description;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final List<Product>? products;

    Categories({
        this.id,
        this.name,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.products,
    });

    factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
    };
}

class Product {
    final int? id;
    final String? name;
    final String? description;
    final String? price;
    final dynamic discountPrice;
    final String? stock;
    final dynamic rating;
    final String? preparationSteps;
    final dynamic imageUrl;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final Pivot? pivot;

    Product({
        this.id,
        this.name,
        this.description,
        this.price,
        this.discountPrice,
        this.stock,
        this.rating,
        this.preparationSteps,
        this.imageUrl,
        this.createdAt,
        this.updatedAt,
        this.pivot,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        discountPrice: json["discount_price"],
        stock: json["stock"],
        rating: json["rating"],
        preparationSteps: json["preparation_steps"],
        imageUrl: json["image_url"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "discount_price": discountPrice,
        "stock": stock,
        "rating": rating,
        "preparation_steps": preparationSteps,
        "image_url": imageUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pivot": pivot?.toJson(),
    };
}

class Pivot {
    final String? categoryId;
    final String? productId;

    Pivot({
        this.categoryId,
        this.productId,
    });

    factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        categoryId: json["category_id"],
        productId: json["product_id"],
    );

    Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "product_id": productId,
    };
}
