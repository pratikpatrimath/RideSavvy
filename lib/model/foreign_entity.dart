class ForeignEntity {
  String? tableName, parentId;
  Map<String, dynamic>? entity;

  ForeignEntity({
    required this.tableName,
    required this.parentId,
    required this.entity,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["tableName"] = tableName;
    data["entity"] = entity;
    data["parentId"] = parentId;
    return data;
  }

  ForeignEntity.fromMap(Map<String, dynamic>? data) {
    tableName = data?['tableName'];
    entity = data?['entity'];
    parentId = data?['parentId'];
  }
}
