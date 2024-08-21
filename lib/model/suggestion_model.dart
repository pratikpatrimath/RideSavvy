class SuggestionModel {
  late String? description;
  late String? placeId;

  SuggestionModel({this.placeId, this.description});

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
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
