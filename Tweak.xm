#import <UIKit/UIKit.h>

static UIButton *floatingButton;
static UIView *menuView;
static UIWindow *overlayWindow;
static BOOL isMenuOpen = NO; // Variable d'état pour la bascule

// Fonction pour basculer le menu
void toggleMenu() {
    isMenuOpen = !isMenuOpen;
    menuView.hidden = !isMenuOpen;
    
    // Feedback visuel sur le bouton
    floatingButton.alpha = isMenuOpen ? 0.5 : 1.0;
}

// Fonction de déplacement
void handlePan(UIPanGestureRecognizer *recognizer) {
    UIView *view = recognizer.view;
    CGPoint translation = [recognizer translationInView:view.superview];
    view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:view.superview];
}

void setupOverlay() {
    if (overlayWindow) return; // Sécurité : ne pas créer deux fois

    // Fenêtre flottante
    overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    overlayWindow.windowLevel = UIWindowLevelAlert + 1;
    overlayWindow.hidden = NO;
    overlayWindow.backgroundColor = [UIColor clearColor];
    overlayWindow.userInteractionEnabled = YES;

    // Bouton "D"
    floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    floatingButton.frame = CGRectMake(20, 100, 50, 50);
    [floatingButton setTitle:@"D" forState:UIControlStateNormal];
    floatingButton.backgroundColor = [UIColor blackColor];
    floatingButton.layer.cornerRadius = 25;
    floatingButton.layer.borderWidth = 2.0;
    floatingButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [floatingButton addTarget:nil action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [floatingButton addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(handlePan:)]];
    [overlayWindow addSubview:floatingButton];

    // Menu
    menuView = [[UIView alloc] initWithFrame:CGRectMake(80, 100, 250, 300)];
    menuView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    menuView.layer.cornerRadius = 15;
    menuView.hidden = YES; // Toujours fermé au départ
    [menuView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(handlePan:)]];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 250, 30)];
    title.text = @"DarkScript Menu";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [menuView addSubview:title];
    
    [overlayWindow addSubview:menuView];
}

// Hook le plus fiable pour détecter le chargement complet de l'interface
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        setupOverlay();
    });
}
%end
