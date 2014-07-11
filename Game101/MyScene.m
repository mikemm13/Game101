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
        
        
        SKSpriteNode *sn = [SKSpriteNode spriteNodeWithImageNamed:@"background.jpg"];
        sn.name = @"background";
        sn.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:sn];
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Tank War!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       self.frame.size.height - myLabel.frame.size.height);
        myLabel.fontColor = [UIColor whiteColor];
        
        [self addChild:myLabel];
        
        NSString *snowParticleFile = [[NSBundle mainBundle] pathForResource:@"snow" ofType:@"sks"];
        SKEmitterNode *snow = [NSKeyedUnarchiver unarchiveObjectWithFile:snowParticleFile];
        [snow setPosition:myLabel.position];
        [self addChild:snow];
        [self launchTanks];
        [self loadLions];
        
    }
    return self;
}

- (void)launchTanks{
    for (int i = 0; i<10; i++) {
        CGPoint location = CGPointMake(0, self.frame.size.height - 50 * i);
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"tank"];
        
        sprite.position = location;
        
        int yCoordOdd = -1 * (arc4random()%100);
        int yCoordEven = arc4random()%100;
        CGVector vector;
        if (i%2 == 0) {
            vector = CGVectorMake(100, yCoordEven);
        } else {
            vector = CGVectorMake(100, yCoordOdd);
        }
        SKAction *action = [SKAction moveBy:vector duration:2];
        SKAction *sound = [SKAction playSoundFileNamed:@"tank.wav" waitForCompletion:NO];
        SKAction *biggerScale = [SKAction scaleBy:4.0 duration:1];
        SKAction *smallerScale = [SKAction scaleBy:0.25 duration:1];
        [sprite runAction:sound];
        [sprite runAction:[SKAction repeatActionForever:action]];
        [sprite runAction:[SKAction repeatActionForever:biggerScale]];
        [sprite runAction:[SKAction repeatActionForever:smallerScale]];
        [self addChild:sprite];
    }

}

- (void) loadLions{
    SKSpriteNode *lion;
    NSMutableArray *walkFrames = [NSMutableArray array];
    
    for (int i=1; i<=3; i++) {
        NSString *textureName = [NSString stringWithFormat:@"lion%02d.png",i];
        SKTexture *temp = [SKTexture textureWithImageNamed:textureName];
        [walkFrames addObject:temp];
    }
    
    lion = [SKSpriteNode spriteNodeWithTexture:walkFrames[0]];
    lion.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:lion];
    
    [lion runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:walkFrames timePerFrame:0.1f resize:NO restore:YES]] withKey:@"lionAnimating"];
    
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
                if (!node.name) {
                    [node removeFromParent];                    
                }
            }
        }
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
