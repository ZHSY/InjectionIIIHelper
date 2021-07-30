# InjectionIIIHelper
依托InjectionIII的Xcode热部署配置文件，无侵害，导入即用，成倍提升工作效率。
效果：

代码在保存之后，立马在模拟器上看到修改后的效果，  
避免Command+R重新编译耗费时间的问题；  
如果APP页面层级太深的话，传统调试要一步步点进到指定页面，  
使用该方案直接就能看到效果，所见即所得。

----
昨天被同事用flutter项目的热部署效果给刺激了一下，被秀之余想到：他用个杂交品种能热部署，而我用苹果亲儿子没道理不行啊！  
所以花了一个上午时间，俺终于找到了这个成吨减少工作量的方案。

超级简单，只有三步：
1、一个工具  
2、选定项目目录  
3、把一个文件放到项目中  

无需其他任何配置，不对项目结构造成任何侵害。

----
### 1、工具下载 InjectionIII
InjectionIII 是我们需要用到个一个工具，不要因为要用一个工具而厌烦这个方案，它很简单。  
它是免费的，app store 搜索：InjectionIII，Icon是 一个针筒。  
也是开源的，GitHub链接： [https://github.com/johnno1962/injectionforxcode](https://github.com/johnno1962/injectionforxcode)

### 2、配置路径
 打开InjectionIII工具，选择Open Project，选择你的代码所在的路径，然后点击Select Project Directory保存。

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/aa8bea8b0a1e47709a5fc78152fb8b3e~tplv-k3u1fbpfcp-zoom-1.image)

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/bde0a07972104bb3970eab9259d77eb2~tplv-k3u1fbpfcp-zoom-1.image)

注意：InjectionIII 的File Watcher选项要保持选中状态。

### 3、导入配置文件（可选）
这步我简单写了一个配置文件，直接 [GitHub](https://github.com/ZHSY/InjectionIIIHelper)下载 导入项目即可。  

如果你比较反感下载文件也可以自己处理：  

1.设置AppDelegate.m  
        打开你的工程，在AppDelegate.m的didFinishLaunchingWithOptions方法按类型添加两行代码：
```
#if DEBUG
    // iOS
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
    // tvOS
    //[[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/tvOSInjection.bundle"] load];
    // macOS
    //[[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/macOSInjection.bundle"] load];
#endif
```
2.设置ViewController  
        
在的修改界面ViewController添加方法- (void)injected，或者给ViewController类扩展添加方法- (void)injected。

方法里写上刷新的动作：viewDidLoad 或者 其他更多方法。
```
- (void)injected
{    
  //自定义修改...
  //重新加载view    
  [self loadView];
  [self viewDidLoad];
  [self viewWillLayoutSubviews];
  [self viewWillAppear:NO];
}
```

3、懒加载和其他异常的处理

- 配置包做了修改view的刷新，代码不多，但是比你自己写方便，推荐你下载了拖进去。
- 因为适用范围的关系[self loadView] 需要慎重调用。
- 懒加载的view 配置包是识别不了，需要自己在VC里手动处理，事例代码：
```
- (void)injected {
    [_tableView removeFromSuperview];
    _tableView = nil;
    [self viewDidLoad];
}
```


### 4、启动项目，修改验证
在Xcode Command+R运行项目 ，看到Injection connected 提示即表示配置成功。  
如果没有，确认一下 第2步是不是对了。
![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f3024b9582cc42f094fd589e8fee50f4~tplv-k3u1fbpfcp-zoom-1.image)

在需要修改的页面，修改控件UI，然后Command+S保存一下代码，立刻就在模拟器上显示修改的信息了。

⚠️注 
- 工程路径中最好不要有中文，目前只处理了view和vc中的保存刷新，并且对部分xib控件无效。
- Bundle 路径跟xcode路径和工具路径相关，不过一般不用更换。
- 编译复杂的项目可能会崩溃，不要放弃，调整一下injected时调用的方法，调通后效率提升不止一倍。
- 有朋友反应使用RAC + MVVM injected 方法注册会崩溃，可使用 INJECTION_BUNDLE_NOTIFICATION 通知来监听 编译更新，后续我会完善更新。

工具使用中如有问题可以参考github上的过往经验，也欢迎留言我们一起讨论。

配置文件git：[https://github.com/ZHSY/InjectionIIIHelper](https://github.com/ZHSY/InjectionIIIHelper)

工具git地址：[https://github.com/johnno1962/injectionforxcode](https://github.com/johnno1962/injectionforxcode)  也可appstore 直接下载


简书链接： 404（删除了，被歧视就不在那混了）  
掘金链接： https://juejin.cn/post/6982462983024672805

如果有帮到你，记得给我个star，我会very兴奋的。

