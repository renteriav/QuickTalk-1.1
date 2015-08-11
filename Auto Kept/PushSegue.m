//
//  PushSegue.m
//  Culdesac
//
//  Created by Kamal Mittal on 18/08/14.
//
//

#import "PushSegue.h"

@implementation PushSegue

- (void) perform {
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    [[sourceViewController navigationController] pushViewController:destinationViewController animated:FALSE];
}
@end
