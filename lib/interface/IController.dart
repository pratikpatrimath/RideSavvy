abstract class IController {
  Future<int> insert({
    required Map<String, dynamic> entity,
    required String tableName,
    required bool isCheckForDuplicate,
  });

  Future<int> update({
    required Map<String, dynamic> entity,
    required String id,
    required String tableName,
    required String colNameForWhereCondition,
  });

  Future<int> delete({
    required String colName,
    required String value,
    required String tableName,
  });

  Future<List<Map<String, dynamic>>> getAll({
    required String tableName,
  });

  Future<List<Map<String, dynamic>>> getByParam({
    required String tableName,
    String? colName,
    String? value,
    String? whereClause,
  });
}
