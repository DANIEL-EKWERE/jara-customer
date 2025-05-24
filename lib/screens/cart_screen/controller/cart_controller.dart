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


  void incrementIngredientQuantity(int itemId, int ingredientId) {
  // Find the cart item
  final itemIndex = cartItems.indexWhere((item) => item.id == itemId);
  if (itemIndex != -1) {
    final cartItem = cartItems[itemIndex];

    // Find the ingredient
    final ingredientIndex =
        cartItem.ingredients.indexWhere((ing) => ing.id == ingredientId);
    if (ingredientIndex != -1) {
      final ingredient = cartItem.ingredients[ingredientIndex];

      // Increment ingredient quantity
      ingredient.quantity?.value++;
      print('Incremented ${ingredient.name} to ${ingredient.quantity?.value}');
    } else {
      print('Ingredient with id $ingredientId not found.');
    }
  } else {
    print('Cart item with id $itemId not found.');
  }
}
  void decrementIngredientQuantity(int itemId, int ingredientId) {
    // Find the cart item
    print('calling method');
    final itemIndex = cartItems.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      final cartItem = cartItems[itemIndex];

      // Find the ingredient
      final ingredientIndex =
          cartItem.ingredients.indexWhere((ing) => ing.id == ingredientId);
      if (ingredientIndex != -1) {
        final ingredient = cartItem.ingredients[ingredientIndex];

        // Decrement ingredient quantity
        if (ingredient.quantity?.value != null && ingredient.quantity!.value > 0) {
          ingredient.quantity?.value--;
          print('Decremented ${ingredient.name} to ${ingredient.quantity?.value}');
        } else {
          print('Ingredient quantity is already zero-one or null.');
        }
      } else {
        print('Ingredient with id $ingredientId not found.');
      }
    } else {
      print('Cart item with id $itemId not found.');
    }
  }

  removeIngredient(int itemId, int ingredientId) {
    // Find the cart item
    final itemIndex = cartItems.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      final cartItem = cartItems[itemIndex];

      // Remove the ingredient
      cartItem.ingredients.removeWhere((ing) => ing.id == ingredientId);
      print('Removed ingredient with id $ingredientId from item $itemId');
    } else {
      print('Cart item with id $itemId not found.');
    }
  }

  void toggleItemSelection(int itemId, int ingredientId) {
    int index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final ingredientIndex = cartItems[index].ingredients.indexWhere((ing) => ing.id == ingredientId);
      if (ingredientIndex != -1) {
        cartItems[index].ingredients[ingredientIndex].isSelected.value = !cartItems[index].ingredients[ingredientIndex].isSelected.value;
        print('Toggled selection for ingredient: ${cartItems[index].ingredients[ingredientIndex].name}, Selected: ${cartItems[index].ingredients[ingredientIndex].isSelected.value}');
      } else {
        print('Ingredient with id $ingredientId not found in item $itemId.');
      }

      // cartItems[index].isSelected.value = !cartItems[index].isSelected.value;
    //  print('Toggled selection for item: ${cartItems[index].name}, Selected: ${cartItems[index].isSelected.value}');
    } else {
      print('Item with id $itemId not found.');
    }
  }
}