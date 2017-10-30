//
//  CancellationTokenExtensionsTests.swift
//  CancellationTokenExtensionsTests
//
//  Created by Tom Lokhorst on 2014-11-08.
//  Copyright (c) 2014 Tom Lokhorst. All rights reserved.
//

import XCTest
import Alamofire
import CancellationTokenExtensions

class CancellationTokenExamplesTests: XCTestCase {

  func testAlamofire() {
    let expectation = self.expectation(description: "Request not cancelled")

    let largeFileUrl = "https://upload.wikimedia.org/wikipedia/commons/5/5f/HubbleDeepField.800px.jpg"
    let source = CancellationTokenSource()
    let token = source.token


    // Start the asynchroneous downloading of a large file, passing in the cancellation token
    request(largeFileUrl, cancellationToken: token)
      .response { response in
        if let error = response.error {
          let nsError = error as NSError
          if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled {
            expectation.fulfill()
          }
        }
      }

    // Request cancellation of the token after 0.1 second
    source.cancelAfter(timeInterval: 0.1)

    // Wait for 1 second for the download to be cancelled
    waitForExpectations(timeout: 1.0, handler: nil)
  }

  func testFibonacci() {
    let source = CancellationTokenSource()
    let token = source.token

    // Request cancellation of the token after 0.5 second
    source.cancelAfter(timeInterval: 0.5)

    // Start calculation of the 36th fibonacci number on main queue
    let result = fib(36, token)

    XCTAssertNotEqual(result, 14930352, "Fibonacci calculation was not cancelled")
  }
}
