## 一、导论

对于不用vim的人来说，vim简直是个噩梦，复杂的指令、丑陋的界面、令人头痛的配置文件，任何一项都足以劝退一大波人，但是对于已经习惯了使用vim的人来说，vim简直就是马良神笔，似乎vim除了生孩子什么都可以做。

虽然从定义来说，vim只是编辑器并非编译器，但是它强大的扩展性给它带来了无限的可能，丰富的插件和独特的配置语法让它在许多程序员心中有了一席之地。

但是众所周知一般都是在Linux工作的人才有可能使用vim，换到Windows下使用vim就需要下载其他软件来间接的使用vim，比如WSL或者Git Bash、VSCode。然而接下来我就来介绍如何在VSCode下安装和配置VIM

## 二、VSCode安装vim插件

在vscode的扩展商店中搜索vim，安装第一个插件，这个插件可以完成大部分原生vim的操作。

![img](https://pic2.zhimg.com/80/v2-ecaa5809b2a19557404ae83210988e69_720w.jpg)

## 三、配置vim

安装完成以后我们需要配置vim，原生的vim有一部分操作十分的不友好，我们常常需要改键配置合适自己的vim。我们通常在setting.json中配置vscode，如果不知道如何打开setting.json可以点开**文件->首选项->设置->文本编辑器**，向下拉找到“**在setting.json中编辑**”。

如下图所示

![img](https://pic4.zhimg.com/80/v2-15adeb2aa193e944cab5997ad3e44993_720w.jpg)

配置语法

接下来来讨论一下如何编写配置，与原始vim不同的是，在原生vim中的配置语法是独属于vim的，但是在vscode中使用的是json格式，json格式是一种轻便易读的格式，如果不了解的同学可以提前学习一下。

如果是第一次配置setting.json的同学，里面应该是没有多少内容，最多几行简单配置。在最后一句配置语句后面打上一个逗号，然后开始新起一行准备写vim配置文件，如下所示。

```text
{
     //默认状态下setting.json文件内容 Begin
    "editor.fontSize": 20,
    "C_Cpp.updateChannel": "Insiders",
    "files.autoGuessEncoding": true,
    "[c]": {
        "editor.defaultFormatter": "ms-vscode.cpptools"
    },
    //默认状态下setting.json文件内容 End

    //关于vim的配置文件
    "vim.commandLineModeKeyBindingsNonRecursive": [],
    "vim.insertModeKeyBindings": [],
    "vim.normalModeKeyBindingsNonRecursive": []
}
```

1. **“\*vim.commandLineModeKeyBindingsNonRecursive\*“**指的是**命令行模式非递归键位绑定，**在原生vim中等同于**norecmap。**
2. **“\*vim.insertModeKeyBindings\*”**指的是**插入模式下键位绑定，**在原生vim里面指的是**imap。**
3. **“\*vim.normalModeKeyBindingsNonRecursive\*”**指的是**普通模式下非递归键位绑定，**在原生vim中是**noremap。**

**插入模式下键位修改**

我这里把esc键映射为jj，意思是在插入模式下，按下两次j会回到正常模式、按下大写s可以保存当前文件、按下大写q可以关闭当前文件。这vim的配置文件中，可以兼容原生vim指令和vscode命令，*"workbench.action.files.save"* 属于vscode命令，*":q!"* 属于原生vim命令。如果想修改其他键位可以根据下面的语法规则进行修改测试。

以下内容只是作为示例，不推荐大家使用大写s和q作为保存和退出，因为在编写程序的时候，我们可能就需要到大写s和q，我建议是先退出到普通模式再保存退出

```json
"vim.insertModeKeyBindings": [
        {
            "before": ["j", "j"],
            "after": ["<Esc>"]
        },
        {
            "before": ["S"],
            "commands": ["workbench.action.files.save"]
        },
        {
            "before": ["Q"],
            "commands": [":q!"],
        }
       
    ],
```

**正常模式下键位修改**

这里我通过按下**leader键+s** 可以保存当前文件、按下**leader+q**关闭文件、按下**leader+sq** 保存并退出文件。在下面我会提到leader键的设置。

```text
 "vim.normalModeKeyBindingsNonRecursive": [
        {
            "before": ["<leader>", "s"],
            "commands":[":w!"]
        },
        {
            "before": ["<leader>", "q"],
            "commands":[":q!"]
        },  
        {
            "before": ["<leader>", "sq"],
            "commands":[":wq!"]
        }
    ],
```

**leader键位设置和取消vim键位映射**

leader在vim中的意思是“前缀”的意思，和tmux中的Ctrl+b是一个意思，可以通过自定义leader键，来构建自己需要的组合快捷键。

在这里我把leader键位映射为空格键<space>。

在vscode里面使用vim有时候vscode原生键位比vim原生键位要舒服一些，我们可以取消到vim里面的键位映射来使用vscode的键位。

比如下面我取消掉了Ctrl+a,Ctrl+f,Ctrl+n在vim中的键位映射，这样子在写代码的时候，我按下Ctrl+a,Ctrl+f,Ctrl+n就可以使用vscode中的全选，查找和新建。

```text
 "vim.leader": "<space>",
 "vim.handleKeys": {
        "<C-a>": false,
        "<C-f>": false,
        "<C-n>": false
}
```

我在vim中设置了相对行号，这样子在进行跳转的时候就可以精确定位行数而且不需要数行号，比如我当前在16行，我想跳到“**//关于vim的配置文件**”这一句，我只需要在普通模式下按下6h，就会自动跳到16-6行。

设置方法：

```text
 "editor.lineNumbers":"relative"
```

有意思的是，如果在vscode中我们找不到对应的设置语句，可以先指定一个键位，在映射到对应的vim命令，然后执行这个命令，比如我在设置相对行号的时候找不到对应的vscode命令，我就可以这样子做：

```text
 "before": ["<leader>", "<leader>"],
  "commands":[":set relativenumber"]//vim下相对行号设置命令
```

这样子在使用完这个命令以后就可以删掉这句配置语句同时保留这个设置。

**如下图**

![img](https://pic3.zhimg.com/80/v2-0344103074e29435f05410959cb61822_720w.jpg)



**结束语**

**我们没必要纠结那个编辑器厉害或者有没有用，不同的人适合不同的编辑器，我们可以不喜欢，但是应该尊重别人的想法。在浏览大量代码的时候，使用鼠标无疑更舒服，但是在编写程序的时候vim可以来带更高效的操作。**