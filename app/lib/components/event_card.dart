import 'package:flutter/material.dart';
import 'package:isc/screens/time_slot.dart';
import 'package:transparent_image/transparent_image.dart';

class EventCard extends StatelessWidget {
  String title;
  String uri;
  EventCard({required this.title, required this.uri});
  static String game = '';
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        game = title;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return TimeSlot();
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
                image:uri,
                placeholder: kTransparentImage,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
