import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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

  IconData getIcon() {
    switch(this.name) {
      case 'Salary': return MdiIcons.cashMultiple;
      case 'Rent': return MdiIcons.homeModern;
      case 'Food': return MdiIcons.food;
      default: return MdiIcons.square;
    }
  }
}
