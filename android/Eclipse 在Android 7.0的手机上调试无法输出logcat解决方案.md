# Eclipse 在Android 7.0的手机上调试无法输出logcat解决方案

 最近公司很多项目都上了Android 7.0 的系统，因为web 项目的开发并行的原因，所以一直没有切换到AS 上来，发现使用eclipse 的时候无法输出logcat ,通过网上google 发现了解决方案

需要更新ADT，这个ADT 并不是google 官方的。

下载地址：链接：http://pan.baidu.com/s/1pL2oopt 密码：qpae
1.ADT使用方法 
Download the zip file then in Eclipse menu Help > Install New Software... > Add > Archive... Just pick the downloaded zip and do the rest of the install process.
2.升级最新ADT和SDK，将ddmlib.jar放入D:\Program Files\Android\android-sdk\tools\lib 目录下，不懂的自行百度“ddmlib.jar”很多教程的！ddmlib.jar下载地址：http://pan.baidu.com/s/1i5yvbnB 


================================================================
概述

我的eclipse的环境：

Eclipse：Eclipse IDE for Java DevelopersVersion: Luna Service Release 2 (4.4.2)

Android SDK Tools：25.2.5

Android SDK Platform-tools：28.0.1

Android SDK Build-tools：28.0.3（dx.jar使用的是25.0.3的）

Android Platform Version：API28:Android 9.0（pie）revision 6


解决方案
1、在SDK安装目录\tools\lib文件下找到ddmlib.jar


2、在Eclipse安装目录中，进入Eclipse\configuration\org.eclipse.osgi查找ddmlib.jar

选中——右键——打开文件位置

3、使用{步骤1} 的ddmlib.jar替换 {步骤2} 的ddmlib.jar 

替换之前，先备份{步骤2}的ddmlib.jar文件、

4、重启Eclipse即可

 


参考资料

 Android 7.0及以上的设备无法在Eclipse上打印日志

在eclipse中 使用7.0及以上手机进行测试时logcat不打印日志的解决办法