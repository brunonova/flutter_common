// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../extensions/build_context.dart';
import '../utils/app.dart';

/// Generic widget to show the content for the about page.
class AboutInfo extends StatefulWidget {
  const AboutInfo({
    super.key,
    this.appIconAssetPath,
    this.appIconSize = 96,
    this.licenseAssetPath,
    required this.authors,
  });

  /// Path to the asset of the icon of the application.
  /// If null, no icon will be shown.
  final String? appIconAssetPath;

  /// Size of the icon of the application.
  final double appIconSize;

  /// Path to the asset of the license file.
  /// If null, the license button won't be shown.
  final String? licenseAssetPath;

  /// Name of the author or authors.
  final List<String> authors;

  @override
  State<AboutInfo> createState() => _AboutInfoState();
}

class _AboutInfoState extends State<AboutInfo> {
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
                if (widget.appIconAssetPath != null)
                  Image(
                    image: AssetImage(widget.appIconAssetPath!),
                    width: widget.appIconSize,
                    height: widget.appIconSize,
                  ),
                if (widget.appIconAssetPath != null) const SizedBox(height: 20),
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
                  children: [for (var author in widget.authors) Text(author)],
                ),
                if (widget.licenseAssetPath != null) const SizedBox(height: 10),
                if (widget.licenseAssetPath != null)
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
    String licenseText =
        await context.assetBundle.loadString(widget.licenseAssetPath!);
    if (mounted) {
      context.showMessageDialog(
        licenseText,
        title: "appName".tr(),
      );
    }
  }
}
