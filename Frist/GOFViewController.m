//
//  ViewController.m
//  UITest
//
//  Created by 孟云 on 15/8/11.
//  Copyright (c) 2015年 Bar. All rights reserved.
//

#import "GOFViewController.h"
//#import "GOFmodel.h"
//#import "StartViewController.h"
#import "AppDelegate.h"
#define Frame_Times  ([[UIScreen mainScreen] bounds].size.width/375.0)

@interface GOFViewController ()

@property(nonatomic, strong) UIView *gameView;
@property(nonatomic, strong) UIButton *preBtn;
@property(nonatomic, strong) UIButton *nextBtn;
@property(nonatomic, strong) UIButton *timeBtn;
@property(nonatomic, strong) UIButton *restartBtn;
@property(nonatomic, strong) UIButton *addBtn;
@property(nonatomic, strong) UIButton *deleteBtn;

@property(nonatomic, strong) UITextField *xText;
@property(nonatomic, strong) UITextField *yText;
@property(nonatomic, strong) UILabel *genLable;


@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)NSMutableArray *tmpdata;
@property(nonatomic,assign)int firstBtnIndex;
@property(nonatomic,assign)int generation;
@property(nonatomic,assign)int nSize;
//@property(nonatomic,assign)NSInteger currentBtnId;

@property(nonatomic,strong)NSTimer *timer;

//- (int) getAroundAliveNum:(int)btnID;

@end

@implementation GOFViewController

- (NSMutableArray *)data
{
    //AppDelegate *appDlg = [[UIApplication sharedApplication] delegate];
    //self.nSize = appDlg.nSize;
    if (!_data)
    {
        _data = [NSMutableArray array];
        for (int i=0;i<self.nSize*self. nSize;++i)
        {
            [_data addObject:[NSNumber numberWithBool:NO]];
        }
        
    }
    return _data;
}

