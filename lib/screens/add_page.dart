import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController describtioncontroller = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titlecontroller.text = title;
      describtioncontroller.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "Edilmeli işleri üýtgediň" : 'Täze edilmeli işi goşuň',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[300],
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titlecontroller,
            decoration: InputDecoration(
                hintText: "Kim ýerine ýetirmeli?",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            controller: describtioncontroller,
            decoration: InputDecoration(
                hintText: 'Edilmeli iş',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 8,
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: isEdit ? uytgetdata : datagos,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Colors.deepPurple[300]), // Set desired color
            ),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                isEdit ? 'Üýtget' : 'Goş',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> uytgetdata() async {
    final todo = widget.todo;
    if (todo == null) {
      return;
    }
    final id = todo['_id'];
    final title = titlecontroller.text;
    final description = describtioncontroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      titlecontroller.text = '';
      describtioncontroller.text = '';
      basarnyklymessage('Üýtgetdiň Şöwket ;)');
    } else {
      yalnysmessage('Nätdiňaý Şöwket!!!');
    }
  }

  Future<void> datagos() async {
    final title = titlecontroller.text;
    final description = describtioncontroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 201) {
      titlecontroller.text = '';
      describtioncontroller.text = '';
      basarnyklymessage('Şöwket seň başarjagyňy öňem bilýädim ;)');
    } else {
      yalnysmessage('Nätdiňaý Şöwket!!!');
    }
  }

  void basarnyklymessage(String sms) {
    final snackBar = SnackBar(
      content: Text(
        sms,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
