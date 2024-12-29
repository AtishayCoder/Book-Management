import 'package:book_management/components/complete_book.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool controller = false;
  List<Widget> completeTasks = [];
  bool completions = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        controller = true;
      });
      var prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey("completed-books") &&
          prefs.getStringList("completed-books")!.isNotEmpty) {
        for (var book in prefs.getStringList("completed-books")!) {
          var pages = prefs.getInt("$book-total-pages")!;
          completeTasks.add(CompleteBook(name: book, totalPages: pages));
        }
      } else {
        completions = false;
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
          completions
              ? SingleChildScrollView(
                padding: EdgeInsets.all(35.0),
                child: Column(children: completeTasks),
              )
              : Padding(
                padding: const EdgeInsets.all(35.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You have not completed any book yet. Complete one to see it here.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
