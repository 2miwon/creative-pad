//
//  CreativePadExtensionParameterAddresses.h
//  CreativePadExtension
//
//  Created by macheewon on 1/22/24.
//

#pragma once

#include <AudioToolbox/AUParameters.h>

#ifdef __cplusplus
namespace CreativePadExtensionParameterAddress {
#endif

typedef NS_ENUM(AUParameterAddress, CreativePadExtensionParameterAddress) {
    gain = 0
};

#ifdef __cplusplus
}
#endif
