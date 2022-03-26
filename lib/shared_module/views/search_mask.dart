import 'package:flutter/material.dart';
import '../../activity_module/utils/debouncer.dart';

class SearchMask<TEntity, TSuggestionFilter> extends StatefulWidget {
  final Debouncer debouncer = Debouncer(milliseconds: 200);
  final Widget Function(
      BuildContext context,
      TSuggestionFilter? activeSuggestionFilter,
      Function(TSuggestionFilter? suggestionFilter)
          onSuggestionFilterTapped)? suggestionFilterBuilder;
  final Future<List<TEntity>> Function(
          String searchTerm, TSuggestionFilter? activeSuggestionFilter)
      searchAction;
  final Widget Function(BuildContext context, TEntity searchResult)
      resultBuilder;
  final Widget title;

  SearchMask(
      {Key? key,
      required this.searchAction,
      required this.resultBuilder,
      required this.title,
      this.suggestionFilterBuilder})
      : super(key: key);

  @override
  _SearchMaskState createState() =>
      _SearchMaskState<TEntity, TSuggestionFilter>();
}

class _SearchMaskState<TEntity, TSuggestionFilter>
    extends State<SearchMask<TEntity, TSuggestionFilter>> {
  final TextEditingController controller = TextEditingController();
  List<TEntity> _searchResults = [];
  TSuggestionFilter? _suggestionFilter;

  Future<void> sendSearchRequest() async {
    if (controller.text.isEmpty && _suggestionFilter == null) return;
    final results =
        await widget.searchAction(controller.text, _suggestionFilter);
    setState(() {
      _searchResults = results;
    });
  }

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
                controller: controller,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  labelText: "Suchen",
                  suffix: IconButton(
                      onPressed: () => controller.clear(),
                      icon: const Icon(Icons.clear)),
                ),
                onChanged: (text) => widget.debouncer.run(sendSearchRequest),
              ),
              if (widget.suggestionFilterBuilder != null)
                widget.suggestionFilterBuilder!(
                    context,
                    _suggestionFilter,
                    (suggestionFilter) => setState(() {
                          _suggestionFilter = suggestionFilter;
                          sendSearchRequest();
                        })),
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
