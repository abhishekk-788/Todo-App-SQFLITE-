import 'package:flutter/material.dart';
import 'package:todo_app/screen/taskpage.dart';
import 'package:todo_app/database_helper.dart';

import '../widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            color: Color(0xFF6F6F6),
            child: Stack(
              children: [
                  Column(
                    children: [

                    /* App Logo */
                    Align(
                      alignment: Alignment.topLeft,
                      child: Image(
                        image: AssetImage('images/logo.png'),
                      ),
                    ),

                    SizedBox(height: 25),

                    /* ListView Builder for viewing Tasks */
                    Expanded(
                        child: FutureBuilder(
                          initialData: [],
                          future: _dbHelper.getTasks(),
                          builder: (context, snapshot) {

                            return ScrollConfiguration(
                              behavior: NoGlowBehaviour(),

                              child: ListView.builder(
                                itemCount:snapshot.data.length,
                                itemBuilder: (context, index) {

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => TaskPage(
                                          task: snapshot.data[index],
                                        )),
                                      ).then((value) {
                                        setState(() {});
                                      });
                                    },

                                    child: TaskView(
                                      title: snapshot.data[index].title,
                                      desc: snapshot.data[index].description,
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        ),
                      ),
                  ],
                ),

                /* Floating Action Button */
                Positioned(
                  bottom: 20.0,
                  right: 0.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaskPage(
                          task: null,
                        )),
                        ).then((value) {
                          setState(() {});
                        });
                    },
                    child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xFF7349EE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image(
                          image: AssetImage('images/add_icon.png'),
                        )
                      ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
