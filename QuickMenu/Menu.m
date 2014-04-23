//
//  Menu.m
//  Menyou
//
//  Created by Noah Martin on 4/21/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "Menu.h"

@implementation Menu

-(int)numberSelected
{
    int count = 0;
    for(id Obj in self.menu)
    {
        // TODO: actually make sure it is selected
        count++;
    }
    return count;
}

@end
