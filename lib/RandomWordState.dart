import 'package:startup_namer/my_flutter_app_icons.dart';
import 'RandomWords.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class RandomWordState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = <WordPair>{};
  final TextStyle _biggerFont = const TextStyle(
      fontSize: 25.0, color: Colors.white, fontFamily: 'Rationale');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        titleTextStyle:
            const TextStyle(fontFamily: 'Rationale', fontSize: 35.0),
        actions: <Widget>[
          IconButton(icon: const Icon(MyFlutterApp.list), onPressed: _pushSaved)
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.black,
                Colors.grey,
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _buildSuggestions()),
          Container(
            width: 100,
            color: Colors.black,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _suggestions.clear();
                  _suggestions.cast();
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)
              ),
              child: const Text('Neue Liste generieren'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x59000000),
            Color(0xff000000),
          ],
        ),
      ),
      child: ListView.builder(
        itemCount: 40,
        padding: const EdgeInsets.all(0.0),
        itemBuilder: (BuildContext context, int i) {
          if (i.isOdd) {
            return const Divider();
          }
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(40).toList());
            _suggestions
                .sort((a, b) => a.asPascalCase.compareTo(b.asPascalCase));
          }
          return _buildRow(_suggestions[index]);
        },
      ),
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: Colors.white,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
      tileColor: alreadySaved ? Colors.grey : null,
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _saved.map(
        (WordPair pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        },
      );
      final List<Widget> divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();
      return Scaffold(
        appBar: AppBar(
          title: const Text("Saved Suggerstions"),
          leading: GestureDetector(
            child: const Icon(MyFlutterApp.chevron_left),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          titleTextStyle:
              const TextStyle(fontFamily: 'Rationale', fontSize: 35.0),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black,
                  Colors.grey,
                ],
              ),
            ),
          ),
        ),
        body: Center(
          child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x59000000),
                    Color(0xff000000),
                  ],
                ),
              ),
              child: ListView(children: divided)),
        ),
      );
    }));
  }
}

// https://blog.logrocket.com/how-to-build-a-bottom-navigation-bar-in-flutter/
// https://penpot.app/