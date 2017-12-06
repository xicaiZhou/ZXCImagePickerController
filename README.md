# ZXCImagePickerController
自定义相机、自定义相册、图片选择器
#####还在使用UIImagePickerController吗？还在填坑吗？那么新手福利来了。教你如何编写属于自己的ImagePickerController。
>目前，ZXCImagePickerController版本为1.0.5，2.0版本正在拼命加载中。小编已经将源码上传至[GitHub](https://github.com/xicaiZhou/ZXCImagePickerController ) 和coocaPod第三方管理库。

######集成方法
>1.跳转到[GitHub](https://github.com/xicaiZhou/ZXCImagePickerController )并下载，将[ZXCImagePickerController](https://github.com/xicaiZhou/ZXCImagePickerController/tree/master/ZXCImagePickerController "ZXCImagePickerController")文件夹拖入自己的工程。
>2.使用cocoaPod快速集成。请在你的podfile中加上pod 'ZXCImagePickerController','~> 1.0.5'。然后pod update更新本地库！

######使用方法
```
    ZXCImagePickerController *pickerVC = [[ZXCImagePickerController alloc] init];
    pickerVC.delegate = self; //遵循ZXCImagePickerControllerDelegate
    //ZXCImagePickerTypeWithAlbum相册模式 ZXCImagePickerTypeWithCamera相机模式
    pickerVC.Type = ZXCImagePickerTypeWithAlbum;
    [self presentViewController:pickerVC animated:YES completion:nil];
```
######代理回调方法
```
@protocol ZXCImagePickerControllerDelegate <NSObject>
-(void)ZXCImagePickerWithPhoto:(UIImage *)image;
@end
```
#####集成注意事项
1.获取权限

```
    <key>NSCameraUsageDescription</key>
    <string>App需要您的同意,才能访问相机</string>
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>App需要您的同意，添加照片</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>App需要您的同意，访问相册</string>
```
2.隐藏状态栏


```
View controller-based status bar appearance 设置为NO
```
代码中出现不懂的或者bug请联系我，我的工作邮箱(zhouxicaijob
@163.com)，欢迎大神指导！最后，有喜欢iOS成长路的同学，请关注哦！



