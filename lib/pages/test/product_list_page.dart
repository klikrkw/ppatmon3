// product_list_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/item/item_bloc.dart';
import 'package:newklikrkw/blocs/item/item_event.dart';
import 'package:newklikrkw/blocs/item/item_state.dart';
import 'package:newklikrkw/models/item_model.dart';
import 'package:newklikrkw/models/product_model.dart';
// import file-file model, bloc, event, state Anda di sini...

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _scrollController = ScrollController();
  Timer? _debounce;

  // Daftar kategori yang tersedia di aplikasi
  final List<String> _categories = ['Semua', 'Sepatu', 'Sandal'];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<ItemBloc<Product>>().add(FetchItemsEvent());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<ItemBloc<Product>>().add(SearchItemsEvent(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Multi-Filter'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // 1. Kolom Input Pencarian Nama
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari nama produk...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // 2. Daftar Kategori (Horizontal ChoiceChips)
          BlocBuilder<ItemBloc<Product>, ItemState<Product>>(
            buildWhen: (previous, current) =>
                previous.selectedCategory != current.selectedCategory,
            builder: (context, state) {
              return Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ..._categories.map((category) {
                      final isSelected = state.selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          selectedColor: Colors.blueAccent,
                          onSelected: (bool selected) {
                            if (selected) {
                              context.read<ItemBloc<Product>>().add(
                                FilterCategoryEvent(category),
                              );
                            }
                          },
                        ),
                      );
                    }), // Perataan mapping widget list
                  ],
                ),
              );
            },
          ),

          // 3. Widget Hasil Data Infinite List
          Expanded(
            child: BlocBuilder<ItemBloc<Product>, ItemState<Product>>(
              builder: (context, state) {
                switch (state.status) {
                  case ItemStatus.initial:
                    return const Center(child: CircularProgressIndicator());

                  case ItemStatus.failure:
                    return const Center(child: Text('Gagal memuat produk.'));

                  case ItemStatus.success:
                    if (state.items.isEmpty) {
                      return const Center(
                        child: Text('Produk tidak ditemukan.'),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.hasReachedMax
                          ? state.items.length
                          : state.items.length + 1,
                      itemBuilder: (context, index) {
                        if (index >= state.items.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final GenericItem<Product> item = state.items[index];
                        final Product product = item.data;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${item.id}')),
                            title: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Kategori: ${product.category} | Rp ${product.price}",
                            ),
                          ),
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
