import 'package:family_accounting/models/CategoryModel.dart';

class IncomeExpenseModel {
  String alias;
  String type;
  String date;
  double amount;
  CategoryModel category;

  IncomeExpenseModel({this.alias, this.type, this.date, this.amount, this.category});

  factory IncomeExpenseModel.fromJson(Map<String, dynamic> json) {
    return IncomeExpenseModel(
      alias: json['alias'],
      type: json['type'],
      date: json['date'],
      amount: json['amount'].toDouble(),
      category: json['category'] != null ? CategoryModel.fromJson(json['category']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alias'] = this.alias;
    data['type'] = this.type;
    data['date'] = this.date;
    data['amount'] = this.amount;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    return data;
  }
}
