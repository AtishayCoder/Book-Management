import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  String bookName = "";
  int pages = 0;
  bool controller = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: controller,
      child: Material(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New book",
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Book name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onChanged: (val) {
                      bookName = val;
                    },
                  ),
                  SizedBox(height: 20.0),
                  Builder(
                    builder: (context) {
                      return TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Allows only digits
                        ],
                        decoration: InputDecoration(
                          hintText: "Number of pages",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onChanged: (val) async {
                          pages = int.parse(val);
                        },
                      );
                    },
                  ),
                  SizedBox(height: 40.0),
                  MaterialButton(
                    onPressed: () async {
                      setState(() {
                        controller = true;
                      });
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      bookName = bookName.toCapitalCase();
                      if (sharedPreferences.containsKey("books")) {
                        List<String> books =
                            sharedPreferences.getStringList("books")!;
                        books.add(bookName);
                        await sharedPreferences.remove("books");
                        await sharedPreferences.setStringList("books", books);
                      } else if (sharedPreferences.containsKey("books") ==
                          false) {
                        await sharedPreferences.setStringList("books", [
                          bookName,
                        ]);
                      }
                      await sharedPreferences.setInt(
                        "$bookName-total-pages",
                        pages,
                      );
                      setState(() {
                        controller = false;
                      });
                      Get.back();
                    },
                    minWidth: double.infinity,
                    height: 40.0,
                    color: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Text("Add", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
