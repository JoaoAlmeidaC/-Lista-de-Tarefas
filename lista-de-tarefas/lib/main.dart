import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/tasks_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoListModel(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: TodoListScreen(),
      ),
    );
  }
}

class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        backgroundColor: Colors.orange,
      ),
      body: Consumer<TodoListModel>(
        builder: (context, todoListModel, _) => ListView.builder(
          itemCount: todoListModel.todoList.length,
          itemBuilder: (context, index) =>
              TodoItemWidget(todoItem: todoListModel.todoList[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: 'Adicionar Tarefa',
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _displayDialog(BuildContext context) async {
    final TextEditingController _titleController = TextEditingController();
    DateTime _selectedDate = DateTime.now();

    showDialog(
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
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2022, 1),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _selectedDate) {
                    _selectedDate = picked;
                  }
                },
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
                Provider.of<TodoListModel>(context, listen: false).addTodoItem(
                  _titleController.text,
                  _selectedDate,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class TodoItemWidget extends StatelessWidget {
  final TodoItem todoItem;

  const TodoItemWidget({required this.todoItem});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todoItem.title),
      onDismissed: (_) {
        Provider.of<TodoListModel>(context, listen: false)
            .removeTodoItem(todoItem);
      },
      background: Container(color: Colors.red),
      child: Card(
        color: Colors.yellow[100],
        child: ListTile(
          title:
              Text(todoItem.title, style: TextStyle(color: Colors.deepOrange)),
          subtitle:
              Text('Data para ser concluído: ${todoItem.date.toString()}'),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              Provider.of<TodoListModel>(context, listen: false)
                  .removeTodoItem(todoItem);
            },
          ),
        ),
      ),
    );
  }
}

class TodoListModel extends ChangeNotifier {
  final List<TodoItem> _todoList = [];

  List<TodoItem> get todoList => _todoList;

  void addTodoItem(String title, DateTime date) {
    _todoList.add(TodoItem(title: title, date: date));
    notifyListeners();
  }

  void removeTodoItem(TodoItem item) {
    _todoList.remove(item);
    notifyListeners();
  }
}

class TodoItem {
  final String title;
  final DateTime date;

  TodoItem({required this.title, required this.date});
}
