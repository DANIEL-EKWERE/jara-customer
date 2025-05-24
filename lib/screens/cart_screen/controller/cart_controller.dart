import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/models/models.dart';



class CartController extends GetxController {
  

  RxList<CartItem> cartItems = <CartItem>[].obs;

  void addToCart(CartItem item) {
    print(item.name);
    int index = cartItems.indexWhere((cartItem) => cartItem.id == item.id);
    print('Index found: $index');
    if (index == -1) {
      cartItems.add(item);
      print(cartItems.length);
      print('Item added to cart: ${item.name}, Quantity: ${item.quantity}');
    } else {
      cartItems[index].quantity += item.quantity.value;
      print(cartItems.length);
      print(cartItems[index].quantity);
    }
   // print('Item added to cart: ${item.name}, Quantity: ${item.quantity}');
  }

  void removeFromCart(int itemId) {
    print('removing $itemId');
    cartItems.removeWhere((item) => item.id == itemId);
  }

  void updateItemQuantity(int itemId, int quantity) {
    print(quantity);
    int index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (quantity <= 0) {
        cartItems.removeAt(index);
      } else {
        cartItems[index].quantity.value = quantity;
      }
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  double get totalPrice {
    return cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity.value));
  }
}