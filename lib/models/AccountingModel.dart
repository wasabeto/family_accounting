import 'package:family_accounting/models/IncomeExpenseModel.dart';

class AccountingModel {
  String id;
  String startDate;
  String endDate;
  List<IncomeExpenseModel> incomeExpenses;

  AccountingModel({this.endDate, this.id, this.incomeExpenses, this.startDate});

  factory AccountingModel.fromJson(Map<String, dynamic> json) {
    return AccountingModel(
      id: json['id'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      incomeExpenses: json['incomeExpenses'] != null ? (json['incomeExpenses'] as List).map((i) => IncomeExpenseModel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    if (this.incomeExpenses != null) {
      data['incomeExpenses'] = this.incomeExpenses.map((v) => v.toJson()).toList();
    }
    return data;
  }

  int getTotalIncomes() {
    return this.incomeExpenses.where((ie) => ie.type == 'income').length;
  }

  int getTotalExpenses() {
    return this.incomeExpenses.where((ie) => ie.type == 'expense').length;
  }

  double getTotalIncomesAmount() {
    double amount = 0;
    this.incomeExpenses.where((ie) => ie.type == 'income').toList().forEach((e) => amount += e.amount);
    return amount;
  }

  double getTotalExpensesAmount() {
    double amount = 0;
    this.incomeExpenses.where((ie) => ie.type == 'expense').toList().forEach((e) => amount += e.amount);
    return amount;
  }

  double getBalance() {
    double totalIncomesAmount = getTotalIncomesAmount();
    double totalExpensesAmount = getTotalExpensesAmount();
    return (totalIncomesAmount > 0) ? (totalExpensesAmount * 100 / totalIncomesAmount).round().toDouble() : 0.0;
  }
}
