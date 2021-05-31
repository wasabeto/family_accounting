

class DashboardModel {
  FamilyAccounting familyAccounting;
  List<AccountingModel> accounting;

  DashboardModel({this.accounting, this.familyAccounting});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      accounting: json['accounting'] != null ? (json['accounting'] as List).map((i) => AccountingModel.fromJson(i)).toList() : null,
      familyAccounting: json['familyAccounting'] != null ? FamilyAccounting.fromJson(json['familyAccounting']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accounting != null) {
      data['accounting'] = this.accounting.map((v) => v.toJson()).toList();
    }
    if (this.familyAccounting != null) {
      data['familyAccounting'] = this.familyAccounting.toJson();
    }
    return data;
  }
}

class CategoryModel {
  String id;
  String name;

  CategoryModel({this.id, this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

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
}

class FamilyAccounting {
  String id;

  FamilyAccounting({this.id});

  factory FamilyAccounting.fromJson(Map<String, dynamic> json) {
    return FamilyAccounting(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
