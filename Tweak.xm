#import <UIKit/UIKit.h>

// On utilise une variable pour stocker le bouton et s'assurer qu'il n'est créé qu'une fois
static UIButton *floatingButton = nil;
static BOOL isMenuOpen = NO;

// Fonction de bascule du menu
void toggleMenu() {
    isMenuOpen = !isMenuOpen;
    // Ici, tu pourrais ajouter l'affichage d'un menu complexe
    NSLog(@"DarkScript: Menu basculé - État: %d", isMenuOpen);
}

// Hook de la classe principale de Unity
%hook UnityAppController

- (void)applicationDidFinishLaunching:(id)application {
    %orig; // On laisse le jeu démarrer normalement

    // On attend que le jeu soit totalement chargé (délai de 5 secondes)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // On récupère la fenêtre principale de Unity
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window) window = [[UIApplication sharedApplication].windows firstObject];

        // Création du bouton "D"
        floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        floatingButton.frame = CGRectMake(50, 100, 60, 60);
        floatingButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [floatingButton setTitle:@"D" forState:UIControlStateNormal];
        floatingButton.layer.cornerRadius = 30;
        floatingButton.layer.borderWidth = 2;
        floatingButton.layer.borderColor = [UIColor whiteColor].CGColor;
        floatingButton.layer.zPosition = 99999; // Priorité maximale

        // Ajout de l'action
        [floatingButton addTarget:nil action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];

        // Ajout au jeu
        [window addSubview:floatingButton];
        [window bringSubviewToFront:floatingButton];
        
        NSLog(@"DarkScript: Bouton injecté avec succès !");
    });
}

%end
