//
//  PlaceDetail.m
//  PlaceSearchAPIDEMO
//
//  Created by Mrugrajsinh Vansadia on 26/04/14.
//  Copyright (c) 2014 Mrugrajsinh Vansadia. All rights reserved.
//

#import "PlaceDetail.h"


#define apiURL @"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@"

#define apiURLWithoutKey @"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true"

#define apiURLWithPlace @"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&language=en&sensor=true&key=AIzaSyB9U-Ssv6A9Tt2keQtZyWMuadHoELYeGlk&location=23.0225,72.5714&radius=500"

@implementation PlaceDetail
-(id)initWithApiKey:(NSString *)ApiKey{
    
    self = [super init];
    if (self) {
        aStrApiKey=ApiKey;
    }
    return self;
}

-(void)getPlaceDetailForReferance:(NSString*)strReferance{
    
   [NSString stringWithFormat:apiURLWithoutKey,strReferance];
    
    //[NSString stringWithFormat:apiURLWithPlace,strReferance];

    
    [[GMSPlacesClient sharedClient]lookUpPlaceID:strReferance callback:^(GMSPlace *place, NSError *error) {
        if(place){
            [_delegate placeDetailForReferance:strReferance didFinishWithResult:place];
        }
        else{
            NSLog(@"%@",error);
        }
    }];
}

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
        // Construct a String around the Data from the response
        NSDictionary *aDict=[NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:&error];
        return aDict;
    }else{return nil;}
    
}
 
 */
@end
