import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:toury/core/utils/colors.dart';
import 'package:toury/core/utils/text_style.dart';
import 'package:toury/featuers/admin/oreder_manager/presentation/widgets/product_item.dart';

class OrderContainer extends StatefulWidget {
  final Map<String, dynamic> order;
  final String orderId;
  final VoidCallback onOrderCompleted;

  const OrderContainer({
    super.key,
    required this.order,
    required this.orderId,
    required this.onOrderCompleted,
  });

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
  late List<Map<String, dynamic>> items;
  late double total;
  final Map<String, TextEditingController> _weightControllers = {};

  @override
  void initState() {
    super.initState();
    items = List<Map<String, dynamic>>.from(widget.order['items'] ?? []);
    total = (widget.order['total'] as num?)?.toDouble() ?? 0.0;

    for (var item in items) {
      _weightControllers[item['productId']] = TextEditingController(
        text: item['weight']?.toString() ?? '0.0',
      );
    }
  }

  @override
  void dispose() {
    _weightControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _updateTotal() {
    double newTotal = 0.0;
    for (var item in items) {
      final weight =
          double.tryParse(_weightControllers[item['productId']]!.text) ?? 0.0;
      newTotal += (item['price'] as num).toDouble() * weight;
    }
    setState(() => total = newTotal);
  }

  Future<void> _completeOrder() async {
    try {
      // تحديث الأوزان في القائمة
      final updatedItems = items.map((item) {
        final weight =
            double.tryParse(_weightControllers[item['productId']]!.text) ?? 0.0;
        return {...item, 'weight': weight};
      }).toList();

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .update({
        'status': 'preparing',
        'items': updatedItems,
        'total': total,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تنفيذ الطلب بنجاح')),
      );

      widget.onOrderCompleted();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تنفيذ الطلب: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.accentColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // معلومات العميل
          Text(widget.order['contact']['phone'] ?? 'بدون رقم',
              style: getBodyStyle()),
          Gap(5.h),
          Text(
            widget.order['contact']['address'] ?? 'بدون عنوان',
            style: getBodyStyle(),
            softWrap: true,
            maxLines: null,
          ),
          Gap(10.h),

          // قائمة المنتجات
          ...items.map((item) => ProductItem(
                item: item,
                controller: _weightControllers[item['productId']]!,
                onChanged: _updateTotal,
              )),
          // ...items.map((item) => _buildProductItem(item)),

          Gap(15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الإجمالي: ${total.toStringAsFixed(2)} ج',
                style: getBodyStyle(fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: _completeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'تنفيذ الطلب',
                  style: getBodyStyle().copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
