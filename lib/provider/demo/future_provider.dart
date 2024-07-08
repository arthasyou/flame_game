import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum City {
  stockholm,
  paris,
  tokyo,
}

Future<String> getWeather(City city) {
  return Future.delayed(
      const Duration(seconds: 1),
      () => {
            City.stockholm: '❄️',
            City.paris: '☔️',
            City.tokyo: 'Wind',
          }[city]!);
}

const unKnowWeather = '🔥';

final cityProvider = StateProvider<City?>((ref) {
  return null;
});

final weathProvider = FutureProvider<String>((ref) {
  final city = ref.watch(cityProvider);
  if (city != null) {
    return getWeather(city);
  } else {
    return unKnowWeather;
  }
});

class CityWidget extends ConsumerWidget {
  const CityWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(weathProvider);
    return Column(
      children: [
        weather.when(
          data: (data) => Text(
            data,
            style: const TextStyle(
              fontSize: 40,
            ),
          ),
          error: (_, __) => const Text('Error'),
          loading: () => const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: City.values.length,
          itemBuilder: (context, index) {
            final city = City.values[index];
            final isSelected = city == ref.watch(cityProvider);
            return ListTile(
              title: Text(city.toString()),
              trailing: isSelected ? const Icon(Icons.check) : null,
              onTap: () {
                ref.read(cityProvider.notifier).state = city;
              },
            );
          },
        ))
      ],
    );
  }
}
