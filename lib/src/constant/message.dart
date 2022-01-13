String getUserError(String msg) {
  try {
    String key = msg.split("\"")[1];
    switch (key) {
      case "user_mobile_key":
        return "Mobile Number Already Exist";
        break;
      case "user_email_key":
        return "Email ID Already Exist";
        break;
      case "gps_imei_key":
        return "GPS IMEI Already Exist";
        break;
      default:
        return msg;
    }
  } catch (e) {
    return msg;
  }
}
