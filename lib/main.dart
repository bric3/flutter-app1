import 'dart:math';

import 'package:app1/model.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Bric3 app',
      home: RandomWords(),
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        brightness: Brightness.dark,

        primaryColor: Colors.amber,
        accentColor: Colors.lightGreenAccent,

        fontFamily: 'Montserrat',

        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <Model>[];
  final _saved = new Set<Model>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  Color _buttonColor = Colors.amber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _buttonColor = Color((Random().nextInt(0xFFFFFF))).withOpacity(1.0);
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tooltip: 'Whatever',
        backgroundColor: _buttonColor,
        child: Icon(Icons.fingerprint),
//        mini: true,
        highlightElevation: 10.0,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        // Add 20 lines from here...
        builder: (BuildContext context) {
          Iterable<ListTile> tiles = _saved.map(
            (Model model) {
              return new ListTile(
                title: new Text(
                  model.name,
                  style: _biggerFont,
                ),
              );
            },
          );
          List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: new ListView(
              children: divided,
              physics: const AlwaysScrollableScrollPhysics(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
//          if (i.isOdd) return Divider();

//          final index = i ~/ 2;
            if (index >= _suggestions.length) {
              _suggestions.addAll(generateModel().take(10));
            }
            return _buildRow(_suggestions[index]);
          }),
    );
  }

  Iterable<Model> generateModel() {
    return generateWordPairs().map((pair) => Model(
        name: pair.asPascalCase, icon: FontAwesomeIcons.mobileAlt, pitch: "Lorem Ipsum"));
  }

  Widget _buildRow(Model model) {
    bool alreadySaved = _saved.contains(model);

    return Card(
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 1.0, vertical: 4.0),
      child: Container(
//        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
        child: _buildListTile(model, alreadySaved),
      ),
    );
  }

  ListTile _buildListTile(Model model, bool alreadySaved) {
    return ListTile(
      title: Text(
        model.name,
        style: _biggerFont,
      ),
      leading: Container(
        padding: EdgeInsets.only(right: 10.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(model.icon, color: Colors.deepOrange),
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      subtitle: Row(
        children: <Widget>[
          Icon(
            Icons.speaker_notes,
            color: Colors.yellowAccent,
            size: 14,
          ),
          Container(
              padding: EdgeInsets.only(left: 4.0),
              child: Text(model.pitch, style: TextStyle(color: Colors.white)))
        ],
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(model);
          } else {
            _saved.add(model);
          }
        });
      },
    );
  }
}
