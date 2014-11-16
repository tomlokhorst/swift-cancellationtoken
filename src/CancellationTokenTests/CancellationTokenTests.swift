//
//  CancellationTokenTests.swift
//  CancellationTokenTests
//
//  Created by Tom Lokhorst on 2014-10-31.
//
//

import UIKit
import XCTest
import CancellationToken

class CancellationTokenTests: XCTestCase {

  func testDefault() {
    let source = CancellationTokenSource()
    let token = source.token

    XCTAssertFalse(token.isCancellationRequested, "Default should be false")
  }

  func testCancel() {
    let source = CancellationTokenSource()
    let token = source.token

    source.cancel()

    XCTAssert(token.isCancellationRequested, "Token should be cancelled")
  }

  func testDelayedCancel() {
    let expectation = expectationWithDescription("Cancel not registered")

    let source = CancellationTokenSource()
    let token = source.token

    delay(0.01) {
      source.cancel()
    }

    delay(0.02) {
      if token.isCancellationRequested {
        expectation.fulfill()
      }
    }

    waitForExpectationsWithTimeout(0.03, handler: nil)
  }

  func testCancelWithDelay() {
    let expectation = expectationWithDescription("Cancel not registered")

    let source = CancellationTokenSource()
    let token = source.token

    source.cancel(0.01)
    XCTAssertFalse(token.isCancellationRequested, "Cancel should still be false")

    delay(0.1) {
      if token.isCancellationRequested {
        expectation.fulfill()
      }
    }

    waitForExpectationsWithTimeout(0.2, handler: nil)
  }

  func testRegisterBefore() {
    let expectation = expectationWithDescription("Cancel not registered")

    let source = CancellationTokenSource()
    let token = source.token

    token.register {
      expectation.fulfill()
    }

    source.cancel(0.01)

    waitForExpectationsWithTimeout(0.2, handler: nil)
  }

  func testRegisterAfter() {
    let expectation = expectationWithDescription("Cancel not registered")

    let source = CancellationTokenSource()
    let token = source.token

    source.cancel()

    token.register {
      expectation.fulfill()
    }

    waitForExpectationsWithTimeout(0.01, handler: nil)
  }
}

func delay(seconds: NSTimeInterval, block: dispatch_block_t!) {
  let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
  let queue = dispatch_get_main_queue()

  dispatch_after(when, queue, block)
}
