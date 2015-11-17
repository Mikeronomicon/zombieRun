//
//  GameScene.m
//  Zombie Conga
//
//  Created by Michael Lorenzo on 11/12/15.
//  Copyright (c) 2015 Michael Lorenzo. All rights reserved.
//

#import "GameScene.h"

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
    _zombie.position = CGPointMake(_zombie.position.x + 2, _zombie.position.y);
}

-(void)moveSprite:(SKSpriteNode *)sprite velocity:(CGPoint)velocity {
    CGPoint amountToMove = CGPointMake(velocity.x * _dt, velocity.y * _dt);
    NSLog(@"Amount to move: %@", NSStringFromCGPoint(amountToMove));
    
    sprite.position = CGPointMake(sprite.position.x + amountToMove.x, sprite.position.y + amountToMove.y);
}

@end
