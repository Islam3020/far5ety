
// نموذج بيانات لعنصر السلة
import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String productId;
  final String productName;
  final double weight;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.weight,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItem(
      id: doc.id,
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      weight: (data['weight'] as num?)?.toDouble() ?? 0.0,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      quantity: data['quantity'] ?? 1,
    );
  }

  double get total => price * weight * quantity;
}