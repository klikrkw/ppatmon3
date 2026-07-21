import '../models/home_dashboard.dart';
import '../services/home_service.dart';

class HomeRepository {
  final HomeService service;

  HomeRepository(this.service);

  Future<HomeDashboard> dashboard(int? userId) async {
    final response = await service.dashboard(userId);

    return HomeDashboard.fromJson(response.data["data"]);
  }
}
