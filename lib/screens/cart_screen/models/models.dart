import 'package:get/get.dart';
import 'package:jara_market/screens/home_screen/models/models.dart';

class CartItems {
  final String name;
  final List<CartItem> cartItems;

  CartItems({required this.name, required this.cartItems});

double get totalPrice {
    return cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity.value));
  }
}



class CartItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final List<Ingredients> ingredients;
  RxInt quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.ingredients,
    this.originalPrice,
    int quantity = 1,
  }) : quantity = RxInt(quantity);

  
}

// class Ingredients {
//   int? id;
//   String? name;
//   String? description;
//   String? price;
//   String? unit;
//   String? stock;
//   String? imageUrl;
//   String? createdAt;

//   Ingredients(
//       {this.id,
//       this.name,
//       this.description,
//       this.price,
//       this.unit,
//       this.stock,
//       this.imageUrl,
//       this.createdAt});

//   Ingredients.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//     price = json['price'];
//     unit = json['unit'];
//     stock = json['stock'];
//     imageUrl = json['image_url'];
//     createdAt = json['created_at'];
//   }
//}

// class Cart {
//   final int id;
//   final List<CartItem> items;

//   Cart({required this.id, required this.items});

//   double get totalPrice {
//     return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
//   }
// }