import 'package:flutter/material.dart';

void main() {
  runApp(const ToDoApp());
}

class Task {
  final String title;
  final String details;

  Task({required this.title, required this.details});
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
 // const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> taskList = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  int editingIndex = -1; // Track the index being edited

  void deleteTask(int index) {
    setState(() {
      taskList.removeAt(index);
    });
  }

  void editTask(int index, String newTitle, String newDetails) {
    setState(() {
      taskList[index] = Task(title: newTitle, details: newDetails);
      editingIndex = -1; // Reset editingIndex after updating
    });
  }

  void addTask() {
    String title = titleController.text;
    String description = descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      if (editingIndex != -1) {
        // If editingIndex is not -1, it means we are editing an existing task
        editTask(editingIndex, title, description);
      } else {
        // If editingIndex is -1, it means we are adding a new task
        Task task = Task(title: title, details: description);
        setState(() {
          taskList.add(task);
        });
      }
      titleController.clear();
      descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.greenAccent,
        title: Text(
          'CRUD',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: Colors.black),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Add Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 2,),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Add Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 55,
                      //color: Colors.red ,
                      width: double.infinity,
                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          primary: Colors.red

                        ),
                        onPressed: () {
                          addTask();
                        },
                        child: Text('Add'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      // Set controllers only when editing
                      titleController.text = taskList[index].title;
                      descriptionController.text = taskList[index].details;
                      setState(() {
                        editingIndex = index; // Set editingIndex when editing
                      });

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Alert',
                                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Colors.black),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.close),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        // No need to edit here, editing will be done in the main UI
                                        Navigator.pop(context); // Close the dialog
                                      },
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Colors.blue),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteTask(index); // Call the function to delete the task
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    subtitle: Text(taskList[index].details),
                    title: Text(taskList[index].title),
                    leading: CircleAvatar(

                      child: Text('${index + 1}',style: TextStyle(color: Colors.white),),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: Colors.black,
                    height: 30,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
