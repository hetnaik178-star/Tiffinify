import '../models/menu_item_model.dart';
import '../models/festival_menu_model.dart';
import '../services/api_service.dart';

class MenuRepository {
  final ApiService _api;
  MenuRepository(this._api);

  List<MenuItemModel>? _todayCache;

  Future<List<MenuItemModel>> getTodayMenu() async {
    if (_todayCache != null) return _todayCache!;
    _todayCache = await _api.getTodayMenu();
    return _todayCache!;
  }

  Future<List<FestivalMenuModel>> getFestivalMenus() => _api.getFestivalMenus();
}