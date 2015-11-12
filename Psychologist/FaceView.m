//
//  FaceView.m
//  Happiness
//
//  Created by Stefan on 05/11/15.
//  Copyright © 2015 Stefan. All rights reserved.
//

#import "FaceView.h"

@implementation FaceView
@synthesize scale=_scale;
@synthesize dataSource = _dataSource;

#define DEFAULT_SCALE 0.90 // factorul de multiplicare folosit la desenarea cercului

-(CGFloat)scale{ //getter pentru scale - daca ajunge la 0 atunci va returna valoarea DEFAULT_SCALE
    if (!_scale)
    {
        return DEFAULT_SCALE;
    }
    else return _scale;
}

- (void)setScale:(CGFloat)scale
{
    if(_scale!=scale)
    {
    _scale=scale;
    [self setNeedsDisplay]; // la valoare noua de scale -> se va redesena
    }
}

- (void) pinch:(UIPinchGestureRecognizer*)gesture
//handler de gesture - ce va face atunci cand apare pinch pe ecran - trebuie actionat de cineva ca sa se produca - un recognizer
{
    if ((gesture.state==UIGestureRecognizerStateChanged)|| (gesture.state==UIGestureRecognizerStateEnded))
    {
        self.scale=self.scale*gesture.scale; //
        gesture.scale=1; // resetam gesture.scale
        NSLog(@"self scale= %f", self.scale);
        NSLog(@"gesture scale= %f", gesture.scale);
        

    }
}
- (void) drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef) context
{
    UIGraphicsPushContext(context); // deschidem zona grafica PUSH
    CGContextBeginPath(context); // vom desena in context un path
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, 1); // defineste arcul de cerc de la 0 la 2PI = cerc
    CGContextStrokePath(context); // deseneaza linia pe arcul definit anterior
    UIGraphicsPopContext(); // inchidem zona grafica POP
    
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context=UIGraphicsGetCurrentContext(); // aducem contextul grafic
    CGPoint midPoint;
    CGRect screenBounds = [[UIScreen mainScreen] bounds]; //iau in considerare bounds-urile ecranului
    
    midPoint.x=screenBounds.origin.x+screenBounds.size.width/2 ; //punctul de mijloc al FaceView-ului si al ecranului
    midPoint.y=screenBounds.origin.y+screenBounds.size.height/2;
//    NSLog(@"midpoint= %@", NSStringFromCGPoint(midPoint));
//    NSLog(@"bounds.origin= %@", NSStringFromCGPoint(self.bounds.origin));
//    NSLog(@"bounds.size= %@", NSStringFromCGSize(self.bounds.size));
//    NSLog(@"screen= %@", NSStringFromCGSize([[UIScreen mainScreen] bounds].size));
//    NSLog(@"screen= %d", NSStringFromRange(gesture.scale);


    
    CGFloat size = screenBounds.size.width/2; // determinam care este latura mai mica - latimea sau inaltimea a.i. sa folosim acest SIZE ca si raza a cercului desenat
    if (screenBounds.size.width > screenBounds.size.height)
    {
        size = screenBounds.size.height/2;
    }
    size *=self.scale;// modificarea dimensiunii la recognizer de pinch
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor] setStroke];
    [self drawCircleAtPoint:midPoint withRadius:size inContext:context];
    
#define EYE_H 0.35
#define EYE_V 0.35
#define EYE_RADIUS 0.10
    
    CGPoint eyePoint;
    eyePoint.x = midPoint.x - size * EYE_H;
    eyePoint.y = midPoint.y - size * EYE_V;
    
    [self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context]; // desenam ochiul stang
    eyePoint.x += size * EYE_H * 2;
    [self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context]; // desenam ochiul drept

#define MOUTH_H 0.45
#define MOUTH_V 0.40
#define MOUTH_SMILE 0.25
    
    CGPoint mouthStart;
    mouthStart.x = midPoint.x - MOUTH_H * size;
    mouthStart.y = midPoint.y + MOUTH_V * size;
    CGPoint mouthEnd = mouthStart;
    mouthEnd.x += MOUTH_H * size * 2;
    CGPoint mouthCP1 = mouthStart;
    mouthCP1.x += MOUTH_H * size * 2/3;
    CGPoint mouthCP2 = mouthEnd;
    mouthCP2.x -= MOUTH_H * size * 2/3;
    
    float smile = [self.dataSource smileForFaceView:self]; // valoarea zambetului [-1,1] - valoarea zambetului va fi furnizata prin dataSource
    if (smile < -1) smile = -1;
    if (smile > 1) smile = 1;

    
    CGFloat smileOffset = MOUTH_SMILE * size * smile;
    mouthCP1.y += smileOffset;
    mouthCP2.y += smileOffset;
    
    UIGraphicsPushContext(context); // deschidem zona grafica PUSH
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
    CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP2.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y); // bezier curve
    CGContextStrokePath(context);
    UIGraphicsPopContext();
    

}


@end
