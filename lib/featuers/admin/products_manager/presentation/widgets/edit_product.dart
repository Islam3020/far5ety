import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:toury/core/functions/dialogs.dart';
import 'package:toury/core/utils/text_style.dart';
import 'package:toury/core/widgets/custom_button.dart';
import 'package:toury/featuers/admin/products_manager/presentation/cubit/product_manager_cubit.dart';
import 'package:toury/featuers/admin/products_manager/presentation/cubit/product_manager_state.dart';

class EditProductView extends StatefulWidget {
  const EditProductView({super.key});

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  
  

 @override
void initState() {
  super.initState();
  context.read<ProductManagerCubit>().getProducts();
}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل المنتج', style: getTitleStyle()),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
      ),
      body: BlocConsumer<ProductManagerCubit, ProductManagerState>(
        listener: (context, state)async {
           if (state is UpdateProductSuccess) {
            showToast(context, 'تم تحديث المنتج بنجاح');
            context.read<ProductManagerCubit>().getProducts();
          } else if (state is UpdateProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('فشل في التحديث: ${state.message}')),
            );
          }

          if (state is DeleteProductSuccess) {
            showToast(context, 'تم حذف المنتج بنجاح');
            context.read<ProductManagerCubit>().getProducts();
          } else if (state is DeleteProductError) {
            showToast(context, 'فشل في الحذف: ${state.message}', isError: true);
          }
        },
        builder: (context, state) {
          if (state is GetProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if(state is GetProductsSuccess){
             final products = state.products;
            return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index].data() as Map<String, dynamic>;
        final productId = products[index].id;

              TextEditingController controller = TextEditingController(
                text: product['productPrice']?.toString() ?? '',
              );

              return ExpansionTile(
                title: Text(
                    "${product['productName']}  ${product['productPrice']}",
                    style: getBodyStyle()),
                children: [
                  TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'سعر المنتج',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Gap(10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        width: 100.w,
                        text: 'حفظ',
                        onPressed: () async {
                          if (controller.text.isNotEmpty) {
                            await context.read<ProductManagerCubit>().updateProductPrice(
                              productId,
                              controller.text.isNotEmpty
                                  ? double.parse(controller.text)
                                  : 0.0,
                            );
                          }
                        },
                      ),
                      CustomButton(
                        width: 100.w,
                        text: 'حذف',
                        onPressed: () {
                          context.read<ProductManagerCubit>().deleteProduct(productId);
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          );
          }else {
            return const Center(child: Text('لا توجد منتجات'));
          }
        },
      ),
    );
  }
}
