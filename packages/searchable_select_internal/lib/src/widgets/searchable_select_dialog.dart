import 'dart:async';

import 'package:flutter/material.dart';
import 'package:searchable_select_internal/searchable_select_internal.dart';
import 'package:flutter/services.dart';
import 'package:searchable_select_internal/src/widgets/search_header_delegate.dart';

class SearchableSelectDialog<T> extends StatefulWidget {
  final String title;

  final SearchRequest<T> searchRequest;

  final List<SearchColumn> columns;

  final List<String> Function(T item) rowBuilder;

  const SearchableSelectDialog({
    super.key,
    required this.title,
    required this.searchRequest,
    required this.columns,
    required this.rowBuilder,
  });

  @override
  State<SearchableSelectDialog<T>> createState() =>
      _SearchableSelectDialogState<T>();
}

class _SearchableSelectDialogState<T> extends State<SearchableSelectDialog<T>> {
  final TextEditingController searchController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  // final FocusNode focusNode = FocusNode();
  final FocusNode keyboardFocusNode = FocusNode();

  final List<T> items = [];

  Timer? debounce;

  int page = 1;

  final int pageSize = 20;

  bool loading = false;

  bool hasMore = true;

  int selectedIndex = 0;

  String keyword = '';

  int? sortColumnIndex;
  bool sortAscending = true;

  @override
  void initState() {
    super.initState();

    loadData(reset: true);

    scrollController.addListener(
      onScroll,
    );
  }

  @override
  void dispose() {
    debounce?.cancel();

    scrollController.dispose();

    searchController.dispose();

    // focusNode.dispose();
    keyboardFocusNode.dispose();

    super.dispose();
  }

  void handleKeyboard(
    KeyEvent event,
  ) {
    if (event is! KeyDownEvent) {
      return;
    }

    if (items.isEmpty) {
      return;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        selectedIndex = (selectedIndex + 1).clamp(
          0,
          items.length - 1,
        );
      });
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        selectedIndex = (selectedIndex - 1).clamp(
          0,
          items.length - 1,
        );
      });
    }

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      Navigator.pop(
        context,
        items[selectedIndex],
      );
    }

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.pop(context);
    }
  }

  void onScroll() {
    if (!hasMore || loading) {
      return;
    }

    if (scrollController.position.pixels >
        scrollController.position.maxScrollExtent - 300) {
      loadData();
    }
  }

  Future<void> loadData({
    bool reset = false,
  }) async {
    if (loading) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      if (reset) {
        page = 1;
        items.clear();
      }

      final PagedResult<T> result = await widget.searchRequest(
        keyword,
        page,
        pageSize,
      );

      items.addAll(result.data);

      hasMore = result.hasMore;

      page++;
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void sortColumn(
    int columnIndex,
  ) {
    setState(() {
      if (sortColumnIndex == columnIndex) {
        sortAscending = !sortAscending;
      } else {
        sortColumnIndex = columnIndex;
        sortAscending = true;
      }

      items.sort((a, b) {
        final va = widget.rowBuilder(a)[columnIndex];

        final vb = widget.rowBuilder(b)[columnIndex];

        return sortAscending ? va.compareTo(vb) : vb.compareTo(va);
      });
    });
  }

  void onSearchChanged(
    String value,
  ) {
    keyword = value;

    debounce?.cancel();

    debounce = Timer(
      const Duration(
        milliseconds: 400,
      ),
      () {
        loadData(reset: true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      autofocus: true,
      focusNode: keyboardFocusNode,
      onKeyEvent: handleKeyboard,
      child: Dialog(
        child: SizedBox(
          width: 1000,
          height: 650,
          child: Column(
            children: [
              buildHeader(),
              buildSearchBox(),
              // buildColumnHeader(),
              // Expanded(
              //   child: CustomScrollView(
              //     controller: scrollController,
              //     slivers: [
              //       SliverPersistentHeader(
              //         floating: true,
              //         pinned: true,
              //         delegate: SearchHeaderDelegate(
              //           columns: widget.columns,
              //         ),
              //       ),
              //       buildBodySliver(),
              //     ],
              //   ),
              // )
              Expanded(
                child: buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
    );
  }

  void clearSearch() {
    searchController.clear();

    keyword = '';

    loadData(reset: true);

    setState(() {});
  }

  Widget buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                  ),
                  onPressed: clearSearch,
                )
              : null,
          border: OutlineInputBorder(),
          hintText: 'Cari...',
        ),
      ),
    );
  }

  Widget buildColumnHeader() {
    return Container(
      margin: const EdgeInsets.only(
        top: 12,
      ),
      padding: const EdgeInsets.all(12),
      color: Colors.grey.shade200,
      child: Row(
        children: widget.columns
            .map(
              (e) => Expanded(
                flex: e.flex,
                child: Text(
                  e.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget buildBody() {
    if (items.isEmpty && loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (items.isEmpty) {
      return const Center(
        child: Text(
          'Data tidak ditemukan',
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: items.length + (loading ? 1 : 0),
      itemBuilder: (
        context,
        index,
      ) {
        if (index >= items.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final item = items[index];

        final row = widget.rowBuilder(item);

        return InkWell(
          onTap: () {
            Navigator.pop(
              context,
              item,
            );
          },
          child: Container(
            color: selectedIndex == index
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: List.generate(
                row.length,
                (i) => Expanded(
                  flex: widget.columns[i].flex,
                  child: Text(
                    row[i],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildMobileItem(
    T item,
  ) {
    final row = widget.rowBuilder(item);

    return Card(
      child: ListTile(
        title: Text(row[1]),
        subtitle: Text(
          row.join(' • '),
        ),
        onTap: () {
          Navigator.pop(
            context,
            item,
          );
        },
      ),
    );
  }

  SliverList buildBodySliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= items.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final item = items[index];

          final row = widget.rowBuilder(item);

          if (MediaQuery.of(context).size.width < 700) {
            return buildMobileItem(item);
          }

          return InkWell(
            key: ValueKey(item),
            onTap: () {
              Navigator.pop(
                context,
                item,
              );
            },
            child: Container(
              color: selectedIndex == index
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              child: Row(
                children: List.generate(
                  row.length,
                  (i) => Expanded(
                    flex: widget.columns[i].flex,
                    child: Text(
                      row[i],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        childCount: items.length + (loading ? 1 : 0),
      ),
    );
  }

  Widget buildContent() {
    if (loading && items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!loading && items.isEmpty) {
      return const Center(
        child: Text(
          'Data tidak ditemukan',
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: SearchHeaderDelegate(
              columns: widget.columns,
              onSort: sortColumn,
              sortColumnIndex: sortColumnIndex,
              sortAscending: sortAscending,
            ),
          ),
          buildBodySliver(),
        ],
      ),
    );
  }
}
