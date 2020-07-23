# performance_fps

Flutter plugin for calculate fps online on Android and IOS,
  its result is the same as flutter performance

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

## Installation
```yaml
dependencies:
  performance_fps: ^0.0.1
```

### Import

```dart
import 'package:performance_fps/performance_fps.dart';
```

## Usage
```dart
Fps.instance.registerCallBack((fps, dropCount) {
      // current fps
    });
    
Fps.instance.cancel();
```

## License

MIT License
