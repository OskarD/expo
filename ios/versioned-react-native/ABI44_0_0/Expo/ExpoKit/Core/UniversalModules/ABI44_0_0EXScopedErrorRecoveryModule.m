// Copyright 2018-present 650 Industries. All rights reserved.

#if __has_include(<ABI44_0_0EXErrorRecovery/ABI44_0_0EXErrorRecoveryModule.h>)
#import "ABI44_0_0EXScopedErrorRecoveryModule.h"

@interface ABI44_0_0EXScopedErrorRecoveryModule ()

@property (nonatomic, strong) NSString *scopeKey;

@end

@implementation ABI44_0_0EXScopedErrorRecoveryModule

- (instancetype)initWithScopeKey:(NSString *)scopeKey
{
  if (self = [super init]) {
    _scopeKey = scopeKey;
  }
  return self;
}

- (BOOL)setRecoveryProps:(NSString *)props
{
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
  NSDictionary *errorRecoveryStore = [preferences dictionaryForKey:[self userDefaultsKey]] ?: @{};
  NSMutableDictionary *newStore = [errorRecoveryStore mutableCopy];
  newStore[_scopeKey] = props;
  [preferences setObject:newStore forKey:[self userDefaultsKey]];
  return [preferences synchronize];
}

- (NSString *)consumeRecoveryProps
{
  NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
  NSDictionary *errorRecoveryStore = [preferences dictionaryForKey:[self userDefaultsKey]];
  if (errorRecoveryStore) {
    NSString *props = errorRecoveryStore[_scopeKey];
    if (props) {
      NSMutableDictionary *storeWithRemovedProps = [errorRecoveryStore mutableCopy];
      [storeWithRemovedProps removeObjectForKey:_scopeKey];
      [preferences setObject:storeWithRemovedProps forKey:[self userDefaultsKey]];
      [preferences synchronize];
      return props;
    }
  }
  return nil;
}

@end
#endif
