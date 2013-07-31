//
//  ConversationTitleView.h
//  Messages
//
//  Created by Jesse on 7/22/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationDataSource.h"

@interface ConversationTitleView : UIView
{
    ConversationDataSource *dataSource;
}

- (id)initWithFrame:(CGRect)frame withDataSource:(ConversationDataSource *)source;
@end
