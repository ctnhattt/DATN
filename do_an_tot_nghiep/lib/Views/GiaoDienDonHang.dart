import 'package:do_an_tot_nghiep/Model/DonHang_Model.dart';
import 'package:flutter/material.dart';

class GiaoDienDonHang extends StatefulWidget {
  final String title;
  final List<Product> selectedProducts;

  const GiaoDienDonHang({
    Key? key,
    required this.title,
    required this.selectedProducts,
  }) : super(key: key);

  @override
  State<GiaoDienDonHang> createState() => _GiaoDienDonHangState();
}

class _GiaoDienDonHangState extends State<GiaoDienDonHang>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = widget.selectedProducts.fold(
      0,
      (sum, product) => sum + (product.price * product.quantity).toInt(),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(222, 0, 183, 255),
        title: const Text(
          'Đơn hàng',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: widget.selectedProducts.isEmpty
          ? const Center(
              child: Text(
                'Bạn chưa có đơn hàng nào',
                style: TextStyle(fontSize: 20),
              ),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  color: Colors.white,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Thông tin đơn hàng',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Số lượng   ',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.selectedProducts.length,
                    itemBuilder: (context, index) {
                      final product = widget.selectedProducts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.grey[300],
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Image.network(
                                      product.imgURL,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: 70,
                                          height: 70,
                                          color: Colors.grey,
                                          child: const Icon(
                                            Icons.error,
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "${product.price} đ",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.selectedProducts.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  color: Colors
                                      .red, // Màu của vùng chứa văn bản "Xóa"
                                  child: const Text(
                                    'Xóa',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 40,
                              right: -7,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (product.quantity > 1) {
                                          product.quantity--;
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.remove_circle_sharp),
                                    iconSize: 25,
                                  ),
                                  SizedBox(
                                    width: 25,
                                    // Độ rộng cố định
                                    child: Text(
                                      '${product.quantity}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        product.quantity++;
                                      });
                                    },
                                    icon: const Icon(Icons.add_circle_sharp),
                                    iconSize: 25,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  color: const Color.fromARGB(255, 222, 148, 148),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tổng tiền',
                            style: TextStyle(fontSize: 28),
                          ),
                          Text(
                            "$totalAmount đ",
                            style: const TextStyle(fontSize: 28),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Thực hiện chức năng gọi món tại đây
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                          ),
                          child: const Text(
                            'Gọi món',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
