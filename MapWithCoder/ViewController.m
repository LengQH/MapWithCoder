//
//  ViewController.m
//  MapWithCoder
//
//  Created by ma c on 16/6/7.
//  Copyright © 2016年 gdd. All rights reserved.
//

#warning 最好用真机运行,还有其中一些小细节也未经过处理,最后代码仅供参考
/**
 *  方法和步骤
 *  1.0 导入对应的地理编码头文件 #import <CoreLocation/CoreLocation.h>
 *  2.0 创建地理编码对应的对象 CLGeocoder
 *  3.0 调用CLGeocoder 中的地理编码和反地理编码的方法
 *  方法分别是: geocodeAddressString: completionHandler:(地理编码)
 *  和 reverseGeocodeLocation: completionHandler:(反地理编码);
 *  4.0 最后其中却什么对象就创建什么对象
 */


#import "ViewController.h"
#import "MBProgressHUD+MJ.h"

#import <CoreLocation/CoreLocation.h>  //导入核心位置库(里面有定位和地理编码的头文件)

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *yourCity;
@property (weak, nonatomic) IBOutlet UILabel *latitudeWithLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeWithLabel;


@property (weak, nonatomic) IBOutlet UITextField *latLabel;
@property (weak, nonatomic) IBOutlet UITextField *longLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShowAction) name:UIKeyboardWillShowNotification object:nil];

}
#pragma mark 地理编码(通过城市得到经度和纬度)的操作
- (IBAction)sureActionWithCity:(UIButton *)sender {
    if(self.yourCity.text.length>0){
        CLGeocoder *stringWithCityName=[[CLGeocoder alloc]init]; //地理编码的类和下面其对应的方法,CLPlacemark是地理信息的类
        [stringWithCityName geocodeAddressString:self.yourCity.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error||!(placemarks.count>0)) {
                [MBProgressHUD showError:@"该城市不存在或者搜索有误"];
            }
            else{
                CLPlacemark *firstObj=[placemarks firstObject]; // 就用第一个位置对象
                CLLocationCoordinate2D cityCoor=firstObj.location.coordinate; //得到城市的纬度和经度
                NSString *strLat=[NSString stringWithFormat:@"%f",cityCoor.latitude];
                NSString *strLong=[NSString stringWithFormat:@"%f",cityCoor.longitude];
                
                self.latitudeWithLabel.hidden=NO;  //SB中是隐藏的
                self.longitudeWithLabel.hidden=NO;
                self.latitudeWithLabel.text=[NSString stringWithFormat:@"纬度是:%@",strLat];
                self.longitudeWithLabel.text=[NSString stringWithFormat:@"经度是:%@",strLong];
            }
            
        }];
    }
    else{
        [MBProgressHUD showError:@"城市位置不能为空"];
    }
}
#pragma mark 地理反编码操作
- (IBAction)sureActionLatAndLong:(UIButton *)sender {
    if(!(self.latLabel.text.length>0)){
        [MBProgressHUD showError:@"请输入纬度"];
    }
    else if(!(self.longLabel.text.length>0)){
        [MBProgressHUD showError:@"请输入经度"];
    }
    else{
        CLLocation *myLocal=[[CLLocation alloc]initWithLatitude:[self.latLabel.text doubleValue] longitude:[self.longLabel.text doubleValue]];
        CLGeocoder *latCoder=[[CLGeocoder alloc]init];
        [latCoder reverseGeocodeLocation:myLocal completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if(error||!(placemarks.count>0)){
                 [MBProgressHUD showError:@"输入的经度或者纬度有误"];
            }
            else{
                self.cityLabel.hidden=NO;
                CLPlacemark *city=[placemarks firstObject];
                self.cityLabel.text=[NSString stringWithFormat:@"对应的是:%@",city.name];
                
            }
        }];
    }
}
#pragma mark 键盘将要出现
-(void)keyBoardWillShowAction{
//    self.latitudeWithLabel.text=nil;  //SB中是隐藏的
//    self.longitudeWithLabel.text=nil;
//    self.latitudeWithLabel.hidden=YES;  //SB中是隐藏的
//    self.longitudeWithLabel.hidden=YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.yourCity resignFirstResponder];
    [self.latLabel resignFirstResponder];
    [self.longLabel resignFirstResponder];
}
@end
