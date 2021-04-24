ImportError: No module named 'xlrd' 解决办法

ImportError: No module named 'xlrd' 解决办法
1 import pandas as pd
2 
3 data = pd.read_excel('工作簿1.xls',sheetname='Sheet1')
　　用pandas读取Excel文件时，会提示

1
ImportError: No module named 'xlrd'
　　该错误是因为Excel需要单独的模块支持，所以需要安装xlrd模块

　　Python3可以在命令提示符中输入

pip3 install xlrd
　　Python2直接输入

pip install xlrd
　　如下图：

再试试就可以导入Excel文件的内容了！