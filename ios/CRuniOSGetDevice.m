//
//  CRuniOSGetDevice.m
//  RuntimeIPhone
//
//  Created by Timothy Ellis on 11/05/12.
//  Copyright (c) 2012 Clickteam. All rights reserved.
//

#import "CRuniOSGetDevice.h"

#import "CExtension.h"
#import "CRun.h"
#import "CBitmap.h"
#import "CServices.h"
#import "CCreateObjectInfo.h"
#import "CImage.h"
#import "CActExtension.h"
#import "CCndExtension.h"
#import "CValue.h"

#include <sys/types.h>
#include <sys/sysctl.h>

@implementation CRuniOSGetDevice

- (NSString *)machine {
    size_t size;
    
    // Set 'oldp' parameter to NULL to get the size of the data
    // returned so we can allocate appropriate amount of space
    sysctlbyname("hw.machine", NULL, &size, NULL, 0); 
    
    // Allocate the space to store name
    char *name = malloc(size);
    
    // Get the platform name
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    // Place name into a string
    NSString *machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    
    // Done with this
    free(name);
    
    return machine;
}

//This function should return the number of conditions contained in the object (equivalent to the CND_LAST define in the ext.h file).
-(int)getNumberOfConditions
{
    return 13;
}

/*
 This function is called when the object is created. As iOS object are just created when needed, there is no EDITDATA structure.
 Instead, I send to the function a CFile object, pointing directly to the data of the object (the EDITDATA structure, on disc).
 The CFile object allows you to read the data. It automatically converts PC-like ordering (big or little Indian I cant remember) into iOS ordering.
 It contains functions to read bytes, shorts, int, colors and strings.
 
 So all you have to do, is read the data from the CFile object, and initialise your object accordingly.
 Return YES if your object has been created successfully.
 */
-(BOOL)createRunObject:(CFile *)file withCOB:(CCreateObjectInfo *)cob andVersion: (int)version
{
    return YES;
}

/*
 Called when the object is destroyed. This routine should free all the memory allocated during createRunObject.
 bFast is true if the object is destroyed at end of frame. It is false if the object is destroyed in the middle of the application.
 */
-(void)destroyRunObject:(BOOL)bFast
{
    
}

/*
 Same as the C++ function. Perform all the tasks needed for your object in this function.
 As the C function, this function returns value indicating what to do :
 • REFLAG_ONESHOT : handleRunObject will not be called anymore
 • REFLAG_DISPLAY : displayRunObject is called at next refresh.
 • Return 0 and the handleRunObject method will be called at the next loop.
 */
-(int)handleRunObject
{
    return REFLAG_ONESHOT;
}

//Called when the application goes into pause mode.
-(void)pauseRunObject
{
    
}

//Called when the application restarts.
-(void)continueRunObject
{
    
}

/*
 The main entry for the evaluation of the conditions.
 • num : number of the condition (equivalent to the CND_ definitions in ext.h)
 • cnd : a pointer to a CCndExtension object that contains useful callback functions to get the parameters.
 This function should return YES or NO, depending on the condition.
 */

/*
 @"i386"      on the simulator
 @"iPod1,1"   on iPod Touch
 @"iPod2,1"   on iPod Touch Second Generation
 @"iPod3,1"   on iPod Touch Third Generation
 @"iPod4,1"   on iPod Touch Fourth Generation
 @"iPhone1,1" on iPhone
 @"iPhone1,2" on iPhone 3G
 @"iPhone2,1" on iPhone 3GS
 @"iPhone3,1" on iPhone 4
 @"iPhone4,1" on iPhone 4S
 @"iPad1,1"   on iPad
 @"iPad2,1"   on iPad 2
 @"iPad3,1"   on iPad 3
 */
-(BOOL)condition:(int)num withCndExtension:(CCndExtension *)cnd
{
    NSString *device = [self machine];
    switch (num)
    {
        case 0:
            return [device isEqualToString:@"i386"];
        case 1:
            return [device isEqualToString:@"iPod1,1"];
        case 2:
            return [device isEqualToString:@"iPod2,1"];
        case 3:
            return [device isEqualToString:@"iPod3,1"];
        case 4:
            return [device isEqualToString:@"iPod4,1"];
        case 5:
            return [device isEqualToString:@"iPhone1,1"];
        case 6:
            return [device isEqualToString:@"iPhone1,2"];
        case 7:
            return [device isEqualToString:@"iPhone2,1"];
        case 8:
            return [device isEqualToString:@"iPhone3,1"];
        case 9:
            return [device isEqualToString:@"iPhone4,1"];
        case 10:
            return [device isEqualToString:@"iPad1,1"];
        case 11:
            return [device isEqualToString:@"iPad2,1"];
        case 12:
            return [device isEqualToString:@"iPad3,1"];
    }
    return NO;
}

/*
 The main entry for the actions.
 • num : number of the action, as defined in ext.h
 • act : pointer to a CActExtension object that contains callback functions to get the parameters.
 */
-(void)action:(int)num withActExtension:(CActExtension *)act
{
}

/*
 The main entry for expressions.
 • num : number of the expression
 To get the expression parameters, you have to call the getExpParam method defined in the "ho" variable, for each of the parameters.
 This function returns a CValue* which contains the parameter.
 You then do a getInt(), getDouble() or getString() with the CValue object to grab the actual value.
 This function returns a pointer to a Cvalue object containing the result.
 The content of the CValue can be a integer, a double or a String.
 There is no need to set the HOF_STRING flags if your return a string : the CValue object contains the type of the returned value.
 You should not alloc the CValue yourself, but instead ask for a temporary value from the Crun class :
 [rh getTempValue:default_value] where default_value is an integer.
 */

-(CValue *)expression:(int)num
{
    if (num == 0)
        return [rh getTempString:[self machine]];
    return [rh getTempValue:0];
}

@end
