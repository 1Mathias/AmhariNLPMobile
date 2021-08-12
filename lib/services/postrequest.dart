import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localization_master/classes/language.dart';
import 'package:flutter_localization_master/localization/language_constants.dart';
import 'package:flutter_localization_master/main.dart';
import 'package:flutter_localization_master/router/route_constants.dart';
import 'package:http/http.dart' as http;

class PostRequest extends StatefulWidget {
  const PostRequest({Key key}) : super(key: key);

  @override
  _PostRequestState createState() => _PostRequestState();
}

class _PostRequestState extends State<PostRequest> {
  TextEditingController _titleController;
  TextEditingController _contentController;
  TextEditingController _userIdController;
  String _responseBody = '<empty>';
  String _error = '<none>';
  bool _pending = false;
  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  @override
  void initState() {
    super.initState();
    this._contentController = TextEditingController();
    this._titleController = TextEditingController();
    this._userIdController = TextEditingController();
    _reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(getTranslated(context, "service_page"))),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<Language>(
              underline: SizedBox(),
              icon: Icon(
                Icons.language,
                color: Colors.white,
              ),
              onChanged: (Language language) {
                _changeLanguage(language);
              },
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            e.flag,
                            style: TextStyle(fontSize: 30),
                          ),
                          Text(e.name)
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: _drawerList(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const Text('''In this example we will POST to the jsonplaceholder API.
          From https://jsonplaceholder.typicode.com/guide.html 
          we see that the API expects title, body and userId in the request body.'''),
          const Divider(),
          TextField(
            controller: this._titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: this._contentController,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: 'Content',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: this._userIdController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'UserId',
              border: OutlineInputBorder(),
            ),
          ),
          ButtonBar(
            children: <Widget>[
              ElevatedButton(
                onPressed: _pending
                    ? null
                    : () => this._httpPost(
                          _titleController.text,
                          _contentController.text,
                          _userIdController.text,
                        ),
                child: const Text('Post'),
              ),
              ElevatedButton(
                onPressed: this._reset,
                child: const Text('Reset'),
              ),
            ],
          ),
          Text('Response body=$_responseBody'),
          const Divider(),
          Text('Error=$_error'),
        ],
      ),
    );
  }

  void _reset({bool resetControllers = true}) {
    setState(() {
      if (resetControllers) {
        this._titleController.text = 'Lorem Ipsum Title';
        this._contentController.text =
            '''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas congue quisque egestas diam in arcu. Quis imperdiet massa tincidunt nunc pulvinar. ''';
        this._userIdController.text = '1';
      }
      this._responseBody = '<empty>';
      this._error = '<none>';
      this._pending = false;
    });
  }

  Future<void> _httpPost(String title, String body, String userId) async {
    _reset(resetControllers: false);
    setState(() => this._pending = true);
    try {
      final http.Response response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': title,
          'body': body,
          'userId': userId,
        }),
      );
      // If the server did return a 201 CREATED response.
      if (response.statusCode == 201) {
        setState(() => this._responseBody = response.body);
      } else {
        setState(() => this._error = 'Failed to add a post: $response');
      }
    } catch (e) {
      setState(() => this._error = 'Failed to add a post: $e');
    }
    setState(() => this._pending = false);
  }

  Container _drawerList() {
    TextStyle _textStyle = TextStyle(
      color: Colors.white,
      fontSize: 24,
    );
    return Container(
      color: Theme.of(context).primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              height: 100,
              child: CircleAvatar(),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Colors.white,
              size: 30,
            ),
            title: Text(
              getTranslated(context, 'about_us'),
              style: _textStyle,
            ),
            onTap: () {
              // To close the Drawer
              Navigator.pop(context);
              // Navigating to About Page
              Navigator.pushNamed(context, aboutRoute);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.white,
              size: 30,
            ),
            title: Text(
              getTranslated(context, 'settings'),
              style: _textStyle,
            ),
            onTap: () {
              // To close the Drawer
              Navigator.pop(context);
              // Navigating to About Page
              Navigator.pushNamed(context, settingsRoute);
            },
          ),
        ],
      ),
    );
  }
}
