#import "FWWebViewController.h"

@interface FWWebViewController ()
@property (nonatomic) BOOL authenticated;
@property (strong, nonatomic) NSURLConnection *urlConnection;
@property (strong, nonatomic) NSURLRequest *request;
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
    NSURL *url = [[NSURL alloc] initWithString:@"https://thwin1/api/competitionPages/wizard"];
    self.request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:self.request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSLog(@"Did start loading: %@ auth:%d", [[request URL] absoluteString], _authenticated);

    if (!_authenticated) {
        _authenticated = NO;
        _urlConnection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
        [_urlConnection start];
        return NO;
    }

    return YES;
}


#pragma mark - NURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{
    NSLog(@"WebController Got auth challange via NSURLConnection");

    if ([challenge previousFailureCount] == 0) {
        _authenticated = YES;
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSLog(@"WebController received response via NSURLConnection");

    // remake a webview call now that authentication has passed ok.
    _authenticated = YES;
    [_webView loadRequest:_request];

    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [_urlConnection cancel];
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

@end
