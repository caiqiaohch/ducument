Erlang中使用protobuff

Erlang中使用protobuff

github:
https://github.com/ngerakines/erlang_protobuffs/tree/master

下载压缩包
编译src中的4个文件
pokemon_pb.erl 
protobuffs.erl
protobuffs_compile.erl
protobuffs_parser.erl

分别生成
pokemon_pb.beam
protobuffs.beam
protobuffs_compile.beam
protobuffs_parser.beam

erl命令
protobuffs_compile:scan_file("文件路径/文件名.proto").

即可生成和文件名相对应的
文件名_pb.beam
文件名_pb.hrl

例如test.proto

message Person {
  required int32 age = 1;
  required string name = 2;
}
 
message Family {
  repeated Person person = 1;
}




运行命令
protobuffs_compile:scan_file("test.proto").

对应生成test_pb.hrl文件和test_pb.beam文件


关键代码
-module(test).
 
-compile([export_all]).
 
-include("test_pb.hrl").
 
encode() ->
  Person = #person{age=25, name="John"},
  test_pb:encode_person(Person).
 
decode() ->
  Data = encode(),
  test_pb:decode_person(Data).
 
encode_repeat() ->
  RepeatData =
  [
    #person{age=25, name="John"},
    #person{age=23, name="Lucy"},
    #person{age=2, name="Tony"}
  ],
  Family = #family{person=RepeatData},
  test_pb:encode_family(Family).
  
decode_repeat() ->
  Data = encode_repeat(),
  test_pb:decode_family(Data).


测试
1> c(test).
{ok,test}
 
2> test:encode().
<<8,25,18,4,74,111,104,110>>
 
8> test:decode().
{person,25,"John"}
 
3> test:encode_repeat().
<<10,8,8,25,18,4,74,111,104,110,10,8,8,23,18,4,76,117,99,
  121,10,8,8,2,18,4,84,111,110,...>>
 
4> test:decode_repeat().
{family,[{person,25,"John"},
         {person,23,"Lucy"},
         {person,2,"Tony"}]}
