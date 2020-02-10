import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Column(
     children: [
       ListTile(
         title: contentLoader(),
         subtitle: contentLoader()
       ),
       Divider(height: 7.0)
     ]
   );
  }

  Widget contentLoader() {
    return Container(
      color: Colors.grey[200],
      height: 24.0,
      width: 150.0,
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
    );
  }

}