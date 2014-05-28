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
#import "MEDynamicTransition.h"
#import "MenyouApi.h"
#import "CategoryViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "Categories.h"
#import "TopDishesViewController.h"

#import "OAuthConsumer.h"

@interface HomeViewController() <MenyouApiDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property double longtidude;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) HomeTableViewDataSource *tableController;
@property (strong, nonatomic) NSMutableArray* data; // The resturants from Yelp
@property (strong, nonatomic) NSURLConnection *conn;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) RestaurantFactory* factory;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property double latitude;
@property (strong, nonatomic) NSMutableArray *searchData;
@property (strong, nonatomic) NSOperationQueue *searchQueue;
@property MEDynamicTransition* dynamicTransition;
@property BOOL loadingYelp;
@property UIActivityIndicatorView *activityIndicator;
@property BOOL isUpdating;
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

-(HomeTableViewDataSource*)tableController
{
    if(_tableController)
        return _tableController;
    return _tableController = [[HomeTableViewDataSource alloc] init];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(becameActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [MenyouApi getInstance].delegate = self;
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.refreshControl = [[UIRefreshControl alloc]
                                        init];
    [self.refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    
    [self.table setDataSource:self.tableController];
    [self.table setDelegate:self.tableController];
    
    self.isUpdating = YES;
    [self.locationManager startUpdatingLocation];
    
    self.dynamicTransition = [[MEDynamicTransition alloc] init];

    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.color = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //start the loading indicator until the list of restaurants is loaded
    self.activityIndicator.center = self.view.center;
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
}

-(void)becameActive
{
    if(!self.isUpdating)
    {
        self.isUpdating = YES;
        [self.locationManager startUpdatingLocation];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.dynamicTransition.slidingViewController = self.slidingViewController;
    self.slidingViewController.delegate = self.dynamicTransition;
    
    self.dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.slidingViewController.delegate action:@selector(handlePanGesture:)];
    
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
    self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
    [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //code to remove highlight when going back
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}
-(void)refreshView:(UIRefreshControl*)refresh
{
    if([CLLocationManager locationServicesEnabled] && !self.isUpdating)
    {
        self.isUpdating = YES;
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
    self.responseData = NULL;  // Stop referencing this for the GC
}

-(void)loadedMenus
{
    self.tableController.restaurants = self.data;
    self.tableController.error = NO_ERROR;  // Clear any error on the table
    [self.table reloadData];
    [self.refreshControl endRefreshing];
    
    if(self.activityIndicator.isAnimating)
    {
        //Once the app is done displying the restaurants, stop the loading indicator
        [self.activityIndicator stopAnimating];
        [self.activityIndicator removeFromSuperview];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.refreshControl endRefreshing];
    self.tableController.error = NO_INTERNET;
    [self.table reloadData];
    
    if(self.activityIndicator.isAnimating)
    {
        //Once the app is done displying the restaurants, stop the loading indicator
        [self.activityIndicator stopAnimating];
        [self.activityIndicator removeFromSuperview];
    }
}

-(void)updateYelp
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.yelp.com/v2/search?category_filter=food,restaurants&sort=1&ll=%f,%f", self.latitude, self.longtidude]];
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

    self.loadingYelp = YES;
    [self.conn cancel];
    self.conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.isUpdating = NO;
    self.tableController.error = NO_LOCATION;
    [self.table reloadData];
	[self.refreshControl endRefreshing];
    
    if(self.activityIndicator.isAnimating)
    {
        //When the app can't determine the loc, stop animating
        [self.activityIndicator stopAnimating];
        [self.activityIndicator removeFromSuperview];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.isUpdating = NO;
    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLocation = newLocation;

    if (currentLocation != nil && ([self.refreshControl isRefreshing] || (oldLocation == nil || [newLocation distanceFromLocation:oldLocation] >= 100))) {
        self.longtidude = currentLocation.coordinate.longitude;
        self.latitude = currentLocation.coordinate.latitude;
        [self updateYelp];
    }
}

-(void)loginStatusChagned
{
    for(Restaurant* r in self.data)
    {
        [r reloadReviews];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showMenuSegue"])
    {
        MenuTabBarController* newController = ((MenuTabBarController*) segue.destinationViewController);
        Restaurant* r;
        if(self.searchDisplayController.active)
        {
            r = [self.searchData objectAtIndex:[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow].row];
        } else {
            r = (Restaurant*)[self.data objectAtIndex:[self. table indexPathForCell:(UITableViewCell*)sender].row];
        }
        newController.title = r.title;
        newController.restaurant = r;
        NSMutableArray* controllers = [[NSMutableArray alloc] init];
        TopDishesViewController* top = [self.storyboard instantiateViewControllerWithIdentifier:@"TopDishesViewController"];
        [top setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0]];
        top.menu = r.menu;
        top.restaurant = r.identifier;
        [controllers addObject:top];
        for(Categories* cat in r.menu.categories)
        {
            CategoryViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:
                                                  @"CategoryViewController"];
            [controller setTitle:@"theseafoods"];
            [controllers addObject:controller];
            [newController setViewControllers:controllers];

        	/*CategoryViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:
                                                  @"CategoryViewController"];
         	controller.title = cat.title;
            controller.category = cat;
            controller.restaurant = r.identifier;
         	[controllers addObject:controller];*/
        }
       
        
       /* CategoryViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:
                                              @"CategoryViewController"];
        [controller setTitle:@"theburgers"];
        [controllers addObject:controller];*/
         [newController setViewControllers:controllers];
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

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    Restaurant* temp = [self.searchData objectAtIndex:[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow].row];
    
    //Getting the menu for the selected restaurant from search
    if (!temp.menu) {
        [[MenyouApi getInstance] getMenuForId: temp.identifier withBlock:^(Menu *menu) {
            [self.activityIndicator stopAnimating];
            [self.activityIndicator removeFromSuperview];
            //if the menu exists
            if(menu != nil)
            {
                //setting the selected restaurants menu
                temp.menu = menu;
                
                //calling the seque
                [self performSegueWithIdentifier:@"showMenuSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
            }
            else //else the menu doesn't exist
            {
                //popup that notifies the user
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle:@"No menu for this restaurant" message:@"This restarant has not yet created a Menyou." delegate:self cancelButtonTitle:@"Return" otherButtonTitles:@"Create a Menyou", nil];
                
                [errorAlert show];
            }
        }];
        self.activityIndicator.center = self.view.center;
        [self.view addSubview:self.activityIndicator];
        [self.activityIndicator startAnimating];
    }
    else
        [self performSegueWithIdentifier:@"showMenuSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //Return button, goes back to screen
    if(buttonIndex == 0){
        // back to the menu
    }
    else{ //Other button takes user to website
        NSURL *url = [NSURL URLWithString:@"http://www.menyouapp.com"];
        //First check if the website can be opened
        bool temp = [[UIApplication sharedApplication] canOpenURL:url];
        
        //If the website does exists, go to it
        if (temp) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
@end
