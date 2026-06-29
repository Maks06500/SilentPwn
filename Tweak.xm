#import <UIKit/UIKit.h>

static UIButton *floatingButton;
static UIView *menuView;

// Fonction pour basculer l'affichage
void toggleMenu() {
    menuView.hidden = !menuView.hidden;
}

// Hook pour injecter notre interface
%hook UIApplication

- (void)didFinishLaunchingWithOptions:(id)options {
    %orig;

    // Utilisation d'une méthode compatible pour obtenir la fenêtre principale
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;

    floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    floatingButton.frame = CGRectMake(20, 100, 50, 50);
    [floatingButton setTitle:@"D" forState:UIControlStateNormal];
    floatingButton.backgroundColor = [UIColor blackColor];
    floatingButton.layer.cornerRadius = 25;
    floatingButton.layer.borderWidth = 2.0;
    floatingButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [floatingButton addTarget:nil action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];

    menuView = [[UIView alloc] initWithFrame:CGRectMake(80, 100, 250, 300)];
    menuView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    menuView.layer.cornerRadius = 15;
    menuView.hidden = YES;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 250, 30)];
    title.text = @"DarkScript Menu";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [menuView addSubview:title];

    [window addSubview:floatingButton];
    [window addSubview:menuView];
}

%end
