// ignore_for_file: deprecated_member_use, missing_return

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/dummy_data.dart';
import 'package:flutter_complete_guide/models/meal.dart';
import 'package:flutter_complete_guide/screens/category_meals_screen.dart';
import 'package:flutter_complete_guide/screens/meal_detail_screen.dart';
import 'package:flutter_complete_guide/screens/settings_screen.dart';
import 'package:flutter_complete_guide/screens/tabs_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    "gluten": false,
    "lactose": false,
    "vegan": false,
    "vegeterian": false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favouritedMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;
      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters["gluten"] && !meal.isGlutenFree) {
          return false;
        }
        if (_filters["lactose"] && !meal.isLactoseFree) {
          return false;
        }
        if (_filters["vegan"] && !meal.isVegan) {
          return false;
        }
        if (_filters["vegeterian"] && !meal.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavourite(String mealId) {
    final existingIndex =
        _favouritedMeals.indexWhere((meal) => meal.id == mealId);
    if (existingIndex > 0) {
      setState(() {
        _favouritedMeals.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favouritedMeals
            .add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      });
    }
  }

  bool _isMealFavourite(String id) {
    return _favouritedMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
              bodyText2: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
              headline6: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "RobotoCondensed",
              ),
            ),
      ),
      initialRoute: '/',
      routes: {
        "/": (ctx) => TabsScreen(_favouritedMeals),
        CategoryMealsScreen.routeName: (ctx) =>
            CategoryMealsScreen(_availableMeals),
        MealDetilsScreen.routeName: (ctx) =>
            MealDetilsScreen(_toggleFavourite, _isMealFavourite),
        SettingsScreen.routeName: (ctx) =>
            SettingsScreen(_filters, _setFilters),
      },
      onUnknownRoute: ((settings) {
        return MaterialPageRoute(
          builder: (ctx) => TabsScreen(_favouritedMeals),
        );
      }),
    );
  }
}
