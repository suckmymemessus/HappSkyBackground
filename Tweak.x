#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <rootless.h>

static NSInteger const HSB_TAG = 159304;

static UIImage *HSBImage(void) {
    static UIImage *image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = ROOT_PATH_NS(@"/Library/Application Support/HappSkyBackground/HappSkyBackground.jpg");
        image = [UIImage imageWithContentsOfFile:path];
    });
    return image;
}


static void HSBInstall(void) {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            HSBInstall();
        });
        return;
    }

    UIApplication *app = UIApplication.sharedApplication;

    for (UIScene *scene in app.connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) {
            continue;
        }

        UIWindowScene *windowScene = (UIWindowScene *)scene;

        for (UIWindow *window in windowScene.windows) {
            if (!window.rootViewController) {
                continue;
            }

            UIImage *image = HSBImage();
            if (!image) {
                continue;
            }

        UIView *old = [window.rootViewController.view viewWithTag:HSB_TAG];

            if (old) {
                old.frame = window.bounds;
                continue;
            }

            UIImageView *iv = [[UIImageView alloc] initWithImage:image];

            iv.tag = HSB_TAG;
            iv.frame = window.bounds;
            iv.autoresizingMask =
                UIViewAutoresizingFlexibleWidth |
                UIViewAutoresizingFlexibleHeight;

            iv.contentMode = UIViewContentModeScaleAspectFill;
            iv.clipsToBounds = YES;
            iv.userInteractionEnabled = NO;
            iv.alpha = 1.0;

        [window.rootViewController.view insertSubview:iv atIndex:0];
        }
    }
}
