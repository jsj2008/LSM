#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UINavigationController (LSAdditional)

/**
 * Pushes a view controller with a transition other than the standard sliding animation.
 */
- (void)pushViewController:(UIViewController*)controller
        animatedWithTransition:(UIViewAnimationTransition)transition;

/**
 * Pops a view controller with a transition other than the standard sliding animation.
 */
- (void)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition;

/**
 * Pops a view controller to root view controller with a transition other than the standard sliding animation.
 */
- (void)popToRootViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition;

@end
