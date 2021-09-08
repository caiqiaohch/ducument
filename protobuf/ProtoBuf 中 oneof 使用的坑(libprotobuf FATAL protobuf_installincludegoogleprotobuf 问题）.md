# ProtoBuf 中 oneof 使用的坑

在运行的时候，遇到了如下的报错：

libprotobuf FATAL /protobuf_install/include/google/protobuf/repeated_field.h:1184] CHECK failed: (index) < (current_size_)

根据解释，最直接的原因用改就是在访问 repeated_field的时候，访问的index超过了他的size，因此建议检查代码中对其的访问。

后来发现是由于在Proto的message定义中，未妥善使用oneof
oneof 中的所有Field Number应该在一个区域内，而不能包含区域外的数字。
例如：

message test{
	oneof object{
		float a  = 1;
		uint32 b = 3;
	}
	string c = 2;
}

若如上定义，则会报上述错误信息，正确定义应该如下：

message test{
	oneof object{
		float a  = 1;
		uint32 b = 2;
	}
	string c = 3;
}

之后的项目过程中，冤家路窄又碰到这个错了，如上述调试后仍然报错，后来修改了一下oneof 里面的对象顺序，成功了！
虽然不知道具体是什么原因，可能repeated 的对象在oneof里会有啥问题，总之，如果还有这类问题，可以调整调整顺序试试看！
————————————————
版权声明：本文为CSDN博主「zyq-lucky」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/Fiona_77/article/details/97812824