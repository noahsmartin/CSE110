//
//  HomeViewController.m
//  QuickMenu
//
//  Created by Noah Martin on 4/14/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewController.h"

@interface HomeViewController()
@property CLLocationManager *locationManager;
@property double longtidude;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) HomeTableViewController *tableController;
@property (strong, nonatomic) NSMutableArray* data;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSURLConnection *conn;
@property (strong, nonatomic) NSMutableData *responseData;
@property double latitude;
@end

@implementation HomeViewController

-(void)viewDidLoad
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.tableController = [[HomeTableViewController alloc] init];
    self.tableController.titles = self.data;
    self.refreshControl = [[UIRefreshControl alloc]
                                        init];
    [self.refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:self.refreshControl];
    
    [self.table setDataSource:self.tableController];
    [self.table setDelegate:self.tableController];
    
    [self.locationManager startUpdatingLocation];

}

-(void)refreshView:(UIRefreshControl*)refresh
{
    [self.locationManager startUpdatingLocation];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:nil];
    [self.data removeAllObjects];
    for(NSDictionary *item in [json objectForKey:@"businesses"])
    {
        [self.data addObject:[item objectForKey:@"name"]];
    }
    [self.table reloadData];
    NSLog(@"%@", self.data);
    self.responseData = NULL;
    
    [self.refreshControl endRefreshing];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // TODO: handle this fail
}

-(NSMutableArray*)data
{
    if(_data)
        return _data;
    return _data = [[NSMutableArray alloc] init];
}

-(void)updateYelp
{

    NSString *urlString = [NSString stringWithFormat:@"http://api.yelp.com/business_review_search?&term=resturants&lat=%f&long=%f&ywsid=TjLyB3gigHVB2autBdRLJg", self.latitude, self.longtidude];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [self.conn cancel];
    self.conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        self.longtidude = currentLocation.coordinate.longitude;
        self.latitude = currentLocation.coordinate.latitude;
    }
    [self.locationManager stopUpdatingLocation];

    [self updateYelp];
}

@end
