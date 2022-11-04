import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class WebSearch extends StatefulWidget {
  const WebSearch({super.key});

  @override
  State<WebSearch> createState() => _WebSearchState();
}

class _WebSearchState extends State<WebSearch> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchMedicine(),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),

      //   body: const WebView(
      //   initialUrl: 'https://www.drugs.com/',
      //  ),
    );
  }
}

class SearchMedicine extends SearchDelegate {
  List<String> Allsuggestions = [
    'paracetamol',
    'Otezla',
    'Melatonin',
    'Benzonatate',
    'Otezla',
    'Doxycycline',
    'Hydroxychloroquine',
    'Aspirin',
    'Pantoprazole',
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear),
        )
      ];
  @override
  Widget buildResults(BuildContext context) => WebView(
        initialUrl: 'https://www.drugs.com/$query',
      );
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = Allsuggestions.where((searchResult) {
      final results = searchResult;
      final input = query;
      return results.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: ((context, index) {
        final suggestion = suggestions[index];

        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      }),
    );
  }
}
