class Category {
  final String id;
  final String name;
  final String icon;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });
}

class LearningMaterial {
  final String id;
  final String categoryId;
  final String title;
  final String description;
  final String content;
  final String category;
  bool isCompleted;
  bool hasQuizCompleted;

  LearningMaterial({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    this.isCompleted = false,
    this.hasQuizCompleted = false,
  });
} 