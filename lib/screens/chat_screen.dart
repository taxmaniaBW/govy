import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/utils/language.dart';
import 'package:flutter_dialogflow/v2/auth_google.dart';
import 'package:flutter_dialogflow/v2/dialogflow_v2.dart';
import 'package:govy/consttants.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  TextEditingController messageSendController = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Icon(
            Icons.arrow_back,
            color: colorPrimary,
          ),
          title: Text(
            "Chat with Govy",
            style: TextStyle(
                fontFamily: 'Avenir',
                color: colorPrimary,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: Container()),
            Container(
                height: 80,
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  decoration: BoxDecoration(
                      border: Border.all(color: colorPrimary),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: messageSendController,
                          decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Send Message"),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: colorPrimary,
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                ))
          ],
        ),
      );

  void chat(query) async {
    AuthGoogle authGoogle = await AuthGoogle(
            fileJson: "assets/angular-rhythm-302109-349dd6c953df.json")
        .build();
    Dialogflow dialogFlow =
        Dialogflow(authGoogle: authGoogle, language: Language.ENGLISH);
    AIResponse response = await dialogFlow.detectIntent(query);
  }
}
