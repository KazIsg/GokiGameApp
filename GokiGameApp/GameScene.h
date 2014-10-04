//
//  GameScene.h
//  GokiGameApp
//

//  Copyright (c) 2014年 Tomohiro Inagaki & Kazuo Ishige. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

//オブジェクト名
#define kBackName       @"Back"         //背景
#define kEarthName      @"Earth"        //地球
#define kSpaceshipName  @"Spaceship"    //宇宙船
#define kMissileName    @"Missile"      //ミサイル
#define kMeteorName     @"Meteor"       //隕石

//カテゴリビットマスク
static const uint32_t missileCategory = 0x1 << 0;   //ミサイル
static const uint32_t meteorCategory = 0x1 << 1;    //隕石
static const uint32_t earthCategory = 0x1 << 2;     //地球
static const uint32_t spaceshipCategory = 0x1 << 3; //宇宙船

@interface GameScene : SKScene <SKPhysicsContactDelegate>   //★デリゲードが不明！！
{
    BOOL _isRotating;   //宇宙船回転中フラグ
    SKTexture *_textureMissile; //ミサイルのテクスチャ
    SKTexture *_textureMeteor;  //隕石のテクスチャ
}

- (void) showGameOver; //ゲーム終了メソッド

@end
