import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppAssetImage extends StatefulWidget {
  final String? path;
  final String? package;
  final double? height, width, scale;
  AppAssetImage(this.path, {this.package, this.height, this.width, this.scale});

  @override
  _AppAssetImageState createState() => _AppAssetImageState();
}

class _AppAssetImageState extends State<AppAssetImage> {
  bool _verified = false;
  String? _package = null;
  @override
  void initState() {
    super.initState();
    if (this.widget.package != null) {
      getPackage();
    } else {
      _verified = true;
      _package = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_verified)
        ? Image.asset(
            widget.path!,
            package: _package,
            height: this.widget.height,
            width: this.widget.width,
            scale: this.widget.scale,
          )
        : Column();
  }

  getPackage() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    print(info.toString());
    setState(() {
      _verified = true;
      _package =
          info.appName != this.widget.package ? this.widget.package : null;
    });
  }
}
