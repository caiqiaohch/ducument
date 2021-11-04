# 工具箱-屏幕截图 (Toolkit-Screenshot)

[![YYQ](https://pic1.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

8 人赞同了该文章

在编写[VIM学习笔记](https://link.zhihu.com/?target=http%3A//yyq123.github.com/learn-vim/learn-vi-00-00-TOC.html)的过程中，我刻意增加了屏幕截图/录像的数量，以便能够更直观地说明各种命令的用法和效果。以下则为我用于制作屏幕截图/录像的几款工具：

**屏幕截图**

在屏幕截图领域，有无数优秀的软件。由于使用频率如此之高，我相信每个人也都有自己的偏好。而**[Greenshot](https://link.zhihu.com/?target=https%3A//getgreenshot.org/)**则是我在试用多款软件之后，安定下来的选择。

Greenshot可以截取整个屏幕、指定窗口、和矩形区域。而“截取上次区域”功能，则可以快速截取之前选定的屏幕区域。比如：我想要说明针对同一文字区域执行命令的效果，那么首先在原始状态下通过鼠标拖拽截取屏幕，然后执行命令，接下来只要点击Shift + Print快捷键就可以针对上次选定的屏幕区域再次进行截图。这大大提高了多次重复截图的效率，而且确保了多次截图时像素位置和图片尺寸的一致性。

Greenshot可以将屏幕截图输出到剪贴板、打印机、文件或者内置的图片编辑器。通过选择以下快捷菜单，可以将屏幕截图同时发送到剪贴板和图片编辑器。那么你就可以在图片编辑器中查看屏幕截图的效果；然后选择继续编辑图片，或者保存为文件，或者直接关闭编辑器，然后将图片粘贴到其他应用程序当中。

![img](https://pic1.zhimg.com/80/v2-ed05737e01648c44a3238b7cebb9abf4_720w.jpg)

在Greenshot内置的图片编辑器中，可以为图片增加注解、标识重点、绘制图形；还可以应用边框、阴影、锯齿、高亮和模糊等多种效果。更重要的是，图片可以保存为greenshot类型的文件。之后您可以多次打开greenshot文件，不断对屏幕截图进行修改，然后再将最终结果输出为PNG或JPG图片格式。这种对于屏幕截图进行多次调整的能力，在其他屏幕截图软件中并不多见。

![img](https://pic3.zhimg.com/80/v2-b43c075ba4141897ea1812666ea00c4a_720w.jpg)

Greenshot是免费的开源软件，支持Windows和Mac操作系统；在Linux下，我会使用开源的[Flameshot](https://link.zhihu.com/?target=https%3A//github.com/lupoDharkael/flameshot)；而在Mac下，则购买了久负盛名的[SnagIt](https://link.zhihu.com/?target=https%3A//www.techsmith.com/screen-capture.html)，同时也使用免费的[Snappy](https://link.zhihu.com/?target=http%3A//snappy-app.com/)。

**屏幕录像**

对于多步骤的键盘操作，静态的屏幕截图就显得力不从心了，而使用**[ScreenToGif](https://link.zhihu.com/?target=http%3A//www.screentogif.com/)**录制动态的屏幕录像，则能够更流畅地演示连续操作。

点击“录像机”按钮，然后将ScreenToGif窗口像取景框一样，移动到需要捕捉的屏幕区域之上；点击红色“录制”按钮，即可以进行屏幕录像：

![img](https://pic4.zhimg.com/80/v2-1a436ec9285cbb7324b71d7a97bfd483_720w.jpg)

完成录制之后，可以在ScreenToGif内置的编辑器中，对屏幕录像进行逐帧调整。比如添加文本和图像元素，调整帧的顺序，删除多余的帧等等。也就是说，你可以通过后期制作，来提供更多视觉辅助，并修正操作演示中不够顺畅的步骤。屏幕录像编辑完成之后，可以导出为Gif动画或者Avi视频。

![img](https://pic1.zhimg.com/80/v2-f687251bf8b05ad7e65350beff63a434_720w.jpg)

ScreenToGif是Windows下的开源软件。在Linux下，我会使用开源的[OBS Studio](https://link.zhihu.com/?target=https%3A//obsproject.com/)；在Mac下，我使用开源的屏幕录像软件[Kap](https://link.zhihu.com/?target=https%3A//getkap.co/)。

**按键屏显**

对于Vim中大量的按键操作，即使利用屏幕录像来演示，有时仍然显得词不达意。而使用**[Carnac](https://link.zhihu.com/?target=http%3A//carnackeys.com/)**，则可以在屏幕上实时显示按键操作，也就可以同步展示输入的命令，以及执行命令的结果。

通过设置按键屏显的位置、字体大小、颜色、背景和样式，可以更加美观和直观地辅助屏幕录像。

![img](https://pic3.zhimg.com/80/v2-1dc97f946330d8c55163eafaffb00c22_720w.jpg)



例如以下屏幕录像，演示了在将'j'映射为'gj'之后，向下移动键和j键，对于折行的不同处理（请参阅[折行](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-23-Wrap.html)章节的详细说明）。俗话说，“一幅图画胜过千言万语”，而一段活动的影像更又胜强百倍了吧？

![img](https://pic2.zhimg.com/v2-dd1bc8d906057001306bfc7154069ad9_b.jpg)



Carnac是Windows下的开源软件。在Linux下，我会使用开源的[Screenkey](https://link.zhihu.com/?target=https%3A//www.thregr.org/~wavexx/software/screenkey/)；在Mac下，我使用开源[KeyCastr](https://link.zhihu.com/?target=https%3A//github.com/keycastr/keycastr)。

发布于 2019-08-06