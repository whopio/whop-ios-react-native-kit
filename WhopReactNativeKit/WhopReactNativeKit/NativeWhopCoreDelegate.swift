//
//  NativeWhopCoreDelegate.swift
//  WhopReactNativeKit
//
//  Created by Jordan Jantschulev on 7/16/25.
//
import Foundation

// MARK: - Bridged Promise Blocks
public typealias ReactKitPromiseResolveBlock = (_ result: [String: Any]?) -> Void
public typealias ReactKitPromiseRejectBlock = (
  _ code: String,
  _ message: String,
  _ error: NSError?
) -> Void

// MARK: - NativeWhopCoreDelegate
@objc public protocol NativeWhopCoreDelegate {

  /// Synchronously executes a command and returns a result dictionary.
  /// - Parameters:
  ///   - name: Command identifier.
  ///   - paramsJson: JSON string with parameters.
  /// - Returns: Dictionary to be bridged back to JS (nil → `undefined` on JS side).
  @objc(execSync:paramsJson:)
  func execSync(
    _ name: String,
    paramsJson: String
  ) -> [String: Any]

  /// Asynchronously executes a command; resolves or rejects the JS promise.
  /// - Parameters:
  ///   - name: Command identifier.
  ///   - paramsJson: JSON string with parameters.
  ///   - resolve: JS promise `resolve`.
  ///   - reject: JS promise `reject`.
  @objc(execAsync:paramsJson:resolve:reject:)
  func execAsync(
    _ name: String,
    paramsJson: String,
    resolve: @escaping ReactKitPromiseResolveBlock,
    reject: @escaping ReactKitPromiseRejectBlock)
}
