/*
    NSRelationshipDescription.h
    Core Data
    Copyright (c) 2004-2009 Apple Inc.
    All rights reserved.
*/

#import <Availability.h>

#import <Foundation/NSObject.h>

#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_4 || __IPHONE_3_0 <=  __IPHONE_OS_VERSION_MAX_ALLOWED

#import <CoreData/NSPropertyDescription.h>

@class NSEntityDescription;

 enum {
    NSNoActionDeleteRule,
    NSNullifyDeleteRule,
    NSCascadeDeleteRule,
    NSDenyDeleteRule
} ;

typedef NSUInteger NSDeleteRule;

// Relationships represent references to other objects. They usually come in pairs, where the reference back is called the "inverse".
NS_CLASS_AVAILABLE(10_4, 3_0)
@interface NSRelationshipDescription : NSPropertyDescription {
@private
	void *_reserved5;
	void *_reserved6;
    __weak NSEntityDescription *_destinationEntity;
    NSString *_lazyDestinationEntityName;
    NSRelationshipDescription *_inverseRelationship;
    NSString *_lazyInverseRelationshipName;
    unsigned long _maxCount;
    unsigned long _minCount;
    NSDeleteRule _deleteRule;
}

- (NSEntityDescription *)destinationEntity;
- (void)setDestinationEntity:(NSEntityDescription *)entity;
- (NSRelationshipDescription *)inverseRelationship;
- (void)setInverseRelationship:(NSRelationshipDescription *)relationship;

// Min and max count indicate the number of objects referenced (1/1 for a to-one relationship, 0 for the max count means undefined) - note that the counts are only enforced if the relationship value is not nil/"empty" (so as long as the relationship value is optional, there might be zero objects in the relationship, which might be less than the min count)
- (NSUInteger)maxCount;
- (void)setMaxCount:(NSUInteger)maxCount;
- (NSUInteger)minCount;
- (void)setMinCount:(NSUInteger)minCount;

- (NSDeleteRule)deleteRule;
- (void)setDeleteRule:(NSDeleteRule)rule;

- (BOOL)isToMany;    // convenience method to test whether the relationship is to-one or to-many

/* Returns the version hash for the relationship.  This value includes the versionHash information from the NSPropertyDescription superclass, the name of the destination entity and the inverse relationship, and the min and max count.
*/
- (NSData *)versionHash __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_3_0);


@end

#endif
