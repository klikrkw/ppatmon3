import 'package:flutter/material.dart';
import 'package:searchable_select_internal/searchable_select_internal.dart';

class SearchableSelectField<T> extends FormField<T> {
  SearchableSelectField({
    super.key,
    required BuildContext context,
    required String label,
    required SearchRequest<T> searchRequest,
    required List<SearchColumn> columns,
    required List<String> Function(T item) rowBuilder,
    required String Function(T item) displayText,
    super.initialValue,
    super.validator,
    super.onSaved,
    ValueChanged<T?>? onChanged,
    bool enabled = true,
  }) : super(
          builder: (field) {
            return InkWell(
              onTap: !enabled
                  ? null
                  : () async {
                      final result = await showDialog<T>(
                        context: context,
                        builder: (_) => SearchableSelectDialog<T>(
                          title: label,
                          searchRequest: searchRequest,
                          columns: columns,
                          rowBuilder: rowBuilder,
                        ),
                      );

                      if (result != null) {
                        field.didChange(result);
                        onChanged?.call(result);
                      }
                    },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: label,
                  border: const OutlineInputBorder(),
                  errorText: field.errorText,
                  suffixIcon: const Icon(
                    Icons.search,
                  ),
                ),
                child: Text(
                  field.value == null
                      ? 'Pilih Data'
                      : displayText(
                          field.value as T,
                        ),
                ),
              ),
            );
          },
        );
}
