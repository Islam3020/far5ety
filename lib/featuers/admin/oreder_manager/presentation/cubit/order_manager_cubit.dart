import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toury/featuers/admin/oreder_manager/presentation/cubit/order_manager_state.dart';

class OrderManagerCubit extends Cubit<OrderManagerState> {
  OrderManagerCubit() : super(OrderManagerInitial());
  

 // في OrderManagerCubit
Future<void> fetchOrders() async {
  emit(OrderManagerLoading());
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .get();
        
    final orders = snapshot.docs;
    emit(OrderManagerLoaded(orders));
  } catch (error) {
    emit(OrderManagerError('Failed to fetch orders: $error'));
  }
}



}

