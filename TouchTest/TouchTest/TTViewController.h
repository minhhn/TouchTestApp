//
//  TTViewController.h
//  TouchTest
//
//  Created by Minh Nguyen on 8/28/12.
//  Copyright (c) 2012 Minh Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *touchesListLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
- (IBAction)tappedOnClearButton:(id)sender;

@end
