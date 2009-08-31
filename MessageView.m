//
//  MessageView.m
//  OrangeCat
//
//  Created by aa on 8/31/09.
//  Copyright 2009 Yammer, Inc. All rights reserved.
//

#import "MessageView.h"

@implementation MessageView

- (NSCollectionViewItem *)newItemForRepresentedObject:(id)object {
  
  // Get a copy of the item prototype, set represented object
  NSCollectionViewItem *newItem = [[self itemPrototype] copy];
  [newItem setRepresentedObject:object];
  
  // Get the new item's view so you can mess with it
  NSView *itemView = [newItem view];
  
  //
  // add your controls to the view here, bind, etc
  //
  
  return newItem;
}

@end
