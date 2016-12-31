//
//  TableViewController.m
//  Contact App
//
//  Created by Rakesh Viparla on 12/7/16.
//  Copyright © 2016 adroit37. All rights reserved.
//

#import "TableViewController.h"
#import "AddViewController.h"
#import <CoreData/CoreData.h>

@interface TableViewController ()
@property (strong, nonatomic) NSMutableArray *contactsArray;

@end

@implementation TableViewController

-(NSManagedObjectContext *)managedObjectContext;
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSManagedObjectContext *managedObjContext = [self managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"ContactDetails"];
    self.contactsArray = [[managedObjContext executeFetchRequest:fetch error:nil] mutableCopy];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSManagedObjectModel *device = [self.contactsArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [device valueForKey:@"name"]]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@", [device valueForKey:@"phonenumber"]]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
    NSManagedObjectContext *context  = [self managedObjectContext];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [context deleteObject:[self.contactsArray objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"%@ %@", error, [error localizedDescription]);
        }
    }
    [self.contactsArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([[segue identifier] isEqualToString:@"UpdateContact"]) {
        
        NSManagedObjectModel *selectedDevice = [self.contactsArray objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        AddViewController *addView = segue.destinationViewController;
        addView.device = selectedDevice;
    }
}

@end