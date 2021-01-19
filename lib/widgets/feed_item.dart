import 'package:flutter/material.dart';

class FeedItem extends StatefulWidget {
  final String feedImage;
  final String title;
  final String time;

  FeedItem({this.title, this.feedImage, this.time});

  @override
  _FeedItemState createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.all(12),
        child: Card(
          child: Column(
            children: <Widget>[
              Image.asset(
                widget.feedImage,
                fit: BoxFit.cover,
                //height: 200,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title,
                  style: TextStyle(
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.grey.shade700),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "23 mins ago",
                    style: TextStyle(fontFamily: 'Avenir'),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
