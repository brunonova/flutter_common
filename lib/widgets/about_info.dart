// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../extensions/build_context.dart';
import '../utils/app.dart';

/// Generic widget to show the content for the about page.
class AboutInfo extends StatelessWidget {
  const AboutInfo({
    super.key,
    this.appIconAssetPath = "assets/images/app_icon.png",
    this.appIconSize = 96,
    this.licenseAssetPath = "assets/license.txt",
    required this.authors,
  });

  /// Path to the asset of the icon of the application.
  final String appIconAssetPath;

  /// Size of the icon of the application.
  final double appIconSize;

  /// Path to the asset of the license file.
  final String licenseAssetPath;

  /// Name of the author or authors.
  final List<String> authors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(appIconAssetPath),
                  width: appIconSize,
                  height: appIconSize,
                ),
                const SizedBox(height: 20),
                const Text(
                  "appName",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ).tr(),
                Text("${'aboutInfo.version'.tr()}: ${App.packageInfo.version}"),
                const SizedBox(height: 10),
                Text("${'aboutInfo.developed_by'.tr()}:"),
                Column(
                  children: [for (var author in authors) Text(author)],
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => _showLicense(context),
                  child: const Text("aboutInfo.license").tr(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// Show the license dialog.
  Future<void> _showLicense(BuildContext context) async {
    context.showMessageDialog(
      await context.assetBundle.loadString(licenseAssetPath),
      title: "appName".tr(),
    );
  }
}
