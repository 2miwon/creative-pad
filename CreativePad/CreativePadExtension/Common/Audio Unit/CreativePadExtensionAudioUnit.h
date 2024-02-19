//
//  CreativePadExtensionAudioUnit.h
//  CreativePadExtension
//
//  Created by macheewon on 1/22/24.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface CreativePadExtensionAudioUnit : AUAudioUnit
- (void)setupParameterTree:(AUParameterTree *)parameterTree;
@end
