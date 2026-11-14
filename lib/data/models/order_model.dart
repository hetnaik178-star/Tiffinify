class OrderItemModel {
  final String menuItemId, name, emoji, specialRequest;
  final int quantity;
  final Map<String, String> customization; // customization_json (PDF §5)
  final double unitPrice;

  OrderItemModel({required this.menuItemId, required this.name, this.emoji = '🍛',
                  this.quantity = 1, this.customization = const {},
                  this.specialRequest = '', required this.unitPrice});

  Map<String, dynamic> toJson() => {'menu_item_id': menuItemId, 'quantity': quantity,
        'customization_json': customization, 'special_request_text': specialRequest};
}

class OrderModel {
  final String id, userId, status, deliveryDate;
  final String? subscriptionId;
  final double totalAmount;
  final List<OrderItemModel> items;

  OrderModel({required this.id, required this.userId, required this.status,
              required this.deliveryDate, required this.totalAmount,
              this.subscriptionId, this.items = const []});

  static const List<String> statusFlow = ['Placed', 'Preparing', 'Ready', 'Delivered'];

  factory OrderModel.fromJson(Map<String, dynamic> j) => OrderModel(
        id: j['id'].toString(), userId: j['user_id'].toString(),
        status: j['status'], deliveryDate: j['delivery_date'],
        subscriptionId: j['subscription_id']?.toString(),
        totalAmount: (j['total_amount'] as num).toDouble());
}