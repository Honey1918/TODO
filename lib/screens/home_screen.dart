import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';
import '../widgets/add_task_modal.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      final List<dynamic> tasksJson = json.decode(tasksString);
      setState(() {
        _tasks = tasksJson.map((e) => Task.fromJson(e)).toList();
      });
    }
  }


  Priority? _sortPriority;

void _sortTasks() {
  setState(() {
    if (_sortPriority == null) {
      _sortPriority = Priority.high;
    } else if (_sortPriority == Priority.high) {
      _sortPriority = Priority.medium;
    } else if (_sortPriority == Priority.medium) {
      _sortPriority = Priority.low;
    } else {
      _sortPriority = null;
    }

    if (_sortPriority != null) {
      _tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    } else {
      // fallback: sort alphabetically
      _tasks.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    }
  });
}
Icon _getPriorityIcon(Priority priority) {
  switch (priority) {
    case Priority.high:
      return Icon(Icons.priority_high, color: Colors.red, size: 18);
    case Priority.medium:
      return Icon(Icons.trending_up, color: Colors.orange, size: 18);
    case Priority.low:
      return Icon(Icons.low_priority, color: Colors.green, size: 18);
  }
}



  void _editTask(int index) {
  final task = _tasks[index];
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return AddTaskModal(
        editingTask: task,
        onAdd: (newTitle, newPriority) {
          setState(() {
            _tasks[index].title = newTitle;
            _tasks[index].priority = newPriority;
          });
          _saveTasks();
        },
      );
    },
  );
}



  void _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksString = json.encode(_tasks.map((e) => e.toJson()).toList());
    await prefs.setString('tasks', tasksString);
  }

void _addTask(String title, Priority priority) {
  if (title.isEmpty) return;
  setState(() {
    _tasks.add(Task(title: title, priority: priority));
  });
  _saveTasks();
}


  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
    });
    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

void _showAddTaskModal() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => AddTaskModal(onAdd: _addTask),
  );
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('To-Do List'),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'sort') _sortTasks();
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'sort', child: Text('Sort by Priority')),
          ],
        ),
      ],
    ),
    body: _tasks.isEmpty
        ? Center(
            child: Text(
              "Nothing's here to do",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              final task = _tasks[index];
              return ListTile(
                leading: Checkbox(
                  value: task.isDone,
                  onChanged: (_) => _toggleTask(index),
                ),
                title: GestureDetector(
                  onTap: () => _editTask(index),
                  child: Row(
                    children: [
                      _getPriorityIcon(task.priority),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteTask(index),
                ),
              );
            },
          ),
    floatingActionButton: FloatingActionButton(
      onPressed: _showAddTaskModal,
      child: Icon(Icons.add),
    ),
  );
}

}
