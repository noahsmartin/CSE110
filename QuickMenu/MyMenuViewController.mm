//
//  MyMenuViewController.m
//  Menyou
//
//  Created by Noah Martin on 4/22/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "MyMenuViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "Dish.h"
#import "QREncoder.h"
#import "DataMatrix.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface MyMenuViewController()
@property UIImage* img;
@end

@implementation MyMenuViewController

-(void)viewDidLoad
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(self.img)
    {
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[self.restaurant.title, self.img] applicationActivities:nil];
        [self presentViewController:activityController animated:YES completion:nil];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.img = nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.restaurant.menu.numberSelected + 1 + 2;
}

- (IBAction)share:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                               initWithTitle:@"Share your meal!" message:@"Would you like to add a picture?" delegate:self cancelButtonTitle:@"No picture" otherButtonTitles:@"Take a picture", nil];
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[self.restaurant.title] applicationActivities:nil];
        [self presentViewController:activityController animated:YES completion:nil];    }
    else {
        if(![self startCameraControllerFromViewController:self usingDelegate:self])
        {
            [[[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Could not find a camera for your device" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.img = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:^{}];
    return YES;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier;
    UITableViewCell *cell;
    if(indexPath.row <= self.restaurant.menu.numberSelected)
    {
        simpleTableIdentifier = @"priceCell";
    }
    else
    {
        simpleTableIdentifier = @"QRCodeCell";
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if(indexPath.row < self.restaurant.menu.numberSelected)
    {
        Dish* d = [self.restaurant.menu selectedItems][indexPath.row];
        cell.textLabel.text = d.title;
        cell.detailTextLabel.text = d.price;
    }
    else if(indexPath.row == self.restaurant.menu.numberSelected)
    {
        cell.textLabel.text = @"Total:";
        cell.detailTextLabel.text = [self.restaurant.menu.totalCost stringValue];
    }
    else
    {
        //the qrcode is square. now we make it 250 pixels wide
        int qrcodeImageDimension = 250;
        
        //the string can be very long
        NSMutableArray* dishes = [NSMutableArray array];
        for(Dish* d in [self.restaurant.menu selectedItems])
        {
            [dishes addObject:[NSNumber numberWithInt:d.identifier]];
        }
        NSDictionary* dict = @{@"name": self.restaurant.title, @"dishes": dishes};
        NSData* d = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
        
        NSString* toEncode = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
        
        //first encode the string into a matrix of bools, TRUE for black dot and FALSE for white. Let the encoder decide the error correction level and version
        DataMatrix* qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:toEncode];
        
        //then render the matrix
        UIImage* qrcodeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:qrcodeImageDimension];
        ((UIImageView*) cell.contentView.subviews[0]).image = qrcodeImage;
    }
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


@end
