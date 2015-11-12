//
//  ViewControllerHappiness.m
//  Happiness
//
//  Created by Stefan on 05/11/15.
//  Copyright © 2015 Stefan. All rights reserved.
//

#import "ViewControllerHappiness.h"
#import "FaceView.h"

@interface ViewControllerHappiness () <FaceViewDataSource>
@property (nonatomic, weak) IBOutlet FaceView *faceView;

@end

@implementation ViewControllerHappiness

@synthesize happiness=_happiness; // valoarea fericirii este cuprinsa intre [0-100]
@synthesize faceView=_faceView;

-(void) setFaceView:(FaceView *)faceView
{
    _faceView=faceView; //setter
    [self.faceView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.faceView action:@selector(pinch:)]];
    // recognizer de pinch gesture
    
    [self.faceView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleHappinessGesture:)]];  // recognizer care va modifica data din MODEL -> happiness

    self.faceView.dataSource = self; // delegam catre controller modificarea zambetului cu ajutorul protocolului

}

- (void)handleHappinessGesture:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self.faceView];
        self.happiness -= translation.y / 2;
        [gesture setTranslation:CGPointZero inView:self.faceView];
    }
}



- (float)smileForFaceView:(FaceView *)sender
{
    return (self.happiness - 50) / 50.0; // valoarea paramentrului din Model este convertita in valoare "inteleasa" de View
}



- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.faceView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    // fac resize la frame ( nu stiu dc nu face asta automat )
    [self.faceView setNeedsDisplay]; // reapeleaza la modificarea orientarii
}


//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerHappinessTransitionCoordinator>)coordinator
//{
//    // Define the new screen size we are about to transition to
//    CGSize windowSize;
//    windowSize= size;
//    
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerHappinessTransitionCoordinatorContext> context){
//        [self.faceView setFrame:CGRectMake(0, 0, size.width, size.height)];
//    } completion:^(id<UIViewControllerHappinessTransitionCoordinatorContext> context){
//    }];
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//}



-(void) setHappiness:(int)happiness
{
    _happiness=happiness;
    [self.faceView setNeedsDisplay]; // atunci cand se modifica modelul - happiness se va redesena view-ul construit
    
}



@end
