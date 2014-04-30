//
//  HomeViewController.m
//  QuickMenu
//
//  Created by Noah Martin on 4/14/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewDataSource.h"
#import "RestaurantFactory.h"
#import "MenuTabBarController.h"
#import "Restaurant.h"

#import "UIViewController+ECSlidingViewController.h"

#import "OAuthConsumer.h"

@interface HomeViewController()
@property (strong, nonatomic) CLLocationManager *locationManager;
@property double longtidude;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) HomeTableViewDataSource *tableController;
@property (strong, nonatomic) NSMutableArray* data; // The resturants from Yelp
@property (strong, nonatomic) NSURLConnection *conn;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) RestaurantFactory* factory;
@property double latitude;
@property (strong, nonatomic) NSMutableArray *searchData;
@property (strong, nonatomic) NSOperationQueue *searchQueue;
@end

NSString* consumer_key = @"iIixPO3MfoeJp2NOyTlpVw";
NSString* consumer_secret = @"LOn-ZnCRWv_4xU_4-CR0Zjf6CmU";
NSString* token_key = @"f_MXBL42HAdYTfSP4bGx0WOxGYuFPr60";
NSString* token_secret = @"ob9tIi9tc40InGRM-qPtfwVrTYc";

@implementation HomeViewController

-(RestaurantFactory*)factory
{
    if(!_factory)
    {
        return _factory = [[RestaurantFactory alloc] initWithDelegate:self];
    }
    return _factory;
}

-(NSMutableArray*)searchData
{
    if(!_searchData)
        return _searchData = [[NSMutableArray alloc] init];
    return _searchData;
}

-(NSOperationQueue*)searchQueue
{
    if(!_searchQueue)
    {
        return _searchQueue = [NSOperationQueue new];
    }
    return _searchQueue;
}

-(CLLocationManager*)locationManager
{
    if(_locationManager)
        return _locationManager;
    return _locationManager = [[CLLocationManager alloc] init];
}

-(void)viewDidLoad
{
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.tableController = [[HomeTableViewDataSource alloc] init];
    self.refreshControl = [[UIRefreshControl alloc]
                                        init];
    [self.refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    
    [self.table setDataSource:self.tableController];
    [self.table setDelegate:self.tableController];
    
    [self.locationManager startUpdatingLocation];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    self.slidingViewController.customAnchoredGestures = @[];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
}



-(void)refreshView:(UIRefreshControl*)refresh
{
    if([CLLocationManager locationServicesEnabled])
    {
        [self.locationManager startUpdatingLocation];
    }
    else
        [self.refreshControl endRefreshing];
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
    self.data = [self.factory restaurantsForData:self.responseData withOldList:self.data];
    // TODO: at this point our api should be called on the list of restuarts to get a list of menus or null if the menu is not found
    // Then the menus that are not found should be removed and everything else should be stored by this class
    self.tableController.restaurants = self.data;
    [self.table reloadData];
    self.tableController.error = NO_ERROR;  // Clear any error on the table
    self.responseData = NULL;  // Stop referencing this for the GC
    
    [self.refreshControl endRefreshing];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.refreshControl endRefreshing];
    self.tableController.error = NO_INTERNET;
    [self.table reloadData];
}

-(void)updateYelp
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.yelp.com/v2/search?category_filter=food,restaurants&limit=10&sort=1&ll=%f,%f", self.latitude, self.longtidude]];
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:consumer_key secret:consumer_secret];
    OAToken *token = [[OAToken alloc] initWithKey:token_key secret:token_secret];
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    NSString *realm = nil;
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    [request prepare];
    
    _responseData = [[NSMutableData alloc] init];

    (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.tableController.error = NO_LOCATION;
    [self.table reloadData];
	[self.refreshControl endRefreshing];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showMenuSegue"])
    {
        MenuTabBarController* newController = ((MenuTabBarController*) segue.destinationViewController);
        Restaurant *r = (Restaurant*)[self.data objectAtIndex:[self. table indexPathForCell:(UITableViewCell*)sender].row];
        newController.title = r.title;
        newController.menu = r.menu;
        [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
    }
}

-(void)loadedDataForId:(NSString *)identifier
{
    [self.table performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchData count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    Restaurant* res = ((Restaurant*)[self.searchData objectAtIndex:indexPath.row]);
    cell.textLabel.text = res.title;
    cell.detailTextLabel.text = res.location;
    return cell;
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.yelp.com/v2/search?term=%@&ll=%f,%f&limit=10", searchString, self.latitude, self.longtidude]];
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:consumer_key secret:consumer_secret];
    OAToken *token = [[OAToken alloc] initWithKey:token_key secret:token_secret];
    
    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    NSString *realm = nil;
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    [request prepare];
    [self.searchQueue cancelAllOperations];
    [self.searchQueue addOperationWithBlock:^{
        NSArray* data = [self.factory loadRestaurantsForData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.searchData removeAllObjects];
            [self.searchData addObjectsFromArray:data];
            [controller.searchResultsTableView reloadData];
        }];
    }];
    return NO;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self.searchQueue cancelAllOperations];
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

@end
