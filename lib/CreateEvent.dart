import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fud/Event.dart';


class CreateEventPage extends StatefulWidget {
  Event event;



  @override
  State<StatefulWidget> createState() => new CreateEventState();
}

class CreateEventState extends State<CreateEventPage> {

  final eventTitle = TextEditingController();
  final cuisineType = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Event')),
      body: _buildBody(),
    );
  }


  Widget _buildBody(){
    return Column(
      children: <Widget>[
        
        Padding(
          padding: EdgeInsets.all(32),
        ),
        TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter Event Title",
          ),
          maxLength: 30,
          style: TextStyle(fontSize: 20, color: Colors.orangeAccent),
          controller: eventTitle,
          keyboardType: TextInputType.text,
        ),
        Divider(height: 8,),

        TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter Cuisine Type",

          ),
          maxLength: 15,
          style: TextStyle(fontSize: 20, color: Colors.orangeAccent),
          controller: cuisineType,
          keyboardType: TextInputType.text,
        ),
        Divider(height: 8,),

        TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Description",
          ),
          maxLength: 75,
          style: TextStyle(fontSize: 20, color: Colors.orangeAccent),
          controller: description,
          keyboardType: TextInputType.multiline,
        ),
        Divider(height: 8,),

        TextFormField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Price",
            prefixText: "\$"
          ),
          style: TextStyle(fontSize: 20, color: Colors.orangeAccent),
          keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
          keyboardAppearance: Brightness.dark,
          controller: price,
        ),
        Divider(height: 8,),

        CupertinoButton(
          child: Text("Create"),
          onPressed: () => submitEvent() /*{
            return showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Text(eventTitle.text),
                  content: Text(description.text),
                );
              }
            );
          },*/
        )
      ],
    );
  }

  void submitEvent(){
        Firestore.instance.collection("events").document(eventTitle.text).setData({
          'eventName' : eventTitle.text,
          'description' : description.text,
          'cuisineType' : cuisineType.text,
          'price' : double.parse(price.text),
          'date' : DateTime.now()
        });
  }

}
