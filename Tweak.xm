#import <UIKit/UIKit.h>

// Déclarations globales
static UIButton *floatingButton;
static UIView *menuView;

// Fonction pour basculer l'affichage du menu
void toggleMenu() {
    menuView.hidden = !menuView.hidden;
}

// Hook de la classe principale pour garantir l'affichage
%hook UIApplication

- (void)didFinishLaunchingWithOptions:(id)options {
    %orig;

    // Création du bouton flottant "D"
    floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    floatingButton.frame = CGRectMake(20, 100, 50, 50);
    [floatingButton setTitle:@"D" forState:UIControlStateNormal];
    floatingButton.backgroundColor = [UIColor blackColor];
    floatingButton.layer.cornerRadius = 25;
    floatingButton.layer.borderWidth = 2.0;
    floatingButton.layer.borderColor = [UIColor whiteColor].CGColor;
    floatingButton.layer.zPosition = 9999; // Force l'affichage au premier plan
    [floatingButton addTarget:nil action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];

    // Création du Menu Principal
    menuView = [[UIView alloc] initWithFrame:CGRectMake(80, 100, 250, 300)];
    menuView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    menuView.layer.cornerRadius = 15;
    menuView.layer.zPosition = 10000;
    menuView.hidden = YES; // Caché par défaut

    // Ajout d'un titre dans le menu
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 250, 30)];
    title.text = @"DarkScript Menu";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [menuView addSubview:title];

    // Ajout des éléments au Window
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        [window addSubview:floatingButton];
        [window addSubview:menuView];
        [window bringSubviewToFront:floatingButton];
    });
}

%end
