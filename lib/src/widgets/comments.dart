import 'package:flutter/material.dart';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/widgets/loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  Map<int, Future<ItemModel>> itemMap;
  final int depth;
  Comment({this.itemId,this.itemMap,this.depth});
  Widget build(context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if(!snapshot.hasData) {
          return LoadingContainer();
        }
        final item = snapshot.data;
        final children = <Widget>[
          ListTile(
            title: buildText(item),
            subtitle: item.by == "" ?  Text("Deleted"): Text(item.by),
            contentPadding: EdgeInsets.only(
              right: 16.0,
              left: depth * 16.0
            ),
          ),
          Divider()
        ];
        item.kids.forEach((eachKid) {
          children.add(
            Comment(
              itemId: eachKid,
              itemMap: itemMap,
              depth: depth + 1,
            ),
          );
        });
        return Column(
          children: children
        );
      },
    );
  }

  Widget buildText(ItemModel item) {
    final text = item.text
    .replaceAll('&#x27',"'")
    .replaceAll('<p>','\n\n')
    .replaceAll('</p>','')
    .replaceAll('&gt;','');
    return Text(text);
  }
}