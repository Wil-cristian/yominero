import 'package:flutter/material.dart';

/// A simple search page that contains a search bar and shows basic
/// results for demonstration purposes. In a full application this
/// page would query a backend or local database for posts,
/// products, or services matching the user's query.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> _results = [];

  void _onSearch(String query) {
    setState(() {
      // For this demo, just return a single result string when the query
      // is non-empty. A real implementation would perform a search.
      if (query.isEmpty) {
        _results = [];
      } else {
        _results = ['Resultado para "$query"'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Buscar',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearch,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _results.isEmpty
                  ? const Center(child: Text('No hay resultados'))
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_results[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}