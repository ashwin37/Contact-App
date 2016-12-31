//
//  AddViewController.h
//  Contact App
//
//  Created by Rakesh Viparla on 12/8/16.
//  Copyright © 2016 adroit37. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AddViewController : UIViewController <MFMessageComposeViewControllerDelegate>

@property(strong) NSManagedObjectModel *device;

@property (strong, nonatomic) IBOutlet UITextField *nameTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *mobileNumTxtFld;


@end
