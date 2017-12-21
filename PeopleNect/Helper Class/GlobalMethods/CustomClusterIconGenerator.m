
//  CustomClusterIconGenerator.m
//  ObjCDemoApp
//
//  Created by Narendra Pandey on 05/12/16.
//  Copyright © 2016 Google. All rights reserved.
//

#import "CustomClusterIconGenerator.h"

@implementation CustomClusterIconGenerator

/* icon for marker cluster */
- (UIImage *)iconForSize:(NSUInteger)size {
    
    NSLog(@"Size is %lu",(unsigned long)size);
    
    NSLog(@"iconForSize cluster called");
    
   //return [self getUIImageFromThisUIView:[self BlueViewMarker:0 markerCount:size]];
    
 //return [self getUIImageFromThisUIView:[self Marker:size]];
    
    return [self getUIImageFromThisUIView:[self CustomImageLabelMarker:size]];
}
/* icon for individual marker */
- (UIImage *)iconForMarker {
    
    NSLog(@"iconForMarker cluster called");

    return [UIImage imageNamed:@"pre_incident"];
}
/* icon for individual marker */
- (UIImage *)iconForText:(NSString *)text withBaseImage:(UIImage *)image {
    
    
    NSLog(@"iconForText cluster called");

    NSLog(@"text is %@",text);

   // return [UIImage imageNamed:@"top_side_btn"];
    return image;
}
- (CGPoint)markerIconGroundAnchor {
    return CGPointMake(0, 0);
}
- (CGPoint)clusterIconGroundAnchor {
    return CGPointMake(0, 0);
}
/* Custom marker for Clustering marker  */
-(UIView *)BlueViewMarker:(NSUInteger)labelTextInt markerCount:(NSUInteger)markerCount{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 69, 60)];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 30, 21)];
    label.text = [NSString stringWithFormat:@"%lu",(unsigned long)markerCount];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor greenColor];    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 21, 69, 38)];
   
    [btn setImage:[UIImage imageNamed:@"btm_delayed"] forState:UIControlStateNormal];
    
    [view addSubview:label];
    [view addSubview:btn];
    return view;
}
/* View to image conversion  */
-(UIImage*)getUIImageFromThisUIView:(UIView*)aUIView{
    UIGraphicsBeginImageContext(aUIView.bounds.size);
    [aUIView drawViewHierarchyInRect:aUIView.layer.bounds afterScreenUpdates:YES];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

-(UIView *)CustomImageLabelMarker:(NSUInteger)markerCount{
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc]init];
    UIImageView *imageview = [[UIImageView alloc] init];
    
    label.textColor = [UIColor colorWithRed:61.0/255.0 green:101.0/255.0 blue:250.0/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor lightGrayColor];
    label.font = [UIFont fontWithName:@"Montserrat-Regular" size:12];
    
    label.text = [NSString stringWithFormat:@"%lu",(unsigned long)markerCount];
    
    label.frame = CGRectMake(0, 0, [self widthOfString:label.text]+20, [self widthOfString:label.text]+20);

    CGFloat x = label.center.x  - 8;

    
    if ( [[NSUserDefaults standardUserDefaults]valueForKey:@"UserLoginDict"] != nil) {
        [imageview setImage:[UIImage imageNamed:@"map"]];
        imageview.frame = CGRectMake(x, label.frame.size.height + 5, 15, 25);

    }else{
        [imageview setImage:[UIImage imageNamed:@"map_user"]];
        CGFloat xY = label.center.x  - 15;
        imageview.frame = CGRectMake(xY, label.frame.size.height + 5, 30, 30);
    }
    imageview.contentMode = UIViewContentModeScaleAspectFit;

    view.frame = CGRectMake(0, 0, label.frame.size.width  , label.frame.size.height + imageview.frame.size.height + 10);
    
    label.layer.cornerRadius = 5.0;
    
    label.layer.masksToBounds = YES;
    
    view.backgroundColor = [UIColor clearColor];
    
    [view addSubview:label];
    [view addSubview:imageview];

    return view;

}

-(UIView *)Marker:(NSUInteger)markerCount{
    
    UIView *view = [[UIView alloc]init];
    
     //label.font = UIFont.optimaRegular(Size: 13)
    
  // 255 101 25
   // view.backgroundColor = [UIColor blueColor];
    
    //view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:101.0/255.0 blue:25.0/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor blueColor];
    label.font = [UIFont fontWithName:@"Optima-Bold" size:18];
    
    label.text = [NSString stringWithFormat:@"%lu",(unsigned long)markerCount];
    
    label.frame = CGRectMake(0, 0, [self widthOfString:label.text]+20, [self widthOfString:label.text]+20);
    
    view.frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.width);
    
    view.layer.cornerRadius = view.frame.size.height/2;
   // view.layer.shadowRadius = 4.0;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.borderWidth = 2.0;
    
   // view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.masksToBounds = YES;
    
    view.backgroundColor = [UIColor clearColor];
    
    [view addSubview:label];
    
    return view;
}

- (CGFloat)widthOfString:(NSString *)string  {
    NSFont *font;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}



/*

- (UIImage *)iconForSize:(NSUInteger)size {
    
    
    
    return [UIImage imageNamed:@"hydrant"];

}
- (UIImage *)iconForMarker {
    return [UIImage imageNamed:@"hall_home"];
}
- (UIImage *)iconForText:(NSString *)text withBaseImage:(UIImage *)image {
    return [UIImage imageNamed:@"ic alaram_"];
}
- (CGPoint)markerIconGroundAnchor {
    return CGPointMake(0, 0);
}
- (CGPoint)clusterIconGroundAnchor {
    return CGPointMake(0, 0);
}
 */
@end
