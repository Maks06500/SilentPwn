#import <UIKit/UIKit.h>

static UIButton *floatingButton = nil;
static UIView *menuView = nil;
static BOOL isMenuOpen = NO;

// 1. On force la vue à accepter le toucher, même si le jeu essaie de le bloquer
%hook UIButton
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self == floatingButton) return YES;
    return %orig;
}
%end

%hook UIView
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self == floatingButton || self == menuView) return YES;
    return %orig;
}
%end

// 2. Logique de bascule
void toggleMenu() {
    isMenuOpen = !isMenuOpen;
    menuView.hidden = !isMenuOpen;
}

// 3. Logique de déplacement
void handlePan(UIPanGestureRecognizer *recognizer) {
    UIView *view = recognizer.view;
    CGPoint translation = [recognizer translationInView:view.superview];
    view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:view.superview];
}

void injectUI(UIWindow *window) {
    if (floatingButton) return;

    floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    floatingButton.frame = CGRectMake(50, 100, 60, 60);
    floatingButton.backgroundColor = [UIColor blackColor];
    [floatingButton setTitle:@"D" forState:UIControlStateNormal];
    floatingButton.layer.cornerRadius = 30;
    floatingButton.layer.zPosition = 999999; // Priorité visuelle maximale
    
    [floatingButton addTarget:nil action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [floatingButton addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(handlePan:)]];
    
    [window addSubview:floatingButton];

    menuView = [[UIView alloc] initWithFrame:CGRectMake(120, 100, 200, 250)];
    menuView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    menuView.layer.cornerRadius = 15;
    menuView.hidden = YES;
    menuView.layer.zPosition = 999998;
    [menuView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(handlePan:)]];
    
    [window addSubview:menuView];
}

%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    UIWindow *window = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        injectUI(window);
    });
}
%end
