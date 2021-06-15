// ignore: file_names
class CodeMap {
    String? type;
    List<String>? items;
  CodeMap({required this.type,required this.items});

  factory CodeMap.fromJson(Map<String, dynamic> json) {
    return CodeMap(
      type: json["type"] as String,
      items: json["items"]!= null ? List.from(json["items"]) : null,
    );
  }
}