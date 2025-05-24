import 'package:get/get.dart';
// import 'package:jara_market/screens/home_screen/models/models.dart';

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

class Ingredients {
  final int id;
  String? name;
  String? description;
  double? price;
  String? unit;
  String? stock;
  String? imageUrl;
  String? createdAt;
  RxInt? quantity;
  RxBool isSelected;

  Ingredients(
      {required this.id,
      this.name,
      this.description,
      this.price,
      this.unit,
      this.stock,
      this.imageUrl,
      this.createdAt,
      quantity = 1,
  }) : quantity = RxInt(quantity), isSelected = RxBool(false);
}

// class Cart {
//   final int id;
//   final List<CartItem> items;

//   Cart({required this.id, required this.items});

//   double get totalPrice {
//     return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
//   }
// }