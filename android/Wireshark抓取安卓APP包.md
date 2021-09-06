# Wireshark抓取安卓APP包

演示使用抓包工具wireshark分析手机lol盒子新闻列表请求地址

wireshark是一款非常强大的开源免费的网络封包分析软件，使用它可以捕获各种网络封包，显示封包的详细信息。
wireshark是一款电脑软件，如何使用它来捕获手机网络数据呢？
wireshark的抓包原理是使用WinPCAP作为接口，直接与网卡进行数据报文交换。我们只需要让手机通过电脑网卡传输数据即可，这里推荐使用360免费wifi。



360免费wifi可以使用笔记本的无线网卡创建一个wifi热点 ，手机连接该wifi即可使用电脑网络上网。
连接之后，打开我们的wireshark
开始抓包，马上用手机盒子点击资讯，让它刷新新闻列表



获取到了很多数据，停止抓包
因为盒子是使用http协议获取新闻列表的，我们可以在过滤输入框内输入http，按下回车。过滤掉无关数据


第一条数据内容是：
GET /apiNewsList.php?action=c HTTP/1.1\r\n
Host: box.dwstatic.com\r\n
我们可以使用浏览器尝试访问这个url，看看是不是我们需要的数据：

[{"type":"newsWithHeader","tag":"headlineNews","name":"\u5934\u6761"},{"type":"news","tag":"newsVideo","name":"\u89c6\u9891"},{"type":"news","tag":"upgradenews","name":"\u8d5b\u4e8b"},{"type":"album","tag":"beautifulWoman","name":"\u9753\u7167"},{"type":"album","tag":"jiongTu","name":"\u56e7\u56fe"},{"type":"album","tag":"wallpaper","name":"\u58c1\u7eb8"}]



格式是json的，经过usc2→ansi转码后：
[{"type":"newsWithHeader","tag":"headlineNews","name":"头条"},{"type":"news","tag":"newsVideo","name":"视频"},{"type":"news","tag":"upgradenews","name":"赛事"},{"type":"album","tag":"beautifulWoman","name":"靓照"},{"type":"album","tag":"jiongTu","name":"囧图"},{"type":"album","tag":"wallpaper","name":"壁纸"}]

发现这个是盒子新闻顶部导航栏的一些分类，并不是我们要找的新闻列表数据，那么继续分析下个数据包：

GET /apiNewsList.php?action=l&newsTag=headlineNews&p=1 HTTP/1.1\r\n
Host: box.dwstatic.com\r\n
尝试访问这个url：
http://box.dwstatic.com/apiNewsList.php?action=l&newsTag=headlineNews&p=1

得到数据经过解析和格式化后：

