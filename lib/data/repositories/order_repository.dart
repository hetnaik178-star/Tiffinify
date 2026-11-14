import '../models/order_model.dart';
import '../services/api_service.dart';

class OrderRepository {
  final ApiService _api;
  OrderRepository(this._api);

  Future<OrderModel> placeOrder(List<OrderItemModel> items, double total) =>
      _api.placeOrder(items, total);

  Future<void> customizeOrder(String orderId, List<OrderItemModel> items) =>
      _api.customizeOrder(orderId, items);
}