import 'package:flutter/material.dart';

class SearchableSelectionDialog<T> extends StatefulWidget {
  final List<T> items;

  final T? selectedItem;

  final String title;

  final String searchHint;

  final String Function(T item) itemLabelBuilder;

  final String Function(T item)? itemSubtitleBuilder;

  final Widget Function(BuildContext context, T item, bool selected)?
  itemBuilder;

  const SearchableSelectionDialog({
    super.key,
    required this.items,
    required this.itemLabelBuilder,
    this.itemSubtitleBuilder,
    this.itemBuilder,
    this.selectedItem,
    this.title = "Pilih Data",
    this.searchHint = "Cari...",
  });

  // ==========================================
  // SHOW METHOD
  // ==========================================

  static Future<T?> show<T>({
    required BuildContext context,

    required List<T> items,

    required String Function(T item) itemLabelBuilder,

    String title = "Pilih Data",

    String searchHint = "Cari...",

    T? selectedItem,

    String Function(T item)? itemSubtitleBuilder,

    Widget Function(BuildContext context, T item, bool selected)? itemBuilder,
  }) async {
    return showDialog<T>(
      context: context,

      barrierDismissible: true,

      builder: (context) {
        return Dialog.fullscreen(
          child: SearchableSelectionDialog<T>(
            items: items,

            selectedItem: selectedItem,

            title: title,

            searchHint: searchHint,

            itemLabelBuilder: itemLabelBuilder,

            itemSubtitleBuilder: itemSubtitleBuilder,

            itemBuilder: itemBuilder,
          ),
        );
      },
    );
  }

  @override
  State<SearchableSelectionDialog<T>> createState() =>
      _SearchableSelectionDialogState<T>();
}

class _SearchableSelectionDialogState<T>
    extends State<SearchableSelectionDialog<T>> {
  final TextEditingController _searchController = TextEditingController();

  late List<T> _filtered;

  @override
  void initState() {
    super.initState();

    _filtered = List.from(widget.items);

    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final keyword = _searchController.text.toLowerCase().trim();

    setState(() {
      if (keyword.isEmpty) {
        _filtered = List.from(widget.items);
      } else {
        _filtered = widget.items.where((e) {
          return widget.itemLabelBuilder(e).toLowerCase().contains(keyword);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              controller: _searchController,
              hintText: widget.searchHint,
              leading: const Icon(Icons.search),
            ),
          ),

          Expanded(
            child: ListView.separated(
              itemCount: _filtered.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final item = _filtered[index];

                final selected = widget.selectedItem == item;

                if (widget.itemBuilder != null) {
                  return InkWell(
                    onTap: () => Navigator.pop(context, item),
                    child: widget.itemBuilder!(context, item, selected),
                  );
                }

                return ListTile(
                  title: Text(widget.itemLabelBuilder(item)),
                  subtitle: widget.itemSubtitleBuilder == null
                      ? null
                      : Text(widget.itemSubtitleBuilder!(item)),
                  trailing: selected
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    Navigator.pop(context, item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
