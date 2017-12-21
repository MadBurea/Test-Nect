#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, JVTextDirection) {
    JVTextDirectionNeutral = 0,
    JVTextDirectionLeftToRight,
    JVTextDirectionRightToLeft,
};

@interface NSString (TextDirectionality)

- (JVTextDirection)getBaseDirection;

@end
