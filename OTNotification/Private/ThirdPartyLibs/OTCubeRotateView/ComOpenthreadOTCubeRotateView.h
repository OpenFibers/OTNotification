//
//  OTRotateView.h
//  OTNotificationViewDemo
//
//  Created by openthread on 8/10/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    OTCubeViewRotateSideFromLeft,
    OTCubeViewRotateSideFromRight,
    OTCubeViewRotateSideFromUpSide,
    OTCubeViewRotateSideFromDownSide
} OTCubeViewRotateSide;

@interface ComOpenthreadOTCubeRotateView : UIView

//Set the current view with out animation.
//Also, you can get the current view ref.
//When animating, this property returns the animating out view.
@property (nonatomic, retain) UIView *currentView;

//Check is animating.
@property (nonatomic, readonly) BOOL isAnimating;

//Perspective value. Default is -1.0f/1000.0f
//e.g. set -1.0f/500.0f will get a stronger 3D visual effect, -1.0f/2000.0f will get a softer 3D visual effect.
//Directly change the animation transform's m34, so extreme value may cause strange animation behavior.
@property (nonatomic, assign) float perspective;

//Animation rotate methods
- (void)rotateToView:(UIView *)nextView
                from:(OTCubeViewRotateSide)rotateSide
   animationDuration:(NSTimeInterval)animationDuration;

- (void)rotateToView:(UIView *)nextView
                from:(OTCubeViewRotateSide)rotateSide
   animationDuration:(NSTimeInterval)animationDuration
          completion:(void (^)(void))completionBlock;

- (void)rotateToView:(UIView *)nextView
                from:(OTCubeViewRotateSide)rotateSide
   animationDuration:(NSTimeInterval)animationDuration
  dimmOnCurrentView:(BOOL)shouldDimm
          completion:(void (^)(void))completionBlock;

@end
