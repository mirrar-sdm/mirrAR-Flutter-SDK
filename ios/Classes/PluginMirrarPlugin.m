#import "PluginMirrarPlugin.h"
#if __has_include(<plugin_mirrar/plugin_mirrar-Swift.h>)
#import <plugin_mirrar/plugin_mirrar-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "plugin_mirrar-Swift.h"
#endif

@implementation PluginMirrarPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPluginMirrarPlugin registerWithRegistrar:registrar];
}
@end
