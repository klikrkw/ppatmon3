import 'package:newklikrkw/models/customer.dart';
import 'package:newklikrkw/utils/dio.dart';
import 'package:searchable_select_internal/searchable_select_internal.dart';

class CustomerRepository {
  CustomerRepository();

  Future<PagedResult<Customer>> search(
    String keyword,
    int page,
    int pageSize,
  ) async {
    final response = await dio.get(
      '/customers',
      queryParameters: {'search': keyword, 'page': page, 'pageSize': pageSize},
    );

    final items = (response.data['data'] as List)
        .map((e) => Customer.fromJson(e))
        .toList();

    final total = response.data['total'];

    return PagedResult<Customer>(data: items, hasMore: page * pageSize < total);
  }
}
