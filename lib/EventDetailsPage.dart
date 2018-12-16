
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fud/Event.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  EventDetailsPage({Key key, @required this.event}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event Details')),
      body: _buildBody(context),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(icon: Icon(Icons.navigation), title: Text('Navigate')),
          BottomNavigationBarItem(icon: Icon(Icons.report), title: Text('Report Event')),
        ],
      ),

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

            descriptionBuild(event.description),
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
    return Text(
      field, style: TextStyle(fontSize: 32, color: Colors.orange),
    );
  }


}

