import 'package:flutter/material.dart';
import '../../model/category_model.dart';

class CategoryDetailProvider extends ChangeNotifier {
  final Data category;

  CategoryDetailProvider(this.category);

  /// 🔥 SUBCATEGORIES FROM API
  List<Subcategories> get subcategories =>
      category.subcategories ?? [];
}
