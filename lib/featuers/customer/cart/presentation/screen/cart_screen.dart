import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toury/core/functions/navigation.dart';
import 'package:toury/core/services/local_storage.dart';
import 'package:toury/core/utils/colors.dart';
import 'package:toury/core/utils/text_style.dart';
import 'package:toury/core/widgets/custom_button.dart';
import 'package:toury/featuers/customer/cart/data/model/cart_model.dart';
import 'package:toury/featuers/customer/cart/presentation/cubit/cubit/cart_cubit.dart';
import 'package:toury/featuers/customer/cart/presentation/screen/checkout.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = AppLocalStorage.getData(key: AppLocalStorage.userToken);
    if (userId != null) {
      context.read<CartCubit>().getCartItems(userId!);
    }
  }

  double _calculateTotalPrice(List<CartItem> cartItems) {
    return cartItems.fold(0.0, (sum, item) => sum + item.total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('السلة'),
          centerTitle: true,
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartError) {
              return Center(child: Text(state.error));
            } else if (state is CartEmpty) {
              return const Center(child: Text('السلة فارغة'));
            } else if (state is CartLoaded) {
              final cartItems = state.cartItems;
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: cartItems.length,
                      separatorBuilder: (_, __) => Divider(height: 20.h),
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.grey[200],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style:
                                          getTitleStyle(color: AppColors.black),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text('الوزن: ${item.weight} كجم'),
                                    Text('السعر للوحدة: ${item.price} ج.م'),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'الإجمالي: ${item.total} ج.م',
                                      style:
                                          getTitleStyle(color: AppColors.black),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => context
                                    .read<CartCubit>()
                                    .removeFromCart(item.id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border(top: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الإجمالي: ${_calculateTotalPrice(cartItems).toStringAsFixed(2)} ج.م',
                          style: getTitleStyle(color: AppColors.black),
                        ),
                        CustomButton(
                          width: 120.w,
                          text: 'إتمام الطلب',
                          onPressed: () {
                            push(
                              context,
                              CheckoutScreen(
                                cartItems: cartItems,
                                total: _calculateTotalPrice(cartItems),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }else {
              return const Center(child: Text('حدث خطاء'));
            }
          },
        ));
  }
}