- (NSMutableArray *)tmpdata
{
    if (!_tmpdata)
    {
        _tmpdata = [self.data mutableCopy];
    }
    return _tmpdata;
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.timer !=nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //AppDelegate *appDlg = [[UIApplication sharedApplication] delegate];
    _nSize = 22;//appDlg.nSize;
    //NSLog(@"%@",self.data);
    //UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:nil action:nil];
    //self.navigationItem.rightBarButtonItem = bar;
    self.navigationItem.title = @"Game Of Life";
    //self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.generation=0;
    
    NSUInteger count = [self.data count];
    [self initGameViewWithCellNumber:count];
    [self initOtherViews];
    
    self.firstBtnIndex = 2;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)initGameViewWithCellNumber:(NSInteger)number
{
    CGFloat navHeight = 51;
    CGFloat startX = 10;
    CGFloat startY = 0+navHeight;
    CGFloat totalWidth = self.view.frame.size.width - 2*startX;
    CGFloat width = totalWidth/self.nSize;
    _gameView = [[UIView alloc]initWithFrame:CGRectMake(startX, startY, totalWidth, totalWidth)];
    [_gameView setBackgroundColor:[UIColor purpleColor]];
    [self.view addSubview:_gameView];
    
    for (int i=0;i<number;++i)
    {
        int row = i/self.nSize;
        int loc = i%self.nSize;
        CGFloat cellBtnX = width*loc;
        CGFloat cellBtnY = width*row;
        UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat spaceWidth = 1.1;
        cellBtn.frame = CGRectMake(cellBtnX+spaceWidth, cellBtnY+spaceWidth, width-1.5*spaceWidth, width-1.5*spaceWidth);
        if (self.data[i] == [NSNumber numberWithBool:NO])
            [cellBtn setBackgroundColor:[UIColor grayColor]];
        else
            [cellBtn setBackgroundColor:[UIColor blueColor]];
        [cellBtn setAccessibilityIdentifier:[[NSString alloc]initWithFormat:@"%d",i]];
        if (self.nSize < 25)
        {
            [cellBtn setTitle:@"o" forState:UIControlStateNormal];
            cellBtn.titleLabel.font = [UIFont systemFontOfSize:[cellBtn intrinsicContentSize].width/2.2];
        }
        [_gameView addSubview:cellBtn];
        [cellBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void) initOtherViews
{
    NSInteger width = 17*Frame_Times;
    CGFloat navHeight = 51;
    
    UILabel *headLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 18, self.view.frame.size.width-100, 30)];
    headLab.text = @"Game Of Life";
    headLab.textAlignment = NSTextAlignmentCenter;
    //[headLab setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:headLab];
    
    
    CGRect frame = CGRectMake(10*Frame_Times, navHeight+380*Frame_Times, width*5, width*2);
    _preBtn = [self buttonInitWithFrame:frame withTitle:@"上一步"  withIfEnable:NO];
    [self.view addSubview:_preBtn];
    [_preBtn addTarget:self action:@selector(clickPre:) forControlEvents:UIControlEventTouchUpInside];
    
    frame = CGRectMake(100*Frame_Times, navHeight+380*Frame_Times, width*5, width*2);
    _nextBtn = [self buttonInitWithFrame:frame withTitle:@"下一步" withIfEnable:NO];
    [self.view addSubview:_nextBtn];
    [_nextBtn addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchUpInside];
    
    frame = CGRectMake(190*Frame_Times, navHeight+380*Frame_Times, width*5, width*2);
    _timeBtn = [self buttonInitWithFrame:frame withTitle:@"自动" withIfEnable:NO];
    [self.view addSubview:_timeBtn];
    [_timeBtn addTarget:self action:@selector(clickTime:) forControlEvents:UIControlEventTouchUpInside];
    
    frame = CGRectMake(280*Frame_Times, navHeight+380*Frame_Times, width*5, width*2);
    _restartBtn = [self buttonInitWithFrame:frame withTitle:@"重开" withIfEnable:NO];
    [self.view addSubview:_restartBtn];
    [_restartBtn addTarget:self action:@selector(clickRestart:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *genLable = [[UILabel alloc]initWithFrame:CGRectMake(50*Frame_Times, 600*Frame_Times, width*9, width*2)];
    NSString *generStr  = [[NSString alloc]initWithFormat:@"自动机第(%d)代",self.generation];
    [genLable setText:generStr];
    [genLable setTag:121];
    [genLable setTextAlignment:NSTextAlignmentCenter];
    _genLable = genLable;
    [self.view addSubview:_genLable];
    
    UITextField *xText = [[UITextField alloc]initWithFrame:CGRectMake(10*Frame_Times, navHeight+420*Frame_Times,  width*5, width*2)];
    xText.borderStyle = UITextBorderStyleRoundedRect;
    xText.autocorrectionType = UITextAutocorrectionTypeYes;
    xText.placeholder = @"xPoint";
    xText.returnKeyType = UIReturnKeyDone;
    xText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [xText setBackgroundColor:[UIColor colorWithRed:1.0 green:0.8 blue:0.7 alpha:0.8]];
    xText.keyboardType = UIKeyboardTypeNumberPad;
    xText.delegate = self;
    _xText = xText;
    [self.view addSubview:_xText];
    
    UITextField *yText = [[UITextField alloc]initWithFrame:CGRectMake(100*Frame_Times, navHeight+420*Frame_Times,  width*5, width*2)];
    yText.borderStyle = UITextBorderStyleRoundedRect;
    yText.autocorrectionType = UITextAutocorrectionTypeYes;
    yText.placeholder = @"yPoint";
    yText.returnKeyType = UIReturnKeyDone;
    yText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [yText setBackgroundColor:[UIColor colorWithRed:1.0 green:0.8 blue:0.7 alpha:0.7]];
    yText.keyboardType = UIKeyboardTypeNumberPad;
    //[yText setEnabled:NO];
    yText.delegate = self;
    _yText = yText;
    [self.view addSubview:_yText];
    
    frame = CGRectMake(190*Frame_Times, navHeight+420*Frame_Times, width*5, width*2);
    _addBtn = [self buttonInitWithFrame:frame withTitle:@"添加" withIfEnable:YES];
    [self.view addSubview:_addBtn];
    [_addBtn addTarget:self action:@selector(clickAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    frame = CGRectMake(280*Frame_Times, navHeight+420*Frame_Times, width*5, width*2);
    _deleteBtn = [self buttonInitWithFrame:frame withTitle:@"删除" withIfEnable:YES];
    [self.view addSubview:_deleteBtn];
    [_deleteBtn addTarget:self action:@selector(clickDelete:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)buttonInitWithFrame:(CGRect)frame withTitle:(NSString *)title withIfEnable:(BOOL)ifEnable
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    [btn setTitle:@"禁用" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor grayColor]forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:0.9 green:0.9 blue:1.0 alpha:0.9]forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    if (!ifEnable)
    {
        [btn setEnabled:ifEnable];
    }
    [btn.layer setCornerRadius:6];
    [btn.layer setBorderWidth:1];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace, (CGFloat[]){0.4,0.4,0.4,1});
    [btn.layer setBorderColor:colorref];
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(colorref);
    return btn;
}

-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    NSTimeInterval animationDuration = 0.3f;
    CGRect frame = self.view.frame;
    if (frame.origin.y == -216) {
        frame.origin.y += 216;
        frame.size.height -=216;
    }
    //self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    [self.view endEditing:YES];
}

- (void) setDataWithFlag:(NSInteger)flag
{
    for (int i=0; i<self.nSize*self.nSize; ++i)
    {
        self.data[i] = [NSNumber numberWithBool:NO];
    }

    if(flag == 1)
    {
        int startPos = 18;
        _data[startPos+1] = [NSNumber numberWithBool:YES];
        _data[startPos+self.nSize] = [NSNumber numberWithBool:YES];
        _data[startPos+self.nSize*2] = [NSNumber numberWithBool:YES];
        _data[startPos+self.nSize*2+1] = [NSNumber numberWithBool:YES];
        _data[startPos+self.nSize*2+2] = [NSNumber numberWithBool:YES];
    }
    if(flag == 2)
    {
        int startPos = 100;
        _data[startPos-1] = [NSNumber numberWithBool:YES];
        _data[startPos] = [NSNumber numberWithBool:YES];
        _data[startPos+1] = [NSNumber numberWithBool:YES];
        startPos = 222;
        _data[startPos+self.nSize] = [NSNumber numberWithBool:YES];
        _data[startPos] = [NSNumber numberWithBool:YES];
        _data[startPos-self.nSize] = [NSNumber numberWithBool:YES];
        startPos = 333;
        _data[startPos-1] = [NSNumber numberWithBool:YES];
        _data[startPos] = [NSNumber numberWithBool:YES];
        _data[startPos+1] = [NSNumber numberWithBool:YES];
        startPos = 415;
        _data[startPos+self.nSize] = [NSNumber numberWithBool:YES];
        _data[startPos] = [NSNumber numberWithBool:YES];
        _data[startPos-self.nSize] = [NSNumber numberWithBool:YES];
    }
    if(flag == 3)
    {
        int startPos = 104;
        _data[startPos-2] = [NSNumber numberWithBool:YES];
        _data[startPos-1] = [NSNumber numberWithBool:YES];
        _data[startPos] = [NSNumber numberWithBool:YES];
        _data[startPos+1] = [NSNumber numberWithBool:YES];
        _data[startPos+2] = [NSNumber numberWithBool:YES];
        startPos = 224;
        _data[startPos+2*self.nSize] = [NSNumber numberWithBool:YES];
        _data[startPos+self.nSize] = [NSNumber numberWithBool:YES];
        _data[startPos] = [NSNumber numberWithBool:YES];
        _data[startPos-self.nSize] = [NSNumber numberWithBool:YES];
        _data[startPos-2*self.nSize] = [NSNumber numberWithBool:YES];
        startPos = 368;
        _data[startPos-2] = [NSNumber numberWithBool:YES];
        _data[startPos-1] = [NSNumber numberWithBool:YES];
        _data[startPos] = [NSNumber numberWithBool:YES];
        _data[startPos+1] = [NSNumber numberWithBool:YES];
        //_data[startPos+2] = [NSNumber numberWithBool:YES];
    }
    for (int i=0; i<self.nSize*self.nSize; ++i)
    {
        id tmpBtn = [_gameView subviews][i];
        if (self.data[i] == [NSNumber numberWithBool:NO])
        {
            [tmpBtn setBackgroundColor:[UIColor grayColor]];
        }
        else if (self.data[i] == [NSNumber numberWithBool:YES])
        {
            [tmpBtn setBackgroundColor:[UIColor blueColor]];
        }
    }
    for (int i=0; i<self.nSize*self.nSize; ++i)
    {
        if (self.data[i] == [NSNumber numberWithBool:YES])
        {
            [_preBtn setEnabled: NO];
            [_nextBtn setEnabled: YES];
            [_timeBtn setEnabled: YES];
            [_restartBtn setEnabled: YES];
            return;
        }
    }
    [_preBtn setEnabled: NO];
    [_nextBtn setEnabled: NO];
    [_timeBtn setEnabled: NO];
    [_restartBtn setEnabled: NO];

}

- (void)click:(UIButton *)btn
{
    int btnID = [btn.accessibilityIdentifier intValue];
    if (self.data[btnID] == [NSNumber numberWithBool:NO])
    {
        self.data[btnID] = [NSNumber numberWithBool:YES];
        [btn setBackgroundColor:[UIColor blueColor]];
    }
    else if (self.data[btnID] == [NSNumber numberWithBool:YES])
    {
        self.data[btnID] = [NSNumber numberWithBool:NO];
        [btn setBackgroundColor:[UIColor grayColor]];
    }
    self.tmpdata = [self.data mutableCopy];
    [_preBtn setEnabled:NO];
    [_nextBtn setEnabled:YES];
    [_timeBtn setEnabled:YES];
    [_restartBtn setEnabled:YES];
    self.generation = 0;
    NSString *generStr  = [[NSString alloc]initWithFormat:@"自动机第(%d)代",self.generation];
    [_genLable setText:generStr];
}

- (int) getAliveOrDie:(int)btnID
{
    return (self.tmpdata[btnID] == [NSNumber numberWithBool:YES])?1:0;
}

- (int) getAroundAliveNum:(int)btnID
{
    int rlt = 0;
    int y = btnID/self.nSize;
    int x = btnID%self.nSize;
    for (int i=x-1;i<=x+1;++i)
        for (int j=y-1; j<=y+1; ++j) {
            if (i>=0 &&i<self.nSize &&j>=0 &&j<self.nSize)
                rlt = rlt+ [self getAliveOrDie:(j*self.nSize+i)];
        }
    rlt = rlt - [self getAliveOrDie:btnID];
    return rlt;
}

- (void)clickNext:(UIButton *)btn
{
    self.tmpdata = [self.data mutableCopy];
    for (int i=0; i<self.nSize*self.nSize; ++i)
    {
        //id tmpBtn = [btnView[self.firstBtnIndex+i] subviews][0];
        id tmpBtn = [_gameView subviews][i];
        int aroundAliveNum = [self getAroundAliveNum:i];
        if (aroundAliveNum == 3)
        {
            self.data[i] = [NSNumber numberWithBool:YES];
        }
        else if (aroundAliveNum == 2)
        {
        }
        else
            self.data[i] = [NSNumber numberWithBool:NO];
        
        if (self.data[i] == [NSNumber numberWithBool:NO])
        {
            [tmpBtn setBackgroundColor:[UIColor grayColor]];
        }
        else if (self.data[i] == [NSNumber numberWithBool:YES])
        {
            [tmpBtn setBackgroundColor:[UIColor blueColor]];
        }
    }
    [_preBtn setEnabled:YES];
    self.generation = self.generation+1;
    NSString *generStr  = [[NSString alloc]initWithFormat:@"自动机第(%d)代",self.generation];
    [_genLable setText:generStr];
}

- (void)clickPre:(UIButton *)btn
{
    self.data = [self.tmpdata mutableCopy];
    for (int i=0; i<self.nSize*self.nSize; ++i)
    {
        id tmpBtn = [_gameView subviews][i];
        if (self.data[i] == [NSNumber numberWithBool:NO])
        {
            [tmpBtn setBackgroundColor:[UIColor grayColor]];
        }
        else if (self.data[i] == [NSNumber numberWithBool:YES])
        {
            [tmpBtn setBackgroundColor:[UIColor blueColor]];
        }
    }
    [btn setEnabled:NO];
    self.generation = self.generation-1;
    NSString *generStr  = [[NSString alloc]initWithFormat:@"自动机第(%d)代",self.generation];
    [_genLable setText:generStr];
}

- (void)clickTime:(UIButton *)btn
{
    if (self.timer !=nil)
    {
        [self.timer invalidate];
        self.timer = nil;
        [_timeBtn setTitle:@"自动" forState:UIControlStateNormal];
    }
    else
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(paint:) userInfo:nil repeats:(YES)];
        [_preBtn setEnabled:NO];
        [_nextBtn setEnabled:NO];
        [_timeBtn setTitle:@"暂停" forState:UIControlStateNormal];
        
    }
}

