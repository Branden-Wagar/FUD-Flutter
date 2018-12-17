import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fud/CreateEvent.dart';
import 'package:fud/Event.dart';
import 'package:fud/EventDetailsPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser currUser;




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
          BottomNavigationBarItem(icon: Icon(Icons.menu), title: Text('Sign In')),
          BottomNavigationBarItem(icon: Icon(Icons.create), title: Text('Create Event')),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('Settings')),
        ],
        onTap: (int i) => BottomNavBarController(i),
      ),
      backgroundColor: Colors.white,
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
          border: Border.all(color: Colors.lightBlue),
          borderRadius: BorderRadius.circular(5.0),
          gradient: LinearGradient(begin: Alignment(-.4, 0), end: Alignment.topRight, colors: [Colors.blue, Colors.orangeAccent])
        ),
        child: ListTile(
          title: Text(event.name, style: TextStyle(fontSize: 20, color: Colors.orangeAccent),),
          subtitle: Text(event.description.toString(), style: TextStyle(fontSize: 16, color: Colors.white),),
          trailing: Text("\$" + event.price.toString(), style: TextStyle(fontSize: 28, color: Colors.black),),
          onTap: () => viewEvent(event),
        ),
      ),
    );
  }


  void viewEvent(Event event){
    Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsPage(event: event)));

  }


  void BottomNavBarController(int i){

    if (i == 0){
      _handleSignIn().then((FirebaseUser user) => currUser = user)
          .catchError((e) => print(e));

    }
    // button index 1 is createEvent
    if (i == 1){
      Navigator.of(context).push(
          new MaterialPageRoute(builder: (BuildContext context){
            return CreateEventPage(currUser: currUser,);
          })
      );
    }

  }


  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("signed in " + user.displayName);
    return user;
  }

}

