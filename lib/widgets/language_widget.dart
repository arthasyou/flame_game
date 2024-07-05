import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../l10n/l10n.dart';
import '../provider/locale_provider.dart';

class LanguagePickerWidget extends ConsumerWidget {
  const LanguagePickerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(localProvider);
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        // value: provider.locale,
        icon: const Icon(
          Icons.language,
          color: Colors.black,
        ),
        items: L10n.all.map((locale) {
          final flag = L10n.getFlag(locale);
          return DropdownMenuItem(
            value: locale,
            child: Center(
              child: Text(
                flag,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          provider.setLocale(value!);
        },
      ),
    );
  }
}
