import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/cart_screen/models/models.dart';

import 'package:jara_market/widgets/custom_text_field.dart';

var controller = Get.find<CartController>();

class CartItemCard1 extends StatefulWidget {
  final int id;
  final String name;
  final String unit;
  final RxDouble basePrice;
  final double? originalPrice;
  final RxInt quantity;
  // final Function(int) addQuantity;
  // final Function(int) removeQuantity;
  final Function() addQuantity;
  final Function() removeQuantity;
  final VoidCallback onDeleteConfirmed;
  final TextEditingController textController;
  final bool isSelected;
  final Function(bool?) onCheckboxChanged;
  final RxList<Ingredients> ingredients;
// int? id;
//   String? name;
//   String? description;
//   String? price;
//   String? unit;
//   String? stock;
//   String? imageUrl;
//   String? createdAt;

  const CartItemCard1({
    Key? key,
    required this.id,
    required this.name,
    required this.unit,
    required this.basePrice,
    this.originalPrice,
    required this.quantity,
    required this.addQuantity,
    required this.removeQuantity,
    required this.onDeleteConfirmed,
    required this.textController,
    required this.isSelected,
    required this.onCheckboxChanged,
    required this.ingredients,
  }) : super(key: key);

  @override
  State<CartItemCard1> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard1> {
  TextEditingController textController = TextEditingController();
  int count = 0;
  double? result;
  double get totalPrice => widget.isSelected
      ? double.tryParse(widget.textController.text) ?? 0
      : widget.basePrice * widget.quantity.value;

  void _showDeleteConfirmationDialog(BuildContext context, int itemId, int ingredientId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Text(
              'Are you sure you want to delete this item from your cart?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
               controller.removeIngredient(itemId, ingredientId);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog1(BuildContext context, int itemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Text(
              'Are you sure you want to delete this item from your cart?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
               controller.removeFromCart(itemId);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.ingredients.isNotEmpty)
          Container(
            width: double.infinity,
            height: 73,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Center(
                    child: Text(
                  widget.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
                Row(children: [
                  const SizedBox(width: 10),
                  Obx((){
                    return Text(
                    '\u20A6${widget.basePrice.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                  }),
                  const Spacer(),
                  IconButton(
                              icon: SvgPicture.asset(
                                  'assets/images/delete.svg'),
                              onPressed: () =>
                                  _showDeleteConfirmationDialog1(context, widget.id),
                            ),
                  const SizedBox(width: 10),
                ],)
              ],
            )),
        Obx((){
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.ingredients.length,
            itemBuilder: (context, index) {
              
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.ingredients[index].isSelected.value
                                  ? Text(
                                      '\u20A6${widget.ingredients[index].price! * widget.ingredients[index].quantity!.value}',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w800,
                                        decoration:
                                            TextDecoration.lineThrough,
                                        fontSize: 14,
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        Obx(
                                          () => Text(
                                            '\u20A6${widget.ingredients[index].price! * widget.ingredients[index].quantity!.value}',
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        //if (widget.originalPrice != null) ...[
                                        if (isSelected) ...[
                                          const SizedBox(width: 8),
                                          Text(
                                            //  'N${widget.originalPrice!.toStringAsFixed(0)}',
                                            '\u20A6${totalPrice.toStringAsFixed(0)}',
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    widget.ingredients[index].name!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.unit,
                                    style: TextStyle(
                                      color: Color(0xff868D94),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      focusColor: Colors.grey,
                                      activeColor: Colors.black,
                                      side: const BorderSide(
                                        color: Color(
                                            0xff868D94), // Change this to your desired stroke color
                                        width:
                                            2, // Optional: stroke thickness
                                      ),
                                      checkColor: Colors.white,
                                      value: isSelected,
                                      onChanged: (bool? value) {
                                        widget.onCheckboxChanged(value);
                                        setState(() {
                                          count++;
                                         // isSelected = value ?? false;
                                         if(value! && count == 0){
                                         result = widget.ingredients[index].price;
                                         }else if(!value && count > 0){
                                          widget.ingredients[index].price = result;
                                         }

                                          controller.toggleItemSelection(widget.id, widget.ingredients[index].id);
                                        });
                                      }),
                                  //SizedBox(width: 2,),
                                  Text(
                                    'Custom Price',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          //mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              // icon: const Icon(Icons.delete, color: Colors.red),
                              icon: SvgPicture.asset(
                                  'assets/images/delete.svg'),
                              onPressed: () =>
                                  _showDeleteConfirmationDialog(context, widget.id, widget.ingredients[index].id),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: widget.ingredients[index].isSelected.value
                                  ? Container(
                                      width: 119,
                                      height: 36,
                                      child: CustomTextField(
                                        keyboardType: TextInputType.number,
                                        controller: textController,
                                        onChanged: (p0){
                                          controller.updateCustomPrice(widget.id, widget.ingredients[index].id, p0);
                                        },
                                        hint: '25000',
                                        prefixIcon: Text('\u20A6'),
                                      ))
                                  : Row(
                                      children: [
                                        GestureDetector(onTap: () {
                                          if (widget.ingredients[index].quantity!.value > 1) {
                                            controller
                                                .decrementIngredientQuantity(
                                                    widget.id,
                                                    widget.ingredients[index]
                                                        .id);
                                          }
                                        }, child: Obx(() {
                                          return Container(
                                            margin: EdgeInsets.all(4),
                                            width: 22,
                                            height: 22,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(3)),
                                                color: widget
                                                            .ingredients[
                                                                index]
                                                            .quantity!
                                                            .value ==
                                                        1
                                                    ? Colors.grey[100]
                                                    : Color(0xffFF9F0A)),
                                            child: Icon(
                                              Icons.remove,
                                              size: 15,
                                            ),
                                          );
                                        })),
                                        Obx(
                                          () => Padding(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8),
                                            child: Text(
                                              widget.ingredients[index]
                                                  .quantity!.value
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Inter',
                                                  fontWeight:
                                                      FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            //widget.addQuantity();
                                            controller
                                                .incrementIngredientQuantity(
                                                    widget.id,
                                                    widget.ingredients[index]
                                                        .id);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(4),
                                            width: 22,
                                            height: 22,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(3)),
                                                color: Color(0xffFF9F0A)),
                                            child: Icon(
                                              Icons.add,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
        
                    // ListView.builder(
                    // itemCount: widget.ingredients.length, shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
                    // itemBuilder: (context, index) {
                    //   final ingredient = widget.ingredients[index];
                    //   return Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 4),
                    //     child: Text(
                    //       '${ingredient.name} - \u20A6${ingredient.price}',
                    //       style: const TextStyle(
                    //         fontSize: 12,
                    //         fontFamily: 'Inter',
                    //         fontWeight: FontWeight.w400,
                    //       ),
                    //     ),
                    //   );
                    // }
                    // ),
                  ],
                ),
              );
            });
        }),
      ],
    );
  }
}
