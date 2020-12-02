import 'package:flutter/material.dart';

class FavouriteList extends StatefulWidget {
  @override
  _FavouriteListState createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Favoritos Richard')),
        body: Center(
          child: Text('You have pressed the button 10 times.'),
        ));
  }
}
