#import "FWWebViewController.h"

@interface FWWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

- (IBAction)didTapRefreshButton:(id)sender;
@end

@implementation FWWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self reloadWebView];
    self.wantsFullScreenLayout = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)didTapRefreshButton:(id)sender {
    [self reloadWebView];
}

- (void)reloadWebView {
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.google.com"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

@end
