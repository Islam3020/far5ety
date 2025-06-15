import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final String orderId;
  final VoidCallback onStatusChanged;

  const OrderCard({
    super.key,
    required this.order,
    required this.orderId,
    required this.onStatusChanged,
  });

  Future<void> _updateOrderStatus(String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});
      onStatusChanged();
    } catch (e) {
      debugPrint('Error updating order status: $e');
    }
  }

  String _formatDate(Timestamp timestamp) {
    return DateFormat('hh:mm a').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    final items = order['items'] as List<dynamic>;
    final contact = order['contact'] as Map<String, dynamic>;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              
              children: [
               
                Text(
                  _formatDate(order['createdAt']),
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
            Divider(height: 24.h),

            // Customer Info
           
            Text(
              'التليفون: ${contact['phone'] ?? 'غير متوفر'}',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              'العنوان: ${contact['address'] ?? 'غير محدد'}',
              style: TextStyle(fontSize: 14.sp),
            ),
            Divider(height: 24.h),

            // Order Items
            Text(
              'المنتجات:',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            ...items.map((item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item['name']} (${item['quantity']} × ${item['price']} ج)',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                  if (item['weight'] != null)
                    Text(
                      '${item['weight']} كجم',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                ],
              ),
            )),
            Divider(height: 24.h),

            // Order Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الإجمالي:',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${order['total']?.toStringAsFixed(2) ?? '0.00'} ج',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Status Actions
            if (order['status'] == 'pending')
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateOrderStatus('preparing'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'بدء التحضير',
                        style: TextStyle(fontSize: 14.sp, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateOrderStatus('cancelled'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'إلغاء الطلب',
                        style: TextStyle(fontSize: 14.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            if (order['status'] == 'preparing')
              ElevatedButton(
                onPressed: () => _updateOrderStatus('completed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 48.h),
                ),
                child: Text(
                  'تم الانتهاء',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white),
                ),
              ),
            if (order['status'] == 'completed')
              Text(
                'تم تنفيذ الطلب',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            if (order['status'] == 'cancelled')
              Text(
                'تم إلغاء الطلب',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}