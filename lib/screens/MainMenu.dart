import 'package:flutter/material.dart';
import 'package:project_tpm/models/place.dart';
import 'package:project_tpm/models/user.dart';
import 'package:project_tpm/presenters/place_presenter.dart';
import 'package:project_tpm/screens/Profile.dart';
import 'package:project_tpm/screens/login.dart';
import 'package:project_tpm/screens/DetailPlace.dart';

class MainMenu extends StatefulWidget {
  final User user;
  const MainMenu({super.key, required this.user});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> implements PlaceView{
  int currentPageIndex = 0;
  late PlacePresenter _presenter;
  bool _isLoading = false;
  List<PlaceModel> _placeTamanList = [];
  List<PlaceModel> _placeAlamList = [];
  List<PlaceModel> _placeBudayaList = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    print("init state dijalankan");
    _presenter = PlacePresenter(this);
    showLoading();
    _presenter.loadPlaceAlamData();
    _presenter.loadPlaceBudayaData();
    _presenter.loadPlaceTamanData();
    print("init state berhenti");
    print("error presenter : $_errorMessage");
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Menu"),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.green,
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
                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                      child: InkWell(
                        onTap: ()=>{
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPlace(place: place),
                            ),
                          )
                        },
                        child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    place.city,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    "Rp ${place.price}",
                                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      )
                    );
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
                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                      child: InkWell(
                        onTap: ()=>{
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPlace(place: place),
                            ),
                          )
                        },
                        child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    place.city,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    "Rp ${place.price}",
                                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      )
                    );
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
                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                      child: InkWell(
                        onTap: ()=>{
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPlace(place: place),
                            ),
                          )
                        },
                        child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    place.city,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    "Rp ${place.price}",
                                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      )
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome to Page of Something")
              ],
            )
          ],
        ),

        UserProfileScreen(
          username: widget.user.username,
          gender: widget.user.gender,
          dateOfBirth: widget.user.dateOfBirth,
          onLogout: () {
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
}