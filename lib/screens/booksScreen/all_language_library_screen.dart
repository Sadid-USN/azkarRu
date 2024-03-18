import 'package:flutter/material.dart';

class AllLanguageLibraryScreen extends StatelessWidget {
  const AllLanguageLibraryScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        mainAxisExtent: 200,
      ),
      padding: const EdgeInsets.all(8.0), // padding around the grid
      itemCount: 4, // total number of items
      itemBuilder: (context, index) {
        return CardContainer(
          onTap: () {},
        );
      },
    );
  }
}

class CardContainer extends StatelessWidget {
  final void Function()? onTap;
  const CardContainer({
    required this.onTap,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFF5E1),
              Color(0xFFFFE4B5),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.25, 0.90],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF1C1C1E),
              offset: Offset(-3, 3),
              blurRadius: 8,
            ),
          ],
        ),
        alignment: Alignment.centerLeft, //to align its child
        padding: EdgeInsets.all(20),
        child: const Text(
          'English books',
          style: TextStyle(
            fontSize: 18,
            color: Colors.blueGrey,
            fontWeight: FontWeight.w200,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
