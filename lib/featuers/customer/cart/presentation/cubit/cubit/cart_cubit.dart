import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toury/core/services/local_storage.dart';
import 'package:toury/featuers/customer/cart/data/model/cart_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  StreamSubscription? cartSubscription;
  final String userId = AppLocalStorage.getData(key: AppLocalStorage.userToken);
  

  Future<void> addToCart({
    required String userId,
    required String productId,
    required String productName,
    required double price,
    required double weight,
    int quantity = 1,
  }) async {
    emit(AddToCartLoading());
    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart');

      // التحقق إذا كان المنتج موجود بالفعل في السلة
      final existingItem =
          await cartRef.where('productId', isEqualTo: productId).limit(1).get();

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
      emit(AddToCartSuccess());
    } catch (e) {
      emit(AddToCartError(e.toString()));
      debugPrint('Error adding to cart: $e');
      throw Exception('Failed to add item to cart');
    }
  }
void getCartItems(String userId) {
  emit(CartLoading());

  // إلغاء أي اشتراك قديم
  cartSubscription?.cancel();

  cartSubscription = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cart')
      .snapshots()
      .listen((snapshot) {
    final cartItems =
        snapshot.docs.map((doc) => CartItem.fromFirestore(doc)).toList();

    if (cartItems.isEmpty) {
      emit(CartEmpty());
    } else {
      emit(CartLoaded(cartItems));
    }
  }, onError: (error) {
    debugPrint('Error fetching cart: $error');
    emit(CartError('حدث خطأ أثناء تحميل السلة'));
  });
}


  @override
  Future<void> close() {
    cartSubscription?.cancel();
    return super.close();
  }

  double calculateTotalPrice(List<CartItem> cartItems) {
    return cartItems.fold(0.0, (sum, item) => sum + item.total);
  }

  Future<void> removeFromCart(String cartItemId) async {
    emit(RemoveFromCartLoading());
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId) // معروف من الكلاس
          .collection('cart')
          .doc(cartItemId)
          .delete();

      emit(RemoveFromCartSuccess());
    } catch (e) {
      emit(RemoveFromCartError('فشل في حذف العنصر من السلة'));
      debugPrint('Error removing from cart: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart');

      final snapshot = await cartRef.get();
      final batch = FirebaseFirestore.instance.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      emit(CartEmpty());
    } catch (e) {
      debugPrint('Error clearing cart: $e');
       emit(CartError('فشل في مسح السلة'));
    }
  }
Future<void> createOrder({
  required String phone,
  required String address,
  required List<Map<String, dynamic>> items,
  required String paymentMethod,
  required double total
}) async {
  try {
    emit(OrderCreate());

   

    // Create the order
    await FirebaseFirestore.instance.collection('orders').add({
      'userId': userId,
      'status': 'pending',
      'paymentMethod': paymentMethod,
      'contact': {
        'phone': phone,
        'address': address,
      },
      'items': items,
      'total': total,
      'createdAt': FieldValue.serverTimestamp(),
    });

    emit(OrderCreated());
  } catch (e) {
    emit(OrderCreateError(e.toString()));
  }
}

}
