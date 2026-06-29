#import <UIKit/UIKit.h>

static UIButton *floatingButton = nil;
static UIView *menuView = nil;
static BOOL isMenuOpen = NO;

// Fonction de bascule
void toggleMenu() {
    isMenuOpen = !isMenuOpen;
    menuView.hidden = !isMenuOpen;
}

// Fonction de déplacement
void handlePan(UIPanGestureRecognizer *recognizer) {
    UIView *view = recognizer.view;
    CGPoint translation = [recognizer translationInView:view.superview];
    view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:view.superview];
}

// Fonction qui "force" l'apparition du bouton
void injectButton(UIWindow *window) {
    if (floatingButton && floatingButton.superview == window) return;

    floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    floatingButton.frame = CGRectMake(20, 100, 50, 50);
    [floatingButton setTitle:@"D" forState:UIControlStateNormal];
    floatingButton.backgroundColor = [UIColor blackColor];
    floatingButton.layer.cornerRadius = 25;
    floatingButton.layer.zPosition = 10000;
    [floatingButton addTarget:nil action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [floatingButton addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(handlePan:)]];
    [window addSubview:floatingButton];

    menuView = [[UIView alloc] initWithFrame:CGRectMake(80, 100, 250, 300)];
    menuView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    menuView.layer.cornerRadius = 15;
    menuView.hidden = YES;
    [menuView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(handlePan:)]];
    [window addSubview:menuView];
}

// Observateur permanent : dès qu'une fenêtre devient la fenêtre principale, on injecte
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    UIWindow *window = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        injectButton(window);
    });
}
%end
