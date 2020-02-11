import 'package:news/src/models/item_model.dart';
import 'package:news/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class CommentsBloc {
  final _commentsFetcher = BehaviorSubject<int>();
  final _commentsOutput = PublishSubject<Map<int, Future<ItemModel>>>();
  final _repository = Repository();
  //getter to fetch the data from streams
  Observable<Map<int, Future<ItemModel>>> get getItemWithComments => _commentsOutput.stream;

  //getter to sink
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    _commentsFetcher.stream.transform(_commentTransformer()).pipe(_commentsOutput);
  }

  _commentTransformer() {
    //input int and output map of ItemModel
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, int id, index) {
        print(index);
        cache[id] = _repository.fetchItem(id);
        cache[id].then((ItemModel item) => {
          item.kids.forEach((eachKid) {
            return fetchItemWithComments(eachKid);
          })
        });
        return cache;
      },
      <int, Future<ItemModel>> {}
    );
  }

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}