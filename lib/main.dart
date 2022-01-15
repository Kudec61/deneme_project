// ignore_for_file: unused_local_variable, import_of_legacy_library_into_null_safe, avoid_print, unused_field, prefer_is_empty

import 'dart:convert';
// import 'dart:html';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Link Shortening',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Link Shortening'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _visible = false;

  String text = "";
  String hintText = "Paste your link";

  TextEditingController controller = TextEditingController();
  TextEditingController copyController = TextEditingController();

  Future<void> shortenURL(String longURL) async {
    final response = await http.post(
        Uri.parse("https://cleanuri.com/api/v1/shorten"),
        body: {'url': controller.text});
    var result = jsonDecode(response.body);
    setState(() {
      controller.text = result['result_url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (input) {
                setState(() {
                  text = input;
                });
              },
              controller: controller,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: hintText,
                  hintStyle: const TextStyle(fontSize: 20),
                  prefixIcon: Visibility(
                      visible: text == "" ? _visible = false : _visible = true,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              hintText = "Paste your link";
                              text = "";
                            });
                            controller.clear();
                          },
                          icon: const Icon(Icons.clear))),
                  suffixIcon: Visibility(
                    visible: text == "" ? _visible = false : _visible = true,
                    child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            Clipboard.setData(
                                ClipboardData(text: controller.text));
                            setState(() {
                              controller.clear();
                              hintText = "Link Copied !";
                            });
                          });
                        },
                        icon: const Icon(
                          Icons.copy_all,
                          size: 35,
                        ),
                        label: const Text(
                          "Copy",
                          style: TextStyle(fontSize: 18),
                        )),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton.icon(
                onPressed: () {
                  shortenURL(controller.text);
                },
                icon: const Icon(
                  Icons.short_text_rounded,
                  size: 40,
                ),
                label: const Text(
                  "Short Link",
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}
