import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Map> _todoItems = <Map>[];
  final TextEditingController _textFieldController = TextEditingController();

  void _addTodoItem(String task) {
    // Only add the task if the user actually entered something
    if (task.isNotEmpty) {
      setState(() => _todoItems.add({"title": task, "completed": false}));
    }
    _textFieldController.clear();
  }

  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

  Widget _buildTodoItem(BuildContext context, int index) {
    return Card(
        color: Colors.white,
        child: ListTile(
          title: Text(
            _todoItems[index]["title"],
            style: _todoItems[index]["completed"]
                ? const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontSize: 18.0,
                  )
                : const TextStyle(fontSize: 18.0),
          ),
          leading: Checkbox(
            value: _todoItems[index]["completed"],
            onChanged: (value) {
              setState(() {
                _todoItems[index]["completed"] =
                    !_todoItems[index]["completed"];
              });
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _removeTodoItem(index),
          ),
        ));
  }

  Future<T?> _displayDialog<T>(BuildContext context) async {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new task'),
          content: TextField(
            controller: _textFieldController,
            decoration:
                const InputDecoration(hintText: 'Enter something to do...'),
          ),
          actions: [
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('ADD'),
              onPressed: () {
                _addTodoItem(_textFieldController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo List'),
          backgroundColor: Colors.pinkAccent,
        ),
        body: ListView.builder(
          itemCount: _todoItems.length,
          itemBuilder: _buildTodoItem,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _displayDialog(context);
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Todo List",
      home: TodoList(),
    );
  }
}
