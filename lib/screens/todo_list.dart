import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:works/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isloading = false;
  List items = [];
  @override
  void initState() {
    fetchtodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edilmeli işleriň sanawy',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[300],
      ),
      body: Visibility(
        visible: isloading,
        replacement: RefreshIndicator(
          onRefresh: fetchtodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'Şu wagt hiç hili iş ýok',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(onSelected: (value) {
                      if (value == 'edit') {
                        navigateToeditPage(item);
                      } else if (value == 'delete') {
                        deleteById(id);
                      }
                    }, itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          child: Text('Üýtget'),
                          value: 'edit',
                        ),
                        const PopupMenuItem(
                          child: Text('Poz'),
                          value: 'delete',
                        ),
                      ];
                    }),
                  ),
                );
              },
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddPage,
        backgroundColor: Colors.deepPurple[300],
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> navigateToeditPage(Map item) async {
    final rota = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, rota);
    setState(() {
      isloading = true;
    });
    fetchtodo();
  }

  Future<void> navigateToAddPage() async {
    final rota = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    await Navigator.push(context, rota);
    setState(() {
      isloading = true;
    });
    fetchtodo();
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      yalnysmessage('Ýalňyşlyk ýüze çykaýdy öýtýän!!!');
    }
  }

  Future<void> fetchtodo() async {
    setState(() {
      isloading = true;
    });
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=20';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isloading = false;
    });
  }

  void yalnysmessage(String sms) {
    final snackBar = SnackBar(
      content: Text(
        sms,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
