//
//  TTViewController.m
//  TouchTest
//
//  Created by Minh Nguyen on 8/28/12.
//  Copyright (c) 2012 Minh Nguyen. All rights reserved.
//

#import "TTViewController.h"

@interface TTViewController ()
@end

@implementation TTViewController
@synthesize touchesListLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setMultipleTouchEnabled:YES];
}

- (void)viewDidUnload
{
    [self setTouchesListLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

static BOOL trackingAnEvent = NO;

static NSUInteger firstTouchTime;
static NSUInteger numberOfTouches;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (trackingAnEvent == NO)
    {
        firstTouchTime = [[NSDate date] timeIntervalSince1970];
        trackingAnEvent = YES;
        numberOfTouches = [touches count];
    }
    else if ([[NSDate date] timeIntervalSince1970] - firstTouchTime < 500)
    {
        trackingAnEvent = YES;
        numberOfTouches += [touches count];
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInView:self.view];
        CGPoint prevLocation = [touch previousLocationInView:self.view];
        if (fabs(location.x - prevLocation.x) + fabs(location.y - prevLocation.y) > 10)
        {
            trackingAnEvent = NO;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    static NSMutableArray *touchesLocation = nil;
    if (touchesLocation == nil)
    {
        touchesLocation = [[NSMutableArray alloc] initWithCapacity:10];
    }
    if (trackingAnEvent == NO)
    {
        numberOfTouches = 0;
        [touchesLocation removeAllObjects];
        return;
    }
    
    for (UITouch *touch in touches)
    {
        CGPoint touchLocation = [touch locationInView:self.view];
        [touchesLocation addObject:[NSString stringWithFormat:@"Position: {x:%.0f, y:%.0f}", touchLocation.x, touchLocation.y]];
    }
    
    numberOfTouches -= [touches count];
    if (numberOfTouches == 0)
    {   
        if ([[NSDate date] timeIntervalSince1970] - firstTouchTime < 2000)
        {
            NSMutableString *touchesInfo = [[NSMutableString alloc] init];
            [touchesInfo appendFormat:@"Number of touches: %d", [touchesLocation count]];
            for (NSString *touchLocationString in touchesLocation)
            {
                [touchesInfo appendFormat:@"\n%@", touchLocationString];
            }
            [touchesLocation removeAllObjects];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.touchesListLabel.text = touchesInfo;
            });
        }
        trackingAnEvent = NO;
    }
}

@end
