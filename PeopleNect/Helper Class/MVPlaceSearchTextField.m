//
//  MVPlaceSearchTextField.m
//  PlaceSearchAPIDEMO
//
//  Created by Mrugrajsinh Vansadia on 26/04/14.
//  Copyright (c) 2014 Mrugrajsinh Vansadia. All rights reserved.
//

#import "MVPlaceSearchTextField.h"
//#import "Macro.h"
#import "PlaceDetail.h"
#import "PlaceObject.h"
#import "MLPAutoCompleteTextField.h"

@import GooglePlaces;

static CGFloat const kFloatingLabelShowAnimationDuration = 0.3f;
static CGFloat const kFloatingLabelHideAnimationDuration = 0.3f;
@interface MVPlaceSearchTextField ()<MLPAutoCompleteFetchOperationDelegate,MLPAutoCompleteSortOperationDelegate,MLPAutoCompleteTextFieldDataSource,MLPAutoCompleteTextFieldDelegate,PlaceDetailDelegate>{
    GMSPlacesClient *_placesClient;
   
    BOOL _isFloatingLabelFontDefault;
}

@end


@implementation MVPlaceSearchTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self commonInit];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/



-(void)awakeFromNib{

    self.autoCompleteDataSource=self;
    self.autoCompleteDelegate=self;
    self.autoCompleteFontSize=14;
    self.autoCompleteTableBorderWidth=0.0;
    self.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=NO;
    self.autoCompleteShouldHideOnSelection=YES;
    self.maximumNumberOfAutoCompleteRows= 100;
    self.autoCompleteShouldHideClosingKeyboard = YES;
    _placesClient = [GMSPlacesClient sharedClient];
    
    UIView *paddingLeftImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.layer.frame.size.height)];
    
    //self.leftViewMode = UITextFieldViewModeAlways;
    
    //self.leftView = paddingLeftImage;
    
    
    if (self.leftImage != nil)
    {
        UIView *paddingLeftImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.layer.frame.size.height, self.layer.frame.size.height)];
        
        UIButton * btn = [[UIButton alloc]init];
        
        btn.frame = CGRectMake(0, 0, self.layer.frame.size.height, self.layer.frame.size.height);
        
        [btn setImage:_leftImage forState:UIControlStateNormal];
        
        [paddingLeftImage addSubview:btn];
        
        //self.leftViewMode = UITextFieldViewModeAlways;
        
        //self.leftView = paddingLeftImage;
    }
    
    else
    {
        if (_rightImage==nil)
        {
            UIView *paddingLeftSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.layer.frame.size.height/2-5, self.layer.frame.size.height)];
            
           // self.leftViewMode = UITextFieldViewModeAlways;
            
            //self.leftView = paddingLeftSpace;
        }
        
    }
    
    /*-----Right Image -----*/
    
    if (self.rightImage != nil)
    {
        UIView *paddingRightImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.layer.frame.size.height, self.layer.frame.size.height)];
        
        UIButton * btn = [[UIButton alloc]init];
        
        btn.frame = CGRectMake(0, 0, self.layer.frame.size.height, self.layer.frame.size.height);
        
        [btn setImage:_rightImage forState:UIControlStateNormal];
        
        [paddingRightImage addSubview:btn];
        
        //self.rightViewMode = UITextFieldViewModeAlways;
       // self.rightView = paddingRightImage;
        
        UIView *paddingLeftSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.layer.frame.size.height/2-5, self.layer.frame.size.height)];
        
        //self.leftViewMode = UITextFieldViewModeAlways;
        
        //self.leftView = paddingLeftSpace;
        
    }
    
}
#pragma mark - Datasource Autocomplete
//example of asynchronous fetch:
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    

        NSString *aQuery=textField.text;
        [NSObject cancelPreviousPerformRequestsWithTarget:_placesClient selector:@selector(autocompleteQuery:bounds:filter:callback:) object:self];
    
        if(aQuery.length>0){
            GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
            filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
        
            
        
            [_placesClient autocompleteQuery:aQuery
                                      bounds:nil
                                      filter:filter
                                    callback:^(NSArray *results, NSError *error) {
                                        if (error != nil) {
                                            NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                            handler(nil);
                                            return;
                                        }
                                        if(results.count>0){
                                        NSMutableArray *arrfinal=[NSMutableArray array];
                                        for (GMSAutocompletePrediction* result in results) {
                                            NSDictionary *aTempDict =  [NSDictionary dictionaryWithObjectsAndKeys:result.attributedFullText.string,@"description",result.placeID,@"reference", nil];
                                            PlaceObject *placeObj=[[PlaceObject alloc]initWithPlaceName:[aTempDict objectForKey:@"description"]];
                                            placeObj.userInfo=aTempDict;
                                            [arrfinal addObject:placeObj];

                                        }
                                            handler(arrfinal);
                                        }else{
                                            handler(nil);
                                        }
                                    }];
        }else{
            handler(nil);
        }
}


