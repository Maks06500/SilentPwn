#import <UIKit/UIKit.h>

static UIButton *floatingButton;
static UIView *menuView;
static UIWindow *overlayWindow;

// Fonction pour basculer la visibilité
void toggleMenu() {
    menuView.hidden = !menuView.hidden;
}

// Fonction appelée quand on déplace un élément
void handlePan(UIPanGestureRecognizer *recognizer) {
    UIView *view = recognizer.view;
    CGPoint translation = [recognizer translationInView:view.superview];
    view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:view.superview];
}

void setupOverlay() {
    overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    overlayWindow.windowLevel = UIWindowLevelAlert + 1;
    overlayWindow.hidden = NO;
    overlayWindow.backgroundColor = [UIColor clearColor];
    overlayWindow.userInteractionEnabled = YES;

    // 1. Bouton "D" avec geste de déplacement
    floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    floatingButton.frame = CGRectMake(20, 100, 50, 50);
    [floatingButton setTitle:@"D" forState:UIControlStateNormal];
    floatingButton.backgroundColor = [UIColor blackColor];
    floatingButton.layer.cornerRadius = 25;
    floatingButton.layer.borderWidth = 2.0;
    floatingButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [floatingButton addTarget:nil action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *panBtn = [[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(handlePan:)];
    [floatingButton addGestureRecognizer:panBtn];
    [overlayWindow addSubview:floatingButton];

    // 2. Menu avec geste de déplacement
    menuView = [[UIView alloc] initWithFrame:CGRectMake(80, 100, 250, 300)];
    menuView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    menuView.layer.cornerRadius = 15;
    menuView.hidden = YES;
    
    UIPanGestureRecognizer *panMenu = [[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(handlePan:)];
    [menuView addGestureRecognizer:panMenu];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 250, 30)];
    title.text = @"DarkScript Menu";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [menuView addSubview:title];
    
    [overlayWindow addSubview:menuView];
}

%hook UIApplication
- (void)didFinishLaunchingWithOptions:(id)options {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        setupOverlay();
    });
}
%end
