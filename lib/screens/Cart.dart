import 'package:flutter/material.dart';
import 'package:project_tpm/models/place.dart';
import 'package:project_tpm/shared/color_palette.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite"),
        backgroundColor: Theme.of(context).colorScheme.secondary, // secondary color
      ),
      body: Center(
        child: Text(
          "Daftar Keranjang Anda akan tampil di sini.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class CartHelper {
  static List<PlaceModel> _cart = [];

  static Future<void> addToCart(PlaceModel place) async {
    if (!_cart.any((p) => p.id == place.id)) {
      _cart.add(place);
    }
  }

  static Future<bool> isInCart(int placeId) async {
    return _cart.any((p) => p.id == placeId);
  }

  static Future<List<PlaceModel>> getCart() async {
    return _cart;
  }

  static Future<void> removeFromCart(int placeId) async {
    _cart.removeWhere((p) => p.id == placeId);
  }

  static Future<void> clearCart() async {
    _cart.clear();
  }
}

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<PlaceModel> cart = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final items = await CartHelper.getCart();
    setState(() {
      cart = items;
    });
  }

  Future<void> _removeItem(int id) async {
    await CartHelper.removeFromCart(id);
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ===== Background Decoration =====
        Positioned(
          top: -40,
          left: -60,
          child: Opacity(
            opacity: 0.18,
            child: Image.asset(
              'assets/3.png',
              width: 180,
              height: 180,
            ),
          ),
        ),
        Positioned(
          top: 120,
          right: -40,
          child: Opacity(
            opacity: 0.13,
            child: Image.asset(
              'assets/4.png',
              width: 120,
              height: 120,
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          left: -30,
          child: Opacity(
            opacity: 0.12,
            child: Image.asset(
              'assets/5.png',
              width: 110,
              height: 110,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: -40,
          child: Opacity(
            opacity: 0.13,
            child: Image.asset(
              'assets/6.png',
              width: 120,
              height: 120,
            ),
          ),
        ),
        Positioned(
          top: 320,
          left: 40,
          child: Opacity(
            opacity: 0.10,
            child: Image.asset(
              'assets/7.png',
              width: 90,
              height: 90,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 60,
          child: Opacity(
            opacity: 0.10,
            child: Image.asset(
              'assets/8.png',
              width: 100,
              height: 100,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 40,
          child: Opacity(
            opacity: 0.10,
            child: Image.asset(
              'assets/9.png',
              width: 90,
              height: 90,
            ),
          ),
        ),
        // ===== Main Content =====
        Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
          appBar: AppBar(
            title: Text("Keranjang Tiket"),
            backgroundColor: Theme.of(context).colorScheme.secondary, // secondary color
          ),
          body: cart.isEmpty
              ? Center(child: Text("Keranjang kosong"))
              : ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final place = cart[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListTile(
                        leading: Image.network(place.pictureUrl, width: 60, height: 60, fit: BoxFit.cover),
                        title: Text(place.placeName),
                        subtitle: Text("Rp ${place.price}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeItem(place.id),
                        ),
                      ),
                    );
                  },
                ),
          bottomNavigationBar: cart.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.payment),
                    label: Text("Checkout Tiket"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("Pembayaran"),
                          content: Text("Tiket berhasil dipesan!"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                CartHelper.clearCart();
                                Navigator.of(ctx).pop();
                                _loadCart();
                              },
                              child: Text("OK"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : null,
        ),
      ],
    );
  }
}
