import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:rainbow/src/constant/constants.dart' as constants;
import 'package:rainbow/src/screens/login/login_page.dart';
import 'package:rainbow/src/widget/action_dialog.dart';

import '../../../rainbow.dart';

abstract class LoginRepository {
  Future<dynamic> fetchToken(username, password);
  Future<dynamic> refreshToken();
  Future<dynamic> requestResetPassword(username);
  Future<dynamic> resetPassword(username, otp, newPassword);
}

class LoginApiCall extends LoginRepository {
  BuildContext context;
  LoginApiCall(this.context);

  @override
  Future<dynamic> fetchToken(username, password) async {
    var config = AppConfig.of(context);
    var mode = (config!.preferences.getServerCode(constants.SERVER_CODE) ==
            constants.TEST_CODE)
        ? AppConfig.MODE_TEST
        : AppConfig.MODE_PRODUCTION;

    String url = config.getBaseUrl(mode) + 'auth/auth/get-token';
    var resBody = {
      'username': username,
      'password': password,
      'portal': config.portal,
    };
    var _body = json.encode(resBody);

    Map<String, String> _headers = {
      "Content-Type": "application/json",
      'user-agent': config.getBrowser().browserAgent.toString()
    };

    final response = await http
        .post(Uri.parse(url), body: _body, headers: _headers)
        .timeout(Duration(minutes: 1),
            onTimeout: () =>
                http.Response({"status": "Request Timeout"}.toString(), 408));

    var tokenObj = json.decode(response.body);
    if (tokenObj["token"] != null) {
      config.preferences.updateToken(tokenObj['token']);
    }
    return response;
  }

  @override
  Future requestResetPassword(username) async {
    var config = AppConfig.of(context);
    var mode = (config!.preferences.getServerCode(constants.SERVER_CODE) ==
            constants.TEST_CODE)
        ? AppConfig.MODE_TEST
        : AppConfig.MODE_PRODUCTION;

    String url = config.getBaseUrl(mode) + 'auth/auth/request-reset-password';
    var _body = json.encode({
      'username': username,
      'portal': config.portal,
    });
    Map<String, String> _headers = {
      "Content-Type": "application/json",
      'user-agent': config.getBrowser().browserAgent.toString()
    };
    final response = await http
        .post(Uri.parse(url), body: _body, headers: _headers)
        .timeout(Duration(minutes: 1),
            onTimeout: () =>
                http.Response({"status": "Request Timeout"}.toString(), 408));
    return response;
  }

  @override
  Future resetPassword(username, otp, newPassword) async {
    var config = AppConfig.of(context);
    var mode = (config!.preferences.getServerCode(constants.SERVER_CODE) ==
            constants.TEST_CODE)
        ? AppConfig.MODE_TEST
        : AppConfig.MODE_PRODUCTION;

    String url = config.getBaseUrl(mode) + 'auth/auth/reset-password';
    var resBody = {
      'username': username,
      'new_password': newPassword,
      'portal': config.portal,
      'otp': otp,
    };
    var _body = json.encode(resBody);
    Map<String, String> _headers = {
      "Content-Type": "application/json",
      'user-agent': config.getBrowser().browserAgent.toString()
    };
    final response = await http
        .post(Uri.parse(url), body: _body, headers: _headers)
        .timeout(Duration(minutes: 1),
            onTimeout: () =>
                http.Response({"status": "Request Timeout"}.toString(), 408));
    return response;
  }

  @override
  Future<dynamic> refreshToken() async {
    var config = AppConfig.of(context);

    var mode = (config!.preferences.getServerCode(constants.SERVER_CODE) ==
            constants.TEST_CODE)
        ? AppConfig.MODE_TEST
        : AppConfig.MODE_PRODUCTION;
    String url = config.getBaseUrl(mode) + 'auth/auth/refresh-token';
    var apiToken = config.preferences.getString(constants.TOKEN);
    if (apiToken != null && apiToken.length == 0) {
      var resBody = {
        'token': apiToken,
        'portal': config.portal,
      };
      var _body = json.encode(resBody);
      Map<String, String> _headers = {
        "Content-Type": "application/json",
        'user-agent': config.getBrowser().browserAgent.toString()
      };
      dynamic response =
          await http.post(Uri.parse(url), body: _body, headers: _headers);
      var tokenObj = json.decode(response.body);
      if (tokenObj["token"] == null) {
        ActionDialog(context, tokenObj["status"], negBTtxt: "", posBTtxt: "OK",
            clickOnPositive: () {
          config.preferences.clear();
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        }).show();
        return null;
      } else {
        config.preferences.updateToken(tokenObj['token']);
        return response;
      }
    }
    return null;
  }
}
