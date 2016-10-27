//
//  AnimationView.m
//  Demo
//
//  Created by 索晓晓 on 16/10/18.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//

#import "AnimationView.h"
@interface AnimationView()
{
    UIBezierPath *_leftArcPath;
    UIBezierPath *_middleLinePath;
    UIBezierPath *_rightArcPath;
    
    CADisplayLink *_leftLink;
    CADisplayLink *_rightLink;
    
    float animationDuration;
    
    float _bgRedio;     //背景半径
    float _bgMiddleH;   //背景中间横线的间距高度
    float _insideOffset;//内边距
    float _acrLineLength;//圆中间线的长度
    float _middleLineLenght;//中间线的长度
    float _redio;//半径
    float _middleTopGap;//中间横线的上半部分高度
    float _middleLineStartX;//中间横线的X轴起点
    float _ymovegap;//圆心到中间矩形的距离
    
    float _leftMoveDistance;//左边移动的距离
    float _leftMoveUnit;//左边移动单位
    float _middleMoveDistance;//中间移动的距离
    float _middleMoveUnit;//中间移动单位
    float _rightMoveDistance;//右边移动的距离
    float _rightMoveUnit;//右边移动单位
    BOOL  _isCanRuningFromLeftToRightAnimation;//是否可以运行过从左到右的动画
    BOOL  _isCanRuningFromRightToLeftAnimation;//是否可以运行过从右到左的动画
    
}

@end

@implementation AnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _bgRedio = 20.0f;
        _bgMiddleH = 10.0f;
        _insideOffset = 2.0f;
        _redio = _bgRedio - _insideOffset;
        _middleTopGap = (_bgMiddleH - _insideOffset) * 0.5f;
        _acrLineLength = 30.0f;
        animationDuration = 0.3f;
        _leftMoveDistance = 0.0f;
        _middleMoveDistance = 0.0f;
        _rightMoveDistance = 0.0f;
        _isCanRuningFromLeftToRightAnimation = YES;
        _isCanRuningFromRightToLeftAnimation = NO;
        
        float angleFlag = 0.0f;  //临时角度
        float ymoveBiggap = 0.0f;//背景
        float ymovegap = 0.0f;   //小圆
        
        angleFlag = asin(_bgMiddleH/2.0f/_bgRedio) * 180 / M_PI;//反余弦之后 出来的是弧度制  返回角度值
        ymoveBiggap = fabs(_bgMiddleH/2.0f / tan(angleFlag * M_PI / 180.0f)); //拿到角度值 转换为弧度制
        
        //计算小圆move
        angleFlag = asin(_middleTopGap/_redio) * 180 / M_PI;//反余弦之后 出来的是弧度制  返回角度值
        ymovegap = fabs(_middleTopGap / tan(angleFlag * M_PI / 180.0f)); //拿到角度值 转换为弧度制
        float middleLineStartX = _insideOffset + _redio + _acrLineLength + ymovegap;
        float middleLineLenght =  (ymoveBiggap - ymovegap) * 2 + 80.0f;//中间线的长度
        _middleLineStartX = middleLineStartX;
        _middleLineLenght = middleLineLenght;
        _ymovegap = ymovegap;
        
        //计算动画间隔
        //动画时间一样 动画长度不同 计算动画速度  从而计算出行动单位
        float s_left = _acrLineLength + _redio;
        float v_left = s_left/animationDuration;
        float unit_left = v_left/60.0f;
        _leftMoveUnit = unit_left;
        
        float s_middle = _middleLineLenght;
        float v_middle = s_middle/animationDuration;
        float unit_middle = v_middle/60.0f;
        _middleMoveUnit = unit_middle;
        
        float s_right = _acrLineLength + _redio;
        float v_right = s_right/animationDuration;
        float unit_right = v_right/60.0f;
        _rightMoveUnit = unit_right;
        
        CGPoint left_left_ArcO = CGPointMake(_redio + _insideOffset,  2 * _bgRedio);
        CGPoint left_right_ArcO = CGPointMake(_redio + _insideOffset + _acrLineLength, _bgRedio * 2);
        
        [[UIColor whiteColor] set];
        //画左边的圆
        UIBezierPath *leftArpath = [UIBezierPath bezierPathWithArcCenter:left_left_ArcO radius:_redio startAngle:M_PI/2 endAngle:-M_PI/2 clockwise:YES];
        leftArpath.lineWidth = 1.0;
        leftArpath.lineCapStyle = kCGLineCapRound; //线条拐角
        leftArpath.lineJoinStyle = kCGLineCapRound; //终点处理
        [leftArpath addLineToPoint:CGPointMake(_redio + _acrLineLength + _insideOffset, _bgRedio +  _insideOffset)];
        [leftArpath addArcWithCenter:left_right_ArcO radius:_redio startAngle:-M_PI/2 endAngle:M_PI/2 clockwise:YES];
        [leftArpath addLineToPoint:CGPointMake(_redio + _insideOffset, _bgRedio * 3 - _insideOffset)];
        _leftArcPath = leftArpath;
        
        //中间的线
        UIBezierPath *middleLinePath = [UIBezierPath bezierPathWithRect:CGRectMake(_middleLineStartX, _bgRedio * 2 - _middleTopGap, 0, _middleTopGap * 2)];
        
        middleLinePath.lineWidth = 1.0;
        middleLinePath.lineCapStyle = kCGLineCapRound; //线条拐角
        middleLinePath.lineJoinStyle = kCGLineCapRound; //终点处理
        _middleLinePath = middleLinePath;
        
        //右边的圆
        UIBezierPath *rightAcrPath = [UIBezierPath bezierPath];
        
        rightAcrPath.lineWidth = 1.0;
        rightAcrPath.lineCapStyle = kCGLineCapRound; //线条拐角
        rightAcrPath.lineJoinStyle = kCGLineCapRound; //终点处理
        _rightArcPath = rightAcrPath;
        
        
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] set];
    
    [_leftArcPath fill];
    [_middleLinePath fill];
    [_rightArcPath fill];
    
    CGContextStrokePath(context);
    
    [super drawRect:rect];
}

