class Setting {
  String name;
  String value;

  Setting({required this.name, required this.value});

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      name: json['Nome'],
      value: json['Valore'],
    );
  }
}
