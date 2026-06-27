class CategoryModel2 {
  String imageUrl;
  String title;
  String description;
  int amount;

  CategoryModel2({
    required this.amount,
    required this.description,
    required this.imageUrl,
    required this.title,
  });
}

class CategoryModel1 {
  String imageUrl;
  String categoryName;
  String color;
  Map<String, dynamic> user;

  CategoryModel1({
    required this.categoryName,
    required this.imageUrl,
    required this.user,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      "image": imageUrl,
      "name": categoryName,
      "user": user,
      "color": color,
    };
  }
}
