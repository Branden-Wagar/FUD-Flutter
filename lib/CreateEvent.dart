import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fud/Event.dart';


class CreateEventPage extends StatefulWidget {
  Event event;
  final FirebaseUser currUser;
  CreateEventPage({Key key, @required this.currUser}) : super(key:key);
  @override
  State<StatefulWidget> createState() => new CreateEventState(currUser: currUser);
}

class CreateEventState extends State<CreateEventPage> {

  CreateEventState({Key key, @required this.currUser}){
    foodTypes = foodTypesToMenuItems();
    //foodTypesToMenuItems().then((val) => foodTypes = val);
  }
  final FirebaseUser currUser;
  final eventTitle = TextEditingController();
  //final cuisineType = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final userNameController = TextEditingController();
  List<DropdownMenuItem<String>> foodTypes;
  String selectedFoodType;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Event')),
      body: _buildBody(),
    );
  }


  Widget _buildBody(){
    if (currUser == null){
      userNameController.text = "Anonymous";
    }
    else{
      userNameController.text = currUser.displayName;
    }
    return ListView(
      children: <Widget>[
        
        Padding(
          padding: EdgeInsets.all(32),
        ),
        TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter Event Title",
            hasFloatingPlaceholder: false,
          ),
          maxLength: 30,
          style: TextStyle(fontSize: 20, color: Colors.orangeAccent),
          controller: eventTitle,
          keyboardType: TextInputType.text,
        ),
        Divider(height: 8,),
        Container(
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DropdownButton<String>(
                  items: foodTypes,
                  value: selectedFoodType,
                  hint: Text("Enter Food Type"),
                  onChanged: (val) {
                    setState(() {
                      selectedFoodType = val;
                    });
                  },
                  style: TextStyle(fontSize: 20, color:Colors.orangeAccent),
                  isExpanded: false,
                  isDense: false,

                ),
              ],
            ),
          ),
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
        Divider(height: 16,),

        CupertinoButton(
          child: Text("Create", style: TextStyle(fontSize: 30, color: Colors.orangeAccent),),
          onPressed: () => submitEvent(),
          color: Colors.lightBlue,
        ),
        IconButton(
          icon: Icon(Icons.create, size: 50,),
          onPressed: () => submitEvent(),
          color: Colors.lightBlue,
          splashColor: Colors.grey,
        ),
        Divider(height: 16,),
        TextField(
          textAlign: TextAlign.center,
          enabled: false,
          controller: userNameController,

        )

      ],
    );
  }


  void submitEvent(){
        Firestore.instance.collection("events").document(eventTitle.text).setData({
          'eventName' : eventTitle.text,
          'description' : description.text,
          'cuisineType' : selectedFoodType,
          'price' : double.parse(price.text),
          'date' : DateTime.now()
        });
        Navigator.pop(context);
  }

  List<DropdownMenuItem<String>> foodTypesToMenuItems() {
    List<String> types = ['Chinese', 'American', 'Italian', 'Pizza', 'Desserts', 'BBQ', 'Mexican', 'Halal', 'Candy'];
    List<DropdownMenuItem<String>> toReturn = new List<DropdownMenuItem<String>>();
    types.forEach((type) => toReturn.add(new DropdownMenuItem(child: Text(type,), value: type,)));
    return toReturn;
  }

}
