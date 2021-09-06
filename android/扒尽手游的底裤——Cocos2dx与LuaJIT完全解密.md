# 扒尽手游的底裤——Cocos2dx与LuaJIT完全解密


编译修改Luajit-lang-toolkit
解包后发现所有的png资源全部加密了打不开（嘿，但是音频还没有加密……不过并不会有人看嘛）。结合lib发现游戏是cocos2x与Lua编写。虽然Lua出了名的好逆，但是查看文件头后发现是编译后的LuaJIT……还是最新的2.1版。一番操作后找到一个项目 luajit-lang-toolkit（以下简称LLT），不过用起来有点小问题。make以后在src文件夹生成了luajit-x程序，与luajit的命令行工具参数一样。

$ luajit-x -bl main
-- BYTECODE -- main:0-0
0001    TGETV    1   0   0
0002    KSHORT   2   1
...
0020    KSHORT   2   1
0021    ITERN    1   1   2
0022    FORL     0 => -32744

-- BYTECODE -- main:0-0
0001    TDUP     0   0
0002    TGETS    0   0   1  ; "__G__TRACKBACK__"
0003    KPRI     0 500
...
0072    TGETS    0   0  19  ; "LAUNCHERPKG"
0073    TGETV    0   0  26
0074    KSHORT   1  30
0075    ITERN    0   2   2
0076    TSETV    0   0  31
0077    ITERN    0   2   1
0078    UNM      1   0
0079    TSETV    0   0  32
0080    ITERN    0   1   2
0081    FORL     0 => -32685
我们可以看到……啥也看不到……但是官方命令行工具的反汇编结果却大有不同。

你看人家至少有个RET啊！

$ luajit -bl main
-- BYTECODE -- main:0-0
0001    GGET     1   0      ; "print"
0002    KSTR     2   1      ; "----------------------------------------"
0003    CALL     1   1   2
...
0019    GGET     1   0      ; "print"
0020    KSTR     2   1      ; "----------------------------------------"
0021    CALL     1   1   2
0022    RET0     0   1

-- BYTECODE -- main:0-0
...
0043    KSTR     0  18      ; ""
0044    GSET     0  19      ; "LAUNCHERPKG"
0045    GGET     0  13      ; "cc"
0046    TGETS    0   0  20  ; "LuaLoadChunksFromZIP"
0047    KSTR     1  21      ; "lib/"
0048    GGET     2   3      ; "GAME_BIT"
0049    KSTR     3  22      ; "/launcher.zip"
0050    CAT      1   1   3
0051    CALL     0   1   2
0052    GGET     0  23      ; "package"
0053    TGETS    0   0  24  ; "loaded"
0054    GGET     1  19      ; "LAUNCHERPKG"
0055    KSTR     2  25      ; "launcher.launcher"
0056    CAT      1   1   2
0057    KPRI     2   0
...
0073    GGET     0  26      ; "require"
0074    KSTR     1  30      ; "app.MyApp"
0075    CALL     0   2   2
0076    TGETS    0   0  31  ; "new"
0077    CALL     0   2   1
0078    MOV      1   0
0079    TGETS    0   0  32  ; "run"
0080    CALL     0   1   2
0081 => RET0     0   1
直接撸汇编可以，但是LLT可以解析更多的东西，怎么办？我仔细参考了一下opcode表，发现很多指令与正确指令之间在指令表之间（比如第一行的TGETV与GGET）只有两个指令的距离。再翻了翻LLT的issues里面有提到了2.1版本，某人还为他写了个patch。我才明白——因为2.1的指令表与2.0相比，中间插入了两个指令，因此后面的指令在表中的位置都相应后挪。

我完善了一下这个patch，将更新的指令表加入了读写过程中，修改后的版本位于我的Github中的v2.1分支。运行修改后的版本输出就正常了。

$ luajit-x -bxg main
1b 4c 4a 02             | Header LuaJIT 2.0 BC
02                      | Flags: BCDUMP_F_STRIP
                        | .. prototype ..
b6 01                   | prototype length 182
00                      | prototype flags None
01                      | parameters number 1
05                      | framesize 5
00 08 00 16             | size uv: 0 kgc: 8 kn: 0 bc: 23
                        | .. bytecode ..
36 01 00 00             | 0001    GGET     1   0      ; "print"
27 02 01 00             | 0002    KSTR     2   1      ; "---------------
                        | -------------------------"
