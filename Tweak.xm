#import <UIKit/UIKit.h>

static UIButton *floatingButton;
static UIView *menuView;
static BOOL isMenuOpen = NO;

void toggleMenu() {
    isMenuOpen = !isMenuOpen;
    menuView.hidden = !isMenuOpen;
}

// On hooke UIViewController pour trouver le moment où l'écran du jeu est prêt
%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;

    // On évite de dupliquer si déjà présent
    if (floatingButton) return;

    // On ajoute le bouton directement sur la vue du contrôleur actuel
    floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    floatingButton.frame = CGRectMake(20, 100, 50, 50);
    [floatingButton setTitle:@"D" forState:UIControlStateNormal];
    floatingButton.backgroundColor = [UIColor blackColor];
    floatingButton.layer.cornerRadius = 25;
    floatingButton.layer.borderWidth = 2.0;
    floatingButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [floatingButton addTarget:nil action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    
    // On ajoute le menu
    menuView = [[UIView alloc] initWithFrame:CGRectMake(80, 100, 250, 300)];
    menuView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    menuView.hidden = YES;
    
    [self.view addSubview:floatingButton];
    [self.view addSubview:menuView];
    
    // On force l'affichage au premier plan
    [self.view bringSubviewToFront:floatingButton];
}
%end
