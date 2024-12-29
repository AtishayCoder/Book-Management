import 'package:book_management/screens/book_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Book extends StatefulWidget {
  const Book({
    super.key,
    required this.name,
    required this.totalPages,
    this.pagesRead = 0,
  });

  final String name;
  final int totalPages;
  final int pagesRead;

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  late int pagesRemaining;
  late double percentComplete;

  @override
  Widget build(BuildContext context) {
    pagesRemaining = widget.totalPages - widget.pagesRead;
    percentComplete = double.parse(
      ((widget.pagesRead / widget.totalPages) * 100).toStringAsFixed(2),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          Get.to(
            () => BookDetails(
              bookName: widget.name,
              totalPages: widget.totalPages,
              pagesRead: widget.pagesRead,
              pagesRemaining: pagesRemaining,
              percentComplete: percentComplete,
            ),
          );
        },
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
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Aligns text to the left
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
                    Text(
                      "Pages Read: ${widget.pagesRead.toString()}",
                      style: TextStyle(
                        color: Colors.white.withAlpha(153),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
