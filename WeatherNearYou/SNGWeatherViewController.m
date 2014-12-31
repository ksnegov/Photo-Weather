//
//  SNGWeatherViewController.m
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 12/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SNGWeatherViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SNGWeatherViewModel.h"
#import "SNGWeatherForecastViewModel.h"
#import "SNGPhotosViewModel.h"

@interface SNGWeatherViewController() <CLLocationManagerDelegate, SNGWeatherViewModelDelegate, SNGPhotosViewModelDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) SNGWeatherViewModel *weather;
@property (strong, nonatomic) SNGPhotosViewModel *photos;
@property (nonatomic, getter=isPlayingPhotos) BOOL playingPhotos;
@property (nonatomic, getter=shouldRefreshData) BOOL refreshData;

@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherConditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudsLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunriseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIScrollView *forecastScrollView;

@end

@implementation SNGWeatherViewController

#pragma mark -
#pragma mark Constants

static const double SNGWeatherViewControllerLocationAccuracy = 500;
static const NSTimeInterval SNGWeatherViewControllerPhotoTimeTransitionChange = 2;
static const NSTimeInterval SNGWeatherViewControllerChangeInterval = 4;

#pragma mark -
#pragma mark Getters

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.distanceFilter = SNGWeatherViewControllerLocationAccuracy;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (SNGPhotosViewModel *)photos {
    if (!_photos) {
        _photos = [[SNGPhotosViewModel alloc] init];
        _photos.delegate = self;
    }
    return _photos;
}

- (SNGWeatherViewModel *)weather {
    if (!_weather) {
        _weather = [[SNGWeatherViewModel alloc] init];
        _weather.delegate = self;
    }
    return _weather;
}

- (NSTimer *)photoTimerWithInterval:(NSTimeInterval)interval {
    return [NSTimer timerWithTimeInterval:interval target:self.photos selector:@selector(requestRandomPhoto) userInfo:nil repeats:NO];
}

#pragma mark -
#pragma mark Setters

- (void)setCurrentLocation:(CLLocation *)currentLocation {
    double distance = (!_currentLocation) ? SNGWeatherViewControllerLocationAccuracy : [_currentLocation distanceFromLocation:currentLocation];
    _currentLocation = currentLocation;
    
    if (distance >= SNGWeatherViewControllerLocationAccuracy) {
        NSLog(@"New location");
        
        // Update weather
        self.weather.latitude = currentLocation.coordinate.latitude;
        self.weather.longitude = currentLocation.coordinate.longitude;
        [self.weather requestWeather];
        
        // Update photos
        self.photos.latitude = currentLocation.coordinate.latitude;
        self.photos.longitude = currentLocation.coordinate.longitude;
        
        if (!self.playingPhotos) {
            self.playingPhotos = YES;
            [self startPhotoSlideshowWithInterval:0];
        }
    }
}

#pragma mark -
#pragma mark UI

/// Update UI
- (void)updateUI {
    if (self.weather) {
        self.placeNameLabel.text = @"";//self.weather.placeName;
        
        self.temperatureLabel.text = self.weather.temperature;
        self.weatherConditionLabel.text = self.weather.conditionName;
        self.cloudsLabel.text = self.weather.clouds;
        self.humidityLabel.text = self.weather.humidity;
        self.pressureLabel.text = self.weather.pressure;
        self.windLabel.text = self.weather.wind;
        self.sunriseLabel.text = self.weather.sunriseTime;
        self.sunsetLabel.text = self.weather.sunsetTime;
    }
    
    /// TODO: show forecast
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0  ||  scrollView.contentOffset.y < 0 )
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
}

#pragma mark -
#pragma mark SNGPhotosViewModelDelegate

