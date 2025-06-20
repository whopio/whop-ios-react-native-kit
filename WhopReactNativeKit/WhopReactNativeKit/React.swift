import Foundation
@_implementationOnly import React
import UIKit

/// Creates and returns a UIView configured with a React Native application.
/// - Parameters:
///   - bundleURL: The URL to the JavaScript bundle file that should be loaded in the React Native application.
///   - moduleName: The name of the React Native module that should be run. This should correspond to a registered React Native module in your JavaScript bundle.
///   - initialProperties: The initial properties that should be passed to the React Native module. These are made available in the React Native application via this.props.
///   - backgroundColor: The background color for the React Native View. Default is .clear.
/// - Returns: A UIView configured to run the specified React Native application.
@MainActor
public func makeReactView(
  bundleURL: URL,
  moduleName: String,
  initialProperties: [AnyHashable: Any]?,
  backgroundColor: UIColor = .clear
) -> UIView {
  let bridge = ReactBridgeManager.shared.bridge(for: bundleURL)

  guard let bridge else {
    return UIView()
  }

  let rootView = RCTRootView(
    bridge: bridge, moduleName: moduleName, initialProperties: initialProperties)
  rootView.backgroundColor = backgroundColor
  return rootView
}

/// Tuple to keep host alive as long as the bridge lives.
private struct BridgeBox {
  let host: ReactHost
  let bridge: RCTBridge
}

/// Central place that hands you a ready-to-use bridge
/// for the given bundle URL. Re-uses the same instance
/// on subsequent calls.
public final class ReactBridgeManager {
  public static let shared = ReactBridgeManager()
  private init() {}

  private var boxes: [URL: BridgeBox] = [:]  // strong refs!

  /// Get (or build) a bridge for *this* JS bundle.
  func bridge(for bundleURL: URL) -> RCTBridge? {
    if let box = boxes[bundleURL] { return box.bridge }

    let host = ReactHost(bundleURL: bundleURL)
    let bridge = RCTBridge(delegate: host, launchOptions: nil)

    if let bridge {
      boxes[bundleURL] = BridgeBox(host: host, bridge: bridge)
    }

    return bridge
  }

  /// Preload / warm up a JS bridge for this bundle URL.
  public func preloadBridge(for bundleURL: URL) {
    bridge(for: bundleURL)
  }

  /// Optional: drop a bridge if you need to free memory
  public func invalidate(bundleURL: URL) {
    boxes[bundleURL]?.bridge.invalidate()
    boxes[bundleURL] = nil
  }
}

/// Carries information you may want to render (message, stack, --)
public struct RNCrashInfo: Sendable {
  public let message: String
  public let stack: [String]
  public let nativeError: Error?

  public init(message: String, stack: [String], nativeError: Error?) {
    self.message = message
    self.stack = stack
    self.nativeError = nativeError
  }
}

/// Single place React Native tells us about hard JS failures.
public final class ReactCrashHandler {
  /// Notification the SwiftUI layer will observe
  public static let didCrash = Notification.Name("RNDidFatalCrash")

  public static let shared = ReactCrashHandler()

  let privateCrashHandler = PrivateReactCrashHandler()

  init() {}

  // MARK: – Wire up  *once*  during app launch

  public func install() {
    privateCrashHandler.install()
  }
}

final class PrivateReactCrashHandler: NSObject, RCTExceptionsManagerDelegate {
  override init() {}

  // MARK: – Wire up  *once*  during app launch

  func install() {
    // JS bundle failed to load                                       ▼▼▼▼▼
    NotificationCenter.default.addObserver(
      self, selector: #selector(bundleFailed(_:)),
      name: NSNotification.Name.RCTJavaScriptDidFailToLoad,
      object: nil
    )

    // JS threw an uncaught exception *after* load
    RCTSetFatalHandler { [weak self] error in
      self?.post(
        info: RNCrashInfo(
          message: (error as NSError?)?.localizedDescription ?? "JS fatal error",
          stack: [],
          nativeError: error
        ))
    }
  }

  // MARK: – RCTExceptionsManagerDelegate (JS runtime -> native)

  func handleSoftJSException(
    withMessage message: String?, stack: [Any]?, exceptionId: NSNumber, extraDataAsJSON: String?
  ) {
    let stackStrings = stack?.compactMap { "\($0)" } ?? []
    post(
      info: RNCrashInfo(
        message: message ?? "Soft JS Exception", stack: stackStrings, nativeError: nil))
  }

  func handleFatalJSException(
    withMessage message: String?, stack: [Any]?, exceptionId: NSNumber, extraDataAsJSON: String?
  ) {
    let stackStrings = stack?.compactMap { "\($0)" } ?? []
    post(
      info: RNCrashInfo(
        message: message ?? "Fatal JS Exception", stack: stackStrings, nativeError: nil))
  }

  // MARK: – Private

  @objc private func bundleFailed(_ note: Notification) {
    let err = note.userInfo?["error"] as? NSError
    post(
      info: RNCrashInfo(
        message: err?.localizedDescription ?? "Bundle failed", stack: [], nativeError: err))
  }

  private func post(info: RNCrashInfo) {
    NotificationCenter.default.post(name: ReactCrashHandler.didCrash, object: info)
  }
}

/// The ReactHost is a class that implements the RCTBridgeDelegate protocol.
/// It is used to provide the source URL for the bridge and the extra modules for the bridge.
final class ReactHost: NSObject, RCTBridgeDelegate {
  let bundleURL: URL

  init(bundleURL: URL) {
    self.bundleURL = bundleURL
  }

  func sourceURL(for bridge: RCTBridge) -> URL? {
    bundleURL
  }

  func extraModules(for bridge: RCTBridge) -> [any RCTBridgeModule] {
    [RCTExceptionsManager(delegate: ReactCrashHandler.shared.privateCrashHandler)]
  }
}
