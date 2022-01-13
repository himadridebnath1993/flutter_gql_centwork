import 'package:flutter/material.dart';
import 'package:rainbow/src/app.dart';
import 'package:web_browser_detect/web_browser_detect.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'data/preference/preference.dart';
import 'function/jwt.dart';

class AppConfig extends InheritedWidget {
  AppConfig(this.home,
      {this.role = "", String service = '', this.portal})
      : this._service = service,
        super(child: App()) {
    Preference.getInstance().then((value) {
      preferences = value;
    });
  }

  final String role;
  final String? portal;
  final String apiProductionUrl = 'http://www.securinglinks.com/';
  final String apiTestUrl = 'http://test.securinglinks.com/';
  final String apiDevUrl = 'http://localhost/';
  final Widget home;
  final String _service;
  late Browser browser;

  late Preference preferences;

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  Browser getBrowser() {
    try {
      if (browser != null && browser.browser != null) {
        return browser;
      } else {
        browser = Browser.detectOrNull()!;
        return browser;
      }
    } catch (e) {
      browser = Browser.detectFrom(
          userAgent: "Unknown", vendor: "Unknown", appVersion: "Unknown");
      return browser;
    }
  }

  // ignore: non_constant_identifier_names
  static int MODE_TEST = 1;
  // ignore: non_constant_identifier_names
  static int MODE_PRODUCTION = 0;

  String getBaseUrl(int mode) {
    if (Foundation.kDebugMode) {
      return apiDevUrl;
    } else if (MODE_TEST == mode) {
      return apiTestUrl;
    }
    return apiProductionUrl;
  }

  String getAppRole(String? token) {
    if (token == null) {}
    var _role = "";
    if (this.role != null) {
      _role = this.role;
    } else {
      Map<String, dynamic> _jwtData = JWT.parse(token!);
      List roles = _jwtData["roles"];

      if (_service != null) {
        for (dynamic r in roles) {
          if (r["service"] == _service) {
            _role = r["role"];
            break;
          }
        }
      } else {
        if (_jwtData["https://cogostech.com/claims"]["x-hasura-allowed-roles"]
            .contains("adminuser")) {
          _role = "adminuser";
        } else {
          _role = _jwtData["https://cogostech.com/claims"]
              ["x-hasura-allowed-roles"][0];
        }
      }
    }
    return _role;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
