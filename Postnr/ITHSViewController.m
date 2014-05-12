//
//  ITHSViewController.m
//  Postnr
//
//  Created by Jyrki Rajala on 2014-05-12.
//  Copyright (c) 2014 Jyrki Rajala. All rights reserved.
//

/*
 Övningsuppgift 11
 Skriv en (ny) app där man kan skriva in ett svenskt postnummer och få reda på
  vilken stad som har det numret. Använd följande öppna api:
  http://yourmoneyisnowmymoney.com/api/zipcodes/?zipcode=42139

 Fortsättning – 1
 Om man söker på de första siffrorna i ett postnummer får man alla träffar i en
  lista. Hantera detta på ett bra sätt så att informationen visas upp tydligt
  för den som använder appen.

 Fortsättning – 2
  Json-responsen från servern ger inte bara namn på staden utan också latitud
   och longitud. Använd dessa koordinater för att visa platsen på en kart-vy
  inne i appen.

 För att kunna använda MKMapView måste maps vara påslaget i settings för
  projektet och du måste importera MapKit.h med hjälp av
  #import <MapKit/MapKit.h>
 */

#import "ITHSViewController.h"

@interface ITHSViewController ()
@property (weak, nonatomic) IBOutlet UITextView *resultView;
@property (weak, nonatomic) IBOutlet UITextField *SearchField;

@end

@implementation ITHSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[self.SearchField addTarget:self.SearchField
						 action:@selector(resignFirstResponder)
			   forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.SearchField becomeFirstResponder];
    [super viewDidAppear:animated];
}


- (IBAction)searchEnded:(id)sender {
	// [self.SearchField resignFirstResponder];
	[self SearchBtnClicked:nil];
}

- (IBAction)SearchBtnClicked:(id)sender {
	
	// Close the darn keyboard upon clickin button
	[self.view endEditing:YES];
	
//	NSString *urlStr = [NSString stringWithFormat:@"http://api.duckduckgo.com/?q=%@&format=json", self.SearchField.text ];

	NSString *urlStr = [NSString stringWithFormat:@"http://yourmoneyisnowmymoney.com/api/zipcodes/?zipcode=%@", self.SearchField.text ];

	NSURL *URL = [NSURL URLWithString:urlStr];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	
	NSURLSession *session = [NSURLSession sharedSession];
	
	NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:
								  ^(NSData *data, NSURLResponse *response, NSError *err){
									  
									  NSError *parseError;
									  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
									  
									  dispatch_async(dispatch_get_main_queue(), ^{
										  //self.resultView.text = json[@"RelatedTopics"][0][@"Text"];

										  if ([json[@"status_code"] intValue] == 100 ) {
											  self.resultView.text = json[@"results"][0][@"address"];
										  } else {
											  self.resultView.text = json[@"status_message"];
										  }
										  
									  });
									  
								  }];
	
	[task resume];

	
}


@end
