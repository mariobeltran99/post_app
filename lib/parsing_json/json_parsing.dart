import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class JsonParsingSimple extends StatefulWidget {
  const JsonParsingSimple({Key? key}) : super(key: key);

  @override
  _JsonParsingSimpleState createState() => _JsonParsingSimpleState();
}

class _JsonParsingSimpleState extends State<JsonParsingSimple> {
  late Future data;
  @override
  void initState(){
    super.initState();
    data = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSON - Posts'),
      ),
      body: Center(
        child: Container(
          child: FutureBuilder(
            future: getData(),
            builder: (context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                return createListView(snapshot.data,context);
              }
              return CircularProgressIndicator();
            }
          ),
        ),
      ),
    );
  }

  Future getData(){
    var data;
    String url = 'jsonplaceholder.typicode.com';
    Network network = Network(url);
    data = network.fetchData();
    return data;
  }
  Widget createListView(List data, BuildContext context){
    return Container(
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, int index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Divider(height: 5.0),
            ListTile(
              title: Text('${data[index]['title']}'),
              subtitle: Text('${data[index]['body']}'),
              leading: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.black26,
                    radius: 23,
                    child: Text('${data[index]['userId']}'),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }

}

class Network{
  final String url;

  Network(this.url);

  Future fetchData() async {

    var response = await get(Uri.https(url, '/posts'));

    if(response.statusCode == 200){
      return json.decode(response.body);
    }else{
      print(response.statusCode);
    }

  }

}