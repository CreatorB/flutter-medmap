class Specification {
  final int id;
  final String name;
  final String value;

  Specification({required this.id, required this.name, required this.value});

  factory Specification.fromJson(Map<String, dynamic> json) {
    return Specification(
      id: json['id'],
      name: json['name'],
      value: json['value'],
    );
  }
}
