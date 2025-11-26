import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
final List<String> categories = [
 "Tily",
  "Antily",
  "Mpanazava",
  "Fanilo",
  "Kiady",
  "Sampana Mena",
  "Lovitao"
];

@override
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(12),
    child: GridView.builder(
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1, // carré
      ),
      itemBuilder: (context, index) {
        final genre = categories[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: Offset(0, 4)),
            ],
          ),
          child: Center(
            child: Text(
              genre,
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    ),
  );
}
}