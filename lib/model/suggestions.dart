class Suggestion {
  late String? description;
  late String? placeId;

  Suggestion({this.placeId, this.description});

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      placeId: json["place_id"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (placeId != null) {
      data["place_id"] = placeId;
    }
    if (description != null) {
      data["description"] = description;
    }
    return data;
  }
}
