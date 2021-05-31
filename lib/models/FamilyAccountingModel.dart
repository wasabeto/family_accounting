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
