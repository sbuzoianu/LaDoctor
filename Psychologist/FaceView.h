//
//  FaceView.h
//  Happiness
//
//  Created by Stefan on 05/11/15.
//  Copyright © 2015 Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaceView;//protocolul FacViewDataSource foloseste ca argument un obiect FaceView declarat ulterior -> facem forward la clasa

@protocol FaceViewDataSource
- (float)smileForFaceView:(FaceView *)sender;
@end

@interface FaceView : UIView

@property (nonatomic) CGFloat scale;

- (void) pinch:(UIGestureRecognizer *) gesture; // pinch gesture e facut public - oricine il poate folosi

//cineva vrea sa controleze zambetul trebuie si sa-l programeze
@property (nonatomic, weak) IBOutlet id <FaceViewDataSource> dataSource;


@end
