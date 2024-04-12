import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _todoList = [];
  final TextEditingController _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index) => _buildTodoItem(_todoList[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: 'Adicionar Tarefa',
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _addTodoItem(String title, DateTime date) {
    if (title.isNotEmpty) {
      setState(() {
        _todoList.add(TodoItem(title: title, date: date));
      });
      _titleController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, digite uma tarefa antes de salvar.'),
        ),
      );
    }
  }

  Widget _buildTodoItem(TodoItem item) {
    return Dismissible(
      key: Key(item.title),
      onDismissed: (direction) {
        _removeTodoItem(item);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${item.title} removido")),
        );
      },
      background: Container(color: Colors.red),
      child: Card(
        color: Colors.yellow[100],
        child: ListTile(
          title: Text(item.title, style: TextStyle(color: Colors.deepOrange)),
          subtitle: Text('Data para ser concluido: ${item.date.toString()}'),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeTodoItem(item),
          ),
        ),
      ),
    );
  }

  void _removeTodoItem(TodoItem item) {
    setState(() {
      _todoList.remove(item);
    });
  }

  Future<void> _displayDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicione sua Tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(hintText: 'Digite a tarefa aqui'),
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('Selecionar Data de Conclusão'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCELAR'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('ADICIONAR'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_titleController.text, _selectedDate);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2022, 1),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}

class TodoItem {
  final String title;
  final DateTime date;

  TodoItem({required this.title, required this.date});
}
