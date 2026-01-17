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
        data!.add(new GetAllCategoriesModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
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
        subcategories!.add(new Subcategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['icon'] = this.icon;
    data['parent_id'] = this.parentId;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.subcategories != null) {
      data['subcategories'] =
          this.subcategories!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['icon'] = this.icon;
    data['parent_id'] = this.parentId;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
