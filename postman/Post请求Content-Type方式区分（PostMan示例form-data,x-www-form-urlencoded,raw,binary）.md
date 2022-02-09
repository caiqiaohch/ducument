# Post请求Content-Type方式区分（PostMan示例form-data,x-www-form-urlencoded,raw,binary）

在PostMan中用Post方式，Body有form-data,x-www-form-urlencoded,raw,binary四种。

其中raw又分以下7种。

现在来区分一下：

form-data
是http请求中的multipart/form-data,它会将表单的数据处理为一条消息，以标签为单元，用分隔符分开。既可以上传键值对，也可以上传文件。当上传的字段是文件时，会有Content-Type来说明文件类型；content-disposition，用来说明字段的一些信息；由于有boundary隔离，所以multipart/form-data既可以上传文件，也可以上传键值对，它采用了键值对的方式，所以可以上传多个文件。

Request Header示例：
POST /upload.do HTTP/1.1
User-Agent: SOHUWapRebot
Accept-Language: zh-cn,zh;q=0.5
Accept-Charset: GBK,utf-8;q=0.7,*;q=0.7
Connection: keep-alive
Content-Length: 60408
Content-Type:multipart/form-data; boundary=ZnGpDtePMx0KrHh_G0X99Yef9r8JZsRJSXC
Host: www.sohu.com

--ZnGpDtePMx0KrHh_G0X99Yef9r8JZsRJSXC

Content-Disposition: form-data;name="desc"
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
[......][......][......][......]...........................

--ZnGpDtePMx0KrHh_G0X99Yef9r8JZsRJSXC

Content-Disposition: form-data;name="pic"; filename="photo.jpg"
Content-Type: application/octet-stream
Content-Transfer-Encoding: binary
[图片二进制数据]

--ZnGpDtePMx0KrHh_G0X99Yef9r8JZsRJSXC--
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
x-www-form-urlencoded
是http请求中的application/x-www-from-urlencoded，会将表单内的数据转换为键值对，&分隔。
当form的action为get时，浏览器用x-www-form-urlencoded的编码方式，将表单数据编码为
(name1=value1&name2=value2…)，然后把这个字符串append到url后面，用?分隔，跳转
到这个新的url。
当form的action为post时，浏览器将form数据封装到http body中，然后发送到server。
这个格式不能提交文件。
raw
可以上传任意格式的文本，可以上传text、json、xml、html、javascript等

binary
等同于Content-Type:application/octet-stream，只可上传二进制数据，通常用来上传文件，由于没有键值，所以一次只能上传一个文件。

————————————————
版权声明：本文为CSDN博主「一只拖后腿的程序猿」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/xu622/article/details/84393419