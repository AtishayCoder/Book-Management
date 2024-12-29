import 'package:flutter/material.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/book.dart';

class Books extends StatefulWidget {
  const Books({super.key});

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  List<Book> books = [];
  bool noBooksStarted = false;
  bool controller = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) async {
      setState(() {
        controller = true;
      });
      var prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey("books") == false ||
          (prefs.containsKey("books") &&
              prefs.getStringList("books")!.isEmpty)) {
        noBooksStarted = true;
      } else {
        var booksTemp = prefs.getStringList("books")!;
        for (var book in booksTemp) {
          var totalPages = prefs.getInt("$book-total-pages")!;
          if (prefs.containsKey("$book-read-pages")) {
            books.add(
              Book(
                name: book,
                totalPages: totalPages,
                pagesRead: prefs.getInt("$book-read-pages")!,
              ),
            );
          } else {
            books.add(Book(name: book, totalPages: totalPages));
          }
        }
      }
      setState(() {
        controller = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: controller,
      child:
          noBooksStarted
              ? Padding(
                padding: const EdgeInsets.all(35.0),
                child: Center(
                  child: Text(
                    "You are not reading any books. Start tracking your reading habits by pressing the button below.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              )
              : SingleChildScrollView(
                padding: EdgeInsets.all(25.0),
                child: Center(child: Column(children: books)),
              ),
    );
  }
}
