#import <UIKit/UIKit.h>

static UIButton *floatingButton = nil;

%hook UnityAppController

- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    
    // Délai pour s'assurer que le jeu est bien chargé avant d'injecter
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *window = nil;

        // Méthode moderne pour récupérer la fenêtre sans déclencher l'erreur 'keyWindow'
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    window = scene.windows.firstObject;
                    break;
                }
            }
        }
        
        // Fallback si la scène n'est pas trouvée
        if (!window) {
            window = [UIApplication sharedApplication].keyWindow;
        }
        
        #pragma clang diagnostic pop

        if (!window) return;

        // Création du bouton
        floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        floatingButton.frame = CGRectMake(20, 100, 50, 50);
        floatingButton.backgroundColor = [UIColor redColor];
        [floatingButton setTitle:@"D" forState:UIControlStateNormal];
        
        // Ajout à la vue
        [window addSubview:floatingButton];
        [window bringSubviewToFront:floatingButton];
    });
}

%end
