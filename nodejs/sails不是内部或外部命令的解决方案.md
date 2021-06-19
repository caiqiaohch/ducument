sails不是内部或外部命令的解决方案
http://sailsdoc.swift.ren/ 这里有 sails中文文档
1 安装好node

2 安装sails

打开cmd窗口，用命令 npm -g install sails 安装sails

安装完成后，用命令  sails new testProject 创建项目 会提示  sails不是内部或外部命令的解决方案。



3 解决方法 手动设置 环境变量

找到 sails的安装目录 例如 



 

路径是  E:\Program Files\nodejs\node_global\

按照下图 配置即可



配置完成后，要一路点确定按钮，关闭窗口

4 关掉cmd窗口，再重新打开

键入 sails new testProject 创建项目 即可成功

