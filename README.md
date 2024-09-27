# PageAnalytics

<a href="https://ibb.co/xgNVjv3"><img src="https://i.ibb.co/5jPq8D2/Untitled-design.png" alt="Untitled-design" border="0"></a>

PageAnalytics is a Flutter package that provides an easy way to track page views and time spent on each page in your Flutter application. It offers callbacks for page start and stop events, making it simple to implement analytics in your app regardless of the navigation method you use.

## Features

- Tracking of page views
- Measurement of time spent on each page
- Lifecycle-aware (handles app paused and resumed states)
- Customizable page start and stop callbacks
- Support for restricted screens (pages you don't want to track)
- Flexible integration with various navigation methods

## Installation

Add `page_analytics` to your `pubspec.yaml` file:

```yaml
dependencies:
  page_analytics: ^1.0.0
```

Then run:

```
flutter pub get
```

## Usage

1. Import the package in your Dart code:

```dart
import 'package:page_analytics/page_analytics.dart';
```

2. Create an instance of `PageAnalytics` in your app:

```dart
final PageAnalytics analytics = PageAnalytics(
  onPageStart: (pageName, pageData) {
    // Implement your page start tracking logic here
    print('Page started: $pageName with data: $pageData');
  },
  onPageStop: (pageName, timeSpent, pageData) {
    // Implement your page stop tracking logic here
    print('Page stopped: $pageName, time spent: $timeSpent seconds, data: $pageData');
  },
  restrictedScreens: ['splash', 'loading'],
);
```

3. Use the `PageAnalytics` instance in your navigation logic:

```dart
// For named routes
Navigator.pushNamed(context, '/details', arguments: {'id': '123'});

// For anonymous routes
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailsPage(),
    settings: RouteSettings(name: '/details', arguments: {'id': '123'}),
  ),
);
```

## Example

Here's a basic example of how to use PageAnalytics in a Flutter app:

```dart
import 'package:flutter/material.dart';
import 'package:page_analytics/page_analytics.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final PageAnalytics analytics = PageAnalytics(
    onPageStart: (pageName, pageData) {
      print('Page started: $pageName with data: $pageData');
    },
    onPageStop: (pageName, timeSpent, pageData) {
      print('Page stopped: $pageName, time spent: $timeSpent seconds, data: $pageData');
    },
    restrictedScreens: ['splash'],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PageAnalytics Demo',
      home: HomePage(analytics: analytics),
    );
  }
}

class HomePage extends StatelessWidget {
  final PageAnalytics analytics;

  HomePage({required this.analytics});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          child: Text('Go to Details'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(analytics: analytics),
                settings: RouteSettings(name: '/details', arguments: {'id': '123'}),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final PageAnalytics analytics;

  DetailsPage({required this.analytics});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details')),
      body: Center(child: Text('Details Page')),
    );
  }
}
```

## Customization

You can customize the behavior of PageAnalytics by modifying the following parameters:

- `onPageStart`: A callback function that is called when a new page is started.
- `onPageStop`: A callback function that is called when a page is stopped (navigated away from).
- `restrictedScreens`: A list of route names that should not be tracked.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.