import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../routes/router.dart';
import '../widgets/language_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class RootPage extends StatelessWidget {
  const RootPage({super.key});

  // int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        GameRoute(),
      ],
      transitionBuilder: (context, child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.app_name),
            centerTitle: true,
            actions: const [
              LanguagePickerWidget(),
              SizedBox(width: 12),
            ],
          ),
          body: child,
          bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.games), label: 'Game'),
            ],
            onDestinationSelected: (int index) {
              tabsRouter.setActiveIndex(index);
            },
            selectedIndex: tabsRouter.activeIndex,
          ),
        );
      },
    );
  }
}
