import 'package:family_accounting/models/AccountingModel.dart';
import 'package:family_accounting/models/FamilyAccountingModel.dart';

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
