//
//  ResultScene.m
//  GokiGameApp
//
//  Created by 石毛 和夫 on 2014/09/28.
//  Copyright (c) 2014年 Tomohiro Inagaki & Kazuo Ishige. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultScene.h"

@implementation ResultScene

/***********************
 methodName:didMoveToView
 Func:SceneがViewに提示された直後に呼ばれる
 ************************/
-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    /* Title */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"GameOver!！";
    myLabel.fontSize = 45;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    [self addChild:myLabel];
    
}

/***********************
 methodName:touchesBegan
 Func:タッチした時に呼ばれる
 ************************/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
    
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

