//
//  GameScene.m
//  GokiGameApp
//
//  Created by 石毛 和夫 on 2014/09/27.
//  Copyright (c) 2014年 Tomohiro Inagaki & Kazuo Ishige. All rights reserved.
//

#import "GameScene.h"
#import "ResultScene.h"

@implementation GameScene

/***********************
 methodName:initWithSize
 Func:指定したサイズのSceneオブジェクトを作成する
 ************************/
-(id)initWithSize:(CGSize)size {

    /* Sprite表示 */
    if(self = [super initWithSize:size]) {
        /* 背景 */
        SKSpriteNode* space = [SKSpriteNode spriteNodeWithImageNamed:@"GameBack.png"];
        space.position = CGPointMake(self.size.width/2, self.size.height/2);    //CGPointMake関数 対象オブジェクトの位置
        space.name = kBackName;
        [self addChild:space];  //Sceneに子ノードを追加
        
        /* 地球 */
        SKSpriteNode* earth = [SKSpriteNode spriteNodeWithImageNamed:@"Earth.png"];
        earth.position = CGPointMake(self.size.width/2, earth.size.height/2);
        earth.name = kEarthName;
        [self addChild:earth];
          // 物理シミュレーション
            // 矩形ボリュームベースの物理体作成
        earth.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(earth.size.width, earth.size.height/2)];
        earth.physicsBody.dynamic = NO; //重力や接触の影響なし
          // 接触設定
        earth.physicsBody.categoryBitMask = earthCategory;
        earth.physicsBody.collisionBitMask = 0;
        
        /* 宇宙船 */
        SKSpriteNode *spaceship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship_1.png"];
        spaceship.position = CGPointMake(self.size.width/2, spaceship.size.height);
        spaceship.name = kSpaceshipName;
        [self addChild:spaceship];
          // 物理シミュレーション
            // 円形ボリュームベースの物理体作成
        spaceship.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:spaceship.size.width/2];
        spaceship.physicsBody.dynamic = NO;  //重力や接触の影響なし
          // 接触設定
        spaceship.physicsBody.categoryBitMask = spaceshipCategory;
        spaceship.physicsBody.collisionBitMask = 0;
 
        /* 物理シミュレーション(World) */
          // 重力設定
        self.physicsWorld.gravity = CGVectorMake(0, -(9.8*0.02));   //隕石を落とすために重力を1/50に設定(引数はx,y軸)
          // 接触デリゲード
        self.physicsWorld.contactDelegate = self;   //★クラスでデリゲードを宣言しないとエラーとなる。処理不明！！
    
        /* ミサイルのテクスチャ */
        _textureMissile = [SKTexture textureWithImageNamed:@"Missile.png"]; //テクスチャオブジェクト作成
        
        /* 隕石のテクスチャ */
        _textureMeteor = [SKTexture textureWithImageNamed:@"Meteor.png"]; //テクスチャオブジェクト作成
        
        /* 隕石を一定間隔でランダムに作る */
        SKAction *makeMeteors = [SKAction sequence: @[  //複数アクション(配列の要素)を順番に連続して実行
                                    // 実行時にメソッドを実行
                                    [SKAction performSelector:@selector(addMeteor) onTarget:self],
                                    // 1.6秒の時間内で平均1.8秒の任意な時間アクションが継続
                                    [SKAction waitForDuration:1.8 withRange:1.6]]
                                 ];
        [self runAction: [SKAction repeatActionForever:makeMeteors]];
        
    } else {
        // debugCode 後でマクロ定義させ、リリース時には空実装とする（★A.I）
        NSLog(@"GameScene Object取得エラー");
    }
    
    return self;
}

/***********************
 methodName:didMoveToView
 Func:SceneがViewに提示された直後に呼ばれる
 ************************/
-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Hello, World!";
    myLabel.fontSize = 10;
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

    /* 宇宙船の回頭中はミサイル発射不可 */
    if( _isRotating==NO ) {
        //タッチ位置
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        //名前から宇宙船を検索
        SKNode *spaceship = [self childNodeWithName:kSpaceshipName];    //小ノード検索
        //宇宙船の位置
        CGPoint spaceship_pt = spaceship.position;
        //宇宙船の新しい角度
        CGFloat radian = -(atan2f(location.x-spaceship_pt.x, location.y-spaceship_pt.y));
        //回転角度から回転時間を求める
        CGFloat diff = fabsf(spaceship.zRotation-radian);
        NSTimeInterval time = diff * 0.3; //回転速度係数
        
        //宇宙船回頭
        _isRotating = YES;
        SKAction *rotate;
        rotate = [SKAction rotateToAngle:radian duration:time]; //ノードを回転させるアクションオブジェクト
        [spaceship runAction:rotate completion:^{   //SKAction完了後にブロック内の処理が呼ばれる
            _isRotating = NO;
            /* ミサイル作成 */
            SKSpriteNode *missaile;
            missaile = [SKSpriteNode spriteNodeWithTexture:_textureMissile];
            missaile.position = CGPointMake(spaceship_pt.x, spaceship_pt.y);
            missaile.name = kMissileName;
            [self addChild:missaile];
            //物理シミュレーション
            missaile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:missaile.size]; // 矩形ボリュームベースの物理体作成
            //宇宙船の向きにミサイル発射(SKActionでは無く物理法則でミサイルを飛ばす)
            missaile.zRotation = radian;
            CGFloat x = sin(radian);
            CGFloat y = cos(radian);
            missaile.physicsBody.velocity = CGVectorMake(-(400*x), (400*y)); //x,y軸を指定してに指定方向に力を設定
            //接触設定
            //カテゴリ（ミサイル）
            missaile.physicsBody.categoryBitMask = missileCategory;
            missaile.physicsBody.contactTestBitMask = meteorCategory;   //隕石とは接触するように設定
            missaile.physicsBody.collisionBitMask = meteorCategory;     //隕石とは衝突するように設定
            
        }];
    }
        
}

