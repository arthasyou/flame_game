# Flame Game

A new Flutter project using Flame.

## Getting Started

Follow these steps to set up and run the project:

1. Install the required dependencies:

    ```bash
    flutter pub get
    ```

2. Compile the protocol buffer definitions:

    ```bash
    protoc --dart_out=lib/ protos/message.proto
    ```

3. Generate proto list

     ```bash
    dart run tools/generate_proto_list.dart
    ```

4. Watch for changes and automatically rebuild:

    ```bash
    flutter pub run build_runner watch
    ```

## Project Structure

- `lib/`: Contains the main application code.
- `protos/`: Contains the protocol buffer definitions.

## Running the App

To run the app on an emulator or a physical device, use the following command:

```bash
flutter run
```

## License

This project is licensed under the MIT License
