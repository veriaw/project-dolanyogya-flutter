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

  @override
  void initState() {
    super.initState();
    _initData();
    _getCurrentLocation();
  }


  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Menu"),
        backgroundColor: secondaryColor,
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
      body: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: [
              Text("Category Budaya"),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _placeBudayaList.length,
                  itemBuilder: (context, index) {
                    final place = _placeBudayaList[index];
                    return Container(
                        width: 200,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10.0),
                        child: InkWell(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPlace(place: place),
                              ),
                            )
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: Image.network(
                                    place.pictureUrl,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    place.placeName,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    place.city,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    "Rp ${place.price}",
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                ),
              ),
              Text("Category Taman Hiburan"),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _placeTamanList.length,
                  itemBuilder: (context, index) {
                    final place = _placeTamanList[index];
                    return Container(
                        width: 200,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10.0),
                        child: InkWell(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPlace(place: place),
                              ),
                            )
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: Image.network(
                                    place.pictureUrl,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    place.placeName,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    place.city,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    "Rp ${place.price}",
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                ),
              ),
              Text("Category Cagar Alam"),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _placeAlamList.length,
                  itemBuilder: (context, index) {
                    final place = _placeAlamList[index];
                    return Container(
                        width: 200,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10.0),
                        child: InkWell(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPlace(place: place),
                              ),
                            )
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: Image.network(
                                    place.pictureUrl,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    place.placeName,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    place.city,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    "Rp ${place.price}",
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                ),
              ),
            ],
          ),
        ),

        //index 1
        Column(
          children: [
            SizedBox(
              height: 400, // Sesuaikan tinggi container
              child: ListView.builder(
                itemCount: _bookmarks.length,
                itemBuilder: (context, index) {
                  final place = _bookmarks[index]; // Ini adalah HiviModel
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
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
                                  pictureUrl: place.pictureUrl),
                            ),
                          ),
                        );
                        setState(() {
                          currentPageIndex = 0;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                place.pictureUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.broken_image, size: 30),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    place.placeName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    place.category,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${place.city}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Rp ${place.price}',
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
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
      ][currentPageIndex],
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
