//
//  DropitBehavior.h
//  Dropit
//
//  Created by Paulo Gama on 23/07/16.
//  Copyright © 2016 Paulo Gama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropitBehavior : UIDynamicBehavior

- (void)addItem:(id<UIDynamicItem>)item;
- (void)removeItem:(id<UIDynamicItem>)item;

@end