42 01 02 01             | 0003    CALL     1   1   2
...
36 01 00 00             | 0019    GGET     1   0      ; "print"
27 02 01 00             | 0020    KSTR     2   1      ; "---------------
                        | -------------------------"
42 01 02 01             | 0021    CALL     1   1   2
4b 00 01 00             | 0022    RET0     0   1
                        | .. uv ..
                        | .. kgc ..
05                      | kgc: ""
0e 74 72 61 63 65 62 61 | kgc: "traceback"
63 6b                   | 
0a 64 65 62 75 67       | kgc: "debug"
06 0a                   | kgc: "\
...
15 5f 5f 47 5f 5f 54 52 | kgc: "__G__TRACKBACK__"
41 43 4b 42 41 43 4b 5f | 
5f                      | 
00                      | kgc: <function: main:0>
                        | .. knum ..
00                      | eof
这个工具可以列出文件的hexdump与子程序的栈帧、局部变量等信息，是我特别心水的地方。下面进入逆向部分。

首先先把所有字节码反汇编并保存至src目录。在命令行中运行

ls | xargs -I% sh -c 'echo "Processing %" && luajit-x -bxg "%" > "src/%.lasm"'
查看PNG头发现字样img.libla，在png以外的文件里查找此字符串

$ grep libla . -R | grep -iv png
Binary file ./lib/armeabi/libcocos2dlua.so matches
如此看来解密过程应该就在libcocos2dlua.so中。先拖IDA里让它分析起来。好吧勉强承认一下南辕北辙了（没事Lua部分后面用到）。

分析libcocos2dlua
在这个so文件里搜索img.libla 定位到函数cocos2d::Image::isMpi(uchar const*,int) 。去cocos2d-x官方文档里查询了一下竟然连Image这个类都没有。感觉不太可能，翻2.x版本的文档找到了对应的类CCImage，一直往后翻发现3.4是最后一个拥有这个类的版本。在字符串里搜一下3. 找一下有没有具体版本，有了意外发现。

.rodata:0119FB8B 0000004D C E:\\MyWorkSpace\\ACGProj\\cocosEngine\\Quick-Cocos2dx-361\\/cocos/./math/Vec3.cpp
噫～原来是用了框架。在GitHub上找到这个框架，作者表示选择了“公认最稳定的版本”3.3。 其实就是懒得学新API了吧。 随便搜一搜还能找到很多有意思的加密方式（见参考资料）。我们开心的开始带源码作业。但是简单搜索后却发现源码里根本没有这个函数。我们回到IDA中，查看调用这个函数判断文件类型的地方。

signed int __fastcall cocos2d::Image::detectFormat(cocos2d::Image *this, const unsigned __int8 *a2, int a3)
{
  cocos2d::Image *v4; // [sp+4h] [bp-14h]@1
  int v5; // [sp+8h] [bp-10h]@1
  unsigned __int8 *v6; // [sp+Ch] [bp-Ch]@1
  signed int v7; // [sp+14h] [bp-4h]@2

  // ...省略...
  else if ( cocos2d::Image::isATITC(v4, v6, v5) & 1 )
  {
    v7 = 7;
  }
  else if ( cocos2d::Image::isMpi(v4, v6, v5) & 1 )
  {
    v7 = 10;
  }
  else
  {
    cocos2d::log("cocos2d: can't detect image format", &GLOBAL_OFFSET_TABLE_);
    v7 = 11;
  }
  return v7;
}
而调用这个函数的地方附近又是这样。

