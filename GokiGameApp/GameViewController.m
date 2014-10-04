//
//  GameViewController.m
//  GokiGameApp
//
//  Created by 石毛 和夫 on 2014/09/27.
//  Copyright (c) 2014年 Tomohiro Inagaki & Kazuo Ishige. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "TitleScene.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

/***********************
 methodName:viewDidLoad
 Func:storyBoardからインスタンス化され、ロードされた時に呼ばれる
************************/
- (void)viewDidLoad
{
    /*親クラスのメソッド実行*/
    [super viewDidLoad];

    /* デバッグコードをON */
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
      //zPositionの描画順序を任意としパフォーマンスを向上させる
    skView.ignoresSiblingOrder = YES;

    /* SceneをViewに設定 */
    TitleScene *scene = [TitleScene sceneWithSize:skView.bounds.size];  //指定したサイズのシーンオブジェクトを作成
    scene.scaleMode = SKSceneScaleModeAspectFill;   //SceneとViewのサイズが異なる場合の表示方法の設定
    [skView presentScene:scene];                    //ViewにSceneを設定し表示
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
