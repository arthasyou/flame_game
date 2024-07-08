import 'package:hooks_riverpod/hooks_riverpod.dart';

const name = [
  'a',
  'b',
  'c',
];

final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(
    const Duration(
      seconds: 1,
    ),
    (i) => i + 1,
  ),
);

final nameProvider = StreamProvider(
  (ref) => ref.watch(tickerProvider.stream),
);
