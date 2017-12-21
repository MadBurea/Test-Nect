

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CustomPlaceHolderTextField : UITextField

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

@end
