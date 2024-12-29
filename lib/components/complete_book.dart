import 'package:flutter/material.dart';

class CompleteBook extends StatefulWidget {
  const CompleteBook({super.key, required this.name, required this.totalPages});

  final String name;
  final int totalPages;

  @override
  State<CompleteBook> createState() => _CompleteBookState();
}

class _CompleteBookState extends State<CompleteBook> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        width: double.infinity,
        height: 90,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                widget.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
              Row(
                children: [
                  Text(
                    "Total Pages: ${widget.totalPages.toString()}",
                    style: TextStyle(
                      color: Colors.white.withAlpha(153),
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
