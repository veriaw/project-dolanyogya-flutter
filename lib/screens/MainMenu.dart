import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_tpm/models/place.dart';
import 'package:project_tpm/models/place_hivi.dart';
import 'package:project_tpm/models/user.dart';
import 'package:project_tpm/presenters/place_presenter.dart';
import 'package:project_tpm/screens/Profile.dart';
import 'package:project_tpm/screens/login.dart';
import 'package:project_tpm/screens/DetailPlace.dart';
import 'package:project_tpm/services/bookmark_service.dart';
import 'package:project_tpm/shared/color_palette.dart';
import 'package:project_tpm/utils/handle_profile_image.dart';
import 'package:project_tpm/utils/user_manager.dart';
import 'package:project_tpm/screens/Cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_tpm/main.dart'; // import untuk akses darkModeNotifier

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> implements PlaceView {
  int currentPageIndex = 0;
  late PlacePresenter _presenter;
  bool _isLoading = false;
  List<PlaceModel> _placeTamanList = [];
  List<PlaceModel> _placeAlamList = [];
  List<PlaceModel> _placeBudayaList = [];
  String? _errorMessage;
  final userManager = UserProfileManager();
  String username = "";
  String gender = "";
  DateTime? birthOfDate;
  int id = 0;
  List<HiviModel> _bookmarks = [];
  LatLng? currentPosition;
  PlaceModel? selectedPlace;
  List<PlaceModel> allPlaces = [];
  String searchQuery = "";
  String selectedCategory = 'Semua'; // Tambahkan state kategori
  Set<int> _bookmarkedIds = {};

  @override
  void initState() {
    super.initState();
    _initData();
    _getCurrentLocation();
    _loadBookmarkedIds();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _loadBookmarkedIds() async {
    final bookmarks = await BookmarkService.getBookmarksByUser(id);
    setState(() {
      _bookmarkedIds = bookmarks.map((e) => e.id).toSet();
    });
  }

  Future<void> _toggleBookmark(PlaceModel place) async {
    final isBookmarked = _bookmarkedIds.contains(place.id);
    if (isBookmarked) {
      await BookmarkService.removeBookmark(place.id);
    } else {
      await BookmarkService.addBookmark(
        HiviModel(
          id: place.id,
          placeName: place.placeName,
          description: place.description,
          category: place.category,
          city: place.city,
          price: place.price,
          ratingAvg: place.ratingAvg,
          pictureUrl: place.pictureUrl,
          latitude: place.latitude,
          longitude: place.longitude,
          userId: id,
        ),
      );
    }
    await _loadBookmarkedIds();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isBookmarked ? 'Dihapus dari Bookmark' : 'Ditambahkan ke Bookmark')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : primaryColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Theme.of(context).colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Menu button pressed')),
            );
          },
        ),
        title: Text(
          "DolanYogya",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: isDarkMode ? primaryColor : Colors.white),
            tooltip: "Keranjang Tiket",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: isDarkMode ? Colors.white : Colors.black),
            tooltip: "Toggle Theme",
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              darkModeNotifier.value = !isDarkMode;
              await prefs.setBool('is_dark_mode', !isDarkMode);
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
          loadBookmarks();
        },
        indicatorColor: secondaryColor,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book),
            label: 'Bookmark',
          ),
          NavigationDestination(
            icon: Icon(Icons.maps_home_work),
            label: 'Maps',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_pin),
            label: 'User Profile',
          ),
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          // Home Tab
          Stack(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar (hanya satu di bawah appbar)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[900] : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                        decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[700]),
                          prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.white : Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Top Offers Section (horizontal banner diganti asset images carousel)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Heyy 👋 ${username.isNotEmpty ? username : 'User'}, ready to explore the special city?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      children: [
                        _BannerImage(assetPath: 'assets/Bannner 1.png'),
                        SizedBox(width: 12),
                        _BannerImage(assetPath: 'assets/Bannner 3.png'),
                        SizedBox(width: 12),
                        _BannerImage(assetPath: 'assets/Bannner 2.png'),
                        SizedBox(width: 12),
                        _BannerImage(assetPath: 'assets/Bannner 4.png'),
                      ],
                    ),
                  ),

                  // Categories Section (horizontal scroll, hanya satu)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      children: [
                        _CategoryChip(
                          icon: Icons.all_inclusive,
                          label: "Semua",
                          selected: selectedCategory == 'Semua',
                          onTap: () => setState(() => selectedCategory = 'Semua'),
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(width: 8),
                        _CategoryChip(
                          icon: Icons.account_balance,
                          label: "Budaya",
                          selected: selectedCategory == 'Budaya',
                          onTap: () => setState(() => selectedCategory = 'Budaya'),
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(width: 8),
                        _CategoryChip(
                          icon: Icons.park,
                          label: "Taman Hiburan",
                          selected: selectedCategory == 'Taman Hiburan',
                          onTap: () => setState(() => selectedCategory = 'Taman Hiburan'),
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(width: 8),
                        _CategoryChip(
                          icon: Icons.nature,
                          label: "Cagar Alam",
                          selected: selectedCategory == 'Cagar Alam',
                          onTap: () => setState(() => selectedCategory = 'Cagar Alam'),
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                  ),

                  // Products for you! Section (list destinasi)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Text(
                      "Tour for you!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        // Gabungkan dan filter list
                        List<PlaceModel> filteredList = [];
                        if (selectedCategory == 'Semua') {
                          filteredList = [
                            ..._placeBudayaList,
                            ..._placeTamanList,
                            ..._placeAlamList,
                          ];
                        } else if (selectedCategory == 'Budaya') {
                          filteredList = _placeBudayaList;
                        } else if (selectedCategory == 'Taman Hiburan') {
                          filteredList = _placeTamanList;
                        } else if (selectedCategory == 'Cagar Alam') {
                          filteredList = _placeAlamList;
                        }
                        filteredList = filteredList.where((place) =>
                          place.placeName.toLowerCase().contains(searchQuery.toLowerCase())
                        ).toList();

                        if (_isLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (filteredList.isEmpty) {
                          return Center(child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Text("Tidak ada data ditemukan.",
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ));
                        }
                        return ListView.builder(
                          itemCount: filteredList.length,
                          padding: const EdgeInsets.only(bottom: 16),
                          itemBuilder: (context, index) {
                            final place = filteredList[index];
                            final isBookmarked = _bookmarkedIds.contains(place.id);
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPlace(place: place),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
                                        child: Image.network(
                                          place.pictureUrl,
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      place.placeName,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      isBookmarked
                                                          ? Icons.bookmark
                                                          : Icons.bookmark_border,
                                                      color: isBookmarked ? Colors.orange : Colors.grey,
                                                      size: 24,
                                                    ),
                                                    tooltip: isBookmarked
                                                        ? "Hapus dari Bookmark"
                                                        : "Tambah ke Bookmark",
                                                    onPressed: () => _toggleBookmark(place),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                place.city,
                                                style: const TextStyle(color: Colors.grey),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "Rp ${place.price}",
                                                style: const TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(Icons.star, color: Colors.orange, size: 16),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    place.ratingAvg.toStringAsFixed(1),
                                                    style: TextStyle(fontSize: 13),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                place.category,
                                                style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Tombol beli tiket tetap dengan tap pada card
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Bookmark Page
          Stack(
            children: [
              // ===== Background Decoration =====
              Positioned(
                top: -30,
                left: -50,
                child: Opacity(
                  opacity: 0.15,
                  child: Image.asset(
                    'assets/4.png',
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: -30,
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
                top: 200,
                right: 30,
                child: Opacity(
                  opacity: 0.10,
                  child: Image.asset(
                    'assets/8.png',
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              // ===== Main Content =====
              _BookmarksPage(
                bookmarks: _bookmarks,
                onDelete: (placeId) async {
                  await BookmarkService.removeBookmark(placeId);
                  loadBookmarks();
                  _loadBookmarkedIds();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bookmark dihapus')),
                  );
                },
                onTap: (place) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPlace(
                        place: PlaceModel(
                          id: place.id,
                          placeName: place.placeName,
                          description: place.description,
                          category: place.category,
                          city: place.city,
                          price: place.price,
                          ratingAvg: place.ratingAvg,
                          latitude: place.latitude,
                          longitude: place.longitude,
                          pictureUrl: place.pictureUrl,
                        ),
                      ),
                    ),
                  );
                  setState(() {
                    currentPageIndex = 0;
                  });
                },
              ),
            ],
          ),

          //Index 2
          Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: currentPosition == null
                        ? Center(child: CircularProgressIndicator())
                        : FlutterMap(
                            options: MapOptions(
                              initialCenter: currentPosition!,
                              initialZoom: 13,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                subdomains: ['a', 'b', 'c'],
                                userAgentPackageName: 'com.example.app',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: currentPosition!,
                                    width: 60,
                                    height: 60,
                                    child: Icon(Icons.person_pin_circle,
                                        color: Colors.blue, size: 40),
                                  ),
                                  ..._placeBudayaList.map((place) => Marker(
                                        point: LatLng(
                                            place.latitude, place.longitude),
                                        width: 60,
                                        height: 60,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedPlace = place;
                                            });
                                          },
                                          child: Icon(Icons.location_on,
                                              color: Colors.red, size: 40),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                  ),
                ],
              ),

              // Card detail place
              if (selectedPlace != null)
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPlace(place: selectedPlace!),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                selectedPlace!.pictureUrl.isNotEmpty
                                    ? selectedPlace!.pictureUrl
                                    : 'https://via.placeholder.com/100',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.broken_image, size: 40),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedPlace!.placeName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    selectedPlace!.city,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Rp${selectedPlace!.price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.orange, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        selectedPlace!.ratingAvg
                                            .toStringAsFixed(1),
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),

          //Index 3
          UserProfileScreen(
            id:id,
            username: username!,
            gender: gender,
            dateOfBirth: birthOfDate,
            onLogout: () {
              userManager.clearUserProfile();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void showAlamPlaceCategory(List<PlaceModel> placeCategoryList) {
    setState(() {
      _placeAlamList = placeCategoryList;
    });
  }

  @override
  void showBudayaPlaceCategory(List<PlaceModel> placeCategoryList) {
    setState(() {
      _placeBudayaList = placeCategoryList;
    });
  }

  @override
  void showTamanPlaceCategory(List<PlaceModel> placeCategoryList) {
    setState(() {
      _placeTamanList = placeCategoryList;
    });
  }

  void loadBookmarks() async {
    final bookmarks = await BookmarkService.getBookmarksByUser(id);
    setState(() {
      _bookmarks = bookmarks;
    });
    print("ini isi bookmark: $_bookmarks");
  }

  void _initData() async {
    _presenter = PlacePresenter(this);
    showLoading();
    await _presenter.loadPlaceAlamData();
    await _presenter.loadPlaceBudayaData();
    await _presenter.loadPlaceTamanData();

    final profile = await userManager.getUserProfile();
    if (profile != null) {
      setState(() {
        id = profile['id']; // key yang benar sesuai map dari UserProfileManager
        username = profile['username'];
        birthOfDate = profile['birthdate'];
        gender = profile['gender'];
      });
      print('user id : $id');
    }
    loadBookmarks();
    setState(() {
      allPlaces = [
        ..._placeTamanList,
        ..._placeAlamList,
        ..._placeBudayaList,
      ];
    });
  }
}

// Tambahkan widget kategori chip
class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isDarkMode;

  const _CategoryChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? (isDarkMode ? Colors.green[700] : Colors.green[300])
              : (isDarkMode ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? (isDarkMode ? Colors.greenAccent : Colors.green)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? Colors.white : Colors.grey, size: 20),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black87),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tambahkan widget banner image di bawah _CategoryChip
class _BannerImage extends StatelessWidget {
  final String assetPath;
  const _BannerImage({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        assetPath,
        width: 220,
        height: 120,
        fit: BoxFit.cover,
      ),
    );
  }
}

// Tambahkan widget BookmarkPage di bawah _BannerImage
class _BookmarksPage extends StatelessWidget {
  final List<HiviModel> bookmarks;
  final void Function(int placeId) onDelete;
  final void Function(HiviModel place) onTap;

  const _BookmarksPage({
    required this.bookmarks,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (bookmarks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            "Belum ada bookmark",
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final place = bookmarks[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                place.pictureUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, size: 32),
                ),
              ),
            ),
            title: Text(
              place.placeName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(place.category, style: TextStyle(color: Colors.blueGrey, fontSize: 13)),
                SizedBox(height: 2),
                Text(place.city, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                SizedBox(height: 2),
                Text('Rp ${place.price}', style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              tooltip: "Hapus Bookmark",
              onPressed: () => onDelete(place.id),
            ),
            onTap: () => onTap(place),
          ),
        );
      },
    );
  }
}
