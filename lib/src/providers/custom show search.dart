import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = ["item", "item", "item", "item", "item", "item"];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear_rounded, color: kAccentColor),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios_new_rounded, color: kAccentColor),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var items in searchTerms) {
      if (items.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(items);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var items in searchTerms) {
      if (items.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(items);
      }
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
