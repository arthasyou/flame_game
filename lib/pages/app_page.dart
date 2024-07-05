import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../widgets/language_widget.dart';

@RoutePage()
class AppPage extends StatelessWidget {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange'),
        actions: const [
          LanguagePicerWidget(),
        ],
      ),
      body: Column(children: [
        ElevatedButton(
          onPressed: () {
            context.router.pushNamed('/sign-in');
          },
          child: const Text('Sign In'),
        )
      ]),
    );
  }
}
