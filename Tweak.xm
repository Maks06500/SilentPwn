#import <UIKit/UIKit.h>

static UIButton *floatingButton;
static UIView *menuView;
static BOOL isMenuOpen = NO;

// On force les vues à accepter le toucher (Anti-protection)
%hook UIView
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self == floatingButton || self == menuView) return YES;
    return %orig;
}
%end

// Logique du bouton
void handlePan(UIPanGestureRecognizer *recognizer) {
    UIView *view = recognizer.view;
    CGPoint translation = [recognizer translationInView:view.superview];
    view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:view.superview];
}

void toggleMenu() {
    isMenuOpen = !isMenuOpen;
    menuView.hidden = !isMenuOpen;
}

// Injection dans la fenêtre principale
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (floatingButton) return;

        UIWindow *window = self;
        
        floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        floatingButton.frame = CGRectMake(50, 100, 60, 60);
        [floatingButton setTitle:@"D" forState:UIControlStateNormal];
        floatingButton.backgroundColor = [UIColor blackColor];
        floatingButton.layer.cornerRadius = 30;
        floatingButton.layer.zPosition = 10000;
        [floatingButton addTarget:nil action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
        [floatingButton addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(handlePan:)]];
        [window addSubview:floatingButton];

        menuView = [[UIView alloc] initWithFrame:CGRectMake(120, 100, 200, 200)];
        menuView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        menuView.hidden = YES;
        menuView.layer.zPosition = 10000;
        [menuView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(handlePan:)]];
        [window addSubview:menuView];
    });
}
%end
