//
//  FLNative.swift
//  Runner
//
//  Created by Harish on 7/21/24.
//

import Flutter
import UIKit

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create (
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView{
    return FLNativeView(frame: frame,
                        viewIdentifier: viewId,
                        arguments: args,
                        binaryMessenger: messenger)
    }
    
    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
        public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
              return FlutterStandardMessageCodec.sharedInstance()
        }
}


class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger) {
        _view = UIView()
        super.init()
        
        // iOS views can be created here
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

        // Set the label's size
        nativeLabel.sizeToFit()

        // Center the label in the view
        nativeLabel.center = _view.center

        _view.addSubview(nativeLabel)

        // Add constraints to keep the label centered
        nativeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nativeLabel.centerXAnchor.constraint(equalTo: _view.centerXAnchor),
            nativeLabel.centerYAnchor.constraint(equalTo: _view.centerYAnchor)
        ])
    }
}
