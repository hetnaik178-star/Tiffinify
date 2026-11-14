class SubscriptionModel {
  final String id, userId, planType, status; // weekly | monthly
  final int mealsPerDay;
  final DateTime startDate, endDate;

  SubscriptionModel({required this.id, required this.userId, required this.planType,
                     required this.mealsPerDay, required this.startDate,
                     required this.endDate, this.status = 'active'});

  int get totalDays => endDate.difference(startDate).inDays;
  int get daysLeft => endDate.difference(DateTime.now()).inDays.clamp(0, totalDays);
  String get planLabel => planType == 'weekly' ? 'Weekly' : 'Monthly';

  factory SubscriptionModel.fromJson(Map<String, dynamic> j) => SubscriptionModel(
        id: j['id'].toString(), userId: j['user_id'].toString(),
        planType: j['plan_type'], mealsPerDay: j['meals_per_day'] ?? 1,
        startDate: DateTime.parse(j['start_date']), endDate: DateTime.parse(j['end_date']),
        status: j['status'] ?? 'active');

  Map<String, dynamic> toJson() => {'id': id, 'user_id': userId, 'plan_type': planType,
        'meals_per_day': mealsPerDay, 'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(), 'status': status};
}