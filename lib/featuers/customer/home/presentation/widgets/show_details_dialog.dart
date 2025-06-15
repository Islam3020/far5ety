import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toury/core/services/local_storage.dart';
import 'package:toury/core/widgets/custom_button.dart';
void showDetailsDialog({
  required BuildContext context,
  
  required String productName,
  required String price,
}) {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          productName,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'السعر: $price ج.م',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
            SizedBox(height: 16.h),
             TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ادخل العدد ',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ادخل الوزن بالكيلو',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          CustomButton(
            text: 'أضف للسلة',
            onPressed: () {
              if (weightController.text.isNotEmpty&&
                  numberController.text.isNotEmpty) {
                final weight = double.tryParse(weightController.text);
                final number = int.tryParse(numberController.text);
                if (weight != null && weight > 0 && number != null && number > 0) {
                  addToCart(userId: AppLocalStorage.getData(key: AppLocalStorage.userToken),productId: productName, productName: productName, price: double.parse(price), quantity: number, weight: weight);
                  
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تمت إضافة المنتج للسلة')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('الوزن غير صالح')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('من فضلك أدخل الوزن')),
                );
              }
            },
          ),
        ],
      );
    },
  );
}

 Future<void> addToCart({
  required String userId,
  required String productId,
  required String productName,
  required double price,
  required double weight,
  int quantity = 1,
}) async {
  try {
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart');

    // التحقق إذا كان المنتج موجود بالفعل في السلة
    final existingItem = await cartRef
        .where('productId', isEqualTo: productId)
        .limit(1)
        .get();

    if (existingItem.docs.isNotEmpty) {
      // إذا المنتج موجود، نزيد الكمية فقط
      await cartRef
          .doc(existingItem.docs.first.id)
          .update({'quantity': FieldValue.increment(quantity)});
    } else {
      // إذا المنتج غير موجود، نضيفه جديد
      await cartRef.add({
        'productId': productId,
        'productName': productName,
        'weight': weight,
        'price': price,
        'quantity': quantity,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  } catch (e) {
    debugPrint('Error adding to cart: $e');
    throw Exception('Failed to add item to cart');
  }
}
