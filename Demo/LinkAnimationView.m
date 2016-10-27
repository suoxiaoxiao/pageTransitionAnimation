//
//  LinkAnimationView.m
//  Demo
//
//  Created by 索晓晓 on 16/10/14.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//

#import "LinkAnimationView.h"

@interface LinkAnimationView ()


@end

@implementation LinkAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}



- (void)drawRect:(CGRect)rect {
    
    //底层形状
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    float redio = 20.0f;//半径
    float acrLineLength = 30.0f;//两边线的长度
    float middleLineLenght = 80.0f; //中间线的长度
    float middleTopGap = 5.0f;
    /*
      * * *               * * *
     *     * *********** *     *
    *                           *
     *     * *********** *     *
      * * *               * * *
     */
    //画第一个半径
    //画左半圆
    
    [[UIColor blueColor] setStroke];
//    CAShapeLayer *temp = [[CAShapeLayer alloc] init];
    UIBezierPath *leftArpath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(redio,  2 * redio) radius:redio startAngle:M_PI/2 endAngle:-M_PI/2 clockwise:YES];
    leftArpath.lineWidth = 1.0;
    leftArpath.lineCapStyle = kCGLineCapRound; //线条拐角
    leftArpath.lineJoinStyle = kCGLineCapRound; //终点处理
    //画上面横线
    [leftArpath addLineToPoint:CGPointMake(redio + acrLineLength, redio)];
    
    
    //画中间横线
    //atan //反正切函数
    //asin  反余弦
    float angleFlag = 0.0f;
    angleFlag = asin(middleTopGap/redio) * 180 / M_PI;//反余弦之后 出来的是弧度制  返回角度值
    float ymovegap = 0.0f;
    ymovegap = fabs(middleTopGap / tan(angleFlag * M_PI / 180.0f)); //拿到角度值 转换为弧度制
    
    
    [leftArpath addArcWithCenter:CGPointMake(redio + acrLineLength, redio * 2) radius:redio startAngle:-M_PI/2 endAngle:-(angleFlag + M_PI/2 * 3) clockwise:YES];
    
    [leftArpath addLineToPoint:CGPointMake(redio + acrLineLength + ymovegap + middleLineLenght, redio * 2 - middleTopGap  - 1.7f)];
    
    float rightStartX = redio + acrLineLength + ymovegap + middleLineLenght;
    
    
    [leftArpath addArcWithCenter:CGPointMake(rightStartX + ymovegap, redio * 2) radius:redio startAngle:(angleFlag + M_PI/2) endAngle:-M_PI/2 clockwise:YES];
    
    [leftArpath addLineToPoint:CGPointMake(rightStartX + ymovegap + acrLineLength, redio)];
    
    [leftArpath addArcWithCenter:CGPointMake(rightStartX + ymovegap+acrLineLength, redio * 2) radius:redio startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
    
    [leftArpath addLineToPoint:CGPointMake(rightStartX + ymovegap, redio * 3)];
    
    [leftArpath addArcWithCenter:CGPointMake(rightStartX + ymovegap, redio * 2) radius:redio startAngle:M_PI_2 endAngle:-angleFlag - M_PI_2  clockwise:YES];
    
    [leftArpath addLineToPoint:CGPointMake(rightStartX - middleLineLenght, redio * 2 + middleTopGap + 1.7f)];
    
    [leftArpath addArcWithCenter:CGPointMake(redio + acrLineLength, redio * 2) radius:redio startAngle:angleFlag - M_PI_2 endAngle:M_PI_2 clockwise:YES];
    
    [leftArpath closePath];
    
    [leftArpath stroke];
    
    CGContextAddPath(context, leftArpath.CGPath);
    CGContextStrokePath(context);
    
}



@end
