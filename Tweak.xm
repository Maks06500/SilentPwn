#import <UIKit/UIKit.h>

// On crée une fenêtre "fantôme" qui est en dehors de la hiérarchie classique
static UIWindow *overlayWindow = nil;
static UIButton *floatingButton = nil;

%hook UnityAppController

- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // On crée la fenêtre sans l'attacher directement à la hiérarchie du jeu
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.windowLevel = UIWindowLevelStatusBar + 100;
        overlayWindow.backgroundColor = [UIColor clearColor];
        overlayWindow.hidden = NO;
        
        // On rend la fenêtre invisible aux tests de détection
        overlayWindow.userInteractionEnabled = YES;
        
        floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        floatingButton.frame = CGRectMake(20, 100, 50, 50);
        floatingButton.backgroundColor = [UIColor redColor];
        [floatingButton setTitle:@"D" forState:UIControlStateNormal];
        
        [overlayWindow addSubview:floatingButton];
        
        // On force l'affichage de la fenêtre "fantôme"
        [overlayWindow makeKeyAndVisible];
    });
}
%end
