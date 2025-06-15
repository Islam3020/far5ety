import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toury/core/utils/colors.dart';
import 'package:toury/core/utils/text_style.dart';

class ProductItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final TextEditingController controller;
  final VoidCallback onChanged;

  const ProductItem({
    super.key,
    required this.item,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '${item['name']} x${item['quantity']}',
              style: getBodyStyle(),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'الوزن',
                hintStyle: getBodyStyle(),
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.redColor,
                    width: 1.w,
                  ),
                 
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              ),
              style: getBodyStyle(),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onChanged: (_) => onChanged(),
            ),
          ),
        ],
      ),
    );
  }
}