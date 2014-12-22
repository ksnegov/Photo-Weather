//
//  SNGWeatherSettingsViewController.m
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 14/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SNGWeatherSettingsViewController.h"
#import "NYSegmentedControl.h"
#import "UIColor+SNGWeatherColors.h"
#import "SNGWeatherSettingsViewModel.h"

@interface SNGWeatherSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgound;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (weak, nonatomic) IBOutlet UILabel *temperatureNameLabel;
@property (weak, nonatomic) IBOutlet NYSegmentedControl *temperatureSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *pressureNameLabel;
@property (weak, nonatomic) IBOutlet NYSegmentedControl *pressureSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedNameLabel;
@property (weak, nonatomic) IBOutlet NYSegmentedControl *windSpeedSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *timeFormatNameLabel;
@property (weak, nonatomic) IBOutlet NYSegmentedControl *timeFormatSegmentedControl;

@property (strong, nonatomic) SNGWeatherSettingsViewModel *settings;

@end

@implementation SNGWeatherSettingsViewController

#pragma mark -
#pragma mark Getters

- (SNGWeatherSettingsViewModel *)settings {
    if (!_settings) {
        _settings = [[SNGWeatherSettingsViewModel alloc] init];
    }
    return _settings;
}

#pragma mark -
#pragma mark View controller lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Backgound
    self.backgound.image = self.backgroundImage;

    // Toolbar
    [self.toolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.toolbar setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny];

    // Done bar button
    self.doneBarButton.tintColor = [UIColor weatherBackgroundColor];
    
    // Temperature Label
    self.temperatureNameLabel.textColor = [UIColor weatherBackgroundColor];
    
    // Temperature segmented control
    NSDictionary *temperatureFormats = [SNGWeatherSettingsViewModel temperatureFormatName];
    for (NSNumber *titleKey in [temperatureFormats allKeys]) {
        [self.temperatureSegmentedControl insertSegmentWithTitle:temperatureFormats[titleKey] atIndex:[titleKey integerValue]];
    }
    self.temperatureSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    self.temperatureSegmentedControl.titleTextColor = [UIColor weatherBackgroundColor];
    self.temperatureSegmentedControl.segmentIndicatorBackgroundColor = [UIColor weatherBackgroundColor];

    // Pressure Label
    self.pressureNameLabel.textColor = [UIColor weatherBackgroundColor];
    
    // Pressure segmented control
    NSDictionary *pressureFormats = [SNGWeatherSettingsViewModel pressureFormatName];
    for (NSNumber *titleKey in [pressureFormats allKeys]) {
        [self.pressureSegmentedControl insertSegmentWithTitle:pressureFormats[titleKey] atIndex:[titleKey integerValue]];
    }
    self.pressureSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    self.pressureSegmentedControl.titleTextColor = [UIColor weatherBackgroundColor];
    self.pressureSegmentedControl.segmentIndicatorBackgroundColor = [UIColor weatherBackgroundColor];

    // Wind speed Label
    self.windSpeedNameLabel.textColor = [UIColor weatherBackgroundColor];
    
    // Wind speed segmented control
    NSDictionary *windSpeedFormats = [SNGWeatherSettingsViewModel windSpeedFormatName];
    for (NSNumber *titleKey in [windSpeedFormats allKeys]) {
        [self.windSpeedSegmentedControl insertSegmentWithTitle:windSpeedFormats[titleKey] atIndex:[titleKey integerValue]];
    }
    self.windSpeedSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    self.windSpeedSegmentedControl.titleTextColor = [UIColor weatherBackgroundColor];
    self.windSpeedSegmentedControl.segmentIndicatorBackgroundColor = [UIColor weatherBackgroundColor];

    // Time format Label
    self.timeFormatNameLabel.textColor = [UIColor weatherBackgroundColor];
    
    // Time format segmented control
    NSDictionary *timeFormats = [SNGWeatherSettingsViewModel timeFormatName];
    for (NSNumber *titleKey in [timeFormats allKeys]) {
        [self.timeFormatSegmentedControl insertSegmentWithTitle:timeFormats[titleKey] atIndex:[titleKey integerValue]];
    }
    self.timeFormatSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    self.timeFormatSegmentedControl.titleTextColor = [UIColor weatherBackgroundColor];
    self.timeFormatSegmentedControl.segmentIndicatorBackgroundColor = [UIColor weatherBackgroundColor];
    
    [self updateUI];
}

#pragma mark -
#pragma mark Update UI

/// Update UI
- (void)updateUI {
    [self.temperatureSegmentedControl setSelectedSegmentIndex:self.settings.temperatureIndex animated:YES];
    [self.pressureSegmentedControl setSelectedSegmentIndex:self.settings.pressureIndex animated:YES];
    [self.windSpeedSegmentedControl setSelectedSegmentIndex:self.settings.windSpeedIndex animated:YES];
    [self.timeFormatSegmentedControl setSelectedSegmentIndex:self.settings.timeFormatIndex animated:YES];
}

#pragma mark -
#pragma mark Change values in segmented controls

- (IBAction)temperatureFormatChangeValue:(id)sender {
    self.settings.temperatureIndex = self.temperatureSegmentedControl.selectedSegmentIndex;
}

- (IBAction)pressureFormatChangeValue:(id)sender {
    self.settings.pressureIndex = self.pressureSegmentedControl.selectedSegmentIndex;
}

- (IBAction)windSpeedFormatChangeValue:(id)sender {
    self.settings.windSpeedIndex = self.windSpeedSegmentedControl.selectedSegmentIndex;
}

- (IBAction)timeFormatChangeValue:(id)sender {
    self.settings.timeFormatIndex = self.timeFormatSegmentedControl.selectedSegmentIndex;
}

#pragma mark -
#pragma mark Bar button actions

/// Close self view controller
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
