import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toury/core/functions/navigation.dart';
import 'package:toury/core/utils/text_style.dart';
import 'package:toury/core/widgets/custom_button.dart';
import 'package:toury/featuers/customer/cart/data/model/cart_model.dart';
import 'package:toury/featuers/customer/cart/presentation/cubit/cubit/cart_cubit.dart';
import 'package:toury/featuers/customer/customer_nav_bar.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen(
      {super.key, required this.cartItems, required this.total});
  final List<CartItem> cartItems;
  final double total;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String paymentMethod = 'كاش عند الاستلام';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مراجعة الطلب'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {
            if(state is OrderCreate){
              // عرض مؤشر التحميل
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Row(
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(width: 16.w),
                        const Text('جاري إنشاء الطلب...'),
                      ],
                    ),
                  );
                },
              );
            }
            if (state is OrderCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إنشاء الطلب بنجاح'),
                  duration: Duration(seconds: 3),
                ),
              );

              // تنظيف الحقول
              _phoneController.clear();
              _addressController.clear();

              // مسح السلة
              context.read<CartCubit>().clearCart();

              // الذهاب إلى الصفحة الرئيسية
              pushAndRemoveUntil(context, const CustomerNavBar());
            }
             else if (state is OrderCreateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('فشل إنشاء الطلب: ${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            }else if(state is OrderCreate){
              const Center(child: CircularProgressIndicator());
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'عنوان التوصيل',
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _addressController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'من فضلك أدخل العنوان'
                          : null,
                      decoration: InputDecoration(
                        hintText: 'اكتب عنوانك بالتفصيل...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.r)),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFE6EFF9),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'رقم التواصل',
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                       validator: (value) => value == null || value.isEmpty ? 'من فضلك أدخل رقم الهاتف' : null,
                      decoration: InputDecoration(
                        hintText: 'اكتب رقم تليفونك...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.r)),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFE6EFF9),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'طريقة الدفع',
                      style: getTitleStyle(),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('كاش عند الاستلام'),
                            value: 'كاش عند الاستلام',
                            groupValue: paymentMethod,
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  paymentMethod = value!;
                                });
                              }
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('فودافون كاش'),
                            value: 'فودافون كاش',
                            groupValue: paymentMethod,
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  paymentMethod = value!;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    CustomButton(
                        text: 'تأكيد الطلب',
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;

                          final cartItems = widget.cartItems
                              .map((item) => {
                                    'productId': item.productId,
                                    'name': item.productName,
                                    'price': item.price,
                                    'quantity': item.quantity,
                                    'weight': item.weight,
                                  })
                              .toList();

                          context.read<CartCubit>().createOrder(
                              phone: _phoneController.text,
                              address: _addressController.text,
                              items: cartItems,
                              paymentMethod: paymentMethod,
                              total: widget.total);
                        })
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
