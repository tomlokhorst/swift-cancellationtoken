<img src="https://cloud.githubusercontent.com/assets/75655/5061903/76be2014-6dac-11e4-950b-2731f3c4cfef.png" alt="swift-cancellationtoken" width="360">
<hr>

A "cancellation token" is a little object that can be passed around to one or more asychronous tasks. This token can be used to indicate a user is no longer interested in the result of an asynchronous task.

By using a CancellationToken, the creation and cancellation of asynchronous tasks is separated into two distinct parts. 

Usage
-----

1. Create a `CancellationTokenSource`.
2. Get the token from the source.
3. Pass the token to some asynchronous task.
4. _The asynchronous task may pass the token along to its subtasks._
5. When no longer interested in the result of the asynchronous task; Cancel the source. This cancellation will propagate to the token, and all copies of the token.
6. _The asynchrounous task may choose to cancel its operation and fail in its own way._


Example
-------

Here's an example based on the [binding](https://github.com/tomlokhorst/swift-cancellationtoken/blob/master/examples/CancellationTokenExamples/Alamofire%2BCancellation.swift) to Alamofire:

```swift
// Create a CancellationTokenSource and a CancellationToken
let source = CancellationTokenSource()
let token = source.token

// Start the asynchroneous downloading of a large file, passing in the cancellation token
alamofireRequest(.GET, largeFileUrl, cancellationToken: token)
  .response { (request, response, data, error) in
    if let error = error {
      if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
        println("The downloading was cancelled")
      }
    }
    else {
      println("The response is available: \(response)")
    }
}

// Some time later, request cancellation
source.cancel()
```

Installation
------------

Due to the lack of Swift suport in tools like [CocoaPods](http://cocoapods.org/), installation of this library is a bit involved. There are two options:

1. Clone this repository as a submodule, and manually link this project as a subproject (same as the [installation instructions for Alamofire](https://github.com/Alamofire/Alamofire#installation))
2. Or, just copy [`CancellationToken.swift`](https://github.com/tomlokhorst/swift-cancellationtoken/blob/master/src/CancellationToken/CancellationToken.swift) into your project


Licence & Credits
-----------------

CancellationToken is written by [Tom Lokhorst](https://twitter.com/tomlokhorst) and available under the [MIT license](https://github.com/tomlokhorst/swift-cancellationtoken/blob/master/LICENSE), so feel free to use it in commercial and non-commercial projects. This library modelled after the [.NET cancellation model](http://msdn.microsoft.com/en-us/library/dd997364.aspx).
