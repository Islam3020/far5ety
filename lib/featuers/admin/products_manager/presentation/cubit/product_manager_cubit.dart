import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toury/featuers/admin/products_manager/presentation/cubit/product_manager_state.dart';

class ProductManagerCubit extends Cubit<ProductManagerState>{
  ProductManagerCubit():super(ProductManagerInitial());

  Future <void> addProduct({
    required String productName,
    required String productType,
    required String productPrice,
  }) async {
    emit(AddProducrtLoading());
    try {
      FirebaseFirestore.instance.collection('products').add({
                      'productName': productName,
                      'productType': productType,
                      'productPrice': productPrice,
                    });
      await Future.delayed(const Duration(seconds: 2));
      emit(AddProducrtSuccess());
    } catch (e) {
      emit(AddProducrtError(message: e.toString()));
    }
  }
Future<void> getProducts() async {
  emit(GetProductsLoading());
  try {
    final snapshot = await FirebaseFirestore.instance.collection('products').get();
    final products = snapshot.docs;
    emit(GetProductsSuccess(products));
  } catch (e) {
    emit(GetProductsError(message: e.toString()));
  }
}
  Future<void> updateProductPrice(String productId, double newPrice) async {
    emit(UpdateProductLoading());
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update({'productPrice': newPrice});
      
      emit(UpdateProductSuccess());
    } catch (e) {
      emit(UpdateProductError(message: e.toString()));
    }
  }

  Future<void> deleteProduct(String productId) async {
    emit(UpdateProductLoading());
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();
      
      emit(UpdateProductSuccess());
    } catch (e) {
      emit(UpdateProductError(message: e.toString()));
    }
  }
}