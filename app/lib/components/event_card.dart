import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:isc/screens/time_slot.dart';
import 'package:transparent_image/transparent_image.dart';

class EventCard extends StatefulWidget {
  String title;
  String uri;
  bool checkAdmin;
  
  EventCard({required this.checkAdmin, required this.title, required this.uri});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  double opacity = 0.5;
  //String game = '';

  double spreadRadius = 5;

  double blurRadius = 7;

  @override
  Widget build(BuildContext context) {
    return widget.checkAdmin == true
        ? FocusedMenuHolder(
            blurSize: 0,
            menuWidth: MediaQuery.of(context).size.width * 0.50,
            blurBackgroundColor: Colors.black12,
            onPressed: () {},
            menuItems: <FocusedMenuItem>[
              FocusedMenuItem(
                  title: Text(
                    "Enable",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                  trailingIcon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
              FocusedMenuItem(
                  title: Text(
                    "Disable",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.redAccent,
                  trailingIcon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      opacity = 0.9;
                      spreadRadius = 0;
                      blurRadius = 0;
                    });
                  }),
            ],
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(opacity),
                    spreadRadius: spreadRadius,
                    blurRadius: blurRadius,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: FadeInImage.memoryNetwork(
                      image: widget.uri,
                      placeholder: kTransparentImage,
                    ),
                  ),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )
                ],
              ),
            ),
          )
        :
         GestureDetector(
            onTap: () {
             
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return TimeSlot(game: widget.title);
                }),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 17), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: FadeInImage.memoryNetwork(
                      image: widget.uri,
                      placeholder: kTransparentImage,
                    ),
                  ),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )
                ],
              ),
            ),
          );
  }
}
