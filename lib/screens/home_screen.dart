import 'package:flutter/material.dart';
import 'package:govy/DummyDB.dart';
import 'package:govy/consttants.dart';
import 'package:govy/model/Feed.dart';
import 'package:govy/screens/services.dart';
import 'package:govy/widgets/feed_item.dart';

import 'chat_screen.dart';

class HomePage extends StatefulWidget {
  final String firstName;

  HomePage({this.firstName});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Feed> feedList;
  List<Widget> pages = [
    HomePage(),
    ServicesScreen(),
  ];
  DummyDB dummyDB = DummyDB();
  bool loading = true;
  void getFeed() async {
    feedList = await dummyDB.createFeed();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.all(8),
                child: RichText(
                  text: TextSpan(
                      text: "Welcome ",
                      style: TextStyle(
                          color: colorPrimary.withOpacity(0.5),
                          fontFamily: 'Avenir',
                          fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: widget.firstName,
                            style: TextStyle(
                                fontFamily: 'Avenir',
                                fontWeight: FontWeight.bold,
                                color: colorPrimary,
                                fontSize: 35))
                      ]),
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            floating: true,
            pinned: true,
            delegate: HomeScreenSearchBar(
                homeSearchBar: Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(color: colorPrimary, width: 2)),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.chat,
                      color: colorPrimary,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Start Chat",
                            hintStyle: TextStyle(
                                color: colorPrimary, fontFamily: 'Avenir'),
                            labelStyle: TextStyle(
                              color: colorPrimary,
                              fontFamily: 'Avenir',
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward,
                        color: colorPrimary,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen()));
                      },
                    ),
                  ),
                ],
              ),
            )),
          ),
          SliverFillRemaining(
            child: loading
                ? CircularProgressIndicator(
                    backgroundColor: colorPrimary,
                    strokeWidth: 8,
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: feedList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FeedItem(
                        feedImage: feedList[index].image,
                        title: feedList[index].title,
                        time: feedList[index].time,
                      );
                    }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorPrimary,
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
    );
  }
}

class HomeScreenSearchBar extends SliverPersistentHeaderDelegate {
  final Container homeSearchBar;

  HomeScreenSearchBar({this.homeSearchBar});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return homeSearchBar;
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
