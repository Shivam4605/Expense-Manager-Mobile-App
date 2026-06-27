class TransactionModel {
  bool? success;
  String? message;
  List<DataModel>? data;
  String? timeStamp;

  TransactionModel({this.success, this.message, this.data, this.timeStamp});

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null
          ? (json['data'] as List)
                .map((element) => DataModel.fromJson(element))
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

class DataModel {
  int? expId;
  double? amount;
  String? description;
  String? date;
  String? time;
  CategoryModel? category;

  DataModel({
    this.amount,
    this.date,
    this.description,
    this.expId,
    this.category,
    this.time,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      expId: json['expId'] ?? 0,
      description: json['description'] ?? "",
      date: json['date'] ?? "",
      time: json['time'] ?? "",
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "expId": expId,
      "amount": amount,
      "description": description,
      "date": date,
      "time": time,
      "category": category?.toJson(),
    };
  }
}

class CategoryModel {
  int? catId;
  String? categoryName;
  String? image;
  String? color;

  CategoryModel({this.catId, this.categoryName, this.color, this.image});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      catId: json['catId'] ?? 0,
      categoryName: json['name'] ?? "",
      image: json['image'] ?? "",
      color: json['color'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "catId": catId,
      "name": categoryName,
      "image": image,
      "color": color,
    };
  }
}



// class CategoryRequestModel{

//   String 
// }