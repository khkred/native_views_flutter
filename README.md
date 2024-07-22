# Native Views in Flutter

This repository contains a comprehensive example of how to embed native platform views in a Flutter application. By following this guide, you can seamlessly integrate native iOS and Android UI components into your Flutter app, leveraging the best of both worlds.

## Table of Contents

- [Introduction](#introduction)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
- [Usage](#usage)
    - [Android Implementation](#android-implementation)
    - [iOS Implementation](#ios-implementation)
- [Best Practices](#best-practices)
- [Contributing](#contributing)
- [License](#license)

## Introduction

Flutter's platform views allow you to embed native views in your Flutter app, enabling you to use platform-specific UI components. This is particularly useful for integrating native SDKs or custom native UI components that are not available in Flutter.

## Getting Started

### Prerequisites

Before you begin, ensure you have met the following requirements:

- Flutter installed on your machine
- Android Studio and Xcode for Android and iOS development, respectively

### Installation

1. **Clone the repository:**

    ```sh
    git clone https://github.com/khkred/native_views_flutter.git
    cd native_views_flutter
    ```

2. **Install dependencies:**

    ```sh
    flutter pub get
    ```

## Usage

This section provides a step-by-step guide to implementing native views in both Android and iOS.

### Android Implementation

1. **Create the Native View:**

    ```kotlin
    // NativeView.kt
    class NativeView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
        private val textView: TextView = TextView(context)

        init {
            textView.text = creationParams?.get("text") as? String ?: "Default Text"
            textView.textAlignment = View.TEXT_ALIGNMENT_CENTER
        }

        override fun getView(): View = textView
        override fun dispose() {}
    }
    ```

2. **Create the View Factory:**

    ```kotlin
    // NativeViewFactory.kt
    class NativeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
        override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
            val creationParams = args as Map<String?, Any?>?
            return NativeView(context, viewId, creationParams)
        }
    }
    ```

3. **Register the View Factory:**

    ```kotlin
    // MainActivity.kt
    class MainActivity: FlutterActivity() {
        override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
            super.configureFlutterEngine(flutterEngine)
            flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory("native-view", NativeViewFactory())
        }
    }
    ```

4. **Use the Native View in Flutter:**

    ```dart
    class NativeView extends StatelessWidget {
      final String text;

      const NativeView({Key? key, required this.text}) : super(key: key);

      @override
      Widget build(BuildContext context) {
        return AndroidView(
          viewType: 'native-view',
          creationParams: {'text': text},
          creationParamsCodec: const StandardMessageCodec(),
        );
      }
    }
    ```

### iOS Implementation

1. **Create the Native View:**

    ```swift
    // FLNative.swift
    import Flutter
    import UIKit

    class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
        private var messenger: FlutterBinaryMessenger

        init(messenger: FlutterBinaryMessenger) {
            self.messenger = messenger
            super.init()
        }

        func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
            return FLNativeView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: messenger)
        }

        public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
            return FlutterStandardMessageCodec.sharedInstance()
        }
    }

    class FLNativeView: NSObject, FlutterPlatformView {
        private var _view: UIView

        init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger) {
            _view = UIView()
            super.init()
            createNativeView(view: _view)
        }

        func view() -> UIView {
            return _view
        }

        func createNativeView(view _view: UIView) {
            _view.backgroundColor = UIColor.blue
            let nativeLabel = UILabel()
            nativeLabel.text = "Native text from iOS"
            nativeLabel.textColor = UIColor.white
            nativeLabel.textAlignment = .center
            nativeLabel.translatesAutoresizingMaskIntoConstraints = false
            _view.addSubview(nativeLabel)

            NSLayoutConstraint.activate([
                nativeLabel.centerXAnchor.constraint(equalTo: _view.centerXAnchor),
                nativeLabel.centerYAnchor.constraint(equalTo: _view.centerYAnchor)
            ])
        }
    }
    ```

2. **Register the View Factory:**

    ```swift
    // AppDelegate.swift
    import UIKit
    import Flutter

    @UIApplicationMain
    @objc class AppDelegate: FlutterAppDelegate {
        override func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
            let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
            let binaryMessenger = controller.binaryMessenger
            let factory = FLNativeViewFactory(messenger: binaryMessenger)
            registrar(forPlugin: "native-view")?.register(factory, withId: "native-view")
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
    }
    ```

3. **Use the Native View in Flutter:**

    ```dart
    class NativeView extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return UiKitView(
          viewType: 'native-view',
          creationParams: {'text': 'Native text from iOS'},
          creationParamsCodec: const StandardMessageCodec(),
        );
      }
    }
    ```

## Best Practices

- **Use Platform Channels Judiciously:** While platform views are powerful, they can be resource-intensive. Use them only when necessary.
- **Optimize View Creation:** Create views lazily and dispose of them when not needed to conserve resources.
- **Handle Lifecycle Events:** Implement proper disposal in your native views to prevent memory leaks.
- **Use Hybrid Composition:** For Android, use hybrid composition for better performance.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

---
