//
//  ConversationsViewController.m
//  Messages
//
//  Created by Jesse on 7/20/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "ConversationsViewController.h"
#import "UIImage+Resize.h"

@interface ConversationsViewController ()

@end

@implementation ConversationsViewController

- (void)handleConversationTap:(id)sender {
    [self performSegueWithIdentifier:@"loadConversation" sender:self];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    id ret = [super initWithCoder:decoder];

    conversations = @[

                      @{
                          @"name": @"Agatha Salvato",
                          @"messageBody": @"Cumque pariatur consectetur rerum earum. Tenetur excepturi magnam explicabo deserunt ipsa distinctio",
                          @"timestamp": @"3:45 PM"

                          },

                      @{
                          @"name": @"Concetta Turmelle",
                          @"messageBody": @"Velit provident fugiat. Voluptatem sunt occaecati qui. Accusantium laboriosam fugit rerum nulla magnam consequatur qui.",
                          @"timestamp": @"Yesterday"

                          },

                      @{
                          @"name": @"Drema Rushin",
                          @"messageBody": @"Iure asperiores sapiente. Ipsa autem illo quis amet porro esse ut. Nemo nam assumenda ut iure.",
                          @"timestamp": @"Yesterday"

                          },

                      @{
                          @"name": @"Howard Trembley",
                          @"messageBody": @"Ullam ut omnis modi quae esse reiciendis quam. Et voluptas sit asperiores facilis.",
                          @"timestamp": @"3:45 PM"

                          },

                      @{
                          @"name": @"Myong Forsman",
                          @"messageBody": @"Dolore eos pariatur. Aut sunt ad fugit delectus. Labore recusandae autem ducimus. Maiores et reprehenderit.",
                          @"timestamp": @"17/3/13"

                          },

                      @{
                          @"name": @"Tiffany Austell",
                          @"messageBody": @"Blanditiis mollitia et temporibus provident.",
                          @"timestamp": @"17/3/13"

                          }
                      ];

    return ret;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:<#(SEL)#>];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"conversationCell";
    ConversationsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSDictionary *conversation = [conversations objectAtIndex:[indexPath indexAtPosition:1]];
    cell.name = conversation[@"name"];
    cell.messageBody = conversation[@"messageBody"];
    cell.timestamp = conversation[@"timestamp"];

    UIImage *avatar = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", ([indexPath indexAtPosition:0] * 2) + [indexPath indexAtPosition:1] + 1]];
    avatar = [avatar thumbnailImage:60 transparentBorder:0 cornerRadius:3 interpolationQuality:kCGInterpolationHigh];

    cell.imageView.image = avatar;

    UIGestureRecognizer *tapParent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleConversationTap:)];
    [cell addGestureRecognizer:tapParent];

    return cell;
}

@end
