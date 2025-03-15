import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {
  final CollectionReference recipe =
      FirebaseFirestore.instance.collection('Recipes');

  Future<void> addRecipe(
    String id,
    String url,
    String image,
    String name,
    String description,
    String author,
    int ratings,
    List<String> ingredients,
    List<String> steps,
    Map<String, String> nutrients,
    Map<String, String> times,
    int serves,
    String difficulty,
    int voteCount,
    String subcategory,
    String dishType,
    String mainCategory,
  ) async {
    try {
      await recipe.add({
        'id': id,
        'url': url,
        'image': image,
        'name': name,
        'description': description,
        'author': author,
        'ratings': ratings,
        'ingredients': ingredients,
        'steps': steps,
        'nutrients': nutrients,
        'times': times,
        'serves': serves,
        'difficulty': difficulty,
        'vote_count': voteCount,
        'subcategory': subcategory,
        'dish_type': dishType,
        'maincategory': mainCategory,
      });
    } catch (e) {
      print('Error adding recipe: $e');
    }
  }

  Stream<QuerySnapshot> getRecipe(String orderBy) {
    return recipe.orderBy(orderBy, descending: false).snapshots();
  }

  Future<void> removeDuplicates() async {
    final snapshot = await recipe.get();
    Map<String, String> uniqueRecipes = {};
    List<String> duplicatesToDelete = [];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final key = '${data['name']}_${data['author']}'; // Adjust based on your criteria

      if (uniqueRecipes.containsKey(key)) {
        duplicatesToDelete.add(doc.id);
      } else {
        uniqueRecipes[key] = doc.id;
      }
    }

    // Delete duplicates
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var id in duplicatesToDelete) {
      batch.delete(recipe.doc(id));
    }

    await batch.commit();
    print('Duplicates removed successfully.');
  }
}