{
    "totalRecord": "11225",
    "totalPage": 449,
    "data": [
        {
            "id": "23727",
            "title": "17日测服：新增五款皮肤插画",
            "content": "9月17日测服：新增五款全新皮肤插画",
            "weight": "64",
            "time": "1442456005",
            "readCount": "76977",
            "ymz_id": null,
            "photo": "http://m1.dwstatic.com/mbox/article_img/shouji_ac75a4c4f67a7983455c6bdebd67a611.jpg",
            "artId": "23727",
            "commentSum": "111",
            "commentUrl": "1509/306410856768&aid=23727&uniqid=b84ebe1a9e890dbe418dbb5b551ff291&gochannel=lol",
            "hasVideo": 0,
            "destUrl": "http://box.dwstatic.com/unsupport.php?lolboxAction=toNewsDetail&newsId=23727",
            "type": "news"
        },
        {
            "id": "16133",
            "title": "乐视-游戏返现狂欢节",
            "content": "letv乐迷节，电视手机嗨送",
            "weight": "60",
            "time": "1441973110",
            "readCount": "0",
            "photo": "http://img.dwstatic.com/lol/1509/305917715872/1441966664448.png",
            "artId": "16133",
            "commentSum": 0,
            "commentUrl": "1411/279211876566&aid=16133&uniqid=23efe8ecbb3387ca07f109acee2d22c9&gochannel=lol",
            "hasVideo": 0,
            "destUrl": "http://box.dwstatic.com/unsupport.php?lolboxAction=toExternalWebView&tag=letvBanner",
            "type": "news"
        },
        {
            "id": "23748",
            "title": "停不下来 官方第四批封号来袭",
            "content": "完全停不下来！官方公布第四批封号名单",
            "weight": "60",
            "time": "1442460818",
            "readCount": "54591",
            "ymz_id": null,
            "photo": "http://m1.dwstatic.com/mbox/article_img/shouji_0f7b4a877a6c0c483472366a4e96ad21.jpg",
            "artId": "23748",
            "commentSum": "243",
            "commentUrl": "1509/306415431461&aid=23748&uniqid=478857ed3f737d786e02002930154e5c&gochannel=lol",
            "hasVideo": 0,
            "destUrl": "http://box.dwstatic.com/unsupport.php?lolboxAction=toNewsDetail&newsId=23748",
            "type": "news"
        },
        {
            "id": "23742",
            "title": "没有Uzi S5将是Imp个人秀？",
            "content": "网友吹一波：没有Uzi S5将是Imp个人秀？",
            "weight": "60",
            "time": "1442459299",
            "readCount": "71030",
            "ymz_id": null,
            "photo": "http://m1.dwstatic.com/mbox/article_img/shouji_5e7bd51307e91f3de8085a761bc3b655.jpg",
            "artId": "23742",
            "commentSum": "173",
            "commentUrl": "1509/306413695823&aid=23742&uniqid=a39613cd0da71ba7e299d801c0e69fa3&gochannel=lol",
            "hasVideo": 0,
            "destUrl": "http://box.dwstatic.com/unsupport.php?lolboxAction=toNewsDetail&newsId=23742",
            "type": "news"
        },
        {
            "id": "23730",
            "title": "每日精彩集锦：皇子怒秀智商",
            "content": "每日精彩集锦 高富帅四阿哥怒秀智商",
            "weight": "60",
            "time": "1442457570",
            "readCount": "56332",
            "ymz_id": null,
            "photo": "http://m1.dwstatic.com/mbox/article_img/shouji_e1026b697fe92b54a78d9ea4d96a9caf.jpg",
            "artId": "23730",
            "commentSum": "53",
            "commentUrl": "1509/306412672653&aid=23730&uniqid=9289b820b4abb192ddfa1d050c89ad47&gochannel=lol",
            "hasVideo": 1,
            "destUrl": "http://box.dwstatic.com/unsupport.php?lolboxAction=toNewsDetail&newsId=23730",
            "type": "video"
        },
        {
            "id": "23738",
            "title": "原凉解说：双5杀新英雄虐棒子",
            "content": "原凉解说 26人头双5杀新英雄血虐棒子",
            "weight": "60",
            "time": "1442457371",
            "readCount": "65390",
            "ymz_id": null,
            "photo": "http://m1.dwstatic.com/mbox/article_img/shouji_aed599d1d85233802b23d0da629288f3.jpg",
            "artId": "23738",
            "commentSum": 62,
            "commentUrl": "1509/306412316943&aid=23738&uniqid=38dbab002c32fb1418067e32bb23760a&gochannel=lol",
            "hasVideo": 1,
            "destUrl": "http://box.dwstatic.com/unsupport.php?lolboxAction=toNewsDetail&newsId=23738",
            "type": "video"
        },

        {
            "id": "23711",
            "title": "三线战队吐槽 凭啥不准上韩援",
            "content": "三线战队的吐槽 禁用外援无疑自斩根基",
            "weight": "60",
            "time": "1442385725",
            "readCount": "274162",
            "ymz_id": null,
            "photo": "http://m1.dwstatic.com/mbox/article_img/shouji_55a5e7dc4808090fe41a594ef85234f5.jpg",
            "artId": "23711",
            "commentSum": "177",
            "commentUrl": "1509/306339976427&aid=23711&uniqid=3f76d9d7ed52c2d8004aa7c4de500cc9&gochannel=lol",
            "hasVideo": 0,
            "destUrl": "http://box.dwstatic.com/unsupport.php?lolboxAction=toNewsDetail&newsId=23711",
            "type": "news"
        },
        {
            "id": "23702",
            "title": "韩服插画活动精美作品欣赏",
            "content": "粉丝插画赞出新高度 韩服活动作品欣赏",
            "weight": "60",
            "time": "1442384776",
            "readCount": "208134",
            "ymz_id": null,
            "photo": "http://m1.dwstatic.com/mbox/article_img/shouji_58f376b6d57d7127e2c44e7174ad2be0.jpg",
            "artId": "23702",
            "commentSum": "68",
            "commentUrl": "1509/306339588332&aid=23702&uniqid=70c93ec295611a2b598fe59e83cc4da4&gochannel=lol",
            "hasVideo": 0,
            "destUrl": "http://box.dwstatic.com/unsupport.php?lolboxAction=toNewsDetail&newsId=23702",
            "type": "news"
        },
        {
            "id": "23699",
            "title": "Riot官方解说 A组看好虎牙",
            "content": "Riot官方解说Jatt分析A组 最看好虎牙",
            "weight": "60",
            "time": "1442384388",
            "readCount": "224516",
            "ymz_id": null,
            "photo": "http://m1.dwstatic.com/mbox/article_img/shouji_265b595033e0051e7a55e23dc252eae0.jpg",
            "artId": "23699",
            "commentSum": "71",
            "commentUrl": "1509/306339137903&aid=23699&uniqid=cdecec024c3788ab5896a281a3ad2f7e&gochannel=lol",
            "hasVideo": 0,
            "destUrl": "http://box.dwstatic.com/unsupport.php?lolboxAction=toNewsDetail&newsId=23699",
            "type": "news"
        },
        {
            "id": "23694",
            "title": "这波不亏 性感COS献给众球迷",
            "content": "这波福利不亏 性感黑丝COS带一波球迷",
            "weight": "60",
            "time": "1442374386",
            "readCount": "257850",
            "ymz_id": null,
            "photo": "http://m1.dwstatic.com/mbox/article_img/shouji_31545716836b1700d85c843cfecaf4f5.jpg",
            "artId": "23694",
            "commentSum": "201",
            "commentUrl": "1509/306329165142&aid=23694&uniqid=45231ff71f0fe7ef6a2676e48143a670&gochannel=lol",
            "hasVideo": 0,
            "destUrl": "http://box.dwstatic.com/unsupport.php?lolboxAction=toNewsDetail&newsId=23694",
            "type": "news"
        }
    ],
    "rs": true,
    "msg": "",
    "order": "time",
    "pageSize": 25,
    "pageNum": 1,
    "headerline": [
        {
            "id": "23715",
            "weight": "61",
            "photo": "http://m1.dwstatic.com/mbox/article_img/toutiao_11a64bbb4fbe91ce30c49b0b0ac14ac4.jpg",
            "artId": "23715",
            "commentSum": "750",
            "commentUrl": "1509/306330727864&aid=23715&uniqid=3c898157a94d6d63377257c63877b0ce&gochannel=lol",
            "destUrl": "http://box.dwstatic.com/unsupport.php?lolboxAction=toNewsDetail&newsId=23715"
        },
        {
            "id": "23678",
            "weight": "64",
            "photo": "http://m1.dwstatic.com/mbox/article_img/toutiao_3ff24938c05c79f1d2929831ac08e350.jpg",
            "artId": "23678",
            "commentSum": "1628",
            "commentUrl": "1509/306321836674&aid=23678&uniqid=a911c403d1b31254fff2898af86729a6&gochannel=lol",
            "destUrl": "http://box.dwstatic.com/unsupport.php?lolboxAction=toNewsDetail&newsId=23678"
        },
        {
            "id": "23664",
            "weight": "61",
            "photo": "http://img.dwstatic.com/lol/1509/305917715872/1441966664522.png",
            "artId": "23664",
            "commentSum": "1330",
            "commentUrl": "1509/306243841513&aid=23664&uniqid=fc8636ce24ad62a481dc8461754eb5ae&gochannel=lol",
            "destUrl": "http://box.dwstatic.com/unsupport.php?lolboxAction=toExternalWebView&tag=letvBanner"
        },
        {
            "id": "23590",
            "weight": "60",
            "photo": "http://m1.dwstatic.com/mbox/article_img/toutiao_8a1d2be06b02e420566f4e02819a0b02.jpg",
            "artId": "23590",
            "commentSum": "569",
            "commentUrl": "1509/306078258871&aid=23590&uniqid=9133ba3323c24f5f4a1793c00141a002&gochannel=lol",
            "destUrl": "http://box.dwstatic.com/unsupport.php?lolboxAction=toNewsDetail&newsId=23590"
        },
        {
            "id": "23550",
            "weight": "63",
            "photo": "http://m1.dwstatic.com/mbox/article_img/toutiao_ba7eddd818d93715fb5609e846e61798.jpg",
            "artId": "23550",
            "commentSum": "3514",
            "commentUrl": "1509/305907816556&aid=23550&uniqid=84cc752e82ebc95cba50054247f3cfa5&gochannel=lol",
            "destUrl": "http://box.dwstatic.com/unsupport.php?lolboxAction=toNewsDetail&newsId=23550"
        }
    ]
}

没错了，正是我们所需要的数据。

http://box.dwstatic.com/apiNewsList.php?action=l&newsTag=headlineNews&p=1
即是lol盒子提交get请求获取新闻列表的url。
————————————————
版权声明：本文为CSDN博主「旋旋丶」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/a997208868/article/details/48521627