- (void)paint:(NSTimer *)paramTimer
{
    self.tmpdata = [self.data mutableCopy];
    for (int i=0; i<self.nSize*self.nSize; ++i)
    {
        id tmpBtn = [_gameView subviews][i];
        int aroundAliveNum = [self getAroundAliveNum:i];
        if (aroundAliveNum == 3)
        {
            self.data[i] = [NSNumber numberWithBool:YES];
        }
        else if (aroundAliveNum == 2)
        {
        }
        else
            self.data[i] = [NSNumber numberWithBool:NO];
        
        if (self.data[i] == [NSNumber numberWithBool:NO])
        {
            [tmpBtn setBackgroundColor:[UIColor grayColor]];
        }
        else if (self.data[i] == [NSNumber numberWithBool:YES])
        {
            [tmpBtn setBackgroundColor:[UIColor blueColor]];
        }
    }
    self.generation = self.generation+1;
    NSString *generStr  = [[NSString alloc]initWithFormat:@"自动机第(%d)代",self.generation];
    [_genLable setText:generStr];
    
}

- (void)clickRestart:(UIButton *)btn
{
    for (int i=0; i<self.nSize*self.nSize; ++i)
    {
        self.data[i] = [NSNumber numberWithBool:NO];
        id tmpBtn = [_gameView subviews][i];
        [tmpBtn setBackgroundColor:[UIColor grayColor]];
    }
    self.tmpdata = [self.data mutableCopy];
    self.generation = 0;
    NSString *generStr  = [[NSString alloc]initWithFormat:@"自动机第(%d)代",self.generation];
    [_genLable setText:generStr];
    if (self.timer !=nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    [_preBtn setEnabled: NO];
    [_nextBtn setEnabled: NO];
    [_timeBtn setEnabled: NO];
    //[_restartBtn setEnabled: NO];
    [_timeBtn setTitle:@"自动" forState:UIControlStateNormal];
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.3f;
    CGRect frame = self.view.frame;
    if (frame.origin.y == 0) {
        frame.origin.y -= 216;
        frame.size.height +=216;
    }
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame=frame;
    [UIView commitAnimations];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.3f;
    CGRect frame = self.view.frame;
    if (frame.origin.y == -216) {
        frame.origin.y += 216;
        frame.size.height -=216;
    }
    //self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    int xPosition = [textField.text intValue];
    if (xPosition >=0&& xPosition <self.nSize)
        [[self.view subviews][self.firstBtnIndex+self.nSize*self.nSize+6] setEnabled:YES];
    return YES;
}

- (void)clickAdd:(UIButton *)btn
{
    int textContentX = -1;
    int textContentY = -1;
    if (([_xText.text isEqualToString:@""]||[_yText.text isEqualToString:@""])== NO)
    {
        textContentX = [_xText.text intValue];
        textContentY = [_yText.text intValue];
    }
    if (textContentX >=0&& textContentX <self.nSize&& textContentY >=0&& textContentY <self.nSize)
    {
        self.data[textContentX+textContentY*self.nSize] = [NSNumber numberWithBool:YES];
        id tmpBtn = [_gameView subviews][textContentX+textContentY*self.nSize];
        [tmpBtn setBackgroundColor:[UIColor blueColor]];
        [_preBtn setEnabled: NO];
        [_nextBtn setEnabled: YES];
        [_timeBtn setEnabled: YES];
        [_restartBtn setEnabled: YES];
    }
}

- (void)clickDelete:(UIButton *)btn
{
    int textContentX = -1;
    int textContentY = -1;
    if (([_xText.text isEqualToString:@""]||[_yText.text isEqualToString:@""])== NO)
    {
        textContentX = [_xText.text intValue];
        textContentY = [_yText.text intValue];
    }
    if (textContentX >=0&& textContentX <self.nSize&& textContentY >=0&& textContentY <self.nSize)
    {
        self.data[textContentX+textContentY*self.nSize] = [NSNumber numberWithBool:NO];
        id tmpBtn = [_gameView subviews][textContentX+textContentY*self.nSize];
        [tmpBtn setBackgroundColor:[UIColor grayColor]];
    }
    for (int i=0; i<self.nSize*self.nSize; ++i)
    {
        if (self.data[i] == [NSNumber numberWithBool:YES])
        {
            return;
        }
    }
    [_preBtn setEnabled: NO];
    [_nextBtn setEnabled: NO];
    [_timeBtn setEnabled: NO];
    //[_restartBtn setEnabled: NO];
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(paint:) userInfo:nil repeats:(YES)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}//test

@end

































