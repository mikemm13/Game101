//
//  MyScene.m
//  Game101
//
//  Created by Miguel Martin Nieto on 11/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Tank War!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       self.frame.size.height - myLabel.frame.size.height);
        
        [self addChild:myLabel];
        
        NSString *snowParticleFile = [[NSBundle mainBundle] pathForResource:@"snow" ofType:@"sks"];
        SKEmitterNode *snow = [NSKeyedUnarchiver unarchiveObjectWithFile:snowParticleFile];
        [snow setPosition:myLabel.position];
        [self addChild:snow];
        [self launchTanks];
    }
    return self;
}

- (void)launchTanks{
    for (int i = 0; i<10; i++) {
        CGPoint location = CGPointMake(0, self.frame.size.height - 50 * i);
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"tank"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction moveBy:CGVectorMake(100, 0) duration:2];
        SKAction *sound = [SKAction playSoundFileNamed:@"tank.wav" waitForCompletion:NO];
        
        [sprite runAction:sound];
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
    
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"tank"];
        
        SKAction *sound = [SKAction playSoundFileNamed:@"explosion.wav" waitForCompletion:YES];
        NSString *fireParticleFile = [[NSBundle mainBundle] pathForResource:@"Tankfire" ofType:@"sks"];
        SKEmitterNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:fireParticleFile];
        [fire setPosition:location];
        [self addChild:fire];

        
        [sprite runAction:sound completion:^{
            [fire removeFromParent];
        }];
        
    
        [self addChild:sprite];
        
        NSArray *nodes = [self nodesAtPoint:location];
        for (SKNode *node in nodes) {
            if ([node isKindOfClass:[SKSpriteNode class]]) {
                [node removeFromParent];
            }
        }
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
