
import 'package:news/src/models/item_model.dart';
import 'package:news/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class StoriesBloc {
  final _repostory = Repository();
  //stream controller with sink and stream
  //broadcast stream controller it reutrn obserbalbe
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  //getter to get stream
  Observable<List<int>> get topIds => _topIds.stream; 
  //capture latest item and emit 
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;
  //getter to sink
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  StoriesBloc() {
    //transform .pipe automatically transform the _itemsOutput
    _itemsFetcher.stream.transform(_itemTransformer()).pipe(_itemsOutput);
  }

  fetchTopIds() async {
    //get top ids by using repository class and add those ids to the sin
    final ids = await _repostory.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache() {
    return _repostory.clearCache();
  }
  
  _itemTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>>cache, int id,index) {
        cache[id] = _repostory.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{}

    );
  }

  dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
    // _items.close();
  }

}
