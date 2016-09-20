# ZoomTransitioning

[![License](https://img.shields.io/:license-mit-blue.svg)](https://doge.mit-license.org)
[![Language](https://img.shields.io/badge/language-swift-orange.svg?style=flat)](https://developer.apple.com/swift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/ZoomTransitioning.svg?style=flat)](http://cocoadocs.org/docsets/ZoomTransitioning/)
[![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/matteocrippa/awesome-swift#animation)

## Overview
`ZoomTransitioning` provides a custom transition with image zooming animation.
When you use this library with `UINavigationController`, you can pop view controller with edge swiping.

![demo](images/demo.gif)

## Demo
Run the demo project in the Demo directory without `carthage update` or `pod install`.

## Usage
Refer to the example project for details.

### `import ZoomTransitioning`
### Adopt `ZoomTransitionSourceDelegate` to source view controller

```swift
extension ImageListViewController: ZoomTransitionSourceDelegate {

    func transitionSourceImageView() -> UIImageView {
        return selectedImageView
    }

    func transitionSourceImageViewFrame(forward forward: Bool) -> CGRect {
        return selectedImageView.convertRect(selectedImageView.bounds, toView: view)
    }

    func transitionSourceWillBegin() {
        selectedImageView.hidden = true
    }

    func transitionSourceDidEnd() {
        selectedImageView.hidden = false
    }

    func transitionSourceDidCancel() {
        selectedImageView.hidden = false
    }
}
```

### Adopt `ZoomTransitionDestinationDelegate` to destination view controller

```swift
extension ImageDetailViewController: ZoomTransitionDestinationDelegate {

    func transitionDestinationImageViewFrame(forward forward: Bool) -> CGRect {
        if forward {
            let x: CGFloat = 0.0
            let y = topLayoutGuide.length
            let width = view.frame.width
            let height = width * 2.0 / 3.0
            return CGRect(x: x, y: y, width: width, height: height)
        } else {
            return largeImageView.convertRect(largeImageView.bounds, toView: view)
        }
    }

    func transitionDestinationWillBegin() {
        largeImageView.hidden = true
    }

    func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView) {
        largeImageView.hidden = false
        largeImageView.image = imageView.image
    }

    func transitionDestinationDidCancel() {
        largeImageView.hidden = false
    }
}
```

### set `delegate` property of `UINavigationController`

```swift
import ZoomTransitioning

class NavigationController: UINavigationController {

    private let zoomNavigationControllerDelegate = ZoomNavigationControllerDelegate()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        delegate = zoomNavigationControllerDelegate
    }
}
```

## Requirements
- Swift 3.0
- iOS 8.0 or later

If you use Swift 2.2, use [1.3.0](https://github.com/WorldDownTown/ZoomTransitioning/releases/tag/1.3.0)

## Installation

### Carthage
ZoomTransitioning is available through [Carthage](https://github.com/Carthage/Carthage). To install it, simply add the following line to your Cartfile:

```
github "WorldDownTown/ZoomTransitioning"
```

### CocoaPods
ZoomTransitioning is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'ZoomTransitioning'
```

### Manually
1. Download and drop ```/ZoomTransitioning```folder in your project.  
2. Congratulations!

## Author
WorldDownTown, WorldDownTown@gmail.com

## License
ZoomTransitioning is available under the MIT license. See the LICENSE file for more info.

