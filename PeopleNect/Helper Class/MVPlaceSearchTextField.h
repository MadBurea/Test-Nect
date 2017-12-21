//
//  MVPlaceSearchTextField.h
//  PlaceSearchAPIDEMO
//
//  Created by Mrugrajsinh Vansadia on 26/04/14.
//  Copyright (c) 2014 Mrugrajsinh Vansadia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLPAutoCompleteTextField.h"
#import "MVPlaceSearchTextField.h"
#import "PlaceObject.h"
#import <GoogleMaps/GoogleMaps.h>
#import "NSString+TextDirectionality.h"

@import GooglePlaces;
@protocol PlaceSearchTextFieldDelegate;

@interface MVPlaceSearchTextField : MLPAutoCompleteTextField
@property(nonatomic,strong)NSString *strApiKey;

IB_DESIGNABLE
@property (nonatomic, strong, readonly) UILabel * floatingLabel;
@property (nonatomic) IBInspectable CGFloat floatingLabelYPadding;
@property (nonatomic) IBInspectable CGFloat floatingLabelXPadding;
@property (nonatomic) IBInspectable CGFloat placeholderYPadding;
@property (nonatomic, strong) UIFont * floatingLabelFont;
@property (nonatomic, strong) IBInspectable UIColor * floatingLabelTextColor;
@property (nonatomic, strong) IBInspectable UIColor * floatingLabelActiveTextColor;

@property (nonatomic, strong) IBInspectable UIImage * leftImage;
@property (nonatomic, strong) IBInspectable UIImage * rightImage;
@property (nonatomic) IBInspectable UIColor *BorderColor;

@property (nonatomic, assign) IBInspectable BOOL animateEvenIfNotFirstResponder;
@property (nonatomic, assign) NSTimeInterval floatingLabelShowAnimationDuration;
@property (nonatomic, assign) NSTimeInterval floatingLabelHideAnimationDuration;
@property (nonatomic, assign) IBInspectable BOOL adjustsClearButtonRect;
@property (nonatomic, assign) IBInspectable BOOL keepBaseline;
@property (nonatomic, assign) BOOL alwaysShowFloatingLabel;
@property (nonatomic, strong) IBInspectable UIColor * placeholderColor;
@property (strong, nonatomic) CALayer *borderLayer;

- (void)setPlaceholder:(NSString *)placeholder floatingTitle:(NSString *)floatingTitle;
- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder floatingTitle:(NSString *)floatingTitle;

@property(nonatomic,strong)IBOutlet id<PlaceSearchTextFieldDelegate>placeSearchDelegate;
@end

@protocol PlaceSearchTextFieldDelegate <NSObject>

-(void)placeSearch:(MVPlaceSearchTextField*)textField ResponseForSelectedPlace:(GMSPlace*)responseDict;
-(void)placeSearchWillShowResult:(MVPlaceSearchTextField*)textField;
-(void)placeSearchWillHideResult:(MVPlaceSearchTextField*)textField;
-(void)placeSearch:(MVPlaceSearchTextField*)textField ResultCell:(UITableViewCell*)cell withPlaceObject:(PlaceObject*)placeObject atIndex:(NSInteger)index;
@end

