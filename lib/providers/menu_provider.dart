import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/menu_item_model.dart';
import '../data/models/festival_menu_model.dart';
import '../data/repositories/menu_repository.dart';
import 'auth_provider.dart';

final menuRepoProvider = Provider((ref) => MenuRepository(ref.watch(apiProvider)));

final todayMenuProvider = FutureProvider<List<MenuItemModel>>(
    (ref) => ref.watch(menuRepoProvider).getTodayMenu());

final festivalMenuProvider = FutureProvider<List<FestivalMenuModel>>(
    (ref) => ref.watch(menuRepoProvider).getFestivalMenus());