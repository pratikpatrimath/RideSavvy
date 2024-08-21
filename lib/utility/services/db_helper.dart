import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../../interface/IController.dart';
import '../../interface/ILoginController.dart';
import '../../model/foreign_entity.dart';
import '../../model/user_master.dart';
import '../constants/string_constants.dart';
import '../helper/common_helper.dart';

class DbHelper<T> extends IController implements ILoginController {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    return await openDatabase(
      StringConstants.databaseName,
      version: StringConstants.databaseVersion,
      onCreate: _onCreate,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  Future<void> _createTables(Database db) async {
    await db.execute(
      "CREATE TABLE IF NOT EXISTS ${StringConstants.tableUserMaster} ("
      "${StringConstants.userId} INTEGER PRIMARY KEY AUTOINCREMENT,"
      "${StringConstants.name} TEXT,"
      "${StringConstants.emailId} TEXT,"
      "${StringConstants.password} TEXT)",
    );
  }

  @override
  Future<int> insert({
    required Map<String, dynamic> entity,
    required String tableName,
    required bool isCheckForDuplicate,
    String? checkWithColumn,
    String? value,
  }) async {
    try {
      final db = await database;

      return await db.transaction<int>((txn) async {
        Map<String, dynamic> entityCopy = Map.from(entity);
        entityCopy.removeWhere((key, value) => value is List);

        final parentId = await txn.insert(
          tableName,
          entityCopy,
          conflictAlgorithm: isCheckForDuplicate
              ? ConflictAlgorithm.replace
              : ConflictAlgorithm.abort,
        );

        if (entity.containsKey('foreign') && entity['foreign'] != null) {
          List<Map<String, dynamic>> foreignMaps;
          foreignMaps = entity['foreign'];
          for (Map<String, dynamic> foreignMap in foreignMaps) {
            ForeignEntity foreign = ForeignEntity.fromMap(foreignMap);
            if (foreign.entity != null && foreign.entity!.isNotEmpty) {
              foreign.entity?[foreign.parentId ?? ""] = parentId;
              await txn.insert(
                foreign.tableName ?? "",
                foreign.entity ?? {},
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          }
        }

        return parentId;
      });
    } catch (e) {
      CommonHelper.printDebugError(e, "DbHelper insert");
      rethrow;
    }
  }

  @override
  Future<int> update({
    required Map<String, dynamic> entity,
    required String id,
    required String tableName,
    required String colNameForWhereCondition,
  }) async {
    int response = -1;
    try {
      final db = await database;
      await db.transaction<int>((txn) async {
        Map<String, dynamic> entityCopy = Map.from(entity);
        entityCopy.removeWhere((key, value) => value is List);

        int updateResponse = await txn.update(
          tableName,
          entityCopy,
          where: '$colNameForWhereCondition = ?',
          whereArgs: [id],
        );

        if (entity.containsKey('foreign') && entity['foreign'] != null) {
          List<Map<String, dynamic>> foreignMaps =
              (entity['foreign'] as List<Map<String, dynamic>>);

          for (Map<String, dynamic> foreignMap in foreignMaps) {
            ForeignEntity foreign = ForeignEntity.fromMap(foreignMap);
            String colName = foreign.parentId ?? "";
            await txn.delete(
              foreign.tableName ?? "",
              where: '$colName = ?',
              whereArgs: [id],
            );
          }

          for (Map<String, dynamic> foreignMap in foreignMaps) {
            ForeignEntity foreign = ForeignEntity.fromMap(foreignMap);
            if (foreign.entity != null && foreign.entity!.isNotEmpty) {
              foreign.entity?[foreign.parentId ?? ""] = id;
              await txn.insert(
                foreign.tableName ?? "",
                foreign.entity ?? {},
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          }
        }

        return response = updateResponse;
      });
    } catch (e) {
      CommonHelper.printDebugError(e, "DbHelper updateMainEntityAndRelated");
      rethrow;
    }

    return response;
  }

  @override
  Future<int> delete({
    required String colName,
    required String value,
    required String tableName,
  }) async {
    try {
      Database db = await database;
      return await db.delete(
        tableName,
        where: '$colName = ?',
        whereArgs: [value],
      );
    } catch (e) {
      CommonHelper.printDebugError(e, "DbHelper delete");
      return -1;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAll({
    required String tableName,
  }) async {
    try {
      Database db = await database;
      return await db.query(tableName);
    } catch (e) {
      CommonHelper.printDebugError(e, "DbHelper getAll");
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getByParam({
    required String tableName,
    String? colName,
    String? value,
    String? whereClause,
  }) async {
    try {
      Database db = await database;
      return await db.query(
        tableName,
        where: whereClause ?? '$colName = ?',
        whereArgs: value == null ? [] : [value],
      );
    } catch (e) {
      CommonHelper.printDebugError(e, "DbHelper getByParam");
      return [];
    }
  }

  @override
  Future<UserMaster?> login({
    required String emailId,
    required String password,
  }) async {
    Database? db = await database;
    List<Map<String, dynamic>> response = await db.query(
      StringConstants.tableUserMaster,
      where: 'emailId = ? AND password= ? ',
      whereArgs: [emailId, password],
    );
    if (response.isNotEmpty) {
      return UserMaster.fromMap(response.first);
    } else {
      throw 'Incorrect Id Or Password';
    }
  }

  @override
  Future<String> register({required UserMaster entity}) async {
    try {
      Database? db = await database;
      List<Map<String, dynamic>> responseList = await getAll(
        tableName: StringConstants.tableUserMaster,
      );
      List<UserMaster> userList = <UserMaster>[];
      userList.assignAll(responseList.map((e) {
        return UserMaster.fromMap(e);
      }).toList());
      for (UserMaster user in userList) {
        if (user.emailId == entity.emailId) {
          return 'Already registered';
        }
      }

      int response = await db.insert(
        StringConstants.tableUserMaster,
        entity.toMap(),
      );
      return response == -1 ? 'Failed' : 'Success';
    } catch (e) {
      CommonHelper.printDebugError(e, "DbHelper line no:313");
    }
    return 'Failed';
  }
}
