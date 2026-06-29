#import <UIKit/UIKit.h>

static UIButton *floatingButton;
static UIView *menuView;
static BOOL isMenuOpen = NO;

// Bascule du menu
void toggleMenu() {
    isMenuOpen = !isMenuOpen;
    menuView.hidden = !isMenuOpen;
    floatingButton.alpha = isMenuOpen ? 0.5 : 1.0;
}

// Déplacement (on utilise des gestes sur les éléments eux-mêmes)
void handlePan(UIPanGestureRecognizer *recognizer) {
    UIView *view = recognizer.view;
    CGPoint translation = [recognizer translationInView:view.superview];
    view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:view.superview];
}

// Fonction appelée pour injecter les éléments
void addOverlayToWindow(UIWindow *window) {
    if (floatingButton) return; // Déjà ajouté

    // Bouton "D"
    floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    floatingButton.frame = CGRectMake(20, 100, 50, 50);
    [floatingButton setTitle:@"D" forState:UIControlStateNormal];
    floatingButton.backgroundColor = [UIColor blackColor];
    floatingButton.layer.cornerRadius = 25;
    floatingButton.layer.borderWidth = 2.0;
    floatingButton.layer.borderColor = [UIColor whiteColor].CGColor;
    floatingButton.layer.zPosition = 9999;
    
    [floatingButton addTarget:nil action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [floatingButton addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(handlePan:)]];
    
    // Menu
    menuView = [[UIView alloc] initWithFrame:CGRectMake(80, 100, 250, 300)];
    menuView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    menuView.layer.cornerRadius = 15;
    menuView.layer.zPosition = 9998;
    menuView.hidden = YES;
    [menuView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(handlePan:)]];
    
    [window addSubview:floatingButton];
    [window addSubview:menuView];
}

%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    UIWindow *window = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        addOverlayToWindow(window);
    });
}
%end
