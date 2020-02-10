import 'dart:io';
import 'package:news/src/abstract/cache.dart';
import 'package:news/src/abstract/source.dart';
import 'package:sqflite/sqflite.dart';
//allow working with filesystem
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../models/item_model.dart';

class NewsDbProvider implements Source,Cachce {
  Database db;

  NewsDbProvider() {
    init();
  }

  void init() async {
    //return refrence to folder on device
    Directory documentDirectory  = await getApplicationDocumentsDirectory();
    //get refrece to actual db
    final path = join(documentDirectory.path,"item.db");
    //BLOB we can store any data we want
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute("""
          CREATE TABLE Items
            (
              id INTEGER PRIMARY KEY,
              type TEXT,
              by TEXT,
              time INTEGER,
              text TEXT,
              parent INTEGER,
              kids BLOB,
              dead INTEGER,
              deleted INTEGER,
              url TEXT,
              score INTEGER,
              title TEXT,
              descendants INTEGER
            )
        """);//oncreate called only for the very first time
      },
    );
  }

  Future<ItemModel> fetchItem(int id) async {
    final maps = await db.query(
      "Items",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );
    if(maps.length > 0) {
      return ItemModel.fromDB(maps.first);
    } 
    return null;
  }

  Future<int> addItem(ItemModel item) {
    return db.insert(
      "Items",
      item.toMapForDB(),
      conflictAlgorithm: ConflictAlgorithm.ignore
    );
  }

  Future<int> clear() {
    return db.delete("Items");
  }

  @override
  Future<List<int>> fetchTopIds() {
    // TODO: implement fetchTopIds
    return null;
  }
}