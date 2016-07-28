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

Here's an example based on the [binding](https://github.com/tomlokhorst/swift-cancellationtoken/blob/develop/extensions/CancellationTokenExtensions/Alamofire%0BCancellation.swift) to Alamofire:

```swift
// Create a CancellationTokenSource and a CancellationToken
let source = CancellationTokenSource()
let token = source.token

// Start the asynchroneous downloading of a large file, passing in the cancellation token
request(.GET, largeFileUrl, cancellationToken: token)
  .response { (request, response, data, error) in
    if let error = error {
      if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
        print("The downloading was cancelled")
      }
    }
    else {
      print("The response is available: \(response)")
    }
  }

// Some time later, request cancellation
source.cancel()
```


Installation
------------

### CocoaPods

CancellationToken is available for both iOS and OS X. Using [CocoaPods](http://cocoapods.org), CancellationToken can be integrated into your Xcode project by specifying it in your `Podfile`:

```ruby
pod 'CancellationToken'
```

Then, run the following command:

```bash
$ pod install
```


### Manual

CancellationToken is just a single file, so instead of using CocoaPods, you could also just copy it into your project:

 - [CancellationToken.swift](https://github.com/tomlokhorst/swift-cancellationtoken/blob/develop/src/CancellationToken/CancellationToken.swift)


Releases
--------

 - **0.2.0** - 2015-09-11 - Swift 2 support
 - 0.1.1 - 2015-06-24 - No more circular references, fixes memory leak
 - **0.1.0** - 2015-03-31 - Initial public release
 - 0.0.0 - 2014-10-31 - Initial private version for project at [Q42](http://q42.com)


Licence & Credits
-----------------

CancellationToken is written by [Tom Lokhorst](https://twitter.com/tomlokhorst) and available under the [MIT license](https://github.com/tomlokhorst/swift-cancellationtoken/blob/master/LICENSE), so feel free to use it in commercial and non-commercial projects. This library modelled after the [.NET cancellation model](http://msdn.microsoft.com/en-us/library/dd997364.aspx).
