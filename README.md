# APParallaxHeader

This category makes it super easy to add a parallax header view to your scroll views. Other alternatives relies on subclassing of `UIScrollView`, `UITableViewController` or `UITableView`. Instead APParallaxHeader uses the Objective-C runtime to add the two following methods to `UIScrollView` without the need to do any subclassing.

```objective-c
- (void)addParallaxWithImage:(UIImage *)image andHeight:(CGFloat)height andShadow:(BOOL)shadow;
- (void)addParallaxWithImage:(UIImage *)image andHeight:(CGFloat)height;
- (void)addParallaxWithView:(UIView*)view andHeight:(CGFloat)height;
```


## Demo

[![Demo](https://raw.github.com/apping/APParallaxHeader/gh-pages/images/MovieScreenshot.png)](http://www.youtube.com/watch?v=7-JMdapWXGU)


## Installation

### From CocoaPods

Add `pod 'APParallaxHeader'` to your Podfile (or `pod 'APParallaxHeader', :head` if you're feeling adventurous, and want to live on the edge).

### Manually

_**Important note if your project doesn't use ARC**: you must add the `-fobjc-arc` compiler flag to `UIScrollView+ APParallaxHeader.m` in Target Settings > Build Phases > Compile Sources._

* Drag the `APParallaxHeader/APParallaxHeader` folder into your project.
* \#import `UIScrollView+APParallaxHeader.h` wherever you feel the need.

## Usage

(see sample Xcode project in `/Demo`)

### Adding Parallax image

```objective-c
[tableView addParallaxWithImage:[UIImage imageNamed:@"ImageName"] andHeight:160];
```

### Adding Parallax custom view

Note: When adding a custom view. Either use ```APParallaxViewDelegate```, auto layout constraints or ```contentMode``` to resize your custom view during scrolling.

```objective-c
UIView *customView = [[UIView alloc] init];
[customView setFrame:CGRectMake(0, 0, 320, 160)];
[self.tableView addParallaxWithView:customView andHeight:160];

[self.tableView.parallaxView setDelegate:self];
```

### APParallaxViewDelegate

APParallaxViewDelegate will notify the delegate about resizing of the parallax view.

####Methods:####

* ```- (void)parallaxView:(APParallaxView *)view willChangeFrame:(CGRect)frame```
* ```- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame```

## ToDo

* Ability to customize the drop shadow size, opacity, color etc.
* Setting a minimum height
* Setting contentMode of the imageView

## Known issues

* Section headers for tableviews with style ```UITableViewStylePlain``` will not be pinned as expected during scrolling.

## Changelog

**0.1.6**

* Re-added/fixed optional shadow implementation

**0.1.5**

* Added delegate callbacks for APParallaxView resizes (```APParallaxViewDelegate```).

**0.1.4**

* Ability to inititate with or without an inner shadow.
* Ability to set a custom view as a parallax view.

**0.1.3**

* Added an inner shadow

**0.1.2**

* Initial release

## Credits

APParallaxHeader is brought to you by [Mathias Amnell](http://twitter.com/amnell) at [Apping AB](http://apping.se). The code is inspired by [Sam Vermette's](http://samvermette.com) work with [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh) (especially the usage of `objc/runtime.h` to make it so easy to implement, without the need of subclassing).

## License
APParallaxHeader is available under the MIT license. See the LICENSE file for more info.