//
//  CancellationToken.swift
//  CancellationToken
//
//  Created by Tom Lokhorst on 2014-10-31.
//
//

import Foundation


enum State {
  case cancelled
  case pending(CancellationTokenSource)
}

/**
A `CancellationToken` indicates if cancellation of "something" was requested.
Can be passed around and checked by whatever wants to be cancellable.

To create a cancellation token, use `CancellationTokenSource`.
*/
public struct CancellationToken {

  private let source: CancellationTokenSource

  internal init(source: CancellationTokenSource) {
    self.source = source
  }

  public var isCancellationRequested: Bool {
    return source.isCancellationRequested
  }

  public func register(_ handler: @escaping () -> Void) {
    source.register(handler)
  }
}

/**
A `CancellationTokenSource` is used to create a `CancellationToken`.
The created token can be set to "cancellation requested" using the `cancel()` method.
*/
public class CancellationTokenSource {

  public var token: CancellationToken {
    return CancellationToken(source: self)
  }

  private var handlers: [() -> Void] = []
  internal var isCancellationRequested = false

  public init() {
  }

  deinit {
    tryCancel()
  }

  public func register(_ handler: @escaping () -> Void) {
    if isCancellationRequested {
      handler()
    }
    else {
      handlers.append(handler)
    }
  }

  public func cancel() {
    tryCancel()
  }

  public func cancel(when: DispatchTime) {
    // On a background queue
    let queue = DispatchQueue.global(qos: .userInitiated)

    queue.asyncAfter(deadline: when) { [weak self] in
      self?.tryCancel()
    }
  }

  public func cancel(seconds: TimeInterval) {
    cancel(when: .now() + seconds)
  }

  @discardableResult
  internal func tryCancel() -> Bool {

    if isCancellationRequested {
      return false
    }

    isCancellationRequested = true
    executeHandlers()

    return true
  }

  private func executeHandlers() {
    // Call all previously scheduled handlers
    for handler in handlers {
      handler()
    }

    // Cleanup
    handlers = []
  }
}
