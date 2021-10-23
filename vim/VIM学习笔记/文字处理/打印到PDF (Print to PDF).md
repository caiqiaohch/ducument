## 在Linux下打印PDF

在Linux和Mac下，Vim会产生一个PostScript文件。该文件能够直接发送到PostScript打印机上，或者通过类似ghostscript的程序进行处理。

为了使用PostScript功能，请使用`:version`命令，确认Vim已经包含“+postscript”特性：

![img](https://pic2.zhimg.com/80/v2-a79534675c9c486f38644d382e81fefd_720w.jpg)

首先使用以下命令，将文件打印至postscript文件：

```vim
:hardcopy > test.ps
```

此打印方式所生成的postscript文件，无法正常显示包括中文在内的UTF-8编码格式。推荐使用**[paps](https://link.zhihu.com/?target=http%3A//paps.sourceforge.net/)**，来生成包含中文的文件：

```vim
:!paps < % > test.ps
```

然后调用**[ps2pdf](https://link.zhihu.com/?target=http%3A//web.mit.edu/ghostscript/www/Ps2pdf.htm)**命令，将postscript文件转换为PDF文件：

```vim
:!ps2pdf test.ps test.pdf
```

通过在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中增加以下自定义命令，可以组合paps和ps2pdf命令，来直接生成PDF文件：

```vim
command Paps !paps % | ps2pdf - %:r.pdf
```

之后在Vim中执行以下命令，即可生成以当前文件名命名的PDF文件：

```vim
:Paps
```

我们也可以利用CUPS PDF打印机，来生成PDF文件。首先使用包管理命令（以Fedora为例），安装**[cups-pdf](https://link.zhihu.com/?target=https%3A//www.cups.org/)**：

```bash
$ dnf install cups-pdf
```

使用以下网址，可以查看打印机是否安装成功，并将其设置为默认打印机：

```http
http://localhost:631/printers/
```

![img](https://pic3.zhimg.com/80/v2-8c9e0d4c5917fa2cb57e24202010fc6e_720w.jpg)

在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中，增加以下[键盘映射](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-51-KeyMapping.html)：

```vim
nmap PpP :%w !lpr -o lpi=8 -o cpi=14<CR><CR>
```

此后使用PpP快捷键，即可生成PDF文件（默认保存在桌面）。你可以通过修改 /etc/cups/cups-pdf.conf 配置文件，来指定文件输出位置。

## 在Mac下打印PDF

在[MacVim](https://link.zhihu.com/?target=https%3A//macvim-dev.github.io/macvim/)中，使用`:set printexpr?`命令，可以发现Mac使用预览程序来生成PDF文件，同样也无法正常显示中文：

```vim
:set printexp=system('open -a Preview '.v:fname_in) + v:shell_error
```

通过在[vimrc](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-59-vimrc.html)配置文件中增加以下自定义命令，可以使用**[cupsfilter](https://link.zhihu.com/?target=https%3A//www.cups.org/doc/man-cupsfilter.html)**命令，来直接生成PDF文件：

```vim
command Print2PDF !cupsfilter % > %:r.pdf 2> /dev/null
```

## 在Windows下打印PDF

在Windows下的GVim中，使用`:hardcopy`命令将打开打印对话框；在其中选择PDF虚拟打印机（例如[Foxit PDF Printer](https://link.zhihu.com/?target=https%3A//www.foxitsoftware.com/pdf-reader/create-pdf/), [PDFCreator](https://link.zhihu.com/?target=https%3A//www.pdfforge.org/pdfcreator)等），即可生成PDF文件：

![img](https://pic1.zhimg.com/80/v2-227bb139d5973f1bc897397fa3f2e038_720w.jpg)



请使用`:help printing`命令，查看关于打印的帮助信息。

发布于 2019-10-24