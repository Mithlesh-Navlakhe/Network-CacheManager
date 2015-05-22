//
//  LTError.h
//  LTMobileLibrary
//
//   05/05/14.
//  Copyright (c) 2014 Ignatiuz. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *LTErrorDomain;

enum LTErrorCode {
    LTErrorAPIError = 0,
    LTErrorUnrecognizedResponse = 1,
    LTErrorUnexpectedResponse = 2,
    LTErrorParseError = 3,
    LTErrorHTTPError = 4,
    LTErrorRequiredError = 5,
};
typedef enum MSErrorCode LTErrorCode;
