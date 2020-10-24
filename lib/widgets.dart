import 'package:flutter/material.dart';

class TaskView extends StatelessWidget {

  final String title;
  final String desc;

  TaskView({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? '(Unnamed Task)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text(desc ?? 'No description'),
          ],
        ),
      )
    );
  }
}

class Todo extends StatelessWidget {
  final String text;
  final bool isDone;

  Todo({this.text, this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 8,
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isDone ? Color(0xFF7349FE) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isDone ? null : Border.all(
                color: Color(0xFF86829D),
                width: 1.5,
              )
            ),
            child: Image(
                image: AssetImage(
                    'images/check_icon.png',
                ),
            ),
          ),
          Flexible(
            child: Text(
                text ?? '(Unnamed TODO)',
                style: TextStyle(
                  color: isDone ? Color(0xFF211551): Color(0xFF86829D),
                  fontSize: 16.0,
                  fontWeight: isDone ? FontWeight.bold: FontWeight.w500,
                )
            ),
          ),
        ],
      ),
    );
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

