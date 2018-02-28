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

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
      source.cancel()
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
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

    source.cancelAfter(timeInterval: 0.01)
    XCTAssertFalse(token.isCancellationRequested, "Cancel should still be false")

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
      if token.isCancellationRequested {
        expectation.fulfill()
      }
    }

    waitForExpectations(timeout: 0.02, handler: nil)
  }

  func testRegisterBefore() {
    let expectation = self.expectation(description: "Cancel not registered")

    let source = CancellationTokenSource()
    let token = source.token

    token.register {
      expectation.fulfill()
    }

    source.cancelAfter(timeInterval: 0.01)

    waitForExpectations(timeout: 0.2, handler: nil)
  }

  func testRegisterAfter() {
    let source = CancellationTokenSource()
    let token = source.token

    var didCancel = false

    source.cancel()

    token.register {
      didCancel = true
    }

    XCTAssertTrue(didCancel)
  }

  func testRegisterDuring() {
    let source = CancellationTokenSource()
    let token = source.token

    var didCancel = false

    token.register {
      token.register {
        didCancel = true
      }
    }

    source.cancel()

    XCTAssertTrue(didCancel)
  }

  func testDeinitSource() {
    var source: CancellationTokenSource? = CancellationTokenSource()
    let token = source!.token

    var didCancel = false

    token.register {
      didCancel = true
    }

    source = nil

    XCTAssertTrue(didCancel)
  }
}
