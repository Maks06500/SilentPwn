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

// Fonction pour basculer le menu
void toggleMenu() {
    isMenuOpen = !isMenuOpen;
    if (menuView) menuView.hidden = !isMenuOpen;
}

// Fonction de déplacement
void handlePan(UIPanGestureRecognizer *recognizer) {
    UIView *view = recognizer.view;
    CGPoint translation = [recognizer translationInView:view.superview];
    view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:view.superview];
}

void setupUI() {
    if (overlayWindow) return;

    // Récupération moderne de la fenêtre active sans erreur de compilation
    UIWindow *targetWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                targetWindow = scene.windows.firstObject;
                break;
            }
        }
    } else {
        // Fallback pour les vieilles versions
        targetWindow = [UIApplication sharedApplication].keyWindow;
    }

    if (!targetWindow) return;

    overlayWindow = [[PassthroughWindow alloc] initWithFrame:targetWindow.bounds];
    overlayWindow.windowLevel = UIWindowLevelAlert + 1;
    overlayWindow.hidden = NO;
    overlayWindow.backgroundColor = [UIColor clearColor];

    // Bouton "D"
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

    // Menu
    menuView = [[UIView alloc] initWithFrame:CGRectMake(120, 100, 200, 250)];
    menuView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    menuView.hidden = YES;
    [menuView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(handlePan:)]];
    [overlayWindow addSubview:menuView];
}

%hook UnityAppController
- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    // On attend un délai pour être certain que la scène est active avant d'ajouter l'UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        setupUI();
    });
}
%end
