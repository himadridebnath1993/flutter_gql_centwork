import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rainbow/src/data/preference/preference.dart';
import 'package:rainbow/src/screens/login/login_page.dart';
import 'package:rainbow/src/widget/action_dialog.dart';

exitAlert(context) {
  ActionDialog(
    context,
    "Exit from this Application?",
    posBTtxt: "Yes",
    negBTtxt: "No",
    clickOnPositive: () {
      do {
        Navigator.of(context).pop();
      } while (Navigator.of(context).canPop());
      SystemNavigator.pop();
      // MinimizeApp.minimizeApp();
    },
  ).show();
}

logoutAlert(context) {
  ActionDialog(
    context,
    "Logout ? \n\nLogin with different user?",
    posBTtxt: "Yes",
    negBTtxt: "No",
    clickOnPositive: () {
      // ignore: sdk_version_set_literal
      Preference.getInstance().then((pref) => {pref.clear()});
      do {
        Navigator.of(context).pop();
      } while (Navigator.of(context).canPop());
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    },
  ).show();
}

changePassword(context) {
//  Navigator.of(context).push(CreateRouteBottom(ForgotPasswordPage()));
}
