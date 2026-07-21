// database_repository.dart
import 'package:newklikrkw/models/item_model.dart';
import 'package:newklikrkw/models/product_model.dart';

abstract class DatabaseRepository<T> {
  Future<List<GenericItem<T>>> fetchItemsFromDb({
    required int offset,
    required int limit,
    String? query,
    String? category, // Tambahkan parameter kategori
  });
}

// product_repository.dart
class ProductRepository implements DatabaseRepository<Product> {
  @override
  Future<List<GenericItem<Product>>> fetchItemsFromDb({
    required int offset,
    required int limit,
    String? query,
    String? category,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 400),
    ); // Simulasi delay DB

    // Data master tiruan dengan properti kategori tambahan
    final List<Product> masterProducts = List.generate(100, (index) {
      final isEven = index % 2 == 0;
      return Product(
        name: isEven
            ? "Sepatu Nike Air Max v$index"
            : "Sandal Adidas Running v$index",
        price: 1500000 + (index * 10000),
        category: isEven ? "Sepatu" : "Sandal", // Menambahkan data kategori
      );
    });

    // Jalankan filter gabungan (Nama & Kategori)
    List<Product> filteredMaster = masterProducts;

    // 1. Filter Nama
    if (query != null && query.isNotEmpty) {
      filteredMaster = filteredMaster
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    // 2. Filter Kategori (Abaikan jika memilih "Semua")
    if (category != null && category.isNotEmpty && category != "Semua") {
      filteredMaster = filteredMaster
          .where((p) => p.category.toLowerCase() == category.toLowerCase())
          .toList();
    }

    // Terapkan pembatasan Pagination (Offset & Limit)
    if (offset >= filteredMaster.length) return [];
    final endIndex = (offset + limit) > filteredMaster.length
        ? filteredMaster.length
        : (offset + limit);
    final paginatedProducts = filteredMaster.sublist(offset, endIndex);

    return List.generate(paginatedProducts.length, (index) {
      return GenericItem<Product>(
        id: offset + index,
        data: paginatedProducts[index],
      );
    });
  }
}
