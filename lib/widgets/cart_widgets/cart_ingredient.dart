import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/home_screen/models/models.dart';
import 'package:jara_market/widgets/custom_text_field.dart';

class CartItemCard1 extends StatefulWidget {
  final String name;
  final String unit;
  final double basePrice;
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
  final List<Ingredients> ingredients;
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
  double get totalPrice => widget.isSelected
      ? double.tryParse(widget.textController.text) ?? 0
      : widget.basePrice * widget.quantity.value;

  void _showDeleteConfirmationDialog(BuildContext context) {
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
                widget.onDeleteConfirmed(); // Call the delete callback
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
    return 
    
    Container(
      padding: const EdgeInsets.symmetric(vertical:10),
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
                 isSelected ? Text(
                          //  'N${widget.originalPrice!.toStringAsFixed(0)}',
                           '\u20A6${totalPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 14,
                            ),
                          ) :   Row(
                      children: [
                        Obx(()=> Text(
                          '\u20A6${totalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w800,
                          ),
                        ),),
                        //if (widget.originalPrice != null) ...[
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Text(
                          //  'N${widget.originalPrice!.toStringAsFixed(0)}',
                           '\u20A6${totalPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Colors.grey[500],
                              decoration: TextDecoration.lineThrough,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(children: [
                      Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text(
                      widget.unit,
                      style: TextStyle(
                        color: Color(0xff868D94),
                        fontWeight: FontWeight.w400,

                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                    ],),
                    Row(children: [
                      Checkbox(
                       // fillColor: MaterialStateProperty.all(Colors.green),
                        overlayColor: MaterialStateProperty.all(Colors.grey),
                        focusColor: Colors.grey,
                        activeColor: Colors.black,
                        side: const BorderSide(
                          color: Color(0xff868D94), // Change this to your desired stroke color
                          width: 2,          // Optional: stroke thickness
                        ),
                        checkColor: Colors.white,
                        value: isSelected, onChanged: (bool? value) {
                          widget.onCheckboxChanged(value);
                          setState(() {
                            isSelected = value ?? false;
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
                    ],)
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   IconButton(
                   // icon: const Icon(Icons.delete, color: Colors.red),
                   icon: SvgPicture.asset('assets/images/delete.svg'),
                    onPressed: () => _showDeleteConfirmationDialog(context),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: isSelected ? Container(
                      width: 119,
                      height: 36,
                      child: CustomTextField(hint: '25000', prefixIcon: Text('\u20A6'),)) : Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (widget.quantity.value > 1) {
                            //  widget.removeQuantity(widget.quantity - 1);
                              widget.removeQuantity();
                            }
                          },
                          child: Obx((){
                            return Container(
                            margin: EdgeInsets.all(4),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(3)),
                              color: widget.quantity.value == 1 ? Colors.grey[100] : Color(0xffFF9F0A)
                            ),
                            child: Icon(Icons.remove,size: 15,),
                          );
                          })
                        ),
                        Obx(() => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            widget.quantity.value.toString(),
                            style: const TextStyle(fontSize: 14, fontFamily: 'Inter', fontWeight: FontWeight.w500),
                          ),
                        ),),
                        GestureDetector(
                          onTap: (){
                            widget.addQuantity();
                          },
                          child: Container(
                            margin: EdgeInsets.all(4),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              color: Color(0xffFF9F0A)
                            ),
                            child: Icon(Icons.add,size: 15,),
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
  }
}
