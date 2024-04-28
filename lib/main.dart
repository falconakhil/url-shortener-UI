import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URL Shortener',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 6, 54, 131)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'URL shortener'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textFieldController = TextEditingController();
  var short_url = "";
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    var url_style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Card(
            color: theme.colorScheme.primary,
            child: ListView(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'URL Shortener',
                        style: style,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: textFieldController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter long URL',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 100,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            post();
                          },
                          child: const Text('Generate'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            copy();
                          },
                          child: const Text('Copy'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SelectableText(
                  short_url,
                  style: url_style,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void post() async {
    var server = Uri(
      host: "localhost",
      port: 8000,
      path: "/add/",
      scheme: 'http',
    );
    var response = await http.post(server,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"long_url": textFieldController.text}));
    short_url = jsonDecode(response.body)['short_url'];

    setState(() {});
  }

  void copy() async {
    await Clipboard.setData(ClipboardData(text: short_url));
  }
}
