//
//  FileViewController.m
//  DIOSExample
//
//  Created by Kyle Browning on 10/11/10.
//  Copyright 2010 Grasscove. All rights reserved.
//

#import "FileViewController.h"
#import "DIOSFile.h"
#import "NSData+Base64.h"
#import "DIOSExampleAppDelegate.h"
@implementation FileViewController
@synthesize imageData;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  delegate = (DIOSExampleAppDelegate*)[[UIApplication sharedApplication] delegate];
}

-(IBAction) getFile:(id) sender {
  [imageViewGet setImage:nil];
  DIOSFile *aFile = [[DIOSFile alloc] initWithSession:[delegate session]];
  [aFile fileGet:[fileIdField text]];
  NSData *returnedImageData = [NSData dataFromBase64String:[[[aFile connResult] objectForKey:@"#data"] objectForKey:@"file"]];
  [imageViewGet setImage:[UIImage imageWithData:returnedImageData]];
  [responseStatus setText:[aFile responseStatusMessage]];
  [urlLabel setText:[aFile methodUrl]];
  [aFile release];
}
-(IBAction) getNodeFiles:(id) sender {
  DIOSFile *aFile = [[DIOSFile alloc] initWithSession:[delegate session]];
  [aFile fileGetNodeFiles:[nodeIdField text]];
  [self displayDebugDIOS:aFile];
  [aFile release];
}
-(IBAction) getPhoto:(id) sender {
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
  picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
  
  popover = [[UIPopoverController alloc]
             initWithContentViewController:picker];
  [popover presentPopoverFromRect:CGRectMake(280, 0, 200, 100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[popover dismissPopoverAnimated:YES];
  imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
  imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],1)];
  [uploadButton setHidden:NO];
}
-(IBAction) uploadPhoto {
  DIOSFile *aFile = [[DIOSFile alloc] initWithSession:[delegate session]];
  NSMutableDictionary *file = [[NSMutableDictionary alloc] init];
  
  NSString *base64Image = [imageData base64EncodedString];
  [file setObject:base64Image forKey:@"file"];
  [file setObject:@"sites/default/files/temp.jpg" forKey:@"filepath"];
  [file setObject:@"temp.jpg" forKey:@"filename"];
  [aFile fileSave:file];  
  [self displayDebugDIOS:aFile];
  imageView.image = nil;
  [aFile release];
}
- (void) displayDebugDIOS:(id)aDIOSConnect {
  
  [responseStatus setText:[aDIOSConnect responseStatusMessage]];
  [responseView setText:[NSString stringWithFormat:@"%@", [aDIOSConnect connResult]]];
  [urlLabel setText:[aDIOSConnect methodUrl]];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Overriden to allow any orientation.
  return NO;
}


- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}


- (void)dealloc {
  [super dealloc];
}


@end
