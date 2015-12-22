//
//  ViewController.m
//  Frist
//
//  Created by mengyun on 15/12/20.
//  Copyright © 2015年 mengyun. All rights reserved.
//

#import "ViewController.h"
#import "GOFViewController.h"
#define Frame_Times  ([[UIScreen mainScreen] bounds].size.width/375.0)
#define Num 3

@interface ViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *sView;
@property (strong, nonatomic) GOFViewController *GOFViewCtl;
@property (strong, nonatomic) UIView *leftViewSet;
@property (assign, nonatomic) CGFloat times;
//@property (strong, nonatomic) UIButton *set;

@end

@implementation ViewController

- (void)setTimes:(CGFloat)newTimes
{
    _times = newTimes;
    if (_times > 0) {
        _leftViewSet.frame = CGRectMake(100 - 100*_times, 334 - 200*_times, 100*_times, 400*_times);
        for (int i = 1; i<=Num; ++i) {
            UIButton *tmpBtn = [_leftViewSet subviews][i-1];
            tmpBtn.frame = CGRectMake(4, 10+35*(i-1)*_times, 100*_times-12, 30*_times);
            if (_times> 0.5) {
                [tmpBtn setTitle:[NSString stringWithFormat:@"__%d__",i] forState:UIControlStateNormal];
            }else {
                [tmpBtn setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _times = 0.0001;
    _sView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 375*Frame_Times, 667*Frame_Times)];
    [_sView setBackgroundColor:[UIColor lightGrayColor]];
    _sView.contentSize = CGSizeMake(575*Frame_Times, 0);
    _sView.showsVerticalScrollIndicator = NO;
    _sView.showsHorizontalScrollIndicator = NO;
    _sView.bounces = NO;
    //_sView.pagingEnabled = YES;
    _sView.delegate = self;
    [self.view addSubview:_sView];
    
    self.GOFViewCtl = [[GOFViewController alloc] init];
    [self.GOFViewCtl.view setFrame:CGRectMake(100, 0, 375*Frame_Times, 667*Frame_Times)];
    [self.GOFViewCtl.view setBackgroundColor:[UIColor lightGrayColor]];
    [self addChildViewController:self.GOFViewCtl];
    [_sView addSubview:self.GOFViewCtl.view];//375+187=562;
    
    
    _leftViewSet = [[UIView alloc] initWithFrame:CGRectMake(1,1,1,1)];
    [_leftViewSet setBackgroundColor:[UIColor grayColor]];
    [_leftViewSet.layer setCornerRadius:5];
    
    for (int i = 1; i<=Num; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(1, 1, 1, 1);
        [btn.layer setCornerRadius:5.0];
        [btn setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.8]];
        [_leftViewSet addSubview:btn];
        [btn setAccessibilityIdentifier:[[NSString alloc]initWithFormat:@"%d",i]];
        [btn addTarget:self action:@selector(clickToSetGOF:) forControlEvents:UIControlEventTouchUpInside];
    }
      [_sView addSubview:_leftViewSet];
    
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame = CGRectMake(4, 10, 88, 30);
//    [btn1 setTitle:@"11111" forState:UIControlStateNormal];
//    [btn1.layer setCornerRadius:5.0];
//    [btn1 setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.8]];
//    [leftViewSet addSubview:btn1];
//    [btn1 addTarget:self action:@selector(clickToSetGOF1:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn2.frame = CGRectMake(4, 45, 88, 30);
//    [btn2 setTitle:@"22222" forState:UIControlStateNormal];
//    [btn2.layer setCornerRadius:5.0];
//    [btn2 setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.8]];
//    [leftViewSet addSubview:btn2];
//    [btn2 addTarget:self action:@selector(clickToSetGOF2:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *setLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    setLeft.frame = CGRectMake(101, 10, 40, 50);
    [setLeft setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    [_sView addSubview:setLeft];
    [setLeft addTarget:self action:@selector(clickToSet:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *setRight = [UIButton buttonWithType:UIButtonTypeCustom];
    setRight.frame = CGRectMake(100+375*Frame_Times-42, 10, 40, 50);
    [setRight setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    [_sView addSubview:setRight];
    [setRight addTarget:self action:@selector(clickToSet:) forControlEvents:UIControlEventTouchUpInside];
    
    [_sView setContentOffset:CGPointMake(100, 0)];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [_sView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //[_sView removeObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    CGFloat xx = _sView.contentOffset.x;
    self.times = 1 - xx/100.0;
    //NSLog(@"__%lf_",_times);
}

- (void) clickToSet:(UIButton *)btn
{
    if (_sView.contentOffset.x == 0 || _sView.contentOffset.x == 200) {
        [_sView setContentOffset:CGPointMake(100, 0)animated:YES];
    }else if (_sView.contentOffset.x == 100 && btn.center.x > 200){
        [_sView setContentOffset:CGPointMake(200, 0)animated:YES];
    }else{
        [_sView setContentOffset:CGPointMake(0, 0)animated:YES];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetX = _sView.contentOffset.x;
    if (offsetX <= 50) {
        offsetX = 0;
    }else if (offsetX <= 150){
        offsetX = 100;
    }else if (offsetX <= 200){
        offsetX = 200;
    }
    [_sView setContentOffset:CGPointMake(offsetX, 0)animated:YES];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

- (void) clickToSetGOF:(UIButton *)btn
{
    NSInteger btnID = [btn.accessibilityIdentifier intValue];
    [_GOFViewCtl setDataWithFlag:btnID];
    [_sView setContentOffset:CGPointMake(100, 0)animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
















