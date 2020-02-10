import 'package:news/src/models/item_model.dart';

abstract class Cachce {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}