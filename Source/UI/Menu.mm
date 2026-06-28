#import <UIKit/UIKit.h>

@interface MenuManager : NSObject
+ (void)showSimpleMenu;
@end

@implementation MenuManager
+ (void)showSimpleMenu {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(20, 50, 150, 50)];
    mainView.backgroundColor = [UIColor blackColor];
    mainView.layer.cornerRadius = 10;
    mainView.layer.borderWidth = 1;
    mainView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    label.text = @"DarkScript";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    
    [mainView addSubview:label];
    [window addSubview:mainView];
}
@end
