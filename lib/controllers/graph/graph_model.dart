class GraphModel {
  bool? success;
  String? message;
  List<DataModelClass>? data;
  String? timeStamp;

  GraphModel({this.data, this.message, this.success, this.timeStamp});

  factory GraphModel.fromJson(Map<String, dynamic> json) {
    return GraphModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null
          ? (json['data'] as List)
                .map((element) => DataModelClass.fromJson(element))
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

class DataModelClass {
  String? categoryName;
  double? amount;
  String? categoryColor;

  DataModelClass({this.amount, this.categoryColor, this.categoryName});

  factory DataModelClass.fromJson(Map<String, dynamic> json) {
    return DataModelClass(
      categoryColor: json['catColor'] ?? "",
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      categoryName: json['catName'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "catName": categoryName,
      "amount": amount,
      "catColor": categoryColor,
    };
  }
}
