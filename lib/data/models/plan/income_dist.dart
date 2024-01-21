import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ExpensesLevel {
  expense,
  nescessity,
  personal,
  saving,
}

abstract class PlanDistribution {
  String get title;
  String get explaination;
  String get shortExplaination;

  bool assertDistribution();

  PlanDistribution();

  factory PlanDistribution.fromJson(Map<String, dynamic> json) {
    final type = json["title"] as String;
    if(type == "5-3-2") return Distribution532();
    if(type == "7-2-1") return Distribution721();
    if(type == "8-2") return Distribution82();
    throw Exception("Unrecognized dist code");
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "explain": explaination,
      "short_explain": shortExplaination,
    };
  }

  Map<ExpensesLevel, int> distributeIncome(int income);
}

class Distribution532 extends PlanDistribution {
  @override
  bool assertDistribution() {
    throw UnimplementedError();
  }

  @override
  String get title => "5-3-2";
  
  @override
  String get explaination => """
    Thu nhập được chia làm 3 phần. 
    - Chi phí thiết yếu (50%) như tiền nhà, tiền ăn, tiền học 
    - Chi phí cá nhân (30%)
    - Khoản tiết kiệm, dư (20%).
    Đây là phân bố tiêu chuẩn, phù hợp với đa số nhu cầu của bạn. 
  """;
  
  @override
  String get shortExplaination => "Đây là phân bố tiêu chuẩn, phù hợp với đa số nhu cầu của bạn.";
  
  @override
  Map<ExpensesLevel, int> distributeIncome(int income) {
    return {
      ExpensesLevel.nescessity: (income * 0.5).toInt(),
      ExpensesLevel.personal: (income * 0.3).toInt(),
      ExpensesLevel.saving: (income * 0.2).toInt(),
    };
  }
}

class Distribution721 extends PlanDistribution {
  @override
  bool assertDistribution() {
    throw UnimplementedError();
  }

  @override
  String get title => "7-2-1";
  
  @override
  String get explaination => """
    Thu nhập được chia làm 3 phần. 
    - Chi phí thiết yếu (70%) như tiền nhà, tiền ăn, tiền học
    - Chi phí cá nhân (20%)
    - Khoản tiết kiệm, dư (10%).
    Tương tự với phân bố 5-3-2 tuy nhiên phù hợp nếu bạn cần chi tiêu nhiều
    hơn trong tháng.
  """;
  
  @override
  String get shortExplaination => "Tương tự với phân bố 5-3-2 tuy nhiên phù hợp nếu bạn cần chi tiêu nhiều hơn trong tháng.";
  
  @override
  Map<ExpensesLevel, int> distributeIncome(int income) {
    return {
      ExpensesLevel.nescessity: (income * 0.7).toInt(),
      ExpensesLevel.personal: (income * 0.2).toInt(),
      ExpensesLevel.saving: (income * 0.1).toInt(),
    };
  }
}

class Distribution6Pots extends PlanDistribution {
  @override
  bool assertDistribution() {
    throw UnimplementedError();
  }

  @override
  String get title => "6 lọ";
  
  @override
  String get explaination => """
    Thu nhập được chia làm 3 phần.
    - Chi phí thiết yếu (50%) như tiền nhà, tiền ăn, tiền học 
    - Chi phí cá nhân (30%)
    - Khoản tiết kiệm, dư (20%).
    Đây là phân bố tiêu chuẩn, phù hợp với đa số nhu cầu của bạn. 
  """;
  
  @override
  String get shortExplaination => throw UnimplementedError();
  
  @override
  Map<ExpensesLevel, int> distributeIncome(int income) {
    return {
      
    };
  }
}

class Distribution82 extends PlanDistribution {
  @override
  bool assertDistribution() {
    throw UnimplementedError();
  }

  @override
  String get title => "8-2";
  
  @override
  String get explaination => """
    Thu nhập được chia thành 2 phần
    - Chi phí sinh hoạt (80%) bao gồm tất cả chi phí tiêu dùng của bạn
    - Tiết kiệm (20%)
    Phân bố đơn giản, phù hợp nếu bạn có không có nhu cầu chi tiêu phức tạp.
  """;
  
  @override
  String get shortExplaination => "Phân bố đơn giản, phù hợp nếu bạn có không có nhu cầu chi tiêu phức tạp.";
  
  @override
  Map<ExpensesLevel, int> distributeIncome(int income) {
    return {
      ExpensesLevel.expense: (income * 0.8).toInt(),
      ExpensesLevel.saving: (income * 0.2).toInt(),
    };
  }
}

final distsProvider = Provider((ref) => 
  <PlanDistribution>[
    Distribution532(),
    Distribution721(),
    Distribution82(),
  ]
);