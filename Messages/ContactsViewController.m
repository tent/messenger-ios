//
//  ContactsViewController.m
//  Messages
//
//  Created by Jesse on 7/21/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "ContactsViewController.h"
#import "UIImage+Resize.h"

@interface ContactsViewController ()
@end

@implementation ContactsViewController


- (id)initWithCoder:(NSCoder *)decoder
{
    id ret = [super initWithCoder:decoder];

    blankView = [[UIView alloc] init];

    contactNames = @[@"Agatha Aguas", @"Agatha Salvato", @"Beula Allshouse", @"Birdie Slye", @"Clorinda Stokely", @"Concetta Turmelle", @"Drema Rushin", @"Dulce Bridges", @"Ericka Nigro", @"Erinn Woolum", @"Franklyn Pavlik", @"Fredrick Strauss", @"Granville Kilmon", @"Guadalupe Sabella", @"Howard Trembley", @"Huong Willaims", @"Ingeborg Chmielewski", @"Irena Winger", @"Julian Mcswain", @"Junior Isherwood", @"Krysten Slayden", @"Kyla Kuehn", @"Lucy Lumpkin", @"Luz Cabot", @"Myong Forsman", @"Myrtle Dimarco", @"Norah Peat", @"Norine Pfau", @"Odilia Mary", @"Omer Oakes", @"Paulette Buttram", @"Phillis Ojeda", @"Qiana Qualls", @"Quanp Mauch", @"Rubi Moseley", @"Ruth Cardoso", @"Shawanda Tunney", @"Stefany Pettit", @"Tiffany Austell", @"Tonia Mcclung", @"Una Umana", @"Uno Kuehn", @"Vina Chynoweth", @"Vina Vancamp", @"Wally Halliday", @"Willa Carl", @"Xanna July", @"Xmar Hack", @"Yadira Yarnell", @"Yen Meuser", @"Zachariah Vento", @"Zetta Fromm"];
    
    groupNames = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];

    return ret;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView setEditing:YES animated:NO];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
    return groupNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return groupNames;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

/*- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [contactNames objectAtIndex:([indexPath indexAtPosition:0] * 2) + [indexPath indexAtPosition:1]];
    cell.multipleSelectionBackgroundView = blankView;
    
    UIImage *avatar = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", ([indexPath indexAtPosition:0] * 2) + [indexPath indexAtPosition:1] + 1]];
    avatar = [avatar thumbnailImage:40 transparentBorder:0 cornerRadius:3 interpolationQuality:kCGInterpolationHigh];
    
    cell.imageView.image = avatar;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
