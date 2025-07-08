import Foundation
internal import RCTRuntime
internal import React
internal import React_RCTAppDelegate
import UIKit

@MainActor
public class ReactKit {
  private var apps: [AppKey: AppInstance] = [:]
  public static let shared = ReactKit()

  private struct AppInstance {
    let rootViewFactory: RCTRootViewFactory
    let jsRuntimeFactoryDelegate: HermesJsRuntimeConfigurator
  }

  public struct AppKey: Hashable {
    public let id: String

    public init(id: String) {
      self.id = id
    }
  }

  public struct AppConfig {
    public let bundleUrl: URL
    public let customizeRootView: ((UIView) -> Void)?

    public init(
      bundleUrl: URL,
      customiseRootView: ((UIView) -> Void)? = nil
    ) {
      self.bundleUrl = bundleUrl
      self.customizeRootView = customiseRootView
    }
  }

  public enum ColorSpace {
    case srgb
    case p3

    fileprivate var rctColorSpace: RCTColorSpace {
      switch self {
      case .p3: .displayP3
      case .srgb: .SRGB
      }
    }
  }

  public enum FontWeight {
    case ultralight
    case thin
    case light
    case regular
    case medium
    case semibold
    case extrabold
    case bold
    case heavy
    case black

    init(reactString str: String?) {
      self =
        switch str {
        case "ultralight": .ultralight
        case "thin": .thin
        case "light": .light
        case "regular": .regular
        case "medium": .medium
        case "semibold": .semibold
        case "extrabold": .extrabold
        case "bold": .bold
        case "heavy": .heavy
        case "black": .black
        default: .regular
        }
    }

    public var uiFontWeight: UIFont.Weight {
      switch self {
      case .ultralight: UIFont.Weight.ultraLight
      case .thin: UIFont.Weight.thin
      case .light: UIFont.Weight.light
      case .regular: UIFont.Weight.regular
      case .medium: UIFont.Weight.medium
      case .semibold: UIFont.Weight.semibold
      case .extrabold: UIFont.Weight.black
      case .bold: UIFont.Weight.bold
      case .heavy: UIFont.Weight.heavy
      case .black: UIFont.Weight.black
      }
    }
  }

  private init() {}

  private func getOrInitApp(forKey key: AppKey, withConfig config: AppConfig)
    -> AppInstance
  {
    if let factory = apps[key] {
      return factory
    }

    let rctConfig = RCTRootViewFactoryConfiguration(
      bundleURL: config.bundleUrl,
      newArchEnabled: true
    )

    let jsConfigurator = HermesJsRuntimeConfigurator(key: key)
    rctConfig.jsRuntimeConfiguratorDelegate = jsConfigurator

    if let customizeRootView = config.customizeRootView {
      rctConfig.customizeRootView = customizeRootView
    }

    let factory = RCTRootViewFactory(configuration: rctConfig)

    logger.info("Creating RCTRootViewFactory for key '\(key.id)'. Config: \(config.bundleUrl)")

    let app = AppInstance(rootViewFactory: factory, jsRuntimeFactoryDelegate: jsConfigurator)

    apps[key] = app
    return app
  }

  public func hasFactory(forKey key: AppKey) -> Bool {
    return apps[key] != nil
  }

  /// Ensure that a factory is pre-created.
  /// If a factory already exists, this function does nothing.
  public func createFactory(forKey key: AppKey, withConfig config: AppConfig) {
    _ = getOrInitApp(forKey: key, withConfig: config)
  }

  /// Initialize and start the react runtime and javascript engine.
  /// Make sure to call `initFactory` first with the same `key`.
  /// Returns true if an existing factory was found. Returns false if no factory was found.
  public func initializeReactHost(forKey key: AppKey, launchOptions: [AnyHashable: Any]?)
    -> Bool
  {
    guard let app = apps[key] else {
      logger.warning(
        "Failed to initiaize RCTHost for key '\(key.id) because no factory was found. Call `createFactory` first."
      )
      return false
    }
    logger.info(
      "Initializing React Host for key '\(key.id)'. launchOptions: \(String(describing: launchOptions))"
    )
    app.rootViewFactory.initializeReactHost(launchOptions: launchOptions)
    return true
  }

