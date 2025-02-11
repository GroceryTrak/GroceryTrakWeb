import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:camera/camera.dart';
import 'package:grocery_trak_web/profile.dart';
import 'models/ingredient_model.dart';
import 'models/recipe_model.dart';
import 'camera_screen.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final CameraDescription camera; // Camera passed in from main()

  MyHomePage({super.key, required this.title, required this.camera});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // 0 for Home, 1 for Profile
  List<IngredientModel> ingredients = [];
  List<RecipeModel> recipes = [];

  void _generateInfo() {
    ingredients = IngredientModel.getRecipes();
    recipes = RecipeModel.getRecipes();
  }

  @override
  void initState() {
    super.initState();
    _generateInfo();
  }

  /// This function handles taps on the bottom navigation bar.
  /// If the Camera button (index 2) is tapped, we navigate to the CameraScreen.
  /// Otherwise, we update the state to show the Home or Profile view.
  void _onItemTapped(int index) {
  if (index == 1) {
    // Navigate to the CameraScreen when "Camera" is tapped.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(camera: widget.camera),
      ),
    );
  } else if (index == 2) {
    // Navigate to ProfilePage when "Profile" is tapped.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  } else {
    setState(() {
      _selectedIndex = index;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: _selectedIndex == 0 ? _buildHomeContent() : _buildHomeContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          // The camera button: tapping this will navigate to the CameraScreen.
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          
        ],
      ),
    );
  }

  /// Returns the content for the "Home" tab.
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchField(),
          SizedBox(height: 40),
          _ingredients(),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Recommended Recipes',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 210,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: recipes[index].boxColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset(
                        recipes[index].iconPath,
                        height: 70,
                      ),
                      Text(
                        recipes[index].name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${recipes[index].difficulty} | ${recipes[index].duration} mins | ${recipes[index].kCal} kCal',
                          style: TextStyle(
                            color: Color(0xff7B6B72),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        height: 45,
                        width: 130,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff9DCEFF), Color(0xff92A3FD)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'View',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: recipes.length,
            ),
          ),
        ],
      ),
    );
  }

  // /// Returns a simple placeholder for the "Profile" tab.
  // Widget _buildProfileContent() {
  //   return Center(
  //     child: Text(
  //       'Profile Page',
  //       style: TextStyle(fontSize: 24),
  //     ),
  //   );
  // }

  // AppBar (unchanged except for being common to both tabs)
  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.green,
      title: Text('Grocery Trak'),
      leading: Container(
        margin: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.amber[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset('assets/icons/Arrow - Left 2.svg'),
      ),
      actions: [
        PopupMenuButton<int>(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Row(
                children: [
                  Icon(Icons.camera),
                  SizedBox(width: 10),
                  Text("Scan"),
                ],
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: Row(
                children: [
                  Icon(Icons.star),
                  SizedBox(width: 10),
                  Text("Profile"),
                ],
              ),
            ),
            PopupMenuItem(
              value: 3,
              child: Row(
                children: [
                  Icon(Icons.chrome_reader_mode),
                  SizedBox(width: 10),
                  Text("Sign Out"),
                ],
              ),
            ),
          ],
          position: PopupMenuPosition.under,
          onSelected: (value) async {
            if (value == 1) {
              // Launch the camera interface when "Scan" is selected.
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CameraScreen(camera: widget.camera),
              ),
            );
            } else if (value == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
              // setState(() {
              //   _selectedIndex = 1;
              // });
            } else if (value == 3) {
              // Handle Sign Out option.
            }
          },
          child: Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 37,
            decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              'assets/icons/dots.svg',
              height: 5,
              width: 5,
            ),
          ),
        )
      ],
    );
  }

  // Search Field remains the same.
  Container _searchField() {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xff1D1617).withOpacity(0.11),
          blurRadius: 40,
          spreadRadius: 0.0,
        ),
      ]),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
          hintText: 'Search Recipe',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Ingredients list widget remains unchanged.
  Column _ingredients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            'Ingredient',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(width: 25),
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: ingredients[index].boxColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(ingredients[index].iconPath),
                      ),
                    ),
                    Text(
                      ingredients[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
