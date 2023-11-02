import 'package:flutter/material.dart';

class PopupMenuButtonWidget extends StatelessWidget {
  final Stream<double> speedStream;
  final Function(double) onSpeedSelected;

  const PopupMenuButtonWidget(
      {Key? key, required this.speedStream, required this.onSpeedSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<double>(
      elevation: 3,
      surfaceTintColor: const Color(0xff376404),
      itemBuilder: (context) {
        return <PopupMenuEntry<double>>[
          PopupMenuItem<double>(
            value: 0.25,
            child: Text("0.25",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
          PopupMenuItem<double>(
            value: 0.5,
            child: Text("0.5",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
          PopupMenuItem<double>(
            value: 0.75,
            child: Text("0.75",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
          PopupMenuItem<double>(
            value: 1.0,
            child: Text("Normal",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
          PopupMenuItem<double>(
            value: 1.25,
            child: Text("1.25x",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
          PopupMenuItem<double>(
            value: 1.5,
            child: Text("1.5x",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
          PopupMenuItem<double>(
            value: 1.75,
            child: Text("1.75x",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
          PopupMenuItem<double>(
            value: 2.0,
            child: Text("2.0x",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
        ];
      },
      onSelected: onSpeedSelected,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(8),
        ),
        child: StreamBuilder<double>(
          stream: speedStream,
          builder: (context, snapshot) {
            return Text(
              "${snapshot.data?.toStringAsFixed(1)}x",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            );
          },
        ),
      ),
    );
  }
}
