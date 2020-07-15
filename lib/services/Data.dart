import 'dart:async';
import 'package:crud_materias/models/Model.dart';
import 'package:sqflite/sqflite.dart';

abstract class Data {

    static Database _db;

    static int get _version => 1;

    static Future<void> init() async {

        if (_db != null) { return; }

        try {
            String _path = await getDatabasesPath() + 'database';
            _db = await openDatabase(_path, version: _version, onCreate: onCreate);
        }
        catch(ex) { 
            print(ex);
        }
    }

    static void onCreate(Database db, int version) async =>
        await db.execute('CREATE TABLE tblMaterias (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nombre STRING, profesor STRING, ' + 
          'cuatrimestre STRING, horario STRING)');

    static Future<List<Map<String, dynamic>>> query(String table) async => _db.query(table);

    static Future<int> insert(String table, Model model) async =>
        await _db.insert(table, model.toMap());
    
    static Future<int> update(String table, Model model) async =>
        await _db.update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

    static Future<int> delete(String table, Model model) async =>
        await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);

    static Future<void> dropTable(String table) async {
      await _db.execute('DROP TABLE IF EXIST $table' );
      await _db.execute('CREATE TABLE tblMaterias (id INTEGER PRIMARY KEY NOT NULL, nombre STRING, profesor STRING, ' + 
        'cuatrimestre STRING, horario STRING)');

    }
}