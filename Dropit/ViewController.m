//
//  ViewController.m
//  Dropit
//
//  Created by Paulo Gama on 23/07/16.
//  Copyright © 2016 Paulo Gama. All rights reserved.
//

#import "ViewController.h"
#import "DropitBehavior.h"

@interface ViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewGame;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) DropitBehavior *dropitBehavior;
@end

@implementation ViewController

static const CGSize DROP_SIZE = {40, 40};

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UIDynamicAnimator *)animator {
    if(!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.viewGame];
        _animator.delegate = self;
    }
    return _animator;
}

- (DropitBehavior *)dropitBehavior {
    if(!_dropitBehavior) {
        _dropitBehavior = [[DropitBehavior alloc] init];
        [self.animator addBehavior:_dropitBehavior];
    }
    return _dropitBehavior;
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    [self removeCompleteRows];
}

- (BOOL)removeCompleteRows {
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];
    
    for(CGFloat y = self.viewGame.bounds.size.height - DROP_SIZE.height/2; y > 0; y -= DROP_SIZE.height) {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [[NSMutableArray alloc] init];
       
        for(CGFloat x = DROP_SIZE.width; x <= self.viewGame.bounds.size.width-DROP_SIZE.width; x += DROP_SIZE.width) {
            UIView *hitView = [self.viewGame hitTest:CGPointMake(x, y) withEvent:NULL];
            if([hitView superview] == self.viewGame) {
                [dropsFound addObject:hitView];
            } else {
                rowIsComplete = NO;
                break;
            }
        }
       
        if (![dropsFound count]) {
            break;
        }
        
        if (rowIsComplete) {
            [dropsToRemove addObjectsFromArray:dropsFound];
        }
    }
    
    if([dropsToRemove count]) {
        for (UIView *drop in dropsToRemove) {
            [self.dropitBehavior removeItem:drop];
        }
        [self animateRemovingDrops:dropsToRemove];
    }
    
    return NO;
}

- (void)animateRemovingDrops:(NSMutableArray *)dropsToRemove {
    [UIView animateWithDuration:1.0 animations:^{
        for(UIView *drop in dropsToRemove) {
            int x = (arc4random()%(int)(self.viewGame.bounds.size.width * 5)) - (int)self.viewGame.bounds.size.width * 2;
            int y = self.viewGame.bounds.size.height;
            drop.center = CGPointMake(x, -y);
        }
    } completion:^(BOOL finished) {
        [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drop];
}

- (void)drop {
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random()%(int)self.viewGame.bounds.size.width) / DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    UIView *viewDrop = [[UIView alloc] initWithFrame:frame];
    viewDrop.backgroundColor = [self randomColor];
    [self.viewGame addSubview:viewDrop];
    
    [self.dropitBehavior addItem:viewDrop];
}

- (UIColor *) randomColor {
    switch (arc4random()%5) {
        case 0:
            return [UIColor greenColor];
            break;
        case 1:
            return [UIColor blueColor];
            break;
        case 2:
            return [UIColor orangeColor];
            break;
        case 3:
            return [UIColor redColor];
            break;
        case 4:
            return [UIColor purpleColor];
            break;
    }
    return [UIColor blackColor];
}

@end
