import 'package:govy/model/Feed.dart';

class DummyDB {
  createFeed() async {
    List<Feed> feed = [
      Feed("H.E Mokgweetsi Masisi to address the nation tonight at 2000hrs",
          "assets/images/masisi.jpg", "23 mins"),
      Feed("Hon Thapelo Matsheka to read the budget speech on Monday",
          "assets/images/parliament.jpg", "2 days"),
      Feed("Kazungula bridge opens", "assets/images/bridge_opening.jpg",
          "1 day"),
      Feed("Vote for your favorite front liner",
          "assets/images/bagaka_ba_rona.jpg", "3 days")
    ];
    return feed;
  }
}
