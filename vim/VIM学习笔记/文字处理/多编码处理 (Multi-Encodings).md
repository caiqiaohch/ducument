# 多编码处理 (Multi-Encodings)

[![YYQ](https://pic3.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

6 人赞同了该文章

在Vim中有四个与编码有关的选项：“fileencodings (fencs)”、“fileencoding (fenc)”、“encoding (enc)”和“termencoding (tenc)”，任何一个选项出现错误，都会导致出现乱码。

## **encoding**

encoding是Vim内部使用的字符编码方式。Vim内部所有的buffer、寄存器、脚本中的字符串等，都会使用encoding设置的编码。如果编码方式与Vim的内部编码不一致，那么会先把编码转换成内部编码。如果编码中含有无法转换为内部编码的字符，那么这些字符就会丢失。因此，在选择Vim内部编码时，一定要使用一种包容力足够强的编码。由于encoding选项涉及到Vim中所有字符的内部表示，因此只能在Vim启动的时候设置一次。在Vim工作过程中修改encoding会造成非常多的问题。

建议将encoding设置为utf-8，同时设置以下选项，以避免在非UTF-8系统（如Windows）下，菜单和系统提示出现乱码：

```vim
set encoding=utf-8
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8
```

当然，你也可以设置菜单和信息都显示为英文，这样也可以避免Vim程序界面乱码的问题：

```vim
set langmenu=en_US
let $LANG = 'en_US'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
```

## **termencoding**

termencoding是Vim用于屏幕显示的编码。Vim会把内部编码转换为屏幕编码，再用于输出。内部编码中含有无法转换为屏幕编码的字符时，该字符会变成问号，但不会影响对它的编辑操作。如果termencoding没有设置，则直接使用encoding而不进行转换。

例如，你在Windows下通过telnet登录Linux工作站时，由于Windows的telnet是GBK编码的，而Linux则使用UTF-8编码，因此telnet下的Vim中就会乱码。此时有两种消除乱码的方式：你可以将Vim的encoding改为gbk，或者保持encoding为utf-8，而将termencoding改为gbk。显然，使用前一种方法时，如果编辑的文件中含有GBK无法表示的字符时，这些字符就会丢失。但如果使用后一种方法，虽然由于终端所限，这些字符无法显示，但在编辑过程中这些字符并不会丢失。

你可以利用以下命令设置termencoding：

```vim
set termencoding=utf-8
```

对于图形界面下的GVim，它的显示不依赖TERM，因此termencoding对于它没有意义。在GTK2下的GVim中，termencoding永远是utf-8，并且不能修改。而Windows下的GVim则忽略termencoding的存在。

## **fileencoding**

当Vim从磁盘上读取文件时，会对文件编码进行探测。如果文件的编码方式和Vim的内部编码方式不同，Vim就会对编码进行转换。转换完毕后，Vim会将fileencoding选项设置为文件的编码。当Vim存盘时，如果encoding和fileencoding不一致，Vim就会进行编码转换。因此，通过打开文件后设置fileencoding，可以将文件由一种编码转换为另一种编码。

```vim
set fileencoding=utf-8
```

注意：因为Vim是在打开文件时，自动探测和设置fileencoding的，所以，如果出现乱码，就无法通过在打开文件后重新设置fileencoding来纠正乱码。

## **fileencodings**

编码的自动识别，是通过设置fileencodings实现的。fileencodings是一个用逗号分隔的列表，列表中的每一项是一种编码的名称。当我们打开文件时，Vim按顺序使用fileencodings中的编码进行尝试解码，如果成功的话，就使用该编码方式进行解码，并将fileencoding设置为这个值；如果失败的话，就继续检验下一个编码。因此，我们在设置fileencodings时，一定要把严格的编码方式放在前面，把宽松的编码方式放在后面。例如，latin1是一种非常宽松的编码方式，任何一种编码方式得到的文本，用latin1进行解码，都不会发生解码失败。当然，解码得到的结果也很可能会是乱码。因此，如果你把latin1放到fileencodings的第一位，那么打开任何中文文件都会显示乱码了。推荐使用以下fileencodings设置：

```vim
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,latin1
```

其中， ucs-bom 是一种非常严格的编码，非该编码的文件几乎没有可能被误判为ucs-bom，因此放在第一位。utf-8也相当严格，除了很短的文件之外也是几乎不可能被误判的，因此放在第二位。接下来是 cp936、gb18030、big5 这些编码相对宽松的编码。 而最为宽松的 latin1 编码，则放在列表的最后。

如果编码被误判了，解码后的结果就会显示为无法识别的乱码了。此时，如果你知道这个文件的正确编码，可以把fileencodings改成只有这一种编码，阻止任何 fall-back 发生，然后重新打开这个文件。

## **编码转换**

当我们看到类似“&#24573;&#28982;”的编码时，可以通过以下命令将&#后的数字，经由函数nr2char()转换为可读的文字：

```vim
:%s/&#\([0-9]\+\);/\=nr2char(submatch(1))/g
```

![img](https://pic1.zhimg.com/80/v2-ccdbd9ff984a0baa5938625f6ea91370_720w.png)

编辑于 2017-02-27