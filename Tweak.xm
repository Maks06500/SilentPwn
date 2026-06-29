#import <UIKit/UIKit.h>

static UIButton *floatingButton = nil;
static BOOL isMenuOpen = NO;

void toggleMenu() {
    isMenuOpen = !isMenuOpen;
    // Pour tester, juste un petit message console
    NSLog(@"DarkScript: Bouton cliqué !");
}

%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    
    // On ne crée une UIWindow que si elle n'existe pas
    if (floatingButton) return;

    // IMPORTANT : On crée un bouton sans cadre parent bloquant
    floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    floatingButton.frame = CGRectMake(50, 50, 60, 60);
    floatingButton.backgroundColor = [UIColor redColor];
    [floatingButton setTitle:@"D" forState:UIControlStateNormal];
    
    // On ajoute le bouton directement sur la fenêtre du jeu
    [self addSubview:floatingButton];
    [self bringSubviewToFront:floatingButton];
    
    [floatingButton addTarget:nil action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
}
%end
