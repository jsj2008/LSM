
#define TT_TRANSITION_DURATION 0.3
#define TT_FAST_TRANSITION_DURATION 0.2
#define TT_FLIP_TRANSITION_DURATION 0.3

#import "UINavigationControllerAdditions.h"

@implementation UINavigationController (LSAdditional)

- (void)pushViewController:(UIViewController*)controller
    animatedWithTransition:(UIViewAnimationTransition)transition {
    [self pushViewController:controller animated:NO];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:TT_FLIP_TRANSITION_DURATION];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
}

- (void)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:TT_FLIP_TRANSITION_DURATION];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];

    [self popViewControllerAnimated:NO];
}

- (void)popToRootViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:TT_FLIP_TRANSITION_DURATION];
	[UIView setAnimationTransition:transition forView:self.view cache:YES];
	[UIView commitAnimations];
    
    [self popToRootViewControllerAnimated:NO];
}

@end
