import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/add_book.dart';
import 'screens/books.dart';
import 'screens/history.dart';

void main() {
  runApp(const Root());
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int navIndex = 0;
  Key keyBooks = UniqueKey();
  Key keyHistory = UniqueKey();
  bool controller = false;

  void resetCallback() {
    keyBooks = UniqueKey();
    keyHistory = UniqueKey();
    print("Refreshing...");
    setState(() {
      frags = [Books(key: keyBooks), History(key: keyHistory)];
    });
  }

  late List<Widget> frags = [Books(key: keyBooks), History(key: keyHistory)];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorObservers: [
        NewScreenChecker(callback: resetCallback, context: context),
      ],
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
      home: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: controller,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Book Management"),
              actions: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: () {
                        Alert(
                          context: context,
                          title: "Delete data",
                          desc: "Are you sure? This will remove all app data!",
                          type: AlertType.warning,
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  controller = true;
                                });
                                var prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.clear();
                                keyBooks = UniqueKey();
                                keyHistory = UniqueKey();
                                Get.back();
                                setState(() {
                                  frags = [
                                    Books(key: keyBooks),
                                    History(key: keyHistory),
                                  ];
                                  controller = false;
                                });
                              },
                            ),
                            DialogButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ],
                          style: AlertStyle(
                            titleStyle: TextStyle(color: Colors.white),
                            descStyle: TextStyle(color: Colors.white),
                          ),
                        ).show();
                      },
                      icon: Icon(Icons.delete_forever_outlined),
                    );
                  },
                ),
              ],
            ),
            body: frags[navIndex],
            floatingActionButton: Builder(
              builder: (context) {
                return FloatingActionButton(
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (c) => AddBook(),
                    );
                    setState(() {
                      keyBooks = UniqueKey();
                      keyHistory = UniqueKey();
                      frags = [Books(key: keyBooks), History(key: keyHistory)];
                    });
                  },
                  child: Icon(Icons.add),
                );
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: navIndex,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.book, color: Colors.white),
                  label: "My Books",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history, color: Colors.white),
                  label: "History",
                ),
              ],
              onTap: (i) {
                setState(() {
                  navIndex = i;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class NewScreenChecker extends NavigatorObserver {
  NewScreenChecker({required this.callback, required this.context});

  final Function() callback;
  final BuildContext context;

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (context.mounted) {
      callback();
    }
  }
}
