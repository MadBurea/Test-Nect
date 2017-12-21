//
//  PN_TextFieldGlobalMethod.m
//  PeopleNect
//
//  Created by Narendra Pandey on 7/28/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

#import "PN_TextFieldGlobalMethod.h"

@implementation PN_TextFieldGlobalMethod

-(void)awakeFromNib{
    /*----- Border -----*/
    _borderLayer = [CALayer layer];
    _borderLayer.backgroundColor = self.BorderColor.CGColor;
    [self.layer addSublayer:_borderLayer];
    /*----- PlaceHolder Color -----*/
    [self setValue:self.PlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self setValue:[UIFont fontWithName:@"HelveticaNeue-Light" size: 13] forKeyPath:@"_placeholderLabel.font"];
    /*----- left Image -----*/
    if (self.leftImag != nil){
    UIView *paddingLeftImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.layer.frame.size.height, self.layer.frame.size.height)];
    UIButton * btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(0, 0, self.layer.frame.size.height, self.layer.frame.size.height);
    [btn setImage:_leftImag forState:UIControlStateNormal];
    [paddingLeftImage addSubview:btn];
   self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = paddingLeftImage;
    }else{
        if (_rightImag==nil){
           UIView *paddingLeftSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.layer.frame.size.height/2-5, self.layer.frame.size.height)];
            self.leftViewMode = UITextFieldViewModeAlways;
            self.leftView = paddingLeftSpace;
        }
    }
    /*-----Right Image -----*/
    if (self.rightImag != nil){
        UIView *paddingRightImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.layer.frame.size.height, self.layer.frame.size.height)];
        UIButton * btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(0, 0, self.layer.frame.size.height, self.layer.frame.size.height);
        [btn setImage:_rightImag forState:UIControlStateNormal];
        [paddingRightImage addSubview:btn];
        self.rightViewMode = UITextFieldViewModeAlways;
        self.rightView = paddingRightImage;
        UIView *paddingLeftSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.layer.frame.size.height/2-5, self.layer.frame.size.height)];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = paddingLeftSpace;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    /*----- Bottom Border -----*/
      _borderLayer.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.layer.frame.size.width, 1.0f);
}

-(void)invalidateIntrinsicContentSize{
}
@end
