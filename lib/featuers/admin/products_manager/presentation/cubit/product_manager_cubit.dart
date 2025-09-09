import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toury/featuers/admin/products_manager/presentation/cubit/product_manager_state.dart';

class ProductManagerCubit extends Cubit<ProductManagerState>{
  ProductManagerCubit():super(ProductManagerInitial());

  String? imagePath;
  File? file;
  String? image;

  Future <void> addProduct({
    required String productName,
    required String productImage,
    required String productType,
    required String productPrice,
  }) async {
    emit(AddProducrtLoading());
    try {
      FirebaseFirestore.instance.collection('products').add({
                      'productName': productName,
                      'productImage': productImage,
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

    Future<void> pickImage() async {
    
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      
        imagePath = pickedFile.path;
        file = File(pickedFile.path);
      
    }
  }

  Future<String?> uploadImageToCloudinary(File imageFile) async {
    try {
      String cloudName = 'dubu310vx'; // Cloudinary cloud name
      String uploadPreset = 'profile_images'; // Your preset name

      String url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path),
        'upload_preset': uploadPreset,
      });

      Response response = await Dio().post(url, data: formData);

      if (response.statusCode == 200) {
        return response.data['secure_url'];
      } else {
        print('Upload failed: ${response.statusMessage}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}