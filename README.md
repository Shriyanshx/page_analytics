# PageAnalytics

<a href="https://ibb.co/xgNVjv3"><img src="https://i.ibb.co/5jPq8D2/Untitled-design.png" alt="Untitled-design" border="0"></a>


PageViewAnalytics is a Flutter plugin that helps you track page views and time spent on each page in your application. It provides callbacks for page start and stop events, allowing you to integrate with your analytics system easily.

## Features

- Track page views automatically
- Measure time spent on each page
- Handle app lifecycle changes (pause/resume)
- Option to exclude specific pages from tracking
- Easy integration with custom analytics systems

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  page_view_analytics: ^1.0.0
```

Then run:

```
$ flutter pub get
```

## Usage

1. Import the package in your Dart code:

```dart
import 'package:page_view_analytics/page_view_analytics.dart';
```

2. Create an instance of `PageViewAnalytics`:

```dart
final analytics = PageViewAnalytics(
  onPageStart: (pageName, pageData) {
    // Handle page start event
    print('Page started: $pageName');
  },
  onPageStop: (pageName, timeSpent, pageData) {
    // Handle page stop event
    print('Page stopped: $pageName, Time spent: $timeSpent seconds');
  },
  restrictedScreens: ['/login', '/splash'], // Optional: pages to exclude from tracking
);
```

3. Integrate with your app's navigation:

```dart
class MyApp extends StatelessWidget {
  final PageViewAnalytics analytics;

  MyApp({required this.analytics});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        // Let PageViewAnalytics handle the route for analytics
        analytics.onGenerateRoute(settings);
        
        // Your actual route generation logic here
        // ...
      },
      // ... other MaterialApp properties
    );
  }
}
```

4. Don't forget to dispose of the analytics object when it's no longer needed:

```dart
@override
void dispose() {
  analytics.dispose();
  super.dispose();
}
```

## Example

Here's a more complete example of how to use PageViewAnalytics in a Flutter app:

```dart
import 'package:flutter/material.dart';
import 'package:page_view_analytics/page_view_analytics.dart';

void main() {
  final analytics = PageViewAnalytics(
    onPageStart: (pageName, pageData) {
      print('Page started: $pageName');
      print('Page data: $pageData');
    },
    onPageStop: (pageName, timeSpent, pageData) {
      print('Page stopped: $pageName');
      print('Time spent: $timeSpent seconds');
      print('Page data: $pageData');
    },
  );

  runApp(MyApp(analytics: analytics));
}

class MyApp extends StatelessWidget {
  final PageViewAnalytics analytics;

  MyApp({required this.analytics});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PageViewAnalytics Demo',
      onGenerateRoute: (settings) {
        analytics.onGenerateRoute(settings);
        
        // Your actual route generation logic
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => HomePage());
          case '/details':
            return MaterialPageRoute(builder: (_) => DetailsPage());
          default:
            return null;
        }
      },
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          child: Text('Go to Details'),
          onPressed: () {
            Navigator.pushNamed(context, '/details', arguments: {'id': '123'});
          },
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details')),
      body: Center(child: Text('Details Page')),
    );
  }
}
```

In this example, the `PageViewAnalytics` instance will track navigation between the `HomePage` and `DetailsPage`, providing start and stop events for each page view.

## Notes

- Make sure to handle the disposal of the `PageViewAnalytics` instance when it's no longer needed to avoid memory leaks.
- The `restrictedScreens` parameter allows you to specify pages that should not be tracked.
- The plugin automatically handles app lifecycle changes, tracking when the app is paused or resumed.