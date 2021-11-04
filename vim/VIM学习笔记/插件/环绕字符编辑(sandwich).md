# 环绕字符编辑(sandwich)

[![YYQ](https://pic2.zhimg.com/v2-c4432de041354a82800b86e53483c9c7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/anthony.yuan)

[YYQ](https://www.zhihu.com/people/anthony.yuan)

一个安静的家伙 对大多数事情都没有兴趣

关注他

16 人赞同了该文章

**[sandwich](https://link.zhihu.com/?target=https%3A//github.com/machakann/vim-sandwich)** 插件可以快速编辑围绕在内容两端的字符（pairs of things surrounding things），比如成对出现的括号、引号，甚至HTML/XML标签等。

sandwich支持vim的[文本对象](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-10-TextObjects.html)（Text Objects)，比如单词、句子和段落等等。同时也支持`.`重复命令（Dot Command）。

## 安装配置

推荐您使用[vim-plug](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-102-plugin-plug.html)或[Vundle](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vi-101-plugin-vundle.html)等插件管理器，来安装GitHub上的[sandwich](https://link.zhihu.com/?target=https%3A//github.com/machakann/vim-sandwich)插件。

以下将利用实例来介绍sandwich插件的主要功能，请注意：

- 在“原始文本”列中，高亮文字表示光标所在位置；
- 在“命令”列中，为顺序执行的命令序列；
- 在“更改效果”列中，为命令执行之后的结果。您可以参考[实例文件](https://link.zhihu.com/?target=https%3A//github.com/yyq123/learn-vim/blob/master/samples/surroundings.txt)并自行测试。

## 新增环绕字符

在常规模式和可视化模式下，可以使用`sa`命令来新增环绕字符：

![img](https://pic4.zhimg.com/80/v2-a33b64f4c9e94b182a5d9c6e35e95597_720w.jpg)

![img](https://pic3.zhimg.com/v2-3b0c090191cfafe67e0814fc97a586ae_b.jpg)

从以上屏幕录像中可以看到：

- 插件提供了友好的视觉反馈。将根据指定的文本对象，自动高亮显示命令将影响的操作范围。例如输入saiw命令时，将高亮显示当前单词；当在可视化模式下操作多行字符时，视觉提示将使用户更加胸有成竹。
- 命令中的`t`表示标签，将在屏幕底部显示提示行，在其中输入的标签名称然后按回车键即可（并不需要输入<>）；

请注意：

1. 插入模式下，并没有专门用于输入环绕字符的快捷键。
2. 可视化模式下的操作：

- 首先使用快捷键进入不同类型的可视化模式。
  比如在Windows下，使用CTRL-Q键进入块视化模式；
- 然后使用j等移动命令来选中文本；
- 最后点击sa键，并输入环绕字符或标签。

## 修改环绕字符

使用`sr`命令可以修改环绕字符：

![img](https://pic1.zhimg.com/80/v2-cf821f08a8d8c80e9444527cca32edc8_720w.jpg)

从以上sr命令可以看到，并不需要明确指明环绕字符，而可以通过标识符`b`来指代，既聪明又方便。

随着命令输入，会以高亮显示将被替换的环绕字符，以便在操作之前确认范围是否正确。

![img](https://pic3.zhimg.com/v2-eb47db230ced6fab3553a508572e913a_b.jpg)

## 删除环绕字符

使用`sd`命令可以删除环绕字符：

![img](https://pic2.zhimg.com/80/v2-ce2fc0693ff3a164076e8ff283fc44a1_720w.jpg)

同样在sd删除命令中，也不需要明确指明环绕字符，而可以通过标识符`b`来指代，大大减少了命令的复杂度。

## HTML标签

假设需要针对以下文本，添加包含多个属性的HTML标签：

```text
Hello World
```

可以使用以下命令，简化标签的录入：

```
sa$tp.class1#id1
<p class="class1" id="id1">Hello World</p>
```

假设需要针对以下文本段落，添加<blockquote>标签：

```text
The passion to save humanity is a
cover for the desire to rule it.
```

可以使用以下命令，针对整个段落进行操作：

```
sa}tblockquote
<blockquote>The passion to save humanity is a
cover for the desire to rule it.</blockquote>
```

## 自定义快捷键

根据[帮助文件](https://link.zhihu.com/?target=https%3A//github.com/machakann/vim-sandwich/blob/master/doc/sandwich.txt)，建议在vimrc配置文件中取消当前s键配置：

```vim
nmap s <Nop>
xmap s <Nop>
```

请注意，在日常操作中可以使用cl命令来代替s功能。

如果频繁使用srtt快捷键来修改标签，那么建议映射为较短的srt快捷键：

```vim
nmap srt <Plug>(operator-sandwich-replace)<Plug>(textobj-sandwich-query-a)tt
```

如果希望使用[surround](https://link.zhihu.com/?target=https%3A//github.com/tpope/vim-surround)风格的快捷键，那么可以参照[surround keymappings](https://link.zhihu.com/?target=https%3A//github.com/machakann/vim-sandwich/wiki/Introduce-vim-surround-keymappings)进行配置。

## 自定义环绕字符

通过自定义receipe，可以设置用户特有的环绕字符。例如在vimrc文件中增加以下命令，以使用[ ( [ { ](https://link.zhihu.com/?target=https%3A//github.com/machakann/vim-sandwich/wiki/Bracket-with-spaces)来指定在括号之后附带一个间隔空格：

```vim
" if you have not copied default recipes
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)

" add spaces inside bracket
let g:sandwich#recipes += [
      \   {'buns': ['{ ', ' }'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['{']},
      \   {'buns': ['[ ', ' ]'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['[']},
      \   {'buns': ['( ', ' )'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['(']},
      \   {'buns': ['{\s*', '\s*}'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['{']},
      \   {'buns': ['\[\s*', '\s*\]'], 'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['[']},
      \   {'buns': ['(\s*', '\s*)'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['(']},
      \ ]
```

使用`:help textobj-sandwich`命令，可以查看sandwich文本对象的帮助信息，使用`:help operator-sandwich`命令，可以查看sandwich操作符的帮助信息。

使用以下命令，可以查看插件的帮助文件：

```vim
:help sandwich
```

## 使用感受

一，相较[surround](https://link.zhihu.com/?target=http%3A//yyq123.github.io/learn-vim/learn-vim-plugin-surround.html)重新发明一系列新概念，[sandwich](https://link.zhihu.com/?target=https%3A//github.com/machakann/vim-sandwich)更多地重用了已经存在的元素，比如Vim的[文本对象(Text Objects)](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-10-TextObjects.html)和[重复命令(Dot Command)](https://link.zhihu.com/?target=https%3A//yyq123.github.io/learn-vim/learn-vi-20-DotCommand.html)，以此保证操作的一致性，并大大降低学习成本。

二，sandwich提供了非常友好的视觉辅助。对于相隔较远或者多层嵌套的环绕字符，随着命令的输入将会高亮显示被影响的字符，这使用户在执行操作之前，能有机会确认命令执行范围是否准确。

我个人更喜欢sandwich的举重若轻，而不是surround的举轻若重。此诚为一家之言，还请自行斟酌。

编辑于 2020-09-25