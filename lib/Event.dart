import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String name;
  final double price;
  final String description;
  final String cuisineType;
  final DateTime date;
  final DocumentReference reference;

  Event.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['eventName'] != null),
        assert(map['description'] != null),
        assert(map['price'] != null),
        assert(map['cuisineType'] != null),
        assert(map['date'] != null),
        name = map['eventName'],
        price = map['price'],
        cuisineType = map['cuisineType'],
        date = map['date'],
        description = map['description'];

  Event.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Event<$name:$price\n$description>";
}