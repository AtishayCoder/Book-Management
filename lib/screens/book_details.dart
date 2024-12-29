import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookDetails extends StatefulWidget {
  const BookDetails({
    super.key,
    required this.bookName,
    required this.totalPages,
    required this.pagesRead,
    required this.pagesRemaining,
    required this.percentComplete,
  });

  final String bookName;
  final int totalPages;
  final int pagesRead;
  final int pagesRemaining;
  final double percentComplete;

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  int pagesReadToday = 0;
  bool controller = false;
  TextEditingController textFieldController = TextEditingController();
  late int pagesRead;
  late int pagesRemaining;
  late double percentComplete;

  @override
  void initState() {
    super.initState();
    pagesRead = widget.pagesRead;
    pagesRemaining = widget.pagesRemaining;
    percentComplete = widget.percentComplete;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: controller,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Details about ${widget.bookName}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Text(
                        "Total Pages: ${widget.totalPages}",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        "Pages Read: $pagesRead",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        "Pages Remaining: $pagesRemaining",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        "Percentage of book read: $percentComplete%",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 40),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: textFieldController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: "Pages Read Today",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                    ),
                    onChanged: (val) {
                      pagesReadToday = int.parse(val);
                    },
                  ),
                  SizedBox(height: 15),
                  Builder(
                    builder: (context) {
                      return MaterialButton(
                        onPressed: () async {
                          setState(() {
                            controller = true;
                          });
                          textFieldController.clear();
                          var prefs = await SharedPreferences.getInstance();
                          if (prefs.containsKey(
                            "${widget.bookName}-read-pages",
                          )) {
                            await prefs.remove("${widget.bookName}-read-pages");
                            await prefs.setInt(
                              "${widget.bookName}-read-pages",
                              pagesReadToday + pagesRead,
                            );
                          } else {
                            await prefs.setInt(
                              "${widget.bookName}-read-pages",
                              pagesReadToday + pagesRead,
                            );
                          }
                          pagesRead += pagesReadToday;
                          if (pagesRead > widget.totalPages) {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Congrats on completing this book!",
                                          ),
                                          SizedBox(height: 10),
                                          MaterialButton(
                                            onPressed: () async {
                                              Get.back();
                                              setState(() {
                                                controller = true;
                                              });
                                              var prefs =
                                                  await SharedPreferences.getInstance();
                                              await prefs.remove(
                                                "${widget.bookName}-read-pages",
                                              );
                                              List<String> tempList =
                                                  prefs.getStringList("books")!;
                                              tempList.remove(widget.bookName);
                                              await prefs.setStringList(
                                                "books",
                                                tempList,
                                              );
                                              if (prefs.containsKey(
                                                "completed-books",
                                              )) {
                                                List<String> list =
                                                    prefs.getStringList(
                                                      "completed-books",
                                                    )!;
                                                list.add(widget.bookName);
                                                await prefs.setStringList(
                                                  "completed-books",
                                                  list,
                                                );
                                              } else {
                                                await prefs.setStringList(
                                                  "completed-books",
                                                  [widget.bookName],
                                                );
                                              }
                                              setState(() {
                                                controller = false;
                                              });
                                              Get.back();
                                            },
                                            minWidth: double.infinity,
                                            elevation: 7.0,
                                            child: Text("Cancel"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            );
                          } else {
                            pagesRemaining = widget.totalPages - pagesRead;
                            percentComplete = double.parse(
                              ((pagesRead / widget.totalPages) * 100)
                                  .toStringAsFixed(3),
                            );
                          }
                          setState(() {
                            controller = false;
                          });
                        },
                        color: Colors.blueAccent,
                        minWidth: double.infinity,
                        height: 35,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Text("Save"),
                      );
                    },
                  ),
                  MaterialButton(
                    onPressed: () {
                      Get.back();
                    },
                    color: Colors.blueAccent,
                    minWidth: double.infinity,
                    height: 35,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Text("Close"),
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
