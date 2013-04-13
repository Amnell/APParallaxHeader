# APParallaxHeader

This category makes it super easy to add a parallax header view to your table views. Other alternatives relies on subclassing of `UITableViewController` or `UITableView`. APParallaxHeader uses the Objective-C runtime instead to add the following method to `UIScrollView`

```objective-c
- (void)addParallaxWithImage:(UIImage *)image andHeight:(CGFloat)height;
```


## Demo

[![Demo](http://raw.github.com/apping/APParallaxHeader/gh-pages/images/MovieScreenshot.png)](http://www.youtube.com/watch?v=7-JMdapWXGU)


## Installation

### From CocoaPods

Add `pod 'APParallaxHeader'` to your Podfile or `pod 'APParallaxHeader', :head` if you're feeling adventurous.

### Manually

_**Important note if your project doesn't use ARC**: you must add the `-fobjc-arc` compiler flag to `UIScrollView+ APParallaxHeader.m` in Target Settings > Build Phases > Compile Sources._

* Drag the `APParallaxHeader/APParallaxHeader` folder into your project.
* Import `UIScrollView+APParallaxHeader.h`

## Usage

(see sample Xcode project in `/Demo`)

### Adding Parallax image

```objective-c
[tableView addParallaxWithImage:[UIImage imageNamed:@"ImageName"] andHeight:160];
```

## ToDo

* Ability to set a custom view as a ParallaxView

## Credits

APParallaxHeader is brought to you by [Mathias Amnell](http://twitter.com/amnell) at [Apping AB](http://apping.se). The code is inspired by [Sam Vermette's](http://samvermette.com) work with [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh) (especially the usage of `objc/runtime.h` to make it so easy to implement, without the need of subclassing).

## License
APParallaxHeader is available under the MIT license. See the LICENSE file for more info.