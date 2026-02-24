class GetAllCategoriesModel {
  bool? status;
  String? message;
  List<GetAllCategoriesModelData>? data;

  GetAllCategoriesModel({this.status, this.message, this.data});

  GetAllCategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    if (json['data'] != null) {
      data = <GetAllCategoriesModelData>[];
      json['data'].forEach((v) {
        data!.add(GetAllCategoriesModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetAllCategoriesModelData {
  String? id;
  String? categoryName;
  String? icon;
  String? parentId;
  String? slug;
  String? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  List<Subcategories>? subcategories;

  GetAllCategoriesModelData(
      {this.id,
        this.categoryName,
        this.icon,
        this.parentId,
        this.slug,
        this.status,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.subcategories});

  GetAllCategoriesModelData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    categoryName = json['category_name']?.toString();
    icon = json['icon']?.toString();
    parentId = json['parent_id']?.toString();
    slug = json['slug']?.toString();
    status = json['status']?.toString();
    deletedAt = json['deleted_at']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    if (json['subcategories'] != null) {
      subcategories = <Subcategories>[];
      json['subcategories'].forEach((v) {
        subcategories!.add(Subcategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    data['icon'] = icon;
    data['parent_id'] = parentId;
    data['slug'] = slug;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (subcategories != null) {
      data['subcategories'] =
          subcategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subcategories {
  String? id;
  String? categoryName;
  String? icon;
  String? parentId;
  String? slug;
  String? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Subcategories(
      {this.id,
        this.categoryName,
        this.icon,
        this.parentId,
        this.slug,
        this.status,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  Subcategories.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    categoryName = json['category_name']?.toString();
    icon = json['icon']?.toString();
    parentId = json['parent_id']?.toString();
    slug = json['slug']?.toString();
    status = json['status']?.toString();
    deletedAt = json['deleted_at']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    data['icon'] = icon;
    data['parent_id'] = parentId;
    data['slug'] = slug;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
