import 'package:flutter/material.dart';
import 'package:isc/constants.dart';

class BookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('BOOKINGS'),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          children: [
            PendingBooking(size: size),
            ConfirmBooking(size: size),
            ConfirmBooking(size: size),
            ConfirmBooking(size: size),
            ConfirmBooking(size: size),
            //PendingBooking(size:size),
          ],
        ),
      ),
    );
  }
}

class ConfirmBooking extends StatelessWidget {
  Future<void> showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Do you want to cancel the booking'),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                print('Confirmed');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  const ConfirmBooking({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.only(right: 10, left: 10),
      height: size.height * 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Text(
          //   "CONFIRMED",
          //   style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Booking Id: 9999999",
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                "Date: 69/68/1969",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Text(
            "Khoko",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
                fontSize: 17),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Kejru + 69 others",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                    fontSize: 17),
              ),
              GestureDetector(
                onTap: () {
                  showMyDialog(context);
                },
                child: Container(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      width: size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: kPrimaryLightColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 2.0), //(x,y)
            blurRadius: 10.0,
          ),
        ],
      ),
    );
  }
}

class PendingBooking extends StatelessWidget {
  Future<void> showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Do you want to cancel the booking'),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                print('Confirmed');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  const PendingBooking({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.only(right: 10, left: 10),
      height: size.height * 0.17,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "PENDING",
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Booking Id: 9999999",
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                "Date: 69/68/1969",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Text(
            "Khoko",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
                fontSize: 17),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Kejru + 69 others",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                    fontSize: 17),
              ),
              Spacer(flex: 6),
              GestureDetector(
                child: Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                ),
              ),
              Spacer(),
              GestureDetector(
                child: Icon(Icons.check_circle_outline, color: Colors.green),
              )
            ],
          )
        ],
      ),
      width: size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: kPrimaryLightColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 2.0), //(x,y)
            blurRadius: 10.0,
          ),
        ],
      ),
    );
  }
}
