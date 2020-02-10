import 'dart:async';
import 'package:news/src/abstract/cache.dart';
import 'package:news/src/abstract/source.dart';

import 'new_db_provider.dart';
import 'news_api_provider.dart';
import '../models/item_model.dart';

class Repository {
  List<Source> sources = <Source> [
    newsDbProvider,
    NewsAPIProvider()
  ];

  List<Cachce> caches = <Cachce> [
    newsDbProvider,
  ];

  Future<List<int>> fetchTopIds() {
    Source source;
    var topIds;
    for(source in sources) {
      topIds = source.fetchTopIds();
      if(topIds != null) {
        break;
      }
    }
    return topIds;
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    var source;
    for(source in sources) {
      item = await source.fetchItem(id);
      if(item != null) {
        break;
      }
    }
    for(var cache in caches) {
      if(cache != source) {
        cache.addItem(item);
      }
    }
    return item;
    //
    // item = await apiProvider.fetchItem(id);
    // dbProvider.addItem(item);
    // return item;
  }

  clearCache() async {
    for(var cache in caches) {
       await cache.clear();
    }
  }

}

final newsDbProvider = new NewsDbProvider();