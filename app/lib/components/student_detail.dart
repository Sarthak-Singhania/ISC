import 'package:flutter/material.dart';

class StudentDetail extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final index;
  StudentDetail({required this.title,required this.controller,required this.index});
  late bool nameField;
  


  @override
  Widget build(BuildContext context) {
    if(index%2==0){
    nameField=true;
  }
   else{
    nameField=false;
   }
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        keyboardType: nameField? TextInputType.name:TextInputType.emailAddress,
        validator: nameField?(value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Your Name");
                        }
                        if (!RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$").hasMatch(value)) {
                          return ("Please Enter a valid name");
                        }
                        return null;
                      }:(value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Your Email");
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Please Enter a valid email");
                        }
                        return null;
                      },
        decoration: InputDecoration(
          labelText: title,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue, width: 3.0),
          ),
        ),
        onSaved: (value) {
          controller.text = value!;
        },
      ),
    );
  }
}