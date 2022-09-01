import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../user-info.dart';

class NotificationProvider extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  Future<void> getNotification() async {
    var notificationResponse = await http.get(
        Uri.parse(kIpAddress + '/pending/${StudentInfo.emailId}'),
        headers: {"x-access-token": StudentInfo.jwtToken});
    var notificationJsonData = await jsonDecode(notificationResponse.body);
    _count = notificationJsonData["message"].length;
    notifyListeners();
  }
}
