#import <UIKit/UIKit.h>

// On définit la fenêtre qui va contenir ton interface
UIWindow *darkScriptWindow;

// La fonction qui crée ton carré noir avec le texte
void createDarkScriptUI() {
    // Création de la fenêtre par-dessus le jeu
    darkScriptWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    darkScriptWindow.windowLevel = UIWindowLevelAlert; // Assure que c'est au-dessus
    darkScriptWindow.hidden = NO;
    darkScriptWindow.backgroundColor = [UIColor clearColor];

    // Le carré noir
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(20, 50, 150, 50)];
    box.backgroundColor = [UIColor blackColor];
    box.layer.cornerRadius = 10;
    box.layer.borderWidth = 1.0;
    box.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // Le texte "DarkScript"
    UILabel *label = [[UILabel alloc] initWithFrame:box.bounds];
    label.text = @"DarkScript";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    
    [box addSubview:label];
    [darkScriptWindow addSubview:box];
}

// L'entrée du tweak (le constructeur)
%ctor {
    // On attend 3 secondes après le lancement pour que le jeu soit prêt
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        createDarkScriptUI();
    });
}