/***********************
 methodName:addMeteor
 Func:隕石のランダム作成
 ************************/
- (void) addMeteor
{
//    if(_gameOver){
//        return;
//    }
    
    SKSpriteNode *meteor = [SKSpriteNode spriteNodeWithTexture:_textureMeteor]; //指定したTextureObjecのSpriteObject作成
    meteor.position = CGPointMake(skRand(40, 240), self.size.height);
    meteor.name = kMeteorName;
    //物理シミュレーション
    meteor.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:meteor.size.width/2];
    [self addChild:meteor];
    //接触設定
    meteor.physicsBody.categoryBitMask = meteorCategory;		//カテゴリー（隕石）
    meteor.physicsBody.contactTestBitMask = spaceshipCategory|earthCategory;//ヒットテストするオブジェクト（宇宙船／ミサイル）
    meteor.physicsBody.collisionBitMask = spaceshipCategory|earthCategory;	//接触できるオブジェクト（宇宙船／ミサイル）
    
    //下方向に回転させて発射
    meteor.physicsBody.velocity = CGVectorMake(skRand(-25, 25), -(skRand(50, 60))); //velocity:加える力の設定
    [meteor.physicsBody applyTorque:0.04];  //物理体に指定したトルクを加えて回転
    
}

/***********************
 methodName:didSimulatePhysics
 Func:物理シュミレーションが実行された毎フレームごとに1回呼ばれるメソッド
 ************************/
- (void) didSimulatePhysics
{
    /* 画面外の隕石を消す */
      // ノードツリーを検索し、見つかる度にブロックスにそのノードらを返す
    [self enumerateChildNodesWithName:kMeteorName usingBlock:^(SKNode *node, BOOL *stop) {
            if(node.position.y < 0 || node.position.x < 0 || node.position.x > 320)
                [node removeFromParent];    //ノードシーンから削除
    }];
    
    /* 画面外のミサイルを消す */
      // ノードツリーを検索し、見つかる度にブロックスにそのノードらを返す
    [self enumerateChildNodesWithName:kMissileName usingBlock:^(SKNode *node, BOOL *stop) {
        if(node.position.y > self.frame.size.height || node.position.y < 0
            || node.position.x < 0 || node.position.x > 320)
            [node removeFromParent];    //ノードシーンから削除
    }];
}

/***********************
 methodName:didBeginContact
 Func:衝突判定通知のデリゲードメソッド
 ************************/
- (void) didBeginContact:(SKPhysicsContact *)contact
{
    /* 衝突したものを判定し、必要によってノードを削除 */
    NSString *bodyNameA = contact.bodyA.node.name;  //接触したオブジェクトのbodyAの名前を設定（？接触Bが隕石と固定？）
      //隕石が地球に落下
    if([bodyNameA isEqualToString:kEarthName]){
    }
      //隕石が宇宙船に衝突
    if([bodyNameA isEqualToString:kSpaceshipName]){
        //宇宙船を削除
        [contact.bodyA.node removeFromParent];
        //結果画面遷移
        [self showGameOver];
    }
      //隕石がミサイルに衝突
    if([bodyNameA isEqualToString:kMissileName]){
        //ミサイルを削除
        [contact.bodyA.node removeFromParent];
    }
    
    //隕石を削除
    [contact.bodyB.node removeFromParent];
}

/***********************
 methodName:showGameOver
 Func:ゲームオーバー時の結果画面遷移
 ************************/
- (void) showGameOver
{
    /* 結果画面へ遷移 */
    ResultScene* Scene = [[ResultScene alloc] initWithSize:self.size];
    SKTransition *tr = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:Scene transition:tr];
}

/***********************
 methodName:skRand
 Func:?
 ************************/
static inline CGFloat skRand(CGFloat low, CGFloat high)
{
    return skRandf() * (high - low) + low;
}

/***********************
 methodName:skRandf
 Func:?
 ************************/
static inline CGFloat skRandf()
{
    return rand() / (CGFloat) RAND_MAX;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
