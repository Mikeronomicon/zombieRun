//
//  GameScene.m
//  Zombie Conga
//
//  Created by Michael Lorenzo on 11/12/15.
//  Copyright (c) 2015 Michael Lorenzo. All rights reserved.
//

#import "GameScene.h"

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointSubtract(const CGPoint a, const CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b) {
    return CGPointMake(a.x * b, a.y * b);
}

static inline CGFloat CGPointLength(const CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

static inline CGPoint CGPointNormalize(const CGPoint a) {
    CGFloat length = CGPointLength(a);
    return CGPointMake(a.x / length, a.y / length);
}

static inline CGFloat CGPointToAngle(const CGPoint a) {
    return atan2f(a.y, a.x);
}

static const float ZOMBIE_MOVE_POINTS_PER_SEC = 120.0;

@implementation GameScene

{
    SKSpriteNode *_zombie;
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    CGPoint _velocity;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor whiteColor];
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        bg.anchorPoint = CGPointMake(0.5, 0.5); // same as default
        //bg.zRotation = M_PI / 8;
        [self addChild:bg];
        CGSize mySize = bg.size;
        NSLog(@"Size: %@", NSStringFromCGSize(mySize));
        _zombie = [SKSpriteNode spriteNodeWithImageNamed:@"zombie1"];
        [self moveSprite:_zombie velocity:CGPointMake(ZOMBIE_MOVE_POINTS_PER_SEC, 0)];
        [self addChild:_zombie];

    }
    return self;
}

-(void)update:(NSTimeInterval)currentTime {
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    } else {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    NSLog(@"%0.2f milliseconds since last update", _dt * 1000);
//    _zombie.position = CGPointMake(_zombie.position.x + 2, _zombie.position.y);
    [self moveSprite:_zombie velocity:_velocity];
    [self boundsCheckPlayer];
    [self rotateSprite:_zombie toFace:_velocity];
}

-(void)moveSprite:(SKSpriteNode *)sprite velocity:(CGPoint)velocity {
    CGPoint amountToMove = CGPointMake(velocity.x * _dt, velocity.y * _dt);
    NSLog(@"Amount to move: %@", NSStringFromCGPoint(amountToMove));
    
    sprite.position = CGPointMake(sprite.position.x + amountToMove.x, sprite.position.y + amountToMove.y);
}

-(void)rotateSprite:(SKSpriteNode *)sprite toFace:(CGPoint)direction {
    sprite.zRotation = atan2f(direction.y, direction.x);
}

-(void)moveZombieToward:(CGPoint)location {
    CGPoint offset = CGPointMake(location.x - _zombie.position.x, location.y - _zombie.position.y);
    CGFloat length = sqrtf(offset.x * offset.x + offset.y * offset.y);
    CGPoint direction = CGPointMake(offset.x / length, offset.y / length);
    _velocity = CGPointMake(direction.x * ZOMBIE_MOVE_POINTS_PER_SEC, direction.y * ZOMBIE_MOVE_POINTS_PER_SEC);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    [self moveZombieToward:touchLocation];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    [self moveZombieToward:touchLocation];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    [self moveZombieToward:touchLocation];
}

-(void)boundsCheckPlayer {
    CGPoint newPosition = _zombie.position;
    CGPoint newVelocity = _velocity;
    
    CGPoint bottomLeft = CGPointZero;
    CGPoint topRight = CGPointMake(self.size.width, self.size.height);
    
    if (newPosition.x <= bottomLeft.x) {
        newPosition.x = bottomLeft.x;
        newVelocity.x = -newVelocity.x;
    }
    if (newPosition.x >= topRight.x) {
        newPosition.x = topRight.x;
        newVelocity.x = -newVelocity.x;
    }
    if (newPosition.y <= bottomLeft.y) {
        newPosition.y = bottomLeft.y;
        newVelocity.y = -newVelocity.y;
    }
    if (newPosition.y >= topRight.y) {
        newPosition.y = topRight.y;
        newVelocity.y = -newVelocity.y;
    }
    _zombie.position = newPosition;
    _velocity = newVelocity;
}

@end
