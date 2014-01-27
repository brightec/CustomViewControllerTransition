//
//  BTSlideInteractor.h
//  test
//
//  Created by Cameron Cooke on 21/01/2014.
//  Copyright (c) 2014 Brightec Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BTSlideInteractor : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>
@property (nonatomic, assign, getter = isPresenting) BOOL presenting;
@end