import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:http/http.dart' as http;

var message1 = "output will appear here";
String x;
void main() {
  runApp(MyApp());
}

final databaseReference = Firestore.instance;
void createRecord(message) async {
  await databaseReference
      .collection("date command")
      .document("result")
      .setData({
    'output': message,
  });
}

web(mycmd) async {
  var message;
  try {
    var url = "http://192.168.84.130/cgi-bin/docker.py?x=${mycmd}";
    var result = await http.get(url);

    message = result.body;

    //return message;
  } catch (_) {
    BotToast.showText(text: "Error in server or Incorrect url");
  }
  createRecord(message);
  //print(mycmd);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text("My Linux Terminal"),
            backgroundColor: Colors.red,
          ),
          body: mybody()),
    );
  }
}

class mybody extends StatefulWidget {
  @override
  _mybodyState createState() => _mybodyState();
}

class _mybodyState extends State<mybody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.2,
                child: FittedBox(
                  child: FadeInImage.assetNetwork(
                      placeholder: 'assets/loading.gif',
                      image:
                          "https://blogs.unity3d.com/wp-content/uploads/2019/05/image1-11.png"),
                ),
              ),
              FittedBox(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: FadeInImage.assetNetwork(
                      placeholder: 'assets/loading.gif',
                      image:
                          'https://developers.redhat.com/blog/wp-content/uploads/2019/07/Red-Hat-Integration-Developers.jpg'),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "My Linux CLI ",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            // FocusScope.of(context).requestFocus(new FocusNode());
            onSubmitted: (value) {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            onChanged: (val) {
              x = val;
            },
            autocorrect: false,
            decoration: InputDecoration(
              hintText: "Enter the command Here",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.amber,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
        ),
        MaterialButton(
          color: Colors.greenAccent,
          onPressed: () {
            web(x);
          },
          child: Text('Execute'),
        ),
        Expanded(
          child: Card(
            elevation: 10,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black87,
                  border: Border.all(color: Colors.black)),
              child: StreamBuilder(
                  stream:
                      Firestore.instance.collection('date command').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView(
                      children: snapshot.data.documents.map((document) {
                        return Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: MediaQuery.of(context).size.height / 2,
                            child: SingleChildScrollView(
                              child: Text(
                                "output: " + document['output'],
                                style: TextStyle(
                                    color: Colors.green, fontSize: 15),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }
}
