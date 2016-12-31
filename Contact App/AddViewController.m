//
//  AddViewController.m
//  Contact App
//
//  Created by Rakesh Viparla on 12/8/16.
//  Copyright © 2016 adroit37. All rights reserved.
//

#import "AddViewController.h"
#import <CoreData/CoreData.h>

@interface AddViewController ()

@end

@implementation AddViewController

@synthesize device;

-(NSManagedObjectContext *)managedObjectContext;
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.device) {
        [self.nameTxtFld setText:[self.device valueForKey:@"name"]];
        [self.mobileNumTxtFld setText:[self.device valueForKey:@"phonenumber"]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveBtn:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (self.device) {
        [self.device setValue:self.nameTxtFld.text forKey:@"name"];
        [self.device setValue:self.mobileNumTxtFld.text forKey:@"phonenumber"];
    } else {
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"ContactDetails" inManagedObjectContext:context];
        [newDevice setValue:self.nameTxtFld.text forKey:@"name"];
        [newDevice setValue:self.mobileNumTxtFld.text forKey:@"phonenumber"];
        
        NSError *error  = nil;
        if (![context save:&error]) {
            NSLog(@"%@ %@", error, [error localizedDescription]);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callBtn:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.mobileNumTxtFld.text]]];
}

- (IBAction)textBtn:(id)sender {
    
    MFMessageComposeViewController *msgComposer = [[MFMessageComposeViewController alloc]init];
    
    if ([MFMessageComposeViewController canSendText]) {
        [msgComposer setRecipients:[NSArray arrayWithObjects:self.mobileNumTxtFld.text, nil]];
        [msgComposer setBody:[NSString stringWithFormat:@"Hey %@", self.nameTxtFld.text]];
        
        [self presentViewController:msgComposer animated:YES completion:NULL];
    }else{
     
        NSLog(@"Can't Send a Text");
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Message Cancelled");
            break;
            
        case MessageComposeResultFailed:
            NSLog(@"Message Failed");
            break;
            
        case MessageComposeResultSent:
            NSLog(@"Message Sent");
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)firstResponderAction:(id)sender {
    
    [self resignFirstResponder];
}

@end