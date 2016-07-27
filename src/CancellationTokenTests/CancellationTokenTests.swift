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
    let expectation = self.expectation(description: "Cancel not registered")

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

    waitForExpectations(timeout: 0.03, handler: nil)
  }

  func testCancelWithDelay() {
    let expectation = self.expectation(description: "Cancel not registered")

    let source = CancellationTokenSource()
    let token = source.token

    source.cancel(seconds: 0.01)
    XCTAssertFalse(token.isCancellationRequested, "Cancel should still be false")

    delay(0.1) {
      if token.isCancellationRequested {
        expectation.fulfill()
      }
    }

    waitForExpectations(timeout: 0.2, handler: nil)
  }

  func testRegisterBefore() {
    let expectation = self.expectation(description: "Cancel not registered")

    let source = CancellationTokenSource()
    let token = source.token

    token.register {
      expectation.fulfill()
    }

    source.cancel(seconds: 0.01)

    waitForExpectations(timeout: 0.2, handler: nil)
  }

  func testRegisterAfter() {
    let expectation = self.expectation(description: "Cancel not registered")

    let source = CancellationTokenSource()
    let token = source.token

    source.cancel()

    token.register {
      expectation.fulfill()
    }

    waitForExpectations(timeout: 0.01, handler: nil)
  }
}

func delay(_ seconds: TimeInterval, execute: () -> Void) {
  let when: DispatchTime = .now() + .milliseconds(Int(seconds * 1000))

  DispatchQueue.main.after(when: when, execute: execute)
}
