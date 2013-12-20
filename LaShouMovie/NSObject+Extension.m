//
//  NSObject+Extension.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects
{
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    if (signature!=nil)
    {
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        for(int i = 0; i < [objects count]; i++)
        {
            id object = [objects objectAtIndex:i];
            [invocation setArgument:&object atIndex:(i+2)];//这里很容易错，因为需要将id类型再次包装一下
        }
        //retain 所有参数，防止参数被释放
        [invocation retainArguments];
        
        [invocation invoke];
        if (signature.methodReturnLength)
        {
            id anObject;
            [invocation getReturnValue:&anObject];
            return anObject;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

//获取安全数据
//规则 无论是字符串、字典、数组，当为NULL、[NSNull null]的时候，统一转换为nil，可以最大程度的避免数据空问题
//注意传进来的data必须为NSMutable*类型
- (void)makeSafe
{
    if([[self class] isSubclassOfClass:[NSMutableDictionary class]])
    {
        NSMutableDictionary* anotherSelf=(NSMutableDictionary*)self;
        for (NSString* key in [anotherSelf allKeys])
        {
            id value=[anotherSelf objectForKey:key];
            if(value==NULL || value==[NSNull null])
            {
                [anotherSelf setObject:LSNULL forKey:key];
            }
            else if([[value class] isSubclassOfClass:[NSMutableDictionary class]])
            {
                [value makeSafe];
            }
            else if([[value class] isSubclassOfClass:[NSMutableArray class]])
            {
                [value makeSafe];
            }
        }
    }
    else if([[self class] isSubclassOfClass:[NSMutableArray class]])
    {
        NSMutableArray* anotherSelf=(NSMutableArray*)self;
        for(int i=0;i<anotherSelf.count;i++)
        {
            id value=[anotherSelf objectAtIndex:i];
            if(value ==NULL || value==[NSNull null])
            {
                [anotherSelf removeObjectAtIndex:i];
            }
            else if([[value class] isSubclassOfClass:[NSMutableDictionary class]])
            {
                [value makeSafe];
            }
            else if([[value class] isSubclassOfClass:[NSMutableArray class]])
            {
                [value makeSafe];
            }
        }
    }
}

@end
