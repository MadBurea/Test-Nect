//
//  PN_TextFieldGlobalMethod.h
//  PeopleNect
//
//  Created by Narendra Pandey on 7/28/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PN_TextFieldGlobalMethod.h"
#import "TPKeyboardAvoidingScrollView.h"
IB_DESIGNABLE

@interface PN_TextFieldGlobalMethod : UITextField

@property (nonatomic) IBInspectable UIImage *leftImag;
@property (nonatomic) IBInspectable UIImage *rightImag;
@property (nonatomic) IBInspectable UIColor *BorderColor;
@property (nonatomic) IBInspectable UIColor *PlaceHolderColor;
@property(nonatomic)BOOL secure;
@property(nonatomic,strong)NSString *actualText;
@property (strong, nonatomic) CALayer *borderLayer;
@end
