#import <UIKit/UIKit.h>

static UIButton *floatingButton = nil;

// 1. On hooke le contrôleur Unity pour attendre qu'il soit prêt
%hook UnityAppController

- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    
    // Délai pour laisser le jeu s'installer tranquillement
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 2. On récupère la vue principale du jeu sans créer de fenêtre
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window) return;

        floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        floatingButton.frame = CGRectMake(20, 100, 50, 50);
        floatingButton.backgroundColor = [UIColor redColor];
        [floatingButton setTitle:@"D" forState:UIControlStateNormal];
        
        // On l'ajoute directement à la fenêtre existante
        [window addSubview:floatingButton];
        [window bringSubviewToFront:floatingButton];
    });
}
%end
