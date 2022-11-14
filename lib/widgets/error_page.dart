// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The error page for [GoRouter].
class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.state});

  /// The route state.
  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("notFound.title").tr(),
            TextButton(
              onPressed: () => context.go("/"),
              child: const Text("notFound.return").tr(),
            ),
          ],
        ),
      ),
    );
  }
}
