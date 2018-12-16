import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fud/Event.dart';

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
    /*
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return EventDetailsPage();
        }
      )
    );*/
  }
}


class EventDetailsPage extends StatelessWidget {
  final Event event;

  EventDetailsPage({Key key, @required this.event}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event Details')),
      body: _buildBody(context),

    );
  }

  Widget _buildBody(BuildContext context){
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(80.0),
            ),
            rowBuild("Title", event.name),
            Divider(height: 32),

            rowBuild("Food Type", event.cuisineType),
            Divider(height: 32,),

            rowBuild("Price", "\$" + event.price.toString()),
            Divider(height: 32,),

          ],

        )

    );
  }

  Widget rowBuild(String label, String field){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("$label: ", style: TextStyle(fontSize: 32),),
        Text(field, style: TextStyle(fontSize: 32, color: Colors.orange),)
      ],
    );
  }

  Widget descriptionBuild(String field){

  }


}

/*
class EventDetailsPage extends StatefulWidget {
  @override
  _EventDetailsState createState() {
    return _EventDetailsState();
  }
}

class _EventDetailsState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event Details')),
      body: _buildBody(context),

    );
  }

  Widget _buildBody(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Title: ", style: TextStyle(fontSize: 32),)
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Cuisine Type:", style: TextStyle(fontSize: 32),)
            ],
          ),
        ],

      )

    );
  }


}*/

