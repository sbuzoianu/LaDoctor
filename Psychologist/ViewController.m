//
//  ViewController.m
//  Psychologist
//
//  Created by Stefan on 12/11/15.
//  Copyright © 2015 Stefan. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerHappiness.h"


@interface ViewController ()
@property (nonatomic) int diagnosis;

@end

@implementation ViewController

@synthesize diagnosis = _diagnosis;

- (void) setAndShowDiagnosis:(int) diagnosis
{
    self.diagnosis=diagnosis;
    [self performSegueWithIdentifier:@"ShowDiagnosis" sender:self];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDiagnosis"]) {
        [segue.destinationViewController setHappiness:self.diagnosis];
    } else if ([segue.identifier isEqualToString:@"Vedeta"]) {
        [segue.destinationViewController setHappiness:100];
    } else if ([segue.identifier isEqualToString:@"Probleme"]) {
        [segue.destinationViewController setHappiness:20];
    } else if ([segue.identifier isEqualToString:@"Aparitie"]) {
        [segue.destinationViewController setHappiness:50];
    }

}

- (IBAction)flying {
    [self setAndShowDiagnosis:85];

}


- (IBAction)apple {
    [self setAndShowDiagnosis:100];

}

- (IBAction)dragons {
    [self setAndShowDiagnosis:20];

}


@end
