//
//  OTRotateView.m
//  OTNotificationViewDemo
//
//  Created by openthread on 8/10/13.
//
//

#import "ComOpenthreadOTCubeRotateView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ComOpenthreadOTCubeRotateView
{
    CATransformLayer *_transformLayer;
    CALayer *_dimmLayer;
    UIView *_currentView;
    UIView *_nextView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _transformLayer = [CATransformLayer layer];
        _transformLayer.frame = self.layer.bounds;
        [self.layer addSublayer:_transformLayer];
        
        self.perspective = -1.0f / 1000.0f;
        
        [self setCurrentView:[[UIView alloc] init]];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _transformLayer.frame = self.bounds;
    _dimmLayer.frame = self.bounds;
    _currentView.frame = self.bounds;
    _nextView.frame = self.bounds;
}

- (BOOL)isAnimating
{
    return _nextView != nil;
}

- (UIView *)currentView
{
    return _currentView;
}

- (void)setCurrentView:(UIView *)currentView
{
    if (_currentView == currentView)
    {
        return;
    }
    
    [_dimmLayer removeFromSuperlayer];
    _dimmLayer = nil;
    
    [_currentView.layer removeFromSuperlayer];
    _currentView = nil;
    
    _currentView = currentView;
    CGRect bounds = self.bounds;
    _currentView.frame = bounds;
    
    [CATransaction begin];
    [CATransaction setDisableActions: TRUE];
    currentView.layer.transform = CATransform3DIdentity;
	[_transformLayer addSublayer:currentView.layer];
    _transformLayer.transform = CATransform3DIdentity;
    [CATransaction commit];
    
    if (_nextView != currentView)
    {
        [_nextView.layer removeFromSuperlayer];
    }
    _nextView = nil;
}

- (void)rotateToView:(UIView *)nextView
                from:(OTCubeViewRotateSide)rotateSide
   animationDuration:(NSTimeInterval)animationDuration
{
    [self rotateToView:nextView
                  from:rotateSide
     animationDuration:animationDuration
            completion:nil];
}

- (void)rotateToView:(UIView *)nextView
                from:(OTCubeViewRotateSide)rotateSide
   animationDuration:(NSTimeInterval)animationDuration
          completion:(void (^)(void))completionBlock
{
    [self rotateToView:nextView
                  from:rotateSide
     animationDuration:animationDuration
     dimmOnCurrentView:YES
            completion:completionBlock];
}

- (void)rotateToView:(UIView *)nextView
                from:(OTCubeViewRotateSide)rotateSide
   animationDuration:(NSTimeInterval)animationDuration
   dimmOnCurrentView:(BOOL)shouldDimm
          completion:(void (^)(void))completionBlock
{
    [CATransaction flush];
    
    //Reset animation if animating
    if (self.isAnimating)
    {
        [self setCurrentView:_nextView];
    }
    
    //Add nextView to _transformLayer
    _nextView = nextView;
    nextView.frame = self.bounds;
	UIView *currentView = _currentView;
    
    CGSize currentSize = currentView.bounds.size;
	CGFloat halfWidth = ([self isRotateSideLandscape:rotateSide] ? currentSize.width : currentSize.height) / 2.0;
	CGFloat duration = animationDuration;
	
	[_transformLayer addSublayer:nextView.layer];
	
    //Add dimm layer if shoudlDimm
    if (shouldDimm)
    {
        _dimmLayer = [CALayer layer];
        _dimmLayer.backgroundColor = [UIColor blackColor].CGColor;
        _dimmLayer.frame = currentView.layer.bounds;
        _dimmLayer.opacity = 0;
        [currentView.layer addSublayer:_dimmLayer];
        
        CABasicAnimation* dimmAnimation= [CABasicAnimation animationWithKeyPath:@"opacity"];
        [dimmAnimation setToValue:[NSNumber numberWithFloat:0.5]];
        [dimmAnimation setDuration:duration];
        [_dimmLayer addAnimation:dimmAnimation forKey:@"opacity"];
    }
    
    //Perform nextView's transform
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	CATransform3D transform = CATransform3DIdentity;
	
    transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
    transform = CATransform3DRotate(transform,
                                    M_PI_2 * ([self isRotateSideDownSideOrLeft:rotateSide] ? -1 : 1),
                                    [self isRotateSidePortrait:rotateSide] ? 1 : 0,
                                    [self isRotateSideLandscape:rotateSide] ? 1 : 0,
                                    0);
    transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
    
	
	nextView.layer.transform = transform;
	[CATransaction commit];
    
	//Perform _transformLayer's transform
	[CATransaction begin];
    [CATransaction setDisableActions:YES];
	[CATransaction setCompletionBlock:^(void) {
        [self setCurrentView:nextView];
        if (completionBlock)
        {
            completionBlock();
        }
    }];
    
	CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	
	transform = CATransform3DIdentity;
	transform.m34 = self.perspective;
	transformAnimation.fromValue = [NSValue valueWithCATransform3D:transform];
	
	transform = CATransform3DIdentity;
	transform.m34 = self.perspective;
    transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
    transform = CATransform3DRotate(transform,
                                    M_PI_2 * ([self isRotateSideDownSideOrLeft:rotateSide] ? 1 : -1),
                                    [self isRotateSidePortrait:rotateSide] ? 1 : 0,
                                    [self isRotateSideLandscape:rotateSide] ? 1 : 0,
                                    0);
    transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
	
	transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
	
	transformAnimation.duration = duration;
	
	[_transformLayer addAnimation:transformAnimation forKey:@"rotate"];
	_transformLayer.transform = transform;
	
	[CATransaction commit];
}

//From downside or left, transformLayer's rotate angel is -M_PI_2, nextLayer's is M_PI_2.
//From upside or right, transformLayer's rotate angel is M_PI_2, nextLayer's is -M_PI_2.
- (BOOL)isRotateSideDownSideOrLeft:(OTCubeViewRotateSide)rotateSide
{
    return (rotateSide == OTCubeViewRotateSideFromLeft)||(rotateSide == OTCubeViewRotateSideFromDownSide);
}

- (BOOL)isRotateSideLandscape:(OTCubeViewRotateSide)rotateSide
{
    return (rotateSide == OTCubeViewRotateSideFromLeft)||(rotateSide == OTCubeViewRotateSideFromRight);
}

- (BOOL)isRotateSidePortrait:(OTCubeViewRotateSide)rotateSide
{
    return (rotateSide == OTCubeViewRotateSideFromUpSide)||(rotateSide == OTCubeViewRotateSideFromDownSide);
}

@end