int __fastcall cocos2d::Image::initWithImageData(cocos2d::Image *this, const unsigned __int8 *a2, int a3)
{
  // ... 解压被压缩的图片数据
        v6 = cocos2d::Image::detectFormat(v8, (const unsigned __int8 *)v11, (int)v10);
    }
    *((_DWORD *)v8 + 10) = v6;
    if ( v6 > 0xA )
    {
      // ... 未知格式错误处理
    }
    else
    {
      switch ( v6 )
      {
        case 1u:
          v12 = cocos2d::Image::initWithPngData(v8, (const unsigned __int8 *)v11, (int)v10) & 1;
          break;
        case 0xAu:
          v12 = cocos2d::Image::initWithMPIData(v8, (const unsigned __int8 *)v11, (int)v10) & 1;
          break;
        case 0u:
          v12 = cocos2d::Image::initWithJpgData(v8, (const unsigned __int8 *)v11, (int)v10) & 1;
          break;
        case 2u:
        //... 
于是我们的目的就明确了——开发者魔改了cocos2d::Image::initWithImageData加入了自己的文件格式，并在 detectFormat 识别格式时调用 isMpi 判断并指定输入文件是否为自己的私有文件格式，然后自己写了一个initWithMPIData并在其中进行了解码或解密操作。我们要做的就是解析或利用这个函数的反向过程来解密图片资源。

以直接调用方式绕过资源加密
开始我尝试了用unicorn-engine模拟运行。但是后来发现函数里调用了malloc等标准库函数，处理起来很麻烦。IDA调试的选项也被我pass掉了，结合cocos2dx在CCImage.cpp中对图片的处理过程可知，内存里面存的是原始的RGBA数据，即使做出来内存dump也卵用无。折腾两天后决定利用NDK自己写一个wrapper，利用这个函数已导出的特性，从so里面获取这个函数并调用它来为我们解密。

我们先从已有代码入手判断一下Image类的结构。结合一下 CCImage.h 与 CCImage.cpp 中cocos2d::Image::initWithPngData 与其在IDA中反汇编的对应关系整理如下。

class CC_DLL Image : public Ref
{
        static const int MIPMAP_MAX = 16;
    unsigned char *_data;  // *(this_ + 20)
    ssize_t _dataLen;  // *(this_ + 24)
    int _width;  // *(this_ + 28)
    int _height; // *(this_ + 32)
    bool _unpack;  // *(this_ + 36) 来自初始化函数，实际并未读写
    Format _fileType;  // *(this_ + 40)
    Texture2D::PixelFormat _renderFormat;  // *(this_ + 44)
    MipmapInfo _mipmaps[MIPMAP_MAX];   // *(this_ + 48) pointer to mipmap images
    int _numberOfMipmaps;  // *(this_ + 176)

    // false if we cann't auto detect the image is premultiplied or not.
    bool _hasPremultipliedAlpha;  //  *(this_ + 180) 在一个判断后可能读写
    std::string _filePath;
其中要注意，这里一定要打开IDA的Show casts显示强制类型转换，例如*((_DWORD *)this + 6) = 4 * v5;这一句中实际被赋值的成员变量的偏移量不是6个字节而是6*DWORD=24字节。

我们据此编写这个对象的测试用例

class Image {
public:
    int __stub1[5];
    unsigned char *_data;  // *(this_ + 20)  wr
    int _dataLen;  // *(this_ + 24) w
    int _width;  // *(this_ + 28)  wr
    int _height; // *(this_ + 32)  wr
    int __stub2;
    int _fileType;  // *(this_ + 40)
    int _renderFormat;  // *(this_ + 44)  w (read in ::hasAlpha)
    char __stub3[132];  // 180-44-4
    bool _hasPremultipliedAlpha;  //  *(this_ + 180) possible w
};

// ...
printf("Image layout:\n"
           "_data: %d\n"
           "_datalen: %d\n"
           "_width: %d\n"
           "_height: %d\n"
           "_fileType: %d\n"
           "_renderFormat: %d\n"
           "_hasPremultipliedAlpha: %d\n",
           offsetof(Image, _data),
           offsetof(Image, _dataLen),
           offsetof(Image, _width),
           offsetof(Image, _height),
           offsetof(Image, _fileType),
           offsetof(Image, _renderFormat),
           offsetof(Image, _hasPremultipliedAlpha)
           );
经NDK编译在armv7设备上运行结果如下（如果编译遇到缺标准库问题，在Application.mk里指定一下GNU C++运行时即可）

Image layout:
_data: 20
_datalen: 24
_width: 28
_height: 32
_fileType: 40
_renderFormat: 44
_hasPremultipliedAlpha: 180
bingo~由于里面的成员变量都是int或指针一类的东西，所以不怎么需要考虑对齐的问题。如果有问题的话参考一下下面参考资料里的ARM文档。

然后就是编写程序了。C++类成员函数在编译时被mangle成一个乱乱的字符串，在IDA里或objdump都可以获得，原样拿来并用dlsym寻找函数指针，用我们伪造的Image类作为第一个参数的this指针调用即可。至于如何将Image对象的内容保存为png，这个就留给大家作为思考题，方法是类似的。伸手党我们都是拒绝的。

注意，这里没有写但是我已经提前分析过我们要调用的函数对Image类的读写状况，对成员变量的所有操作都是先写入再读取，不存在未初始化的情况。如果大家要用类似方法调用其他函数，也要注意传入的数据成员的值。

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <dlfcn.h>
#include "CCImage.h"

#define assert(cond, err) if (!(cond)) {printf(err);exit(1);}

typedef bool (*initWithMPIData_t)(Image*, char *, ssize_t);
const char* initWithMPIData_mangled = "_ZN7cocos2d5Image15initWithMPIDataEPKhi";

int main(int argc, char** argv) {
    assert(argc > 1, "usage: decrypt [encrypted_png]\n");

    Image *img = new Image();
    
    FILE *f = fopen(argv[1], "rb");
    assert(f != NULL, "File not exists!");
    
    fseek(f, 0, SEEK_END);
    long fsize = ftell(f);
    printf("Source file size: %ld\n", fsize);
    fseek(f, 0, SEEK_SET);
    
    char *buf = (char *)malloc(fsize + 1);
    fread(buf, fsize, 1, f);
    buf[fsize] = 0;    
    fclose(f);
    assert(!memcmp(buf, "img.libla", 9), "File already decrypted~~\n");
    
    void* handle = dlopen("/data/local/tmp/libcocos2dlua.so", RTLD_LAZY);
    assert(handle != NULL, "libcocos2dlua.so missing or corrupted!\n");
    
    initWithMPIData_t initWithMPIData_ptr = (initWithMPIData_t) dlsym(handle, initWithMPIData_mangled);
    
    assert(initWithMPIData_ptr != NULL, "Image::initWithMPIData not found\n");
    printf("Image::initWithMPIData found at: %p\n", initWithMPIData_ptr);
    
    initWithMPIData_ptr(img, buf, fsize);
    printf("Decrypted image %d x %d, raw size %d.\n",
        img->_width, img->_height, img->_dataLen);
    
        // 留给大家的思考题
    
    return 0;
}
push到手机上运行一下。顺便一提，1.out.png和1.png的大小是完全一样的。说明这个算法完全可逆。就是我懒而已……

$ ./decrypt assets/res/photo/imgs/normal/1.png
Source file size: 92363
Image::initWithMPIData found at: 0xe8185854
Decrypted image 488 x 720, raw size 1405440.
Saving to assets/res/photo/imgs/normal/1.out.png
OK，然后用shell脚本批量处理一下就可以把所有文件都解密掉了。接下来我们要做的就是，将每个图片与他的角色匹配起来，顺便看一看能不能挖掘出其他的信息。

LuaJIT探幽
这是一个三国题材的游戏，我们搜索关键字“赵云”，定位到类 app.data.db.cardDef 。这里再赞一下LLT，kgc和knum信息都是官方工具无法dump出来的。而官方文档又晦涩难懂（还一堆TODO干脆就是没写完），稍微好一点的教材就是LLT对字节码解析过程的源代码了。

在这里就结合一下例子来解释一下 LuaJIT 生成的二进制文件格式。看最左边的hex与右侧的数字注释

1b 4c 4a 02             | Header LuaJIT 2.0 BC                                | 1
02                      | Flags: BCDUMP_F_STRIP                                | 2
                        | .. prototype ..
ce b9 16                | prototype length 367822                        | 3
02                      | prototype flags PROTO_VARARG                | 4
00                      | parameters number 0                                | 5
03                      | framesize 3                                                | 6
00 99 02 00 85 06       | size uv: 0 kgc: 281 kn: 0 bc: 774        | 7
                        | .. bytecode ..
34 00 00 00             | 0001    TNEW     0   0
35 01 00 00             | 0002    TDUP     1   0
3e 01 01 00             | 0003    TSETB    1   0   1
..... 此处省略770行，都是汇编
4c 00 02 00             | 0773    RET1     0   2
                        | .. uv ..
                        | .. kgc ..
01 00 63                | ktab narray: 0 nhash: 99                        | 8
0e 63 61 72 64 53 63 6f | ktabk string: "cardScore"
72 65                   | 
03 d0 0f                | ktabk int: 2000
3 bytes固定头部"\x1bLJ"，第四位02是bytecode版本，01为LuaJIT 2.0，02为LuaJIT 2.1。2.1版本目前没有官方文档，只能从代码略窥一二。区别见参考资料patch。
flags定义参考LLT源码bytecode.luabc2
用ULEB128表示的不定长数字开始一个“节”(prototype，相当于一个函数定义)并指定节的长度，若读到0则认为文件结束。
flag参考同上，1byte
参数数量，1byte
栈帧大小3 猜测与内存分配相关，1byte
此处四个数字分别为：
uv: Upvalue来自调用者的变量，1byte
kgc: 动态分配的变量数量（猜测,翻译是garbage collected?），可存储字符串(str*B指针)、数组(karray)或字典(khash)，ULEB128
kn: 常量，可理解为const，ULEB128
bc: bytecode，汇编码条数（每条指令都是4bytes定长），ULEB128
kgc格式：类型（字符串或数组/字典）1位，若类型为数组或字典。此处为01表示数组。
数组/字典(ktab)格式，在kgc类型后紧跟的2bytes
narray:存储的数组元素个数（可理解为Python中的*args）
nhash:存储的字典元素个数（可理解为Python中的**kwargs）
紧跟一串ktabk按上面两个值来计数。一个数组元素一个ktabk，一个字典元素两个ktabk
ktabk的类型在LuaJIT的lj_bcdump.h文件的 BCDUMP_KTAB_XXX 枚举定义中。int为03，字符串为05加上字符串长度。此项类型为ULEB128
我解释的比较概括，更准确的定义需要参考官方文档上的范式。

我们可以看见，字节码格式非常紧凑，几乎没有浪费什么空间。而且不得不说，写程序解析原始字节码比读取LLT输出的文本要容易得许多……所以我写了一个。

下面的脚本用于解析LuaJIT产生的文件并将其中的常量信息提取到一个csv文件中。

#!/usr/bin/env python3
import sys
from pathlib import Path
import csv

target = Path("app.data.db.cardDef" if len(sys.argv) < 2 else sys.argv[1])

def readULEB128(file):
    result = offset = 0
    while True:
        byte = file.read(1)
        result += (byte[0] & 0x7F) << offset
        offset += 7
        if byte[0] < 0x80:
            return result

def readKtabk(file):
    type_ktab = readULEB128(file)
    assert type_ktab == 3 or type_ktab > 4, \
        "Unsupported ktab type {} at position {}".format(type_ktab, file.tell())
    if type_ktab == 3:
        return readULEB128(file)
    else:
        ret = file.read(type_ktab-5)
        try:
            return ret.decode()
        except UnicodeDecodeError as e:
            print("ERROR at pos", file.tell(), str(e))
        return ret.hex()

def main():
    with target.open('rb') as f:
        f.seek(5)                       # skip header
        length_total = readULEB128(f)   # read proto leng
        print("proto length", length_total)
        prototype_start_pos = f.tell()
        f.seek(4, 1)                    # skip flag, param, frame, uv
        num_vars = readULEB128(f)
        _ = readULEB128(f)              # kn not used
        num_bytecode = readULEB128(f)
        f.seek(num_bytecode*4, 1)   # skip bytecode

        kgcs = []
    
        for _ in range(num_vars):       # read one kgc per time
            type_kgc = f.read(1)[0]
            assert type_kgc == 1, \
                "Unsupported variable {} at {}".format(type_kgc, f.tell())
            print("== reading new one from", f.tell())
    
            narray = readULEB128(f)
            nhash = readULEB128(f)
            array = []
            hashes = {}
            for _ in range(narray):
                array.append(readKtabk(f))
            for _ in range(nhash):
                key = readKtabk(f)
                val = readKtabk(f)
                print("Reading key: ", key, "val:", val)
                hashes[key] = val
    
            kgcs.append(hashes or array)  # a ktab may only contain one
    
        assert f.tell() - prototype_start_pos == length_total, \
            "What happened?? file corrupted? at {}".format(f.tell())
    
        assert f.read(1)[0] == 0, "More prototypes following, I'm tired"
    
        print("Dump success!")
    
    with open("dumpinfo.csv", 'w') as csvfile:
        csvfile.write('\ufeff')
        writer = csv.DictWriter(csvfile, sorted(kgcs[0].keys()))
        writer.writeheader()
        writer.writerows(kgcs)
    
        print("dumped into dumpinfo.csv")

if __name__ == '__main__':
    main()
得到类似下面格式的csv。表头被我删去了。太长，丑。但是下面这一串信息里面已经包含了绝大多数我们可能需要的信息，包括角色攻击力、生命值、售价、技能ID、语音ID等等，甚至还有放大招的时候喊的口号。也有很大的潜力哦～

0,0,0,0,0,0,0,0,9,7,1,17,430,75,327,327,327,1,1,1,14500,14500,14500,65,0,2000,5,0,6,1250,0,90,240,道为核心   天道无为   道法自然  且善且行,3273,3,60,30,100,150,45,5,327,136,Y01,249,255,481,3272,130,1400,130,梦里繁花,3,75,左慈,0,0,0,0,35,240,5,0,0,3273,23,24,24,0,0,1,1,1,0,0,149,290,5,5,0,0,0,0,0,0,0,0,0,6,6,100,45,0,0,0,350,45,0
15,15,38,25,746,115,60,0,2,8,1,15,260,42,15,15,15,1,1,1,2500,2500,2500,120,0,1,2,1150,7,1300,600,124,232,什么  你说现在不流行用剑了？,0,0,0,0,0,180,60,5,15,150,S03,320,267,743,745,79,1500,140,,0,35,木鹿大王,0,0,0,0,120,246,5,0,0,747,0,13,14,15,15,0,1,1,1,1,110,232,0,4,0,0,0,0,0,0,0,0,0,4,4,500,60,0,0,0,150,60,0
15,5,37,10,744,130,35,0,2,8,1,15,260,42,15,15,15,1,1,1,2500,2500,2500,120,166,1,2,1150,5,1300,600,112,210,什么  你说现在不流行用剑了？,0,0,0,0,0,150,45,4,15,145,S03,290,230,743,743,50,1500,130,,0,45,木鹿大王,0,0,0,0,105,200,4,0,0,747,0,13,14,15,15,0,1,1,1,1,100,210,0,5,0,0,0,0,0,0,0,0,0,4,4,200,45,0,0,0,150,45,0
710,5,39,15,716,115,60,0,9,7,1,17,430,76,710,710,710,1,1,1,50000,50000,50000,150,0,2000,5,0,8,1350,0,237,286,尝尝这南蛮之地的烈火吧 ,0,0,0,0,0,260,65,6,710,165,M02,250,246,495,715,105,1500,145,含光剑 ,7,60,祝融,0,0,0,0,115,210,6,0,0,717,46,50,33,0,0,1,1,1,0,0,139,305,5,3,0,0,0,0,0,0,0,0,0,6,6,250,65,0,0,0,650,65,0
0,0,0,0,0,0,0,0,2,8,1,24,440,95,308,308,308,1,1,1,10000,10000,10000,165,185,400,2,1200,9,1300,1500,151,309,切...（无视）...,0,0,0,0,0,600,70,6,308,160,Y02,439,304,2308,352,91,2900,155,青龙偃月刀,1,60,关羽,0,0,0,0,160,309,6,0,0,352,0,39,17,18,18,0,1,1,1,1,139,312,2,4,0,0,0,0,0,0,0,0,0,4,4,600,70,0,0,0,500,70,0
搜索一下文首配图的文件编号2308，找到大概在关羽那行的第……呃……58列。当然这列有名字就叫icon，而名字顾名思义列名就叫name。继续祭出python把解密输出目录中所有名字中含编号的文件批量重命名。

import csv
from pathlib import Path

with open("dumpinfo.csv") as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        icon = row['icon']
        name = row['name']
        for f in Path().rglob(icon+'.png'):
            f.rename(f.with_name('{}-{}.png'.format(icon, name)))
大功告成！



这部分是弄完了，但是学无止境嘛～好了我学PIL去了，再把图切切剪剪做个卡牌合集去（逃

防护措施
加壳反制静态分析。
不要导出敏感函数。
增加加密函数上下文依赖性。（划重点）
混淆。（有成熟方案吗？）
参考资料
https://github.com/LuaJIT/LuaJIT/blob/v2.1/src/lj_bc.h
https://github.com/franko/luajit-lang-toolkit/issues/11
https://github.com/u0u0/Quick-Cocos2dx-Community
http://www.cocoachina.com/bbs/read.php?tid-330295.html
http://wavetry.leanote.com/post/quick-cocos2d-x%E5%9B%BE%E7%89%87%E8%B5%84%E6%BA%90%E5%8A%A0%E5%AF%86
http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042f/IHI0042F_aapcs.pdf
http://wiki.luajit.org/Bytecode-2.0
https://github.com/franko/luajit-lang-toolkit/blob/master/lang/bytecode.lua
https://developer.android.com/ndk/guides/cpp-support.html#rc
