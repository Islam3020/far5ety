import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toury/core/functions/navigation.dart';
import 'package:toury/core/services/local_storage.dart';
import 'package:toury/featuers/admin/store/presentation/widgets/order_card.dart';
import 'package:toury/featuers/auth/presentation/pages/login_view.dart';

class StoreView extends StatefulWidget {
  const StoreView({super.key});

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  late DateTime _selectedDate;
  late Future<QuerySnapshot> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final startOfDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    setState(() {
      _ordersFuture = FirebaseFirestore.instance
          .collection('orders')
          .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
          .where('createdAt', isLessThan: endOfDay)
          .orderBy('createdAt', descending: true)
          .get();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلبات اليوم'),
        leading:  IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AppLocalStorage.removeData(key: AppLocalStorage.userToken);
              AppLocalStorage.removeData(
                key: AppLocalStorage.userType,
                
              );
              pushReplacement(context,const LoginView());
            },
          ),
        actions: [

          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: FutureBuilder<QuerySnapshot>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('حدث خطأ: ${snapshot.error}'));
            }

            final orders = snapshot.data?.docs ?? [];

            if (orders.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد طلبات لليوم المحدد',
                  style: TextStyle(fontSize: 18.sp),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _loadOrders,
              child: ListView.separated(
                itemCount: orders.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final order = orders[index].data() as Map<String, dynamic>;
                  return OrderCard(
                    order: order,
                    orderId: orders[index].id,
                    onStatusChanged: _loadOrders,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}