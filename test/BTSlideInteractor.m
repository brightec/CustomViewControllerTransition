//
//  BTSlideInteractor.m
//  test
//
//  Created by Cameron Cooke on 21/01/2014.
//  Copyright (c) 2014 Brightec Ltd. All rights reserved.
//

#import "BTSlideInteractor.h"


@implementation BTSlideInteractor

# pragma mark -
# pragma mark Helpers

const CGFloat PresentedViewHeightPortrait = 720.0f;
const CGFloat PresentedViewHeightLandscape = 440.0f;

- (CGRect)rectForDismissedState:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController;
    UIView *containerView = [transitionContext containerView];
    
    if (self.presenting)
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    else
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    switch (fromViewController.interfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeRight:
            return CGRectMake(-PresentedViewHeightLandscape, 0,
                              PresentedViewHeightLandscape, containerView.bounds.size.height);
        case UIInterfaceOrientationLandscapeLeft:
            return CGRectMake(containerView.bounds.size.width, 0,
                              PresentedViewHeightLandscape, containerView.bounds.size.height);
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGRectMake(0, -PresentedViewHeightPortrait,
                              containerView.bounds.size.width, PresentedViewHeightPortrait);
        case UIInterfaceOrientationPortrait:
            return CGRectMake(0, containerView.bounds.size.height,
                              containerView.bounds.size.width, PresentedViewHeightPortrait);
        default:
            return CGRectZero;
    }
}


- (CGRect)rectForPresentedState:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController;
    if (self.presenting)
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    else
        fromViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    switch (fromViewController.interfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeRight:
            return CGRectOffset([self rectForDismissedState:transitionContext], PresentedViewHeightLandscape, 0);
        case UIInterfaceOrientationLandscapeLeft:
            return CGRectOffset([self rectForDismissedState:transitionContext], -PresentedViewHeightLandscape, 0);
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGRectOffset([self rectForDismissedState:transitionContext], 0, PresentedViewHeightPortrait);
        case UIInterfaceOrientationPortrait:
            return CGRectOffset([self rectForDismissedState:transitionContext], 0, -PresentedViewHeightPortrait);
        default:
            return CGRectZero;
    }
}


# pragma mark -
# pragma mark UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.presenting = YES;
    return self;
}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.presenting = NO;
    return self;
}


# pragma mark -
# pragma mark UIViewControllerAnimatedTransitioning

- (void)animationEnded:(BOOL)transitionCompleted
{
    // reset state
    self.presenting = NO;
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    NSLog(@"containerView frame=%@ bounds=%@", NSStringFromCGRect(containerView.frame), NSStringFromCGRect(containerView.bounds));
    
    if (self.presenting) {
        // set starting rect for animation
        toViewController.view.frame = [self rectForDismissedState:transitionContext];
        toViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [containerView addSubview:toViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.frame = [self rectForPresentedState:transitionContext];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.frame = [self rectForDismissedState:transitionContext];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [fromViewController.view removeFromSuperview];
        }];
    }
}

@end
