import 'package:flutter/material.dart';
import 'package:searchable_select_internal/searchable_select_internal.dart';

class SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<SearchColumn> columns;

  final void Function(int index)? onSort;

  final int? sortColumnIndex;

  final bool sortAscending;

  SearchHeaderDelegate({
    required this.columns,
    this.onSort,
    this.sortColumnIndex,
    this.sortAscending = true,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: List.generate(
          columns.length,
          (index) {
            final column = columns[index];

            return Expanded(
              flex: column.flex,
              child: InkWell(
                onTap: () => onSort?.call(index),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        column.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (sortColumnIndex == index)
                      Icon(
                        sortAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 14,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  bool shouldRebuild(
    covariant SearchHeaderDelegate oldDelegate,
  ) {
    return true;
  }
}
