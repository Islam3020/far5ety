import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final String status; // 'pending', 'completed', 'cancelled'
  final ContactInfo contact;
  final List<OrderItem> items;
  final double total;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.contact,
    required this.items,
    required this.total,
    required this.createdAt,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'],
      status: data['status'],
      contact: ContactInfo.fromMap(data['contact']),
      items: List<OrderItem>.from(
          data['items']?.map((x) => OrderItem.fromMap(x)) ?? []),
      total: (data['total'] as num).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'status': status,
      'contact': contact.toMap(),
      'items': items.map((x) => x.toMap()).toList(),
      'total': total,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class OrderItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final double weight; 

  OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.weight
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
      weight: (map['weight'] as num).toDouble(), 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'weight': weight
    };
  }
}

class ContactInfo {
  final String phone;
  final String address;

  ContactInfo({required this.phone, required this.address});

  factory ContactInfo.fromMap(Map<String, dynamic> map) {
    return ContactInfo(
      phone: map['phone'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'address': address,
    };
  }
}