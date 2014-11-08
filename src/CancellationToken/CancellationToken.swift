//
//  CancellationToken.swift
//  CancellationToken
//
//  Created by Tom Lokhorst on 2014-10-31.
//
//

import Foundation

/**
An empty token that will never be cancelled
*/
public let EmptyToken = CancellationTokenSource().token

/**
A `CancellationToken` indicates if cancellation of "something" was requested.
Can be passed around and checked by whatever wants to be cancellable.

To create a cancellation token, use `CancellationTokenSource`.
*/
public class CancellationToken {
  public private(set) var isCancellationRequested = false
  private var handlers : [Void -> Void] = []

  internal init() {
  }

  internal func tryCancel() -> Bool {
    if !isCancellationRequested {
      isCancellationRequested = true
      executeHandlers()

      return true
    }

    return false
  }

  public func register(handler: Void -> Void) {
    if isCancellationRequested {
      handler()
    }
    else {
      handlers.append(handler)
    }
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

/**
A `CancellationTokenSource` is used to create a `CancellationToken`.
The created token can be set to "cancellation requested" using the `cancel()` method.
*/
public class CancellationTokenSource {
  public let token = CancellationToken()

  public init() {
  }

  public func cancel() {
    token.tryCancel()
  }

  public func cancel(when: dispatch_time_t) {
    // On main queue, for now
    dispatch_after(when, dispatch_get_main_queue()) {
      self.token.tryCancel()
      return
    }
  }

  public func cancel(seconds: NSTimeInterval) {
    cancel(dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC))))
  }
}
