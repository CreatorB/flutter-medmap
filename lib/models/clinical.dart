class Clinical {
  final int id;
  final String? content;

  Clinical({required this.id, this.content});

  factory Clinical.fromJson(Map<String, dynamic> json) {
    return Clinical(
      id: json['id'],
      content: json['content'],
    );
  }
}