- (void)showAlert{
    UIAlertController*vc = [UIAlertController alertControllerWithTitle:@"不能进行动画" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:YES completion:^{
        
    }];
    
    return ;
}


- (void)formLeftToRightAnimation{
    
    if (!_isCanRuningFromLeftToRightAnimation) { [self showAlert]; return;}
    _leftLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(leftAnimation)];
    [_leftLink setPreferredFramesPerSecond:60];
    [_leftLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
}
- (void)leftAnimation{
    
    _isCanRuningFromLeftToRightAnimation = NO;
    
    if (_leftMoveDistance >= _acrLineLength) {
        
        if (_leftMoveDistance >  _acrLineLength + _ymovegap) {
            
            //开始右边视图扩大
            if (_rightMoveDistance < _ymovegap) {//扩大圆的半径
                
                _rightMoveDistance += _rightMoveUnit;
                _middleMoveDistance -= _middleMoveUnit;
                
                UIBezierPath *rightAcrPath = [UIBezierPath bezierPath];
                rightAcrPath.lineWidth = 1.0;
                rightAcrPath.lineCapStyle = kCGLineCapRound; //线条拐角
                rightAcrPath.lineJoinStyle = kCGLineCapRound; //终点处理
                CGPoint right_left_ArcO= CGPointMake(_insideOffset + _redio + _acrLineLength + _ymovegap + _middleLineLenght + _rightMoveDistance, _bgRedio * 2);
                [rightAcrPath addArcWithCenter:right_left_ArcO radius:_rightMoveDistance startAngle:0 endAngle:M_PI * 2 clockwise:NO];
                
                _rightArcPath = rightAcrPath;
                
                UIBezierPath *middleLinePath = [UIBezierPath bezierPathWithRect:CGRectMake(_middleLineStartX + _middleLineLenght - _middleMoveDistance, _bgRedio * 2 - _middleTopGap, _middleMoveDistance, _middleTopGap * 2)];
                middleLinePath.lineWidth = 1.0;
                middleLinePath.lineCapStyle = kCGLineCapRound; //线条拐角
                middleLinePath.lineJoinStyle = kCGLineCapRound; //终点处理
                _middleLinePath = middleLinePath;
                
                
            }else{
                
                if (_rightMoveDistance >= _acrLineLength + _ymovegap) {
                    
                    _rightMoveDistance = _acrLineLength + _ymovegap;
                    _middleMoveDistance = 0;
                    
                    UIBezierPath *rightAcrPath = [UIBezierPath bezierPath];
                    
                    rightAcrPath.lineWidth = 1.0;
                    rightAcrPath.lineCapStyle = kCGLineCapRound; //线条拐角
                    rightAcrPath.lineJoinStyle = kCGLineCapRound; //终点处理
                    
                    CGPoint right_left_ArcO= CGPointMake(_insideOffset + _redio + _acrLineLength + _ymovegap + _middleLineLenght + _ymovegap, _bgRedio * 2);
                    
                    CGPoint right_right_ArcO = CGPointMake(_insideOffset + _redio + _acrLineLength + _ymovegap + _middleLineLenght + _rightMoveDistance, _bgRedio * 2);
                    
                    [rightAcrPath addArcWithCenter:right_left_ArcO radius:_redio startAngle:-M_PI/2 endAngle:M_PI_2 clockwise:NO];
                    [rightAcrPath addLineToPoint:CGPointMake(self.frame.size.width - (_acrLineLength - (_rightMoveDistance - _redio)) - _insideOffset - _redio, 3 * _bgRedio - _insideOffset)];
                   [rightAcrPath addArcWithCenter:right_right_ArcO radius:_redio startAngle:M_PI_2 endAngle:-M_PI_2 clockwise:NO];
                    [rightAcrPath addLineToPoint:CGPointMake(self.frame.size.width - _insideOffset - _redio - _acrLineLength, _bgRedio + _insideOffset)];
                    
                    _rightArcPath = rightAcrPath;
                    
                    UIBezierPath *middleLinePath = [UIBezierPath bezierPathWithRect:CGRectMake(_middleLineStartX + _middleLineLenght - _middleMoveDistance, _bgRedio * 2 - _middleTopGap, 0, _middleTopGap * 2)];
                    middleLinePath.lineWidth = 1.0;
                    middleLinePath.lineCapStyle = kCGLineCapRound; //线条拐角
                    middleLinePath.lineJoinStyle = kCGLineCapRound; //终点处理
                    _middleLinePath = middleLinePath;
                    
                    [self setNeedsDisplay];
                    [self setNeedsDisplayInRect:self.frame];
                    
                    _isCanRuningFromRightToLeftAnimation = YES;
                    [_leftLink invalidate];
                    _leftLink = nil;
                    return ;
                    
                }else{//圆中间线长度
                    
                    _rightMoveDistance += _rightMoveUnit;
                    _middleMoveDistance -= _middleMoveUnit;
                    
                    if (_rightMoveDistance > _acrLineLength + _ymovegap) {
                        _rightMoveDistance = _acrLineLength + _ymovegap;
                    }
                    
                    UIBezierPath *rightAcrPath = [UIBezierPath bezierPath];
                    
                    rightAcrPath.lineWidth = 1.0;
                    rightAcrPath.lineCapStyle = kCGLineCapRound; //线条拐角
                    rightAcrPath.lineJoinStyle = kCGLineCapRound; //终点处理
                    
                    CGPoint right_left_ArcO= CGPointMake(_insideOffset + _redio + _acrLineLength + _ymovegap + _middleLineLenght + _ymovegap, _bgRedio * 2);
                    
                    CGPoint right_right_ArcO = CGPointMake(_insideOffset + _redio + _acrLineLength + _ymovegap + _middleLineLenght + _rightMoveDistance, _bgRedio * 2);
                    
                    [rightAcrPath addArcWithCenter:right_left_ArcO radius:_redio startAngle:-M_PI/2 endAngle:M_PI_2 clockwise:NO];
                    [rightAcrPath addLineToPoint:CGPointMake(self.frame.size.width - (_acrLineLength - (_rightMoveDistance - _redio)) - _insideOffset - _redio, 3 * _bgRedio - _insideOffset)];
                    [rightAcrPath addArcWithCenter:right_right_ArcO radius:_redio startAngle:M_PI_2 endAngle:-M_PI_2 clockwise:NO];
                    [rightAcrPath addLineToPoint:CGPointMake(self.frame.size.width - _insideOffset - _redio - _acrLineLength, _bgRedio + _insideOffset)];
                    
                    _rightArcPath = rightAcrPath;
                    
                    UIBezierPath *middleLinePath = [UIBezierPath bezierPathWithRect:CGRectMake(_middleLineStartX + _middleLineLenght - _middleMoveDistance, _bgRedio * 2 - _middleTopGap, _middleMoveDistance, _middleTopGap * 2)];
                    middleLinePath.lineWidth = 1.0;
                    middleLinePath.lineCapStyle = kCGLineCapRound; //线条拐角
                    middleLinePath.lineJoinStyle = kCGLineCapRound; //终点处理
                    _middleLinePath = middleLinePath;
                }
            }
        }else{
        
            _middleMoveDistance += _middleMoveUnit;
            _leftMoveDistance += _leftMoveUnit;
            
            CGPoint point = CGPointMake(_leftMoveDistance + _redio + _insideOffset, _bgRedio * 2);
            
            UIBezierPath *leftArpath = [UIBezierPath bezierPathWithArcCenter:point radius:_redio - (_leftMoveDistance - _acrLineLength) startAngle:0 endAngle:M_PI * 2 clockwise:YES];
            leftArpath.lineWidth = 1.0;
            leftArpath.lineCapStyle = kCGLineCapRound; //线条拐角
            leftArpath.lineJoinStyle = kCGLineCapRound; //终点处理
            _leftArcPath = leftArpath;
            
            
            UIBezierPath *middleLinePath = [UIBezierPath bezierPathWithRect:CGRectMake(_middleLineStartX, _bgRedio * 2 - _middleTopGap, _middleMoveDistance, _middleTopGap * 2)];
            middleLinePath.lineWidth = 1.0;
            middleLinePath.lineCapStyle = kCGLineCapRound; //线条拐角
            middleLinePath.lineJoinStyle = kCGLineCapRound; //终点处理
            _middleLinePath = middleLinePath;
        }
        
    }else{
        
        _middleMoveDistance += _middleMoveUnit;
        
        _leftMoveDistance += _leftMoveUnit;
        
        CGPoint left_left_ArcO = CGPointMake(_redio + _insideOffset + _leftMoveDistance,  2 * _bgRedio);
        
        CGPoint left_right_ArcO = CGPointMake(_redio + _insideOffset + _acrLineLength, _bgRedio * 2);
        UIBezierPath *leftArpath = [UIBezierPath bezierPathWithArcCenter:left_left_ArcO radius:_redio startAngle:M_PI/2 endAngle:-M_PI/2 clockwise:YES];
        [leftArpath addLineToPoint:CGPointMake(_redio + _acrLineLength + _insideOffset, _bgRedio +  _insideOffset)];
        [leftArpath addArcWithCenter:left_right_ArcO radius:_redio startAngle:-M_PI/2 endAngle:M_PI/2 clockwise:YES];
        [leftArpath addLineToPoint:CGPointMake(_redio + _insideOffset + _leftMoveDistance, _bgRedio * 3 - _insideOffset)];
        leftArpath.lineWidth = 1.0;
        leftArpath.lineCapStyle = kCGLineCapRound; //线条拐角
        leftArpath.lineJoinStyle = kCGLineCapRound; //终点处理
        _leftArcPath = leftArpath;
        
        
        UIBezierPath *middleLinePath = [UIBezierPath bezierPathWithRect:CGRectMake(_middleLineStartX, _bgRedio * 2 - _middleTopGap, _middleMoveDistance, _middleTopGap * 2)];
        middleLinePath.lineWidth = 1.0;
        middleLinePath.lineCapStyle = kCGLineCapRound; //线条拐角
        middleLinePath.lineJoinStyle = kCGLineCapRound; //终点处理
        _middleLinePath = middleLinePath;
    }
    
    [self setNeedsDisplay];
    [self setNeedsDisplayInRect:self.frame];
    
    
}