#pragma mark - AutoComplete Delegates
-(void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField didSelectAutoCompleteString:(NSString *)selectedString withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PlaceObject *placeObj=(PlaceObject*)selectedObject;
    NSString *aStrPlaceReferance=[placeObj.userInfo objectForKey:@"reference"];
    PlaceDetail *placeDetail=[[PlaceDetail alloc]initWithApiKey:_strApiKey];
    placeDetail.delegate=self;
    [placeDetail getPlaceDetailForReferance:aStrPlaceReferance];
    
}
-(BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
         shouldConfigureCell:(UITableViewCell *)cell
      withAutoCompleteString:(NSString *)autocompleteString
        withAttributedString:(NSAttributedString *)boldedString
       forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
           forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_placeSearchDelegate respondsToSelector:@selector(placeSearch:ResultCell:withPlaceObject:atIndex:)]){
        [_placeSearchDelegate placeSearch:self ResultCell:cell withPlaceObject:autocompleteObject atIndex:indexPath.row];
    }else{
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    return YES;
}

-(void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField willShowAutoCompleteTableView:(UITableView *)autoCompleteTableView{
    if([_placeSearchDelegate respondsToSelector:@selector(placeSearchWillShowResult:)]){
        [_placeSearchDelegate placeSearchWillShowResult:self];
    }
}
-(void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField willHideAutoCompleteTableView:(UITableView *)autoCompleteTableView{
    if([_placeSearchDelegate respondsToSelector:@selector(placeSearchWillHideResult:)]){
        [_placeSearchDelegate placeSearchWillHideResult:self];
    }
}


#pragma mark - PlaceDetail Delegate

-(void)placeDetailForReferance:(NSString *)referance didFinishWithResult:(GMSPlace*)resultDict{
        //Respond To Delegate
    [_placeSearchDelegate placeSearch:self ResponseForSelectedPlace:resultDict];
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _floatingLabel = [UILabel new];
    _floatingLabel.alpha = 0.0f;
    [self addSubview:_floatingLabel];
    
    _floatingLabelFont = [self defaultFloatingLabelFont];
    _floatingLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:12.0];
    
    //_floatingLabel.font = _floatingLabelFont;
    _floatingLabelTextColor = [UIColor grayColor];
    _floatingLabel.textColor = _floatingLabelTextColor;
    _animateEvenIfNotFirstResponder = NO;
    _floatingLabelShowAnimationDuration = kFloatingLabelShowAnimationDuration;
    _floatingLabelHideAnimationDuration = kFloatingLabelHideAnimationDuration;
    [self setFloatingLabelText:self.placeholder];
    
    _adjustsClearButtonRect = YES;
    _isFloatingLabelFontDefault = YES;
    
}

#pragma mark -

- (UIFont *)defaultFloatingLabelFont
{
    UIFont *textFieldFont = nil;
    
    if (!textFieldFont && self.attributedPlaceholder && self.attributedPlaceholder.length > 0) {
        textFieldFont = [self.attributedPlaceholder attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    }
    if (!textFieldFont && self.attributedText && self.attributedText.length > 0) {
        textFieldFont = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    }
    if (!textFieldFont) {
        textFieldFont = self.font;
    }
    
    return [UIFont fontWithName:textFieldFont.fontName size:roundf(textFieldFont.pointSize * 1.0f)];
}

- (void)updateDefaultFloatingLabelFont
{
    UIFont *derivedFont = [self defaultFloatingLabelFont];
    
    if (_isFloatingLabelFontDefault) {
        self.floatingLabelFont = derivedFont;
    }
    else {
        _floatingLabelFont = derivedFont;
    }
}

- (UIColor *)labelActiveColor
{
    if (_floatingLabelActiveTextColor) {
        return _floatingLabelActiveTextColor;
    }
    else if ([self respondsToSelector:@selector(tintColor)]) {
        return [self performSelector:@selector(tintColor)];
    }
    return [UIColor blueColor];
}

- (void)setFloatingLabelFont:(UIFont *)floatingLabelFont
{
    if (floatingLabelFont != nil) {
        _floatingLabelFont = floatingLabelFont;
    }
    _floatingLabel.font =  _floatingLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:12.0];
    
    _isFloatingLabelFontDefault = floatingLabelFont == nil;
    [self setFloatingLabelText:self.placeholder];
    [self invalidateIntrinsicContentSize];
}

- (void)showFloatingLabel:(BOOL)animated
{
    void (^showBlock)() = ^{
        _floatingLabel.alpha = 1.0f;
        _floatingLabel.frame = CGRectMake(_floatingLabel.frame.origin.x,
                                          _floatingLabelYPadding,
                                          _floatingLabel.frame.size.width,
                                          _floatingLabel.frame.size.height);
    };
    
    if (animated || 0 != _animateEvenIfNotFirstResponder) {
        [UIView animateWithDuration:_floatingLabelShowAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:showBlock
                         completion:nil];
    }
    else {
        showBlock();
    }
}

- (void)hideFloatingLabel:(BOOL)animated
{
    void (^hideBlock)() = ^{
        _floatingLabel.alpha = 0.0f;
        _floatingLabel.frame = CGRectMake(_floatingLabel.frame.origin.x,
                                          _floatingLabel.font.lineHeight + _placeholderYPadding,
                                          _floatingLabel.frame.size.width,
                                          _floatingLabel.frame.size.height);
        
    };
    
    if (animated || 0 != _animateEvenIfNotFirstResponder) {
        [UIView animateWithDuration:_floatingLabelHideAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:hideBlock
                         completion:nil];
    }
    else {
        hideBlock();
    }
}

- (void)setLabelOriginForTextAlignment
{
    CGRect textRect = [self textRectForBounds:self.bounds];
    
    CGFloat originX = textRect.origin.x;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        originX = textRect.origin.x + (textRect.size.width/2) - (_floatingLabel.frame.size.width/2);
    }
    else if (self.textAlignment == NSTextAlignmentRight) {
        originX = textRect.origin.x + textRect.size.width - _floatingLabel.frame.size.width;
    }
    else if (self.textAlignment == NSTextAlignmentNatural) {
        JVTextDirection baseDirection = [_floatingLabel.text getBaseDirection];
        if (baseDirection == JVTextDirectionRightToLeft) {
            originX = textRect.origin.x + textRect.size.width - _floatingLabel.frame.size.width;
        }
    }
    
    _floatingLabel.frame = CGRectMake(originX + _floatingLabelXPadding, _floatingLabel.frame.origin.y,
                                      _floatingLabel.frame.size.width, _floatingLabel.frame.size.height);
}

