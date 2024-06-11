class AddFullNameResult {
  final String? name;

  AddFullNameResult(this.name);

  factory AddFullNameResult.fromJson(Map<String, dynamic> json) =>
      AddFullNameResult(json['name']);

  @override
  String toString() => 'AddFullNameResult: {name: $name}';
}