- (void)formRightToLeftAnimation{
    if (!_isCanRuningFromRightToLeftAnimation){ [self showAlert]; return;}
    _rightLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(rightAnimation)];
    [_rightLink setPreferredFramesPerSecond:60];
    [_rightLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)rightAnimation{
    
    _isCanRuningFromRightToLeftAnimation = NO;
    
    
    if (_rightMoveDistance > _ymovegap) {//右边圆缩小圆间距 和 中间横线边长
        
        _rightMoveDistance -= _rightMoveUnit;
        
        _middleMoveDistance += _middleMoveUnit;
        
        UIBezierPath *rightAcrPath = [UIBezierPath bezierPath];
        rightAcrPath.lineWidth = 1.0;
        rightAcrPath.lineCapStyle = kCGLineCapRound; //线条拐角
        rightAcrPath.lineJoinStyle = kCGLineCapRound; //终点处理
        
        CGPoint right_left_ArcO= CGPointMake(_insideOffset + _redio + _acrLineLength + _ymovegap + _middleLineLenght + _ymovegap, _bgRedio * 2);
        
        CGPoint right_right_ArcO = CGPointMake(_insideOffset + _redio + _acrLineLength + _ymovegap + _middleLineLenght + _rightMoveDistance, _bgRedio * 2);
        
        [rightAcrPath addArcWithCenter:right_left_ArcO radius:_redio startAngle:-M_PI/2 endAngle:M_PI_2 clockwise:NO];
        [rightAcrPath addLineToPoint:CGPointMake(self.frame.size.width - (_acrLineLength - (_rightMoveDistance - _redio)) - _insideOffset - _redio, 3 * _bgRedio - _insideOffset)];
        [rightAcrPath addArcWithCenter:right_right_ArcO radius:_redio startAngle:M_PI_2 endAngle:-M_PI_2 clockwise:NO];
        [rightAcrPath addLineToPoint:CGPointMake(self.frame.size.width - _insideOffset - _redio - _acrLineLength, _bgRedio + _insideOffset)];
        
        _rightArcPath = rightAcrPath;
        
        
        UIBezierPath *middleLinePath = [UIBezierPath bezierPathWithRect:CGRectMake(_middleLineStartX + (_middleLineLenght - _middleMoveDistance), _bgRedio * 2 - _middleTopGap, _middleMoveDistance, _middleTopGap * 2)];
        middleLinePath.lineWidth = 1.0;
        middleLinePath.lineCapStyle = kCGLineCapRound; //线条拐角
        middleLinePath.lineJoinStyle = kCGLineCapRound; //终点处理
        _middleLinePath = middleLinePath;
        
    }else{
        
        
        if (_rightMoveDistance > 0.01) {//右边圆减小  横线加长 //这里大于0.01  是由于0.0000>0 系统判断出错
            
            _rightMoveDistance -= _rightMoveUnit;
            _middleMoveDistance += _middleMoveUnit;
            
            if (_rightMoveDistance < 0) {
                _rightMoveDistance = 0;
            }
            
            UIBezierPath *rightAcrPath = [UIBezierPath bezierPath];
            rightAcrPath.lineWidth = 1.0;
            rightAcrPath.lineCapStyle = kCGLineCapRound; //线条拐角
            rightAcrPath.lineJoinStyle = kCGLineCapRound; //终点处理
            
            CGPoint right_left_ArcO= CGPointMake(_insideOffset + _redio + _acrLineLength + _ymovegap + _middleLineLenght + _rightMoveDistance, _bgRedio * 2);
            [rightAcrPath addArcWithCenter:right_left_ArcO radius:_rightMoveDistance startAngle:0 endAngle:M_PI * 2 clockwise:NO];
            
            NSLog(@"%f",_rightMoveDistance);
            
            _rightArcPath = rightAcrPath;
            
            UIBezierPath *middleLinePath = [UIBezierPath bezierPathWithRect:CGRectMake(_middleLineStartX + (_middleLineLenght - _middleMoveDistance), _bgRedio * 2 - _middleTopGap, _middleMoveDistance, _middleTopGap * 2)];
            middleLinePath.lineWidth = 1.0;
            middleLinePath.lineCapStyle = kCGLineCapRound; //线条拐角
            middleLinePath.lineJoinStyle = kCGLineCapRound; //终点处理
            _middleLinePath = middleLinePath;
            
        }else{
        
            
            if (_leftMoveDistance < _acrLineLength) {
                
                if (_leftMoveDistance <= 0 ) {//到达最终位置
                    
                    _middleMoveDistance = 0;
                    
                    
                    CGPoint left_left_ArcO = CGPointMake(_redio + _insideOffset,  2 * _bgRedio);
                    
                    CGPoint left_right_ArcO = CGPointMake(_redio + _insideOffset + _acrLineLength, _bgRedio * 2);
                    
                    UIBezierPath *leftArpath = [UIBezierPath bezierPathWithArcCenter:left_left_ArcO radius:_redio startAngle:M_PI/2 endAngle:-M_PI/2 clockwise:YES];
                    [leftArpath addLineToPoint:CGPointMake(_redio + _acrLineLength + _insideOffset, _bgRedio +  _insideOffset)];
                    [leftArpath addArcWithCenter:left_right_ArcO radius:_redio startAngle:-M_PI/2 endAngle:M_PI/2 clockwise:YES];
                    [leftArpath addLineToPoint:CGPointMake(_redio + _insideOffset + _leftMoveDistance, _bgRedio * 3 - _insideOffset)];
                    leftArpath.lineWidth = 1.0;
                    leftArpath.lineCapStyle = kCGLineCapRound; //线条拐角
                    leftArpath.lineJoinStyle = kCGLineCapRound; //终点处理
                    _leftArcPath = leftArpath;
                    
                    
                    
                    UIBezierPath *middleLinePath = [UIBezierPath bezierPathWithRect:CGRectMake(_middleLineStartX, _bgRedio * 2 - _middleTopGap, _middleMoveDistance, _middleTopGap * 2)];
                    middleLinePath.lineWidth = 1.0;
                    middleLinePath.lineCapStyle = kCGLineCapRound; //线条拐角
                    middleLinePath.lineJoinStyle = kCGLineCapRound; //终点处理
                    _middleLinePath = middleLinePath;
                    
                    [_rightLink invalidate];
                    _rightLink = nil;
                    
                    _isCanRuningFromLeftToRightAnimation = YES;
                    
                }else{ //左边圆中间横线边长  两个圆中间横线变短
                    
                    _leftMoveDistance -= _leftMoveUnit;
                    _middleMoveDistance -= _middleMoveUnit;
                    
                    if (_leftMoveDistance < 0 ) {
                        _leftMoveDistance = 0;
                    }
                    
                    CGPoint left_left_ArcO = CGPointMake(_redio + _insideOffset + _leftMoveDistance,  2 * _bgRedio);
                    
                    CGPoint left_right_ArcO = CGPointMake(_redio + _insideOffset + _acrLineLength, _bgRedio * 2);
                    
                    UIBezierPath *leftArpath = [UIBezierPath bezierPathWithArcCenter:left_left_ArcO radius:_redio startAngle:M_PI/2 endAngle:-M_PI/2 clockwise:YES];
                    [leftArpath addLineToPoint:CGPointMake(_redio + _acrLineLength + _insideOffset, _bgRedio +  _insideOffset)];
                    [leftArpath addArcWithCenter:left_right_ArcO radius:_redio startAngle:-M_PI/2 endAngle:M_PI/2 clockwise:YES];
                    [leftArpath addLineToPoint:CGPointMake(_redio + _insideOffset + _leftMoveDistance, _bgRedio * 3 - _insideOffset)];
                    leftArpath.lineWidth = 1.0;
                    leftArpath.lineCapStyle = kCGLineCapRound; //线条拐角
                    leftArpath.lineJoinStyle = kCGLineCapRound; //终点处理
                    _leftArcPath = leftArpath;

                    
                
                    
                    UIBezierPath *middleLinePath = [UIBezierPath bezierPathWithRect:CGRectMake(_middleLineStartX, _bgRedio * 2 - _middleTopGap, _middleMoveDistance, _middleTopGap * 2)];
                    middleLinePath.lineWidth = 1.0;
                    middleLinePath.lineCapStyle = kCGLineCapRound; //线条拐角
                    middleLinePath.lineJoinStyle = kCGLineCapRound; //终点处理
                    _middleLinePath = middleLinePath;
                    
                }
                
            }else{//左边圆半径加长  横线变短
                
                
                _leftMoveDistance -= _leftMoveUnit;
                _middleMoveDistance -= _middleMoveUnit;
            
                CGPoint point = CGPointMake( _redio + _insideOffset + _leftMoveDistance, _bgRedio * 2);
                
                UIBezierPath *leftArpath = [UIBezierPath bezierPathWithArcCenter:point radius:_acrLineLength + _ymovegap - _leftMoveDistance startAngle:0 endAngle:M_PI * 2 clockwise:YES];
                leftArpath.lineWidth = 1.0;
                leftArpath.lineCapStyle = kCGLineCapRound; //线条拐角
                leftArpath.lineJoinStyle = kCGLineCapRound; //终点处理
                _leftArcPath = leftArpath;
                
                UIBezierPath *middleLinePath = [UIBezierPath bezierPathWithRect:CGRectMake(_middleLineStartX, _bgRedio * 2 - _middleTopGap, _middleMoveDistance, _middleTopGap * 2)];
                middleLinePath.lineWidth = 1.0;
                middleLinePath.lineCapStyle = kCGLineCapRound; //线条拐角
                middleLinePath.lineJoinStyle = kCGLineCapRound; //终点处理
                _middleLinePath = middleLinePath;
            }
        }
        
        
        
    }
    
    [self setNeedsDisplay];
    [self setNeedsDisplayInRect:self.frame];

    
}

@end
