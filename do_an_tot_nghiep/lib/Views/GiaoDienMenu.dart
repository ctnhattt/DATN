import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_tot_nghiep/Model/DonHang_Model.dart';
import 'package:do_an_tot_nghiep/Views/GiaoDienDonHang.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as BadgesLibrary;

class TrangMenu extends StatefulWidget {
  const TrangMenu({super.key, required this.title});
  final String title;

  @override
  State<TrangMenu> createState() => _TrangMenuState();
}

class _TrangMenuState extends State<TrangMenu> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Product> selectedProducts = [];
  int badgeCount = 0;
  void _addItemToCart(Product product) {
    setState(() {
      bool isExist = false;
      for (var item in selectedProducts) {
        if (item.name == product.name) {
          isExist = true;
          break;
        }
      }

      if (!isExist) {
        selectedProducts.add(product);
        badgeCount = selectedProducts.length;
      }
    });
  }

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

  Stream<QuerySnapshot> _getItems(String category) {
    return FirebaseFirestore.instance
        .collection('menu')
        .doc('category')
        .collection(category)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(222, 0, 183, 255),
        title: const Text(
          'MENU',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Chức năng tìm kiếm
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,
              size: 30.0,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GiaoDienDonHang(
                    title: 'Đơn Hàng',
                    selectedProducts: selectedProducts,
                  ),
                ),
              );
            },
            icon: Stack(
              children: [
                const Icon(
                  Icons.receipt_long,
                  color: Colors.black,
                  size: 30.0,
                ),
                Positioned(
                  right: 11,
                  top: 4,
                  child: BadgesLibrary.Badge(
                    badgeContent: Text(
                      '$badgeCount',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: TabBar(
            isScrollable: false,
            controller: _tabController,
            labelColor: Colors.blue,
            indicatorPadding: EdgeInsets.zero,
            labelPadding: const EdgeInsets.symmetric(horizontal: 1),
            tabs: const [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [SizedBox(width: 1), Text('Cake')],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [SizedBox(width: 1), Text('Bread')],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [SizedBox(width: 1), Text('Drink')],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [SizedBox(width: 1), Text('Other')],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildCategoryTab('cake'),
            _buildCategoryTab('bread'),
            _buildCategoryTab('drink'),
            _buildCategoryTab('other'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String category) {
    return StreamBuilder<QuerySnapshot>(
      stream: _getItems(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final data = snapshot.data!.docs;

        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index].data() as Map<String, dynamic>;
              final name = item['name'] ?? 'Unknown';
              final price = item['price'] ?? 0;
              final imgURL = item['imgURL'] ?? '';

              return GestureDetector(
                onTap: () {
                  _addItemToCart(Product(
                    name: name,
                    price: price,
                    imgURL: imgURL,
                  ));
                },
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imgURL,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$price đ',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          _addItemToCart(Product(
                            name: name,
                            price: price,
                            imgURL: imgURL,
                          ));
                        },
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
