//
//  TimerTask.m
//  SimmerLabelDemo
//
//  Created by l on 16/8/12.
//  Copyright © 2016年 l. All rights reserved.
//

#import "TimerTask.h"
#import <pthread.h>

@interface TimerTask ()

@property (nonatomic, strong) NSMutableDictionary *timers;
@property (nonatomic, copy) dispatch_block_t block;
@property (nonatomic, strong) id identifier;

@end

@implementation TimerTask {
    pthread_mutex_t _lock;
}

+ (instancetype)sharedInstance {
    static TimerTask *task;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        task = [[TimerTask alloc] initInner];
    });
    return task;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Init TimerTask Error"
                                   reason:@"TimerTask is a single instance,must use +sharedInstance method to initialize "
                                 userInfo:nil];
}

- (instancetype)initInner
{
    self = [super init];
    if (self) {
        
        pthread_mutex_init(&_lock, NULL);
        _timers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addTimer:(NSTimer *)timer target:(id)target {
    
    pthread_mutex_lock(&_lock);
    [_timers setObject:timer forKey:[self keyOfTarget:target]];
    pthread_mutex_unlock(&_lock);
}

- (void)removeTimerWittarget:(id)target {
    
    pthread_mutex_lock(&_lock);
    NSString *timerKey = [self keyOfTarget:target];
    NSTimer *timer = [_timers objectForKey:timerKey];
    [timer invalidate];
    [_timers removeObjectForKey:timerKey];
    pthread_mutex_unlock(&_lock);
}

- (void)removeAllTimers {
    
    pthread_mutex_lock(&_lock);
    [_timers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSTimer *obj, BOOL * _Nonnull stop) {
        [obj invalidate];
    }];
    pthread_mutex_unlock(&_lock);
}

- (NSString *)keyOfTarget:(id)target {
    return [NSString stringWithFormat:@"ljw+%p",target];
}

- (BOOL)containTarget:(id)target {
    return [_timers objectForKey:[self keyOfTarget:target]];
}

- (void)addTimerTaskWith:(NSTimeInterval)timeInterval target:(id)aTarget userInfo:(NSDictionary *)userInfo repeats:(BOOL)repeats processBlock:(dispatch_block_t)block{
    _block = block;
    [self addTimer:[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(processBlock) userInfo:userInfo repeats:YES] target:aTarget];
}

- (void)processBlock {
    if (_block) {
        _block();
    }
}

@end

