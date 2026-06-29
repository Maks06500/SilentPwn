#import <UIKit/UIKit.h>

// Classe pour permettre au jeu de recevoir les clics là où il n'y a pas le bouton
@interface PassthroughWindow : UIWindow
@end

@implementation PassthroughWindow
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) return nil;
    return hitView;
}
@end

static UIButton *floatingButton = nil;
static UIView *menuView = nil;
static PassthroughWindow *overlayWindow = nil;
static BOOL isMenuOpen = NO;

void toggleMenu() {
    isMenuOpen = !isMenuOpen;
    if (menuView) menuView.hidden = !isMenuOpen;
}

void handlePan(UIPanGestureRecognizer *recognizer) {
    UIView *view = recognizer.view;
    CGPoint translation = [recognizer translationInView:view.superview];
    view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:view.superview];
}

void setupUI() {
    if (overlayWindow) return;

    UIWindow *targetWindow = nil;
    
    // Utilisation de la directive pour ignorer le warning de dépréciation
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                targetWindow = scene.windows.firstObject;
                break;
            }
        }
    }
    
    if (!targetWindow) {
        targetWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    #pragma clang diagnostic pop

    if (!targetWindow) return;

    overlayWindow = [[PassthroughWindow alloc] initWithFrame:targetWindow.bounds];
    overlayWindow.windowLevel = UIWindowLevelAlert + 1;
    overlayWindow.hidden = NO;
    overlayWindow.backgroundColor = [UIColor clearColor];

    floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    floatingButton.frame = CGRectMake(50, 100, 60, 60);
    floatingButton.backgroundColor = [UIColor blackColor];
    [floatingButton setTitle:@"D" forState:UIControlStateNormal];
    floatingButton.layer.cornerRadius = 30;
    floatingButton.layer.borderWidth = 2;
    floatingButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [floatingButton addTarget:nil action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [floatingButton addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(handlePan:)]];
    [overlayWindow addSubview:floatingButton];

    menuView = [[UIView alloc] initWithFrame:CGRectMake(120, 100, 200, 250)];
    menuView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    menuView.hidden = YES;
    [menuView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(handlePan:)]];
    [overlayWindow addSubview:menuView];
}

%hook UnityAppController
- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        setupUI();
    });
}
%end
