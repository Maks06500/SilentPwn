#import <UIKit/UIKit.h>

// On crée une classe de fenêtre qui laisse passer les clics vers le jeu
@interface TransparentWindow : UIWindow
@end

@implementation TransparentWindow
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    // Si on touche le bouton, on le traite. Sinon, on laisse le clic passer au jeu.
    if (hitView == self || hitView == nil) return nil;
    return hitView;
}
@end

static UIButton *floatingButton = nil;
static TransparentWindow *overlayWindow = nil;

%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    
    // On ne crée l'overlay qu'une fois
    if (overlayWindow) return;

    // Fenêtre par-dessus tout
    overlayWindow = [[TransparentWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    overlayWindow.windowLevel = UIWindowLevelAlert + 1; // Niveau très haut
    overlayWindow.hidden = NO;
    overlayWindow.userInteractionEnabled = YES; // Indispensable

    floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    floatingButton.frame = CGRectMake(50, 50, 60, 60);
    floatingButton.backgroundColor = [UIColor redColor];
    [floatingButton setTitle:@"D" forState:UIControlStateNormal];
    
    // Action de test
    [floatingButton addTarget:self action:@selector(debugClick) forControlEvents:UIControlEventTouchUpInside];
    
    [overlayWindow addSubview:floatingButton];
}
%end

// Pour vérifier si ça clique
%hook UIWindow
%new
- (void)debugClick {
    NSLog(@"DarkScript: CLIC REÇU !");
}
%end
