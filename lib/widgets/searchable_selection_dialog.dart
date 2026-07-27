import 'package:flutter/material.dart';
import 'dart:async';

class SearchableSelectionDialog<T> extends StatefulWidget {
  final List<T>? items;
  final Future<List<T>> Function(String keyword)? asyncItems;
  final T? selectedItem;

  final String title;

  final String searchHint;

  final String Function(T item) itemLabelBuilder;

  final String Function(T item)? itemSubtitleBuilder;

  final Widget Function(BuildContext context, T item, bool selected)?
  itemBuilder;

  const SearchableSelectionDialog({
    super.key,
    this.items,
    required this.itemLabelBuilder,
    this.itemSubtitleBuilder,
    this.itemBuilder,
    this.selectedItem,
    this.title = "Pilih Data",
    this.searchHint = "Cari...",
    this.asyncItems,
  });

  // ==========================================
  // SHOW METHOD
  // ==========================================

  static Future<T?> show<T>({
    required BuildContext context,

    List<T>? items,

    required String Function(T item) itemLabelBuilder,

    String title = "Pilih Data",
    Future<List<T>> Function(String keyword)? asyncItems,
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
            items: items ?? [],

            selectedItem: selectedItem,

            title: title,

            searchHint: searchHint,
            asyncItems: asyncItems,
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
  bool _loading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _filtered = List.from(widget.items as Iterable<T>);

    _searchController.addListener(_onSearch);
    if (widget.asyncItems != null) {
      _load("");
    }
  }

  Future<void> _load(String keyword) async {
    if (widget.asyncItems == null) return;

    setState(() {
      _loading = true;
    });

    try {
      final result = await widget.asyncItems!(keyword);

      if (!mounted) return;

      setState(() {
        _filtered = result;
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _debouncedSearch(String keyword) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _load(keyword);
    });
  }

  void _onSearch() {
    // final keyword = _searchController.text.toLowerCase().trim();

    // setState(() {
    //   if (keyword.isEmpty) {
    //     _filtered = List.from(widget.items);
    //   } else {
    //     _filtered = widget.items.where((e) {
    //       return widget.itemLabelBuilder(e).toLowerCase().contains(keyword);
    //     }).toList();
    //   }
    // });
    final keyword = _searchController.text.trim();

    if (widget.asyncItems != null) {
      _debouncedSearch(keyword);
      return;
    }

    setState(() {
      if (keyword.isEmpty) {
        _filtered = List.from(widget.items as Iterable<T>);
      } else {
        _filtered = widget.items!.where((e) {
          return widget
              .itemLabelBuilder(e)
              .toLowerCase()
              .contains(keyword.toLowerCase());
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
              trailing: [
                if (_loading)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.lightBlue,
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              itemCount: _filtered.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final item = _filtered[index];
                final selected = widget.selectedItem == item;

                return ListTile(
                  title: Text(widget.itemLabelBuilder(item)),
                  subtitle: widget.itemSubtitleBuilder == null
                      ? null
                      : Text(widget.itemSubtitleBuilder!(item)),
                  trailing: selected
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () => Navigator.pop(context, item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
