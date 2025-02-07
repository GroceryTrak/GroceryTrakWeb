import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:camera/camera.dart';
import 'models/ingredient_model.dart';
import 'models/recipe_model.dart';
import 'camera_screen.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final CameraDescription camera; 

  MyHomePage({super.key, required this.title, required this.camera});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchField(),
            SizedBox(height: 40),
            _ingredients(),
            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
          ],
        ),
      ),
    );
  }

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
          onSelected: (value) async {
            if (value == 1) {
              // Launch the camera interface when "Scan" is selected.
              final imagePath = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraScreen(camera: widget.camera),
                ),
              );
              if (imagePath != null) {
                // Process the captured image (for example, pass the path to your CV model)
                print("Captured image: $imagePath");
              }
            } else if (value == 2) {
              // Handle Profile option.
            } else if (value == 3) {
              // Handle Sign Out option.
            }
          },
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
        ),
      ],
    );
  }

  // Search Field and _ingredients methods remain unchanged...
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
