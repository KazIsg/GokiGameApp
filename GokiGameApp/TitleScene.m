//
//  TitleScene.m
//  GokiGameApp
//
//  Created by 石毛 和夫 on 2014/09/27.
//  Copyright (c) 2014年 Tomohiro Inagaki & Kazuo Ishige. All rights reserved.
//

#import "TitleScene.h"
#import "GameScene.h"

@implementation TitleScene

/***********************
 methodName:didMoveToView
 Func:SceneがViewに提示された直後に呼ばれる
 ************************/
-(void)didMoveToView:(SKView *)view {

    /* Title */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"]; //Font名を指定してオブジェクト生成
    myLabel.text = @"G退治!！";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    [self addChild:myLabel];    //シーンに小ノードとして追加
    
    /* StartButton */
    SKLabelNode *pleaseTouch = [SKLabelNode labelNodeWithFontNamed:@"Baskerville-Bold"]; //Font名を指定してオブジェクト生成
    pleaseTouch.text = @"GAME START";
    pleaseTouch.fontSize = 20;
    pleaseTouch.position = CGPointMake(CGRectGetMidX(self.frame), 80);
    [self addChild:pleaseTouch];    //シーンに小ノードとして追加
      //Action追加
    NSArray* actions = @[[SKAction fadeAlphaTo:0.0 duration:0.75],[SKAction fadeAlphaTo:1.0 duration:0.75]];
    SKAction* action = [SKAction repeatActionForever:[SKAction sequence:actions]];
    [pleaseTouch runAction:action];
    
}

/***********************
 methodName:touchesBegan
 Func:タッチした時に呼ばれる
 ************************/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    /*画面遷移*/
    GameScene* Scene = [[GameScene alloc] initWithSize:self.size];
    SKTransition *tr = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:Scene transition:tr];

}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end