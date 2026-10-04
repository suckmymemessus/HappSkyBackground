#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <rootless.h>

static NSInteger const HSB_TAG = 159304;

static UIImage *HSBImage(void) {
    static UIImage *image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle bundleForClass:NSClassFromString(@"HappSkyBackground")] pathForResource:@"IMG_0021" ofType:@"jpeg"];
        image = [UIImage imageWithContentsOfFile:path];
    });
    return image;
}

static void HSBInstallOnView(UIView *view) {
    if (!view || view.bounds.size.width < 10 || view.bounds.size.height < 10) return;

    UIImage *image = HSBImage();
    if (!image) return;

    UIView *old = [view viewWithTag:HSB_TAG];
    if (old) {
        old.frame = view.bounds;
        return;
    }

    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
    iv.tag = HSB_TAG;
    iv.frame = view.bounds;
    iv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = YES;
    iv.userInteractionEnabled = NO;
    iv.alpha = 0.78;

    [view insertSubview:iv atIndex:0];

    // Let the root container reveal the image while leaving child UI untouched.
    view.backgroundColor = [UIColor clearColor];
    view.opaque = NO;
}

static void HSBInstall(void) {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{ HSBInstall(); });
        return;
    }
    UIApplication *app = UIApplication.sharedApplication;
    for (UIScene *scene in app.connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) {

            continue;
        }
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        for (UIWindow *window in windowScene.windows) {
            UIViewController *root = window.rootViewController;
            if (root.viewIfLoaded) {
                HSBInstallOnView(root.view);
            }
        }
    }
}

%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig(animated);

    if ([NSBundle.mainBundle.bundleIdentifier isEqualToString:@"su.ffg.happ"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            HSBInstall();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                HSBInstall();
            });
        });
    }
}

%end

%ctor {
    if ([NSBundle.mainBundle.bundleIdentifier isEqualToString:@"su.ffg.happ"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                HSBInstall();
            });
        });
    }
}
