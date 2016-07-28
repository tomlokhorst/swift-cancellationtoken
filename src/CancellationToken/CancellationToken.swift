//
//  CancellationToken.swift
//  CancellationToken
//
//  Created by Tom Lokhorst on 2014-10-31.
//
//

import Foundation

/**
A token that will never be cancelled
*/
public let NotCancellableToken = CancellationToken(state: .notCancelled)

/**
A already cancelled token
*/
public let CancelledToken = CancellationToken(state: .cancelled)

enum State {
  case cancelled
  case notCancelled
  case pending(CancellationTokenSource)
}

/**
A `CancellationToken` indicates if cancellation of "something" was requested.
Can be passed around and checked by whatever wants to be cancellable.

To create a cancellation token, use `CancellationTokenSource`.
*/
public struct CancellationToken {

  private var state: State

  public var isCancellationRequested: Bool {
    switch state {
    case .cancelled:
      return true

    case .notCancelled:
      return false

    case let .pending(source):
      return source.isCancellationRequested
    }
  }

  internal init(state: State) {
    self.state = state
  }

  public func register(_ handler: (Void) -> Void) {

    switch state {
    case let .pending(source):
      source.register(handler)

    default:
      handler()
    }
  }
}

/**
A `CancellationTokenSource` is used to create a `CancellationToken`.
The created token can be set to "cancellation requested" using the `cancel()` method.
*/
public class CancellationTokenSource {

  public var token: CancellationToken {
    if isCancellationRequested {
      return CancellationToken(state: .cancelled)
    }
    else {
      return CancellationToken(state: .pending(self))
    }
  }

  private var handlers: [(Void) -> Void] = []
  internal var isCancellationRequested = false

  public init() {
  }

  public func register(_ handler: (Void) -> Void) {
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
    let queue = DispatchQueue.global(attributes: .qosUserInitiated)

    queue.after(when: when) { [weak self] in
      self?.tryCancel()
      return
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
