class ProductModel {
  String ? name;
  String ?image;
  String ? description;
  double? price;
  int? quantity;

  ProductModel({
    this.name,
    this.image,
    this.description,
    this.price,
    this.quantity,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    description = json['description'];
    price = json['price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['description'] = description;
    data['price'] = price;
    data['quantity'] = quantity;
    return data;
  }
  
}