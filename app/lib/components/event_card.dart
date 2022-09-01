import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:isc/routes.dart';
import 'package:isc/user-info.dart';
import 'package:transparent_image/transparent_image.dart';

class EventCard extends StatefulWidget {
  final String title;
  final String uri;
  final List info;
  EventCard({required this.title, required this.uri, required this.info});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  double opacity = 0.5;
  bool toggleValue = false;
  double spreadRadius = 5;
  bool value = true;
  double blurRadius = 7;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        StudentInfo.gameChoosen = widget.title;
        StudentInfo.gameChoosenInfo = widget.info;
        Navigator.pushNamed(context, AppRoutes.studentTime);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? Colors.grey.withOpacity(0.5)
                      : Colors.purple.shade500, // purple 500
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 5), // changes position of shadow
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
            AutoSizeText(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? Colors.black
                      : Colors.purple),
            )
          ],
        ),
      ),
    );
  }
}
