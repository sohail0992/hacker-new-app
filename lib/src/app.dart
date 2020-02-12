import 'package:flutter/material.dart';
import 'package:news/src/screens/news_list.dart';
import 'blocs/comments_provider.dart';
import 'blocs/stories_provider.dart';
import 'screens/news_detail.dart';

class App extends StatelessWidget {

  Widget build(context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'Hacker News',
          onGenerateRoute: (RouteSettings routeSettings) {
            return routes(routeSettings);
          },
        ),
      ),
    );

  }

  routes(RouteSettings settings) {
    if(settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          final storiesBloc = StoriesProvider.of(context);
          storiesBloc.fetchTopIds();
          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          final commentsBloc = CommentsProvider.of(context);
          final itemId = int.parse(settings.name.replaceFirst('/',''));
          commentsBloc.fetchItemWithComments(itemId);
          return NewsDetail(
            itemId: itemId,
          );
        },
      );
    }
  }
}