/// Call this method when new photo arrived
- (void)photoDidRecieved {
    
    UIColor *color = [self.photos preferredTextColor];

    self.settingsButton.tintColor = color;
    
    [UIView transitionWithView:self.view duration:SNGWeatherViewControllerPhotoTimeTransitionChange options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.background.image = self.photos.photo;
        
        self.placeNameLabel.textColor = color;
        self.temperatureLabel.textColor = color;
        self.weatherConditionLabel.textColor = color;
        self.cloudsNameLabel.textColor = color;
        self.cloudsLabel.textColor = color;
        self.humidityNameLabel.textColor = color;
        self.humidityLabel.textColor = color;
        self.pressureNameLabel.textColor = color;
        self.pressureLabel.textColor = color;
        self.windNameLabel.textColor = color;
        self.windLabel.textColor = color;
        self.sunriseNameLabel.textColor = color;
        self.sunriseLabel.textColor = color;
        self.sunsetNameLabel.textColor = color;
        self.sunsetLabel.textColor = color;
        
        if (self.shouldRefreshData) {
            [self updateUI];
            self.refreshData = NO;
        }
    } completion:^(BOOL result) {
        [self startPhotoSlideshowWithInterval:SNGWeatherViewControllerChangeInterval];
    }];
}

#pragma mark -
#pragma mark SNGWeatherViewModelDelegate

/// Call this method when we recieved weather from model
- (void)weatherDidRecieved {
    if (self.playingPhotos) {
        self.refreshData = YES;
    } else {
        [self updateUI];
    }
}

/// Call this method when error occurs during downloading weather
- (void)weatherDidFailureRequest:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Weather downloading", nil) message:NSLocalizedString(@"Can't get weather", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = [locations lastObject];
}

#pragma mark -
#pragma mark Timer

/// Add photo timer with interval to NSDefaultRunLoop
- (void)startPhotoSlideshowWithInterval:(NSTimeInterval)interval {
    if (self.isPlayingPhotos) {
        [[NSRunLoop mainRunLoop] addTimer:[self photoTimerWithInterval:interval] forMode:NSDefaultRunLoopMode];
    }
}

#pragma mark -
#pragma mark Tracking location

/// Start tracking location. Ask permissions for it
- (void)startTrackingLocation {
    NSString *error;
    
    if (![CLLocationManager locationServicesEnabled]) {
        error = NSLocalizedString(@"Location service disabled", nil);
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        error = NSLocalizedString(@"The app doesn't have permissions for using location", nil);
    }
    
    if (error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Location error", nil) message:error preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        UIAlertAction *settingAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        
        [alert addAction:defaultAction];
        [alert addAction:settingAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

/// Stop tracking location
- (void)stopTrackingLocation {
    [self.locationManager stopUpdatingLocation];
    self.playingPhotos = NO;
}

#pragma mark -
#pragma mark Appearing, dissapearing on the screen

/// Invoke this method when we recieved UIApplicationWillEnterForegroundNotification
- (void)becomeForeground:(NSNotification *)notification {
    [self startTrackingLocation];
    
    if (self.currentLocation) {
        [self.weather requestWeather];
        
        self.playingPhotos = YES;
        [self startPhotoSlideshowWithInterval:SNGWeatherViewControllerChangeInterval];
    }
}

/// Invoke this method when we recieved UIApplicationDidEnterBackgroundNotification
- (void)becomeBackground:(NSNotification *)notification {
    [self stopTrackingLocation];
    self.playingPhotos = NO;
    [self.photos stopDownloadingPhotos];
}

#pragma mark -
#pragma mark UIViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playingPhotos = NO;
    self.refreshData = NO;
    
    // Start listening UIApplication - UIApplicationWillEnterForegroundNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

    // Start listening UIApplication - UIApplicationDidEnterBackgroundNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    self.settingsButton.tintColor = [UIColor whiteColor];
    
    // Fill scroll view view views
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
    if (!self.isPlayingPhotos && self.currentLocation) {
        self.playingPhotos = YES;
        [self startPhotoSlideshowWithInterval:SNGWeatherViewControllerChangeInterval];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startTrackingLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTrackingLocation];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark UIViewController

/// Status bar style
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
