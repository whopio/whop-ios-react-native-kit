import Foundation
internal import RCTRuntime
internal import React
internal import ReactAppDependencyProvider
internal import ReactKitObjC
internal import React_RCTAppDelegate
import UIKit

@MainActor
public class ReactKit {
  private var apps: [AppKey: AppInstance] = [:]
  public static let shared = ReactKit()

  private struct AppInstance {
    let factory: RCTReactNativeFactory
    let delegate: ReactKitFactoryDelegate
    let factoryDelegate: AppFactoryDelegate

    var rootViewFactory: RCTRootViewFactory {
      factory.rootViewFactory
    }
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
    public let colorSpace: ColorSpace
    public let httpClientDelegate: HttpClientConfigurationDelegate?

    public init(
      bundleUrl: URL,
      customiseRootView: ((UIView) -> Void)? = nil,
      colorSpace: ColorSpace = .srgb,
      httpClientDelegate: HttpClientConfigurationDelegate? = nil
    ) {
      self.bundleUrl = bundleUrl
      self.customizeRootView = customiseRootView
      self.colorSpace = colorSpace
      self.httpClientDelegate = httpClientDelegate
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

    let delegate = ReactKitFactoryDelegate(withKey: key, withConfig: config)
    let factory = ReactKitAppFactory(delegate: delegate, releaseLevel: .Stable)
    let factoryDelegate = AppFactoryDelegate(config: config, key: key)
    factory.reactKitDelegate = factoryDelegate

    logger.info(
      "[RNKit] Creating RCTRootViewFactory for key '\(key.id)'. Config: \(config.bundleUrl)")

    let app = AppInstance(factory: factory, delegate: delegate, factoryDelegate: factoryDelegate)

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
        "[RNKit] Failed to initiaize RCTHost for key '\(key.id) because no factory was found. Call `createFactory` first."
      )
      return false
    }
    logger.info(
      "[RNKit] Initializing React Host for key '\(key.id)'. launchOptions: \(String(describing: launchOptions))"
    )
    app.rootViewFactory.initializeReactHost(launchOptions: launchOptions)
    return true
  }

  /// Drop the factory for the passed key. This will remove the strong reference
  /// and it should be deallocated upon unloading any views
  public func removeFactory(forKey key: AppKey) {
    let didExist = apps.removeValue(forKey: key) != nil
    logger.info("[RNKit] Removing factory for key '\(key.id)'. Did exist = \(didExist)")
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
      logger.error(
        "[RNKit] Received fatal error from RCTSetFatalHandler: \(String(describing: nsError))")
      if let nsError {
        handleError(.init(error: nsError))
      } else {
        handleError(.init(message: "null error thrown - caught in RCTSetFatalHandler"))
      }
    }

    RCTSetFatalExceptionHandler { exception in
      logger.error(
        "[RNKit] Received fatal exception from RCTSetFatalExceptionHandler: \(String(describing: exception))"
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

  /// Provide a url session configuration to be used for all requests.
  public func setGlobalUrlSessionConfiguration(configuration: URLSessionConfiguration) {
    RCTSetCustomNSURLSessionConfigurationProvider {
      configuration
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

@objc(ReactKitFactoryDelegate)
class ReactKitFactoryDelegate: RCTDefaultReactNativeFactoryDelegate {
  let key: ReactKit.AppKey
  let config: ReactKit.AppConfig

  init(withKey key: ReactKit.AppKey, withConfig config: ReactKit.AppConfig) {

    logger.info(
      "[RNKit] [ReactKitFactoryDelegate] Constructed ReactKitFactoryDelegate for key: \(key.id) with bundleUrl: \(config.bundleUrl)"
    )
    self.key = key
    self.config = config
    super.init()
    super.dependencyProvider = ReactKitAppDependencyProvider(config: config)
  }

  override func bundleURL() -> URL? {
    config.bundleUrl
  }

  override func sourceURL(for bridge: RCTBridge) -> URL? {
    config.bundleUrl
  }

  override func defaultColorSpace() -> RCTColorSpace {
    config.colorSpace.rctColorSpace
  }

  override func customize(_ rootView: RCTRootView) {
    if let customize = config.customizeRootView {
      customize(rootView)
    } else {
      super.customize(rootView)
    }
  }

  override func createJSRuntimeFactory() -> JSRuntimeFactoryRef {
    logger.info(
      "[RNKit] [ReactKitFactoryDelegate] Initialized hermes runtime factory for key: \(self.key.id)"
    )
    return jsrt_create_hermes_factory()
  }

  override func turboModuleEnabled() -> Bool {
    true
  }

  override func fabricEnabled() -> Bool {
    true
  }

  override func bridgelessEnabled() -> Bool {
    true
  }

  override func newArchEnabled() -> Bool {
    true
  }
}

@objc(ReactKitAppDependencyProvider)
class ReactKitAppDependencyProvider: RCTAppDependencyProvider {
  let config: ReactKit.AppConfig

  init(config: ReactKit.AppConfig) {
    self.config = config
    super.init()
    logger.info(
      "[RNKit] [ReactKitAppDependencyProvider] constructed. \(config.httpClientDelegate?.getAppHost() ?? "<null>") "
    )
  }

  override func urlRequestHandlerClassNames() -> [String] {
    let base = super.urlRequestHandlerClassNames()
    let custom = TokenInjectorHttpRequestHandler.moduleName()
    let combined = [custom] + base
    logger.info(
      "[RNKit] [ReactKitAppDependencyProvider] URL handlers: \( combined.joined(separator: ", ") )")
    return combined
  }
}

@objc(AppFactoryDelegate)
class AppFactoryDelegate: NSObject, ReactKitAppFactoryDelegate {
  let config: ReactKit.AppConfig
  let key: ReactKit.AppKey

  init(config: ReactKit.AppConfig, key: ReactKit.AppKey) {
    self.config = config
    self.key = key
  }

  func getModuleInstance(from moduleClass: AnyClass) -> (any ReactKitTurboModule)? {
    Logger.init().info(
      "[RNKit] [AppFactoryDelegate] getModuleInstance called for key \(self.key.id) with class: \(String(describing: moduleClass))"
    )
    if moduleClass == TokenInjectorHttpRequestHandler.self, let del = config.httpClientDelegate {
      Logger.init().info(
        "[RNKit] [AppFactoryDelegate] constructing TokenInjectorHttpRequestHandler. for del with host: \(del.getAppHost())"
      )
      return TokenInjectorHttpRequestHandler(configDelegate: del)
    }
    return nil
  }
}

public protocol HttpClientConfigurationDelegate {
  func getAccessToken() -> String?
  func getRefreshToken() -> String?
  func getAppHost() -> String
}

@objc(TokenInjectorHttpRequestHandler)
class TokenInjectorHttpRequestHandler: RCTHTTPRequestHandler, ReactKitTurboModule {
  let configDelegate: HttpClientConfigurationDelegate

  init(configDelegate: HttpClientConfigurationDelegate) {
    self.configDelegate = configDelegate
    super.init()
    logger.info(
      "[RNKit] [TokenInjectorHttpRequestHandler] constructed with delegate for: \(configDelegate.getAppHost())"
    )
  }

  override func handlerPriority() -> Float {
    10
  }

  override func send(_ request: URLRequest!, with delegate: (any RCTURLRequestDelegate)!) -> Any! {
    logger.info(
      "[RNKit] [TokenInjectorHttpRequestHandler] sending request to: \(String(describing: request?.url))"
    )
    guard var mutRequest = request else { return super.send(request, with: delegate) }

    let isRelative = mutRequest.url?.host() == nil && mutRequest.url?.scheme == nil

    if mutRequest.url?.host() == configDelegate.getAppHost() || isRelative {
      logger.info(
        "[RNKit] [TokenInjectorHttpRequestHandler] is a valid app api request: \(String(describing: mutRequest.url))"
      )

      // Attach auth header if present
      var cookie = ""
      if let accessToken = configDelegate.getAccessToken() {
        logger.info(
          "[RNKit] [TokenInjectorHttpRequestHandler] attaching access token to request: \(String(describing: mutRequest.url))"
        )
        cookie += "whop-core.access-token=\(accessToken);"
      }

      // Attach refresh header if present
      if let refreshToken = configDelegate.getRefreshToken() {
        logger.info(
          "[RNKit] [TokenInjectorHttpRequestHandler] attaching refresh token to request: \(String(describing: mutRequest.url))"
        )
        cookie += "whop-core.refresh-token=\(refreshToken);"
      }

      if !cookie.isEmpty {
        mutRequest.setValue(cookie, forHTTPHeaderField: "cookie")
      }
    }

    if isRelative, let url = mutRequest.url {
      let baseUrl = URL(string: "https://\(configDelegate.getAppHost())")
      let newUrl = URL(string: url.relativeString, relativeTo: baseUrl)
      logger.info(
        "[RNKit] [TokenInjectorHttpRequestHandler] updating relative url to \(String(describing: newUrl))"
      )
      mutRequest.url = newUrl
    }

    mutRequest.setValue("hello_world_from_react_native", forHTTPHeaderField: "x-custom-rn-token")
    return super.send(mutRequest, with: delegate)
  }

  // func getTurboModule(_ params: Any!) -> Any! {
  //   self
  // }

  override static func moduleName() -> String {
    NSStringFromClass(TokenInjectorHttpRequestHandler.self)
  }
}
