import 'package:flutter/cupertino.dart';
import 'package:saving_app/data/models/category.model.dart';

String transactTypeToJson(TransactionType type) {
  return type.toString();
}

TransactionType jsonToTransactType(String json) {
  for(var value in TransactionType.values) {
    if(value.toString() == json) {
      return value;
    }
  }
  throw Exception("value [$json] cant be deserialize to TransactionType");
}

Map<String, dynamic> iconToJson(IconData icon) =>
{
  "code": icon.codePoint,
  "font_family": icon.fontFamily,
  "font_package": icon.fontPackage,
};

IconData jsonToIcon(Map<String, dynamic> json) {
  return IconData(
    json["code"],
    fontFamily: json["font_family"],
    fontPackage: json["font_package"],
  );
}