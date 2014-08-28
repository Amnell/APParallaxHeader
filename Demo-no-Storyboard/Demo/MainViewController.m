//
//  MainViewController.m
//  Demo
//
//  Created by Js Lim on 8/28/14.
//
//

#import "MainViewController.h"

// the image section height
static CGFloat topSectionHeight = 270.f;

// when drag below this offset, shows the full screen image
static CGFloat fullScreenCutoffPoint = 360;

@interface MainViewController ()

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIWebView *webView;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    // this is example by scrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    // add imageView instead of image (or you want to add in any other view)
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), topSectionHeight)];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // to shows the content on below section
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    _webView.delegate = self;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.scrollEnabled = NO;
    for (UIView* subView in [_webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView* shadowView in [subView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    [shadowView setHidden:YES];
                }
            }
        }
    }
    [_scrollView addSubview:_webView];
    
    [_scrollView addParallaxWithView:_imageView andHeight:topSectionHeight];
    
    // load content
    _imageView.image = [UIImage imageNamed:@"ParallaxImage.jpg"];
    [_webView loadHTMLString:[NSString stringWithFormat:@"<div id='main-wrapper' style='color:#8e8e8e;font-family:HelveticaNeue;padding:20px 5px;'>%@</div>", @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"] baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.y < -fullScreenCutoffPoint && velocity.y < 0.1) {
        // when is dragging downward, shows the full screen image
        CGRect frame = scrollView.parallaxView.frame;
        frame.origin.y = -CGRectGetHeight(self.view.frame);
        frame.size.height = CGRectGetHeight(self.view.frame);
        scrollView.parallaxView.frame = frame;
        
        // adjust the scrollView's contentInset so that the scrollView won't scroll to the original offset
        UIEdgeInsets inset = scrollView.contentInset;
        inset.top = CGRectGetHeight(frame);
        scrollView.contentInset = inset;
        [scrollView setContentOffset:CGPointMake(0, frame.origin.y) animated:YES];
    } else if (velocity.y > 0) {
        // when is dragging upward, then restore to default height
        CGRect frame = scrollView.parallaxView.frame;
        frame.origin.y = -topSectionHeight;
        frame.size.height = topSectionHeight;
        scrollView.parallaxView.frame = frame;
        
        UIEdgeInsets inset = scrollView.contentInset;
        inset.top = topSectionHeight;
        scrollView.contentInset = inset;
        [scrollView setContentOffset:CGPointMake(0, frame.origin.y) animated:YES];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // get the html content height
    NSString *output = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"main-wrapper\").offsetHeight;"];
    // reset the webView's height
    CGFloat height = MAX([output intValue], CGRectGetHeight(_scrollView.frame) - CGRectGetMaxY(_imageView.frame));
    webView.frame = CGRectMake(CGRectGetMinX(webView.frame), CGRectGetMinY(webView.frame), CGRectGetWidth(webView.frame), height);
    height = MAX(CGRectGetMaxY(webView.frame), CGRectGetHeight(_scrollView.frame) + 1);
    
    // adjust the contentSize of scrollView, make sure it is scrollable (if content height is not greater than scrollView's height, scroll will be disabled)
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), height);
}

@end
