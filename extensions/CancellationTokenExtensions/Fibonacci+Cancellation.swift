//
//  Fibonacci+Cancellation.swift
//  CancellationTokenExtensions
//
//  Created by Tom Lokhorst on 2014-11-08.
//  Copyright (c) 2014 Tom Lokhorst. All rights reserved.
//

import Foundation
import CancellationToken

// A terribly inefficient way of calculating a fibonacci number
public func fib(n: Int, cancellationToken: CancellationToken) -> Int {

  if cancellationToken.isCancellationRequested {
    // If cancellation was requested, we exit prematurely with an invalid result
    return -1
  }

  switch n {
  case 0:
    return 0
  case 1:
    return 1
  default:
    return fib(n - 1, cancellationToken) + fib(n - 2, cancellationToken)
  }
}
