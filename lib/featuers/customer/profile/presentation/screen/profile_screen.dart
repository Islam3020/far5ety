import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toury/core/functions/navigation.dart';
import 'package:toury/core/services/local_storage.dart';
import 'package:toury/core/utils/text_style.dart';
import 'package:toury/featuers/auth/presentation/pages/login_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _userDataFuture;
  late Future<QuerySnapshot> _activeOrdersFuture;
  late Future<QuerySnapshot> _completedOrdersFuture;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _userId = AppLocalStorage.getData(key: AppLocalStorage.userToken);
    AppLocalStorage.removeData(key: AppLocalStorage.userType);
    _loadData();
  }

  void _loadData() {
    _userDataFuture = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .get()
        .then((snapshot) => snapshot.data() ?? {});

    _activeOrdersFuture = FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: _userId)
        .where('status', whereIn: ['pending', 'preparing'])
        .orderBy('createdAt', descending: true)
        .get();

    _completedOrdersFuture = FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: _userId)
        .where('status', whereIn: ['completed', 'cancelled'])
        .orderBy('createdAt', descending: true)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('حسابي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AppLocalStorage.removeData(key: AppLocalStorage.userToken);
              pushReplacement(context,const LoginView());
            },
          ),
        ],
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userDataFuture,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${userSnapshot.error}'));
          }

          

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // معلومات المستخدم
                
                SizedBox(height: 32.h),

                // الطلبات الحالية
                Text('الطلبات الحالية', style: getTitleStyle()),
                SizedBox(height: 16.h),
                FutureBuilder<QuerySnapshot>(
                  future: _activeOrdersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text('حدث خطأ في جلب الطلبات'));
                    }

                    final orders = snapshot.data?.docs ?? [];

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index].data() as Map<String, dynamic>;
                        return _buildOrderCard(order, orders[index].id, true);
                      },
                    );
                  },
                ),

                SizedBox(height: 32.h),

                // الطلبات السابقة
                Text('سجل الطلبات', style: getTitleStyle()),
                SizedBox(height: 16.h),
                FutureBuilder<QuerySnapshot>(
                  future: _completedOrdersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text('حدث خطأ في جلب الطلبات'));
                    }

                    final orders = snapshot.data?.docs ?? [];

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index].data() as Map<String, dynamic>;
                        return _buildOrderCard(order, orders[index].id, false);
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
Widget _buildOrderCard(Map<String, dynamic> order, String orderId, bool isCurrent) {
  final items = order['items'] as List<dynamic>;
  final total = order['total']?.toStringAsFixed(2) ?? '0.00';
  final status = _getStatusText(order['status']);

  return Card(
    margin: EdgeInsets.symmetric(vertical: 8.h),
    child: ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('عدد المنتجات: ${items.length}'),
          ...items.map((item) {
            final name = item['name'] ?? 'منتج بدون اسم';
            final quantity = item['quantity'] ?? 1;
            return Text('- $name x$quantity');
          }),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('حالة الطلب: $status'),
          Text('الإجمالي: $total ج.م'),
          if (order['createdAt'] != null)
            Text('التاريخ: ${_formatDate(order['createdAt'].toDate())}'),
        ],
      ),
      trailing: isCurrent
          ? PopupMenuButton<String>(
              onSelected: (value) => _handleOrderAction(value, orderId, order['status']),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'cancel', child: Text('إلغاء الطلب')),
              ],
            )
          : null,
    ),
  );
}


  String _getStatusText(String status) {
    switch (status) {
      case 'pending': return 'في انتظار التأكيد';
      case 'preparing': return 'جاري التحضير';
      case 'completed': return 'تم التنفيذ';
      case 'cancelled': return 'ملغى';
      default: return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleOrderAction(String action, String orderId, String currentStatus) {
    if (action == 'cancel') {
      FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': 'cancelled'})
          .then((_) => _loadData()); // إعادة تحميل البيانات بعد التعديل
    }
  }
}