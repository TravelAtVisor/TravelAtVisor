import 'package:flutter/material.dart';
import '../utils/debouncer.dart';

class SearchMask<TEntity> extends StatefulWidget {
  final Debouncer debouncer = Debouncer(milliseconds: 200);
  final TextEditingController controller = TextEditingController();

  final Future<List<TEntity>> Function(String searchTerm) searchAction;
  final Widget Function(BuildContext context, TEntity searchResult)
      resultBuilder;
  final Widget title;

  SearchMask(
      {Key? key,
      required this.searchAction,
      required this.resultBuilder,
      required this.title})
      : super(key: key);

  @override
  _SearchMaskState createState() => _SearchMaskState<TEntity>();
}

class _SearchMaskState<TEntity> extends State<SearchMask<TEntity>> {
  List<TEntity> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: widget.title),
        body: SafeArea(
          child: Column(
            children: [
              TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  labelText: "Suchen",
                  suffix: IconButton(
                      onPressed: () => widget.controller.clear(),
                      icon: const Icon(Icons.clear)),
                ),
                onChanged: (text) => widget.debouncer.run(() async {
                  final results = await widget.searchAction(text);
                  setState(() {
                    _searchResults = results;
                  });
                }),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final item = _searchResults.elementAt(index);
                    return widget.resultBuilder(context, item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
