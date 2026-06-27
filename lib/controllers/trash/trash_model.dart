class TrashModel {
  bool? success;
  String? message;
  List<TrashData>? data;
  String? timeStamp;

  TrashModel({this.data, this.message, this.success, this.timeStamp});

  factory TrashModel.fromJson(Map<String, dynamic> json) {
    return TrashModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null
          ? (json['data'] as List)
                .map((element) => TrashData.fromJson(element))
                .toList()
          : [],
      timeStamp: json['timeStamp'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": data?.map((element) => element.toJson()).toList(),
      "timeStamp": timeStamp,
    };
  }
}

class TrashData {
  int? trashId;
  double? trashAmount;
  String? trashDescription;
  String? trashDate;
  String? trashTime;
  TrashCategory? trashCategory;

  TrashData({
    this.trashAmount,
    this.trashCategory,
    this.trashDate,
    this.trashDescription,
    this.trashId,
    this.trashTime,
  });

  factory TrashData.fromJson(Map<String, dynamic> json) {
    return TrashData(
      trashId: json['trashId'] ?? 0,
      trashAmount: (json['trashAmount'] as num?)?.toDouble() ?? 0.0,
      trashDescription: json['trashDescription'] ?? "",
      trashDate: json['trashDate'] ?? "",
      trashTime: json['trashTime'] ?? "",
      trashCategory: json['trashCategory'] != null
          ? TrashCategory.fromJson(json['trashCategory'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "trashId": trashId,
      "trashAmount": trashAmount,
      "trashCategory": trashCategory?.toJson(),
      "trashDate": trashDate,
      "trashDescription": trashDescription,
      "trashTime": trashTime,
    };
  }
}

class TrashCategory {
  int? catId;
  String? categoryName;
  String? image;

  TrashCategory({this.catId, this.categoryName, this.image});

  factory TrashCategory.fromJson(Map<String, dynamic> json) {
    return TrashCategory(
      catId: json['catId'] ?? 0,
      categoryName: json['name'] ?? "",
      image: json['image'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"catId": catId, "name": categoryName, "image": image};
  }
}
