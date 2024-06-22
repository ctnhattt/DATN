class Product {
  final String name;
  final int price;
  final String imgURL;
  int quantity;

  Product({
    required this.name,
    required this.price,
    required this.imgURL,
    this.quantity = 1,
  });
}
