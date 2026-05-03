#import <Foundation/Foundation.h>
#import <objc/runtime.h>

// 兼容无 substrate.h 头文件场景
extern "C" void MSHookMessageEx(Class _class, SEL message, IMP hook, IMP *old);

// 将命中的文本整体替换为一个空格
static NSString *ReplaceIfNeeded(NSString *input) {
    if (![input isKindOfClass:[NSString class]] || input.length == 0) {
        return input;
    }

    if ([input containsString:@"TG@macked_chat"] ||
        [input containsString:@"TG@macked_channel"]) {
        return @" ";
    }

    return input;
}

static NSString *(*orig_NSString_stringWithString)(Class cls, SEL _cmd, NSString *str);
static NSString *hook_NSString_stringWithString(Class cls, SEL _cmd, NSString *str) {
    return orig_NSString_stringWithString(cls, _cmd, ReplaceIfNeeded(str));
}

static id (*orig_NSString_initWithString)(id self, SEL _cmd, NSString *str);
static id hook_NSString_initWithString(id self, SEL _cmd, NSString *str) {
    return orig_NSString_initWithString(self, _cmd, ReplaceIfNeeded(str));
}

__attribute__((constructor))
static void init_tweak(void) {
    @autoreleasepool {
        Class nsStringCls = objc_getClass("NSString");

        MSHookMessageEx(object_getClass(nsStringCls),
                        @selector(stringWithString:),
                        (IMP)hook_NSString_stringWithString,
                        (IMP *)&orig_NSString_stringWithString);

        MSHookMessageEx(nsStringCls,
                        @selector(initWithString:),
                        (IMP)hook_NSString_initWithString,
                        (IMP *)&orig_NSString_initWithString);
    }
}
