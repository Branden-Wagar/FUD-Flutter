import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fud/CreateEvent.dart';
import 'package:fud/Event.dart';
import 'package:fud/EventDetailsPage.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fud',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Events')),
      body: _buildBody(context),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.menu), title: Text('Options')),
          BottomNavigationBarItem(icon: Icon(Icons.create), title: Text('Create Event')),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('Settings')),
        ],
        onTap: (int i) => CreateEvent(i),
      ),
    );
  }

  
  void CreateEvent(int i){
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (BuildContext context){
        return CreateEventPage();
      })
    );
  }
  
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('events').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final event = Event.fromSnapshot(data);

    return Padding(
      key: ValueKey(event.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(event.name),
          subtitle: Text(event.description.toString()),
          trailing: Text("Price: \$" + event.price.toString()),
          onTap: () => viewEvent(event),
        ),
      ),
    );
  }


  void viewEvent(Event event){
    Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsPage(event: event)));

  }
}