- (void)setFloatingLabelText:(NSString *)text
{
    _floatingLabel.text = text;
    [self setNeedsLayout];
}

#pragma mark - UITextField

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self updateDefaultFloatingLabelFont];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self updateDefaultFloatingLabelFont];
}

- (CGSize)intrinsicContentSize
{
    CGSize textFieldIntrinsicContentSize = [super intrinsicContentSize];
    [_floatingLabel sizeToFit];
    return CGSizeMake(textFieldIntrinsicContentSize.width,
                      textFieldIntrinsicContentSize.height + _floatingLabelYPadding + _floatingLabel.bounds.size.height);
}

- (void)setCorrectPlaceholder:(NSString *)placeholder
{
    if (self.placeholderColor && placeholder) {
        NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                                    attributes:@{NSForegroundColorAttributeName: self.placeholderColor}];
        [super setAttributedPlaceholder:attributedPlaceholder];
    } else {
        [super setPlaceholder:placeholder];
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [self setCorrectPlaceholder:placeholder];
    [self setFloatingLabelText:placeholder];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder
{
    [super setAttributedPlaceholder:attributedPlaceholder];
    [self setFloatingLabelText:attributedPlaceholder.string];
    [self updateDefaultFloatingLabelFont];
}

- (void)setPlaceholder:(NSString *)placeholder floatingTitle:(NSString *)floatingTitle
{
    [self setCorrectPlaceholder:placeholder];
    [self setFloatingLabelText:floatingTitle];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder floatingTitle:(NSString *)floatingTitle
{
    [super setAttributedPlaceholder:attributedPlaceholder];
    [self setFloatingLabelText:floatingTitle];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    if ([self.text length] || self.keepBaseline) {
        rect = [self insetRectForBounds:rect];
    }
    return CGRectIntegral(rect);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    if ([self.text length] || self.keepBaseline) {
        rect = [self insetRectForBounds:rect];
    }
    return CGRectIntegral(rect);
}

- (CGRect)insetRectForBounds:(CGRect)rect
{
    CGFloat topInset = ceilf(_floatingLabel.bounds.size.height + _placeholderYPadding);
    topInset = MIN(topInset, [self maxTopInset]);
    return CGRectMake(rect.origin.x, rect.origin.y + topInset / 2.0f, rect.size.width, rect.size.height);
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    CGRect rect = [super clearButtonRectForBounds:bounds];
    if (0 != self.adjustsClearButtonRect
        && _floatingLabel.text.length // for when there is no floating title label text
        ) {
        if ([self.text length] || self.keepBaseline) {
            CGFloat topInset = ceilf(_floatingLabel.font.lineHeight + _placeholderYPadding);
            topInset = MIN(topInset, [self maxTopInset]);
            rect = CGRectMake(rect.origin.x, rect.origin.y + topInset / 2.0f, rect.size.width, rect.size.height);
        }
    }
    return CGRectIntegral(rect);
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect rect = [super leftViewRectForBounds:bounds];
    
    CGFloat topInset = ceilf(_floatingLabel.font.lineHeight + _placeholderYPadding);
    topInset = MIN(topInset, [self maxTopInset]);
    rect = CGRectOffset(rect, 0, topInset / 2.0f);
    
    return rect;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    
    CGRect rect = [super rightViewRectForBounds:bounds];
    
    CGFloat topInset = ceilf(_floatingLabel.font.lineHeight + _placeholderYPadding);
    topInset = MIN(topInset, [self maxTopInset]);
    rect = CGRectOffset(rect, 0, topInset / 2.0f);
    
    return rect;
}

- (CGFloat)maxTopInset
{
    return MAX(0, floorf(self.bounds.size.height - self.font.lineHeight - 4.0f));
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    [self setNeedsLayout];
}

- (void)setAlwaysShowFloatingLabel:(BOOL)alwaysShowFloatingLabel
{
    _alwaysShowFloatingLabel = alwaysShowFloatingLabel;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _borderLayer.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.layer.frame.size.width, 1.0f);
    [self setLabelOriginForTextAlignment];
    
    CGSize floatingLabelSize = [_floatingLabel sizeThatFits:_floatingLabel.superview.bounds.size];
    
    _floatingLabel.frame = CGRectMake(_floatingLabel.frame.origin.x,
                                      _floatingLabel.frame.origin.y,
                                      floatingLabelSize.width,
                                      floatingLabelSize.height);
    
    BOOL firstResponder = self.isFirstResponder;
    _floatingLabel.textColor = (firstResponder && self.text && self.text.length > 0 ?
                                self.labelActiveColor : self.floatingLabelTextColor);
    if ((!self.text || 0 == [self.text length]) && !self.alwaysShowFloatingLabel) {
        [self hideFloatingLabel:firstResponder];
    }
    else {
        [self showFloatingLabel:firstResponder];
    }
}


#pragma mark - URL Operation
/*
- (NSDictionary *)stringWithUrl:(NSURL *)url
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    
    
    if(urlData){
        // Construct a Dictionary around the Data from the response
        NSDictionary *aDict=[NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:&error];
        return aDict;
    }else{return nil;}
    
}
*/

@end
