class CategoryModel {
  bool? success;
  String? message;
  List<CategoryData>? data;
  String? timeTaps;

  CategoryModel({this.success, this.message, this.data, this.timeTaps});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null
          ? (json['data'] as List)
                .map((element) => CategoryData.fromJson(element))
                .toList()
          : [],
      timeTaps: json['timeStamp'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": data?.map((element) => element.toJson()).toList(),
      "timeStamp": timeTaps,
    };
  }
}

class CategoryData {
  int? categoryId;
  String? name;
  String? image;
  String? color;

  CategoryData({this.categoryId, this.name, this.image, this.color});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      categoryId: json['catId'] ?? 0,
      name: json['name'] ?? "",
      image: json['image'] ?? "",
      color: json['color'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"catId": categoryId, "name": name, "image": image, "color": color};
  }
}
