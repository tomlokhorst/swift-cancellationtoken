//
//  CancellationToken.swift
//  CancellationToken
//
//  Created by Tom Lokhorst on 2014-10-31.
//
//

import Foundation

/**
A `CancellationToken` indicates if cancellation of "something" was requested.
Can be passed around and checked by whatever wants to be cancellable.

To create a cancellation token, use `CancellationTokenSource`.
*/
public struct CancellationToken {

  private weak var source: CancellationTokenSource?

  internal init(source: CancellationTokenSource) {
    self.source = source
  }

  public var isCancellationRequested: Bool {
    return source?.isCancellationRequested ?? true
  }

  public func register(_ handler: @escaping () -> Void) {
    guard let source = source else {
      return handler()
    }

    source.register(handler)
  }
}

/**
A `CancellationTokenSource` is used to create a `CancellationToken`.
The created token can be set to "cancellation requested" using the `cancel()` method.
*/
public class CancellationTokenSource {

  private let internalState: InternalState
  fileprivate var isCancellationRequested: Bool {
    return internalState.readCancelled()
  }

  public init() {
    internalState = InternalState()
  }

  deinit {
    tryCancel()
  }

  public var token: CancellationToken {
    return CancellationToken(source: self)
  }

  public func register(_ handler: @escaping () -> Void) {
    if let handler = internalState.addHandler(handler) {
      handler()
    }
  }

  public func cancel() {
    tryCancel()
  }

  public func cancelAfter(deadline dispatchTime: DispatchTime) {
    // On a background queue
    let queue = DispatchQueue.global(qos: .userInitiated)

    queue.asyncAfter(deadline: dispatchTime) { [weak self] in
      self?.tryCancel()
    }
  }

  public func cancelAfter(timeInterval: TimeInterval) {
    cancelAfter(deadline: .now() + timeInterval)
  }

  internal func tryCancel() {
    let handlers = internalState.tryCancel()

    // Call all previously scheduled handlers
    for handler in handlers {
      handler()
    }
  }
}

extension CancellationTokenSource {
  typealias Handler = () -> Void

  fileprivate class InternalState {
    private let lock = NSLock()
    private var cancelled = false
    private var handlers: [() -> Void] = []

    func readCancelled() -> Bool {
      lock.lock(); defer { lock.unlock() }

      return cancelled
    }

    func tryCancel() -> [Handler] {
      lock.lock(); defer { lock.unlock() }

      if cancelled {
        return []
      }

      let handlersToExecute = handlers

      cancelled = true
      handlers = []

      return handlersToExecute
    }

    func addHandler(_ handler: @escaping Handler) -> Handler? {
      lock.lock(); defer { lock.unlock() }

      if !cancelled {
        handlers.append(handler)
        return nil
      }

      return handler
    }
  }
}
