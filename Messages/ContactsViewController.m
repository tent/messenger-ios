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

    _blankView = [[UIView alloc] init];

    _contactNames = @[@"Albert Branton", @"Albertine Athens", @"Andreas Gullickson", @"Andreas Mapes", @"Birdie Slye", @"Birgit Amaya", @"Bobby Pringle", @"Bryan Bowley", @"Burt Dejean", @"Carlos Mcvicker", @"Carmine Broad", @"Clark Prude", @"Clemente Salinas", @"Clora Calmes", @"Clorinda Stokely", @"Cory Dunnigan", @"Dario Reid", @"Derick Greenberg", @"Donita Broad", @"Drema Rushin", @"Dwayne Akers", @"Dwight Cawthon", @"Earnest Ashburn", @"Efren Stauber", @"Ela Cockrell", @"Eli Domino", @"Elias Omara", @"Elliott Kemble", @"Ellsworth Gambill", @"Erin Trudell", @"Exie Oquin", @"Fidel Delong", @"Franklyn Pavlik", @"Fredrick Strauss", @"Gabriel Melugin", @"Hien Hoffmann", @"Hilario Luken", @"Huong Willaims", @"Inell Mcgregor", @"Jacob Alspaugh", @"Jere Densmore", @"Jerrell Krug", @"Joan Tarrance", @"Jolene Juneau", @"Junior Isherwood", @"Justin Mendonca", @"Kristel Deyo", @"Kyla Kuehn", @"Leif Wall", @"Long Gensler", @"Loyd Steven", @"Lucy Lumpkin", @"Luigi Hanning", @"Luz Cabot", @"Myong Forsman", @"Myrtle Dimarco", @"Nora Mandez", @"Norah Peat", @"Omer Oakes", @"Otha Pietrowski", @"Philip Bourquin", @"Phillis Ojeda", @"Qiana Qualls", @"Ramiro Nipper", @"Randal Harriss", @"Reid Shah", @"Reuben Colby", @"Riley Hippler", @"Rolando Rushford", @"Rosenda Boller", @"Ruth Cardoso", @"Scott Swindle", @"Sharon Weinstein", @"Shawanda Tunney", @"Sid Pettigrew", @"Stephan Izzard", @"Teodoro Mckain", @"Tiffany Austell", @"Tobias Varley", @"Una Umana", @"Vaughn Torre", @"Vina Chynoweth", @"Vincenzo Friberg", @"Warren Edgley"];

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return _contactNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

/*- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [_contactNames objectAtIndex:[indexPath indexAtPosition:0]];
    cell.multipleSelectionBackgroundView = _blankView;
    
    UIImage *avatar = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", [indexPath indexAtPosition:0] + 1]];
    avatar = [avatar thumbnailImage:cell.frame.size.height transparentBorder:2 cornerRadius:6 interpolationQuality:kCGInterpolationHigh];
    
    NSLog(@"cell dimentions{ width: %f height: %f }", cell.frame.size.width, cell.frame.size.height);
    
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
