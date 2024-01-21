import 'package:intl/intl.dart';
import 'package:saving_app/data/models/category.model.dart';
import 'package:saving_app/utils/json.dart';
import 'package:saving_app/utils/times.dart';

class PlanTransaction {
  String id;
  String title;
  int amount;
  String categoryId;
  String? targetAccount;
  DateTime? transactDate;
  Periodic? period;
  TransactionType transactType;
  PaidStatus status;
  int notificationId;

  PlanTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.transactType,
    this.targetAccount,
    this.transactDate,
    this.period,
    this.status = PaidStatus.upcoming,
    this.notificationId = -1,
  });

  PlanTransaction.fromJson(Map<String, dynamic> json) :
    id = json["id"],
    title = json["title"],
    amount = json["amount"] as int,
    categoryId = json["category"],
    transactType = jsonToTransactType(json["transact_type"]),
    transactDate = DateTime.parse(json["transact_date"]),
    period = jsonToPeriodic(json["period"]),
    status = jsonToPaidStatus(json["status"])!,
    targetAccount = json["target_account"],
    notificationId = json["noti"] as int;
  
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json["id"] = id;
    json["title"] = title;
    json["amount"] = amount;
    json["category"] = categoryId;
    json["target_account"] = targetAccount;
    json["transact_type"] = transactType.toString();
    if(transactDate != null) {
      json["transact_date"] = transactDate?.toIso8601String();
    }
    if(period != null) {
      json["period"] = period.toString();
    }
    json["status"] = status.toString();
    json["noti"] = notificationId;
    return json;
  }

  ScheduledNotification makeNotification() {
    return ScheduledNotification(
      id: notificationId, 
      content: "Bạn có lịch cho khoản $title vào hôm nay với số tiền ${NumberFormat.decimalPattern().format(amount)} VND", 
      title: "Nhắc lịch thu chi", 
      type: period!,
      referenceDateTime: transactDate!.to9PM(),
    );
  }
}

enum Periodic {
  onetime,
  daily,
  weekly,
  monthly,
  yearly,
}

Periodic? jsonToPeriodic(String json) {
  for(var value in Periodic.values) {
    if(value.toString() == json) return value;
  }
  return null;
}

enum PaidStatus {
  upcoming,
  paid,
  late
}

PaidStatus? jsonToPaidStatus(String json) {
  for(var value in PaidStatus.values) {
    if(value.toString() == json) return value;
  }
  return null;
}

class ScheduledNotification {
  ScheduledNotification({
    required this.id, 
    required this.content, 
    required this.title, 
    required this.type,
    required this.referenceDateTime,
  });

  int id;
  String content = "";
  String title;
  Periodic type;
  DateTime referenceDateTime;

  Map<String, String> get payload => {

  };

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "content": content,
      "title": title,
      "type": type.toString(),
      "ref_time": referenceDateTime.toIso8601String(),
    };
  }

  ScheduledNotification.fromJson(Map<String, dynamic> json) 
  : id = json["id"] as int,
    content = json["content"],
    title = json["title"],
    type = jsonToPeriodic(json["type"])!,
    referenceDateTime = DateTime.parse(json["ref_time"]);
}
