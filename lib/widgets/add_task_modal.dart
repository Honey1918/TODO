import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import '../models/task.dart';

class AddTaskModal extends StatefulWidget {
  final Function(String, Priority) onAdd;
  final Task? editingTask; // null means adding

  AddTaskModal({required this.onAdd, this.editingTask});

  @override
  _AddTaskModalState createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  late TextEditingController _controller;
  Priority _selectedPriority = Priority.medium;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.editingTask?.title ?? '');
    _selectedPriority = widget.editingTask?.priority ?? Priority.medium;
  }

  void _handleAdd() {
    if (_controller.text.trim().isEmpty) return;
    widget.onAdd(_controller.text.trim(), _selectedPriority);
    Navigator.of(context).pop();
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  Icon _getPriorityIcon(Priority priority) {
  switch (priority) {
    case Priority.high:
      return Icon(Icons.priority_high, color: Colors.red);
    case Priority.medium:
      return Icon(Icons.trending_up, color: Colors.orange);
    case Priority.low:
      return Icon(Icons.low_priority, color: Colors.green);
  }
}


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: 'Enter task'),
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s.,!?-]')),
                  ],
                  autofocus: true,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<Priority>(
                  value: _selectedPriority,
                  decoration: InputDecoration(labelText: 'Priority'),
                  items: Priority.values.map((p) {
                    String label = p.toString().split('.').last.toUpperCase();
                    return DropdownMenuItem(
                      value: p,
                      child: Row(
                        children: [
                          _getPriorityIcon(p),
                          SizedBox(width: 8),
                          Text(label),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedPriority = val);
                  },
                ),

                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: _handleCancel, child: Text('Cancel')),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _handleAdd,
                      child: Text(widget.editingTask == null ? 'Add to List' : 'Save'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
