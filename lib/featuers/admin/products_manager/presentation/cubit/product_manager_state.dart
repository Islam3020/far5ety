import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ProductManagerState {}
final class ProductManagerInitial extends ProductManagerState {}

final class AddProducrtLoading extends ProductManagerState {}

final class AddProducrtSuccess extends ProductManagerState {}

final class AddProducrtError extends ProductManagerState {
  final String message;
  AddProducrtError({required this.message});
}

final class UpdateProductLoading extends ProductManagerState {}
final class UpdateProductSuccess extends ProductManagerState {}
final class UpdateProductError extends ProductManagerState {
  final String message;
  UpdateProductError({required this.message});
}

final class GetProductsLoading extends ProductManagerState {}
class GetProductsSuccess extends ProductManagerState {
  final List<QueryDocumentSnapshot> products;
  GetProductsSuccess(this.products);
}
final class GetProductsError extends ProductManagerState {
  final String message;
  GetProductsError({required this.message});
}

final class DeleteProductLoading extends ProductManagerState {}
final class DeleteProductSuccess extends ProductManagerState {}
final class DeleteProductError extends ProductManagerState {
  final String message;
  DeleteProductError({required this.message});
}