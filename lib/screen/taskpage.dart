import 'package:flutter/material.dart';
import 'package:todo_app/models/tasks.dart';
import 'package:todo_app/models/todo.dart';

import '../database_helper.dart';
import '../widgets.dart';

class TaskPage extends StatefulWidget {
  final Task task;
  TaskPage({@required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  String _taskTitle = '';
  String _taskDescription = '';

  DatabaseHelper _dbHelper = DatabaseHelper();
  int _taskId = 0;

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if(widget.task != null) {
      _contentVisible = true;
      _taskTitle = widget.task.title;
      _taskDescription = widget.task.description;
      _taskId = widget.task.id;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();
    super.initState();
  }

  /* Release the memory allocated to variables when state object is removed */
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [

                        /* Back Button */
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            size: 26,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }
                        ),

                        /* Create/Update Title of Task */
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            controller: TextEditingController()..text = _taskTitle,
                            decoration: InputDecoration(
                              hintText: 'Enter Task Title',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),

                            onSubmitted: (value) async {
                              if (value != '')
                              {
                                /* When you create the current task */
                                if (widget.task == null) {

                                  Task _newTask = Task(
                                    title: value,
                                  );

                                  _taskId = await _dbHelper.insertTask(_newTask);

                                  setState(() {
                                    _contentVisible = true;
                                    _taskTitle = value;
                                  });
                                }

                                /* When you update the current task */
                                else {
                                  await _dbHelper.updateTaskTitle(_taskId, value);
                                }

                                _descriptionFocus.requestFocus();
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    /* Create/Update Description of Task */
                    Visibility(
                      visible: _contentVisible,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: TextField(
                          focusNode: _descriptionFocus,
                          onSubmitted: (value) async{
                            if(value != ""){
                              if(_taskId != 0) {
                                await _dbHelper.updateTaskDescription(_taskId, value);
                                _taskDescription = value;
                              }
                            }
                            _todoFocus.requestFocus();
                          },
                          controller: TextEditingController()..text = _taskDescription,
                          decoration: InputDecoration(
                            hintText: 'Enter Description for the task ...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24,
                            ),
                          ),
                        ),
                      ),
                    ),

                    /* Update the isDone of the Todos */
                    Visibility(
                      visible: _contentVisible,
                      child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.getTodo(_taskId),
                        builder: (context, snapshot) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    if(snapshot.data[index].isDone == 0) {
                                      await _dbHelper.updateTodoDone(snapshot.data[index].id, 1);
                                    }
                                    else {
                                      await _dbHelper.updateTodoDone(snapshot.data[index].id, 0);
                                    }
                                    setState(() {});
                                  },
                                  child: Todo(
                                    text: snapshot.data[index].title,
                                    isDone: snapshot.data[index].isDone == 0 ? false : true,
                                  ),
                                );
                              }
                            ),
                          );
                        }
                      ),
                    ),

                    Visibility(
                      visible: _contentVisible,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          children: [

                            /* CheckBox for todo_item */
                            Container(
                              width: 20,
                              height: 20,
                              margin: EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
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

                            /* TextField for todo_item */
                            Expanded(
                              child: TextField(
                                focusNode: _todoFocus,
                                controller: TextEditingController()..text = '',

                                  onSubmitted: (value) async{
                                  if (value != '') {
                                    if (_taskId != 0) {
                                       TodoModel _newTodo = TodoModel(
                                        title: value,
                                         isDone: 0,
                                         taskId: _taskId,
                                      );
                                      await _dbHelper.insertTodo(_newTodo);
                                      setState(() {});
                                      _todoFocus.requestFocus();
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter Todo item...',
                                  border: InputBorder.none,
                                )
                              ),
                            )

                          ],
                        ),
                      ),
                    )
                  ],
                ),

                /* Delete Task Button */
                Visibility(
                  visible: _contentVisible,
                  child: Positioned(
                    bottom: 20.0,
                    right: 0.0,
                    child: GestureDetector(
                      onTap: () async {
                        if(_taskId != 0) {
                          await _dbHelper.deleteTask(_taskId);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xFFFE3577),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image(
                            image: AssetImage('images/delete_icon.png'),
                          )
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