  /// Drop the factory for the passed key. This will remove the strong reference
  /// and it should be deallocated upon unloading any views
  public func removeFactory(forKey key: AppKey) {
    let didExist = apps.removeValue(forKey: key) != nil
    Logger.init().info("Removing factory for key '\(key.id)'. Did exist = \(didExist)")
  }

  /// Render the react native app.
  /// The `moduleName` must match a valid string passed into
  /// `AppRegistry.registerComponent('moduleName', () => ...)`
  /// on the javascript side.
  /// The intial props can be any object that can be converted to javascript.
  ///
  /// This function will reuse existing factory for the provided key.
  /// If one does not exist, then it will create the factory with the passed `config`.
  public func getView(
    forKey key: AppKey,
    withConfig config: AppConfig,
    withModuleName moduleName: String,
    initialProperties: [AnyHashable: Any]? = nil,
    launchOptions: [AnyHashable: Any]? = nil
  ) -> UIView {
    let app = getOrInitApp(forKey: key, withConfig: config)
    let view = app.rootViewFactory.view(
      withModuleName: moduleName,
      initialProperties: initialProperties,
      launchOptions: launchOptions
    )
    return view
  }

  public func getView(
    forKey key: AppKey,
    withModuleName moduleName: String,
    initialProperties: [AnyHashable: Any]?,
    launchOptions: [AnyHashable: Any]? = nil
  ) -> UIView? {
    guard let app = apps[key] else { return nil }
    let view = app.rootViewFactory.view(
      withModuleName: moduleName,
      initialProperties: initialProperties,
      launchOptions: launchOptions
    )
    return view
  }

  public func setErrorHandler(_ handleError: @escaping @Sendable (ReactKitError) -> Void) {
    RCTSetFatalHandler { nsError in
      logger.error("Received fatal error from RCTSetFatalHandler: \(String(describing: nsError))")
      if let nsError {
        handleError(.init(error: nsError))
      } else {
        handleError(.init(message: "null error thrown - caught in RCTSetFatalHandler"))
      }
    }

    RCTSetFatalExceptionHandler { exception in
      logger.error(
        "Received fatal exception from RCTSetFatalExceptionHandler: \(String(describing: exception))"
      )
      if let exception {
        handleError(.init(exception: exception))
      } else {
        handleError(.init(message: "null exception thrown - caught in RCTSetFatalExceptionHandler"))
      }
    }
  }

  public func setColorSpace(_ colorSpace: ColorSpace) {
    RCTSetDefaultColorSpace(colorSpace.rctColorSpace)
  }

  public func setFontHandler(_ handler: @escaping @Sendable (CGFloat, FontWeight) -> UIFont) {
    RCTSetDefaultFontHandler { fontSize, fontWeight in
      let font = FontWeight(reactString: fontWeight)
      return handler(fontSize, font)
    }
  }
}

public struct ReactKitError: Error {
  public let message: String

  public var localizedDescription: String {
    return message
  }

  init(message: String) {
    self.message = message
  }

  init(exception: NSException) {
    self.message = exception.name.rawValue + ": " + (exception.reason ?? "")
  }

  init(error: any Error) {
    self.message = error.localizedDescription
  }
}

@objc(RCTJSRuntimeConfiguratorProtocol)
class HermesJsRuntimeConfigurator: NSObject, RCTJSRuntimeConfiguratorProtocol {
  let key: ReactKit.AppKey

  init(key: ReactKit.AppKey) {
    self.key = key
  }

  @objc func createJSRuntimeFactory() -> JSRuntimeFactoryRef {
    logger.info("Initialized hermes runtime factory for key: \(self.key.id)")
    return jsrt_create_hermes_factory()
  }
}
