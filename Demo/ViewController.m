//
//  ViewController.m
//  Demo
//
//  Created by 索晓晓 on 16/9/30.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "LinkAnimationView.h"
#import "AnimationView.h"

@interface ViewController ()
{
    UIScrollView                *_scrllView;
    FirstViewController         *_firstVC;
    SecondViewController        *_secondVC;
    LinkAnimationView           *_aniView;
    AnimationView               *_moveView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //80 - 30 - 20 - 30 - 20 - 40
    _aniView = [[LinkAnimationView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 220)/2, 64, 220, 80)];
    _aniView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_aniView];
    
    //首先分三段动画
    _moveView = [[AnimationView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 220)/2, 64, 220, 80)];
    _moveView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_moveView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 300, 150, 50);
    [btn setTitle:@"右往左动画" forState:0];
    [btn setTitleColor:[UIColor redColor] forState:0];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 370, 150, 50);
    [btn1 setTitle:@"左往右动画" forState:0];
    [btn1 setTitleColor:[UIColor redColor] forState:0];
    [btn1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
}

- (void)btnClick:(UIButton *)sender
{
    
    [_moveView formRightToLeftAnimation];
}

- (void)btn1Click:(UIButton *)sender{
    
    [_moveView formLeftToRightAnimation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
