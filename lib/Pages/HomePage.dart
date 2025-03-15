import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodie/FireBase.dart';
import 'package:foodie/properties/RecipeTile.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final DataBase Data = DataBase();

  Future<void> importJson(BuildContext context) async {
    try {
      // Load JSON file from assets
      final String rawData = await rootBundle.loadString('recipes.json');
      List<dynamic> jsonData = json.decode(rawData); // Parse the JSON data

      // Check if JSON data is valid
      if (jsonData.isEmpty) {
        throw Exception('JSON format is invalid or empty.');
      }

      // Iterate over each recipe in the JSON data
      for (var item in jsonData) {
        await DataBase().addRecipe(
          item['id']?.toString() ?? '',
          item['url']?.toString() ?? '',
          item['image']?.toString() ?? '',
          item['name']?.toString() ?? 'No Name',
          item['description']?.toString() ?? 'No Description',
          item['author']?.toString() ?? 'Unknown Author',
          item['rattings'] ??
              0, // Ensure to fix the key from 'rattings' to 'ratings' if needed
          List<String>.from(item['ingredients'] ?? []),
          List<String>.from(item['steps'] ?? []),
          item['nutrients'] != null
              ? Map<String, String>.from(item['nutrients'])
              : {},
          item['times'] != null ? Map<String, String>.from(item['times']) : {},
          item['serves'] ?? 0,
          item['difficult']?.toString() ?? 'Easy',
          item['vote_count'] ?? 0,
          item['subcategory']?.toString() ?? '',
          item['dish_type']?.toString() ?? '',
          item['maincategory']?.toString() ?? '',
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipes imported successfully!')),
      );
    } catch (e) {
      print('Error importing JSON file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error importing file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'F O O D I E',
          style: GoogleFonts.dongle(
              textStyle: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          )),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            Data.getRecipe('name'), // Adjust the field to order by if necessary
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Items'));
          } else {
            List<DocumentSnapshot> recipeList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: recipeList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = recipeList[index];
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                // Extracting required data
                String id = data['id'] ?? '';
                String url = data['url'] ?? '';
                String name = data['name'] ?? 'No Name';
                String description = data['description'] ?? 'No Description';
                String author = data['author'] ?? 'Unknown Author';
                int ratings = data['ratings'] ?? 0;
                List<String> ingredients =
                    List<String>.from(data['ingredients'] ?? []);
                int serves = data['serves'] ?? 0;
                String difficulty = data['difficulty'] ?? 'Easy';

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: RecipeTile(
                    name: name,
                    description: description,
                    author: author,
                    ratings: ratings,
                    ingredients: ingredients,
                    serves: serves,
                    difficulty: difficulty,
                    url: url,
                    onAddPressed: () {
                      // Define the action for the add button
                      print('Add pressed for recipe: $name');
                      // You can add your purchase or add logic here
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
