import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

String getAssetIconUrl(String fileName) {
  return 'assets/icons/$fileName';
}

String getAssetImageUrl(String fileName) {
  return 'assets/images/$fileName';
}

DateTime getLastDateOfMonth(DateTime date) {
  return new DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
}

TimeOfDay parseTimeOfDay(String normTime) {
  if (normTime != null &&
      (normTime.contains("AM") || normTime.contains("PM"))) {
    int hour;
    int minute;
    String ampm = normTime.substring(normTime.length - 2);

    String result = normTime.substring(0, normTime.indexOf(' '));
    if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
      hour = int.parse(result.split(':')[0]);
      if (hour == 12) hour = 0;
      minute = int.parse(result.split(":")[1]);
    } else {
      hour = int.parse(result.split(':')[0]) + 12;
      minute = int.parse(result.split(":")[1]);
    }
    return TimeOfDay(hour: hour, minute: minute);
  } else if (normTime != null && normTime.length > 0) {
    return TimeOfDay(
        hour: int.parse(normTime.split(":")[0]),
        minute: int.parse(normTime.split(":")[1]));
  } else {
    return TimeOfDay(hour: 0, minute: 0);
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(Uint8List data) {
  return base64Encode(data);
}

QueryResult createGraphError(String msg) {
  return QueryResult(
      exception:
          OperationException(graphqlErrors: [GraphQLError(message: msg)]),
      source: null);
}
