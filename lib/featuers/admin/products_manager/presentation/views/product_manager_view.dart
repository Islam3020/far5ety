import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:toury/core/functions/dialogs.dart';
import 'package:toury/core/functions/navigation.dart';
import 'package:toury/core/services/local_storage.dart';
import 'package:toury/core/widgets/custom_button.dart';
import 'package:toury/featuers/admin/products_manager/presentation/cubit/product_manager_cubit.dart';
import 'package:toury/featuers/admin/products_manager/presentation/cubit/product_manager_state.dart';
import 'package:toury/featuers/admin/products_manager/presentation/widgets/edit_product.dart';

class ProductManagerView extends StatefulWidget {
  const ProductManagerView({super.key});

  @override
  State<ProductManagerView> createState() => _ProductManagerViewState();
}

class _ProductManagerViewState extends State<ProductManagerView> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productTypeController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
   User? user;

  Future<void> _getUser() async {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    
    super.initState();
    AppLocalStorage.cacheData(
      key: AppLocalStorage.userType,
      value: 'admin',
    );
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المنتجات'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Form(
            key: _formKey,
            child: BlocListener<ProductManagerCubit, ProductManagerState>(
              listener: (context, state) {
                if (state is AddProducrtLoading) {
                  showDialog(
                    context: context,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (state is AddProducrtSuccess) {
                  Navigator.pop(context);
                  productNameController.clear();
                  productTypeController.clear();
                  productPriceController.clear();
                 showToast(context, 'تم اضافة المنتج بنجاح');
                  
                }
                if (state is AddProducrtError) {
                  Navigator.pop(context);
                  showToast(context,state.message,isError: true);
                }
              },
              child: Column(
                children: [
                  Gap(50.h),
                  TextFormField(
                    controller: productNameController,
                    decoration: InputDecoration(
                      hintText: 'اسم المنتج',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  Gap(20.h),
                  TextFormField(
                    controller: productTypeController,
                    decoration: InputDecoration(
                      hintText: 'الصنف ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  Gap(20.h),
                  TextFormField(
                    controller: productPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'السعر ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  Gap(20.h),
                  CustomButton(
                      width: 200.w,
                      text: 'اضف منتج',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ProductManagerCubit>().addProduct(
                            productName: productNameController.text,
                            productType: productTypeController.text,
                            productPrice: productPriceController.text,
                          );
                        }
                      }),
                  Gap(40.h),
                  CustomButton(
                      width: 200.w,
                      text: 'تعديل الاسعار',
                      onPressed: () {
                        push(context, const EditProductView());
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
