class PaymentModel {
  final String id, userId, method, status, txnId;
  final String? orderId, subscriptionId;
  final double amount;

  PaymentModel({required this.id, required this.userId, required this.amount,
                required this.method, required this.status, required this.txnId,
                this.orderId, this.subscriptionId});

  factory PaymentModel.fromJson(Map<String, dynamic> j) => PaymentModel(
        id: j['id'].toString(), userId: j['user_id'].toString(),
        amount: (j['amount'] as num).toDouble(), method: j['method'] ?? 'upi',
        status: j['status'] ?? 'pending', txnId: j['txn_id'] ?? '',
        orderId: j['order_id']?.toString(), subscriptionId: j['subscription_id']?.toString());
}