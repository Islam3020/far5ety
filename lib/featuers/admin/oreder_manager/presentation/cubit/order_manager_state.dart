import 'package:cloud_firestore/cloud_firestore.dart';

abstract class OrderManagerState {}

class OrderManagerInitial extends OrderManagerState {}

class OrderManagerLoading extends OrderManagerState {}

class OrderManagerLoaded extends OrderManagerState {
  final List<QueryDocumentSnapshot> orders;

  OrderManagerLoaded(this.orders);
}

class OrderManagerError extends OrderManagerState {
  final String message;

  OrderManagerError(this.message);
}
