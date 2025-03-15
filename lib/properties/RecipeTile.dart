import 'package:flutter/material.dart';

class RecipeTile extends StatefulWidget {
  final String name;
  final String description;
  final String author;
  final int ratings;
  final List<String> ingredients;
  final int serves;
  final String difficulty;
  final String url;

  final VoidCallback onAddPressed; // Callback for the add button

  const RecipeTile({super.key, 
    required this.name,
    required this.description,
    required this.author,
    required this.ratings,
    required this.ingredients,
    required this.serves,
    required this.difficulty,
    required this.url,
    required this.onAddPressed,
  });

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _toggleExpand,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Author: ${widget.author}'),
                        Text('Ratings: ${widget.ratings}'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.description, style: const TextStyle(fontWeight: FontWeight.normal)),
                  const SizedBox(height: 10),
                  const Text('Ingredients:'),
                  ...widget.ingredients.map((ingredient) => Text('- $ingredient')),
                  const SizedBox(height: 10),
                  Text('Serves: ${widget.serves}'),
                  Text('Difficulty: ${widget.difficulty}'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // IconButton(
                      //   onPressed: widget.onAddPressed,
                      //   icon: Icon(
                      //     Icons.add,
                      //     color: Theme.of(context).colorScheme.inversePrimary,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
