PHP API中，MYSQL与MYSQLI的持久连接区别

转载自：http://www.cnxct.com/some-differences-between-mysql-and-mysqli-of-persistent-connection/

很久很久以前，我也是因为工作上的bug，研究了php mysql client的连接驱动mysqlnd 与libmysql之间的区别php与mysql通讯那点事，这次又遇到一件跟他们有联系的事情，mysqli与mysql持久链接的区别。写出这篇文章，用了好一个多月，其一是我太懒了，其二是工作也比较忙。最近才能腾出时间，来做这些事情。每次做总结，都要认真阅读源码，理解含义，测试验证，来确认这些细节。而每一个步骤都需要花费很长的时间，而且，还不能被打断。一旦被打断了，都需要很长时间去温习上下文。也故意强迫自己写这篇总结，改改自己的惰性。

在我和我的小伙伴们如火如荼的开发、测试时发生了“mysql server too many connections”的错误，稍微排查了一下，发现是php后台进程建立了大量的链接，而没有关闭。服务器环境大约如下php5.3.x 、mysqli API、mysqlnd 驱动。代码情况是这样：

复制代码
//后台进程A
/*
配置信息
'mysql'=>array(
     'driver'=>'mysqli',
//   'driver'=>'pdo',
//   'driver'=>'mysql',
     'host'=>'192.168.111.111',
     'user'=>'root',
     'port'=>3306,
     'dbname'=>'dbname',
     'socket'=>'',
     'pass'=>'pass',
     'persist'=>true,    //下面有提到哦，这是持久链接的配置
    ),
*/
$config=Yaf_Registry::get('config');
$driver = Afx_Db_Factory::DbDriver($config['mysql']['driver']);     //mysql  mysqli
$driver::debug($config['debug']);     //注意这里
$driver->setConfig($config['mysql']);     //注意这里
Afx_Module::Instance()->setAdapter($driver);     //注意这里，哪里不舒服，就注意看哪里。

$queue=Afx_Queue::Instance();
$combat = new CombatEngine();
$Role = new Role(1,true);
$idle_max=isset($config['idle_max'])?$config['idle_max']:1000;
while(true)
{
    $data = $queue->pop(MTypes::ECTYPE_COMBAT_QUEUE, 1);
    if(!$data){
        usleep(50000);    //休眠0.05秒
         ++$idle_count;
        if($idle_count>=$idle_max)
        {
            $idle_count=0;
             Afx_Db_Factory::ping();
        }
        continue;
    }
    $idle_count=0;
    $Role->setId($data['attacker']['role_id']);
    $Property   = $Role->getModule('Property');
    $Mounts     = $Role->getModule('Mounts');
    //............
    unset($Property, $Mounts/*.....*/);
｝
复制代码
从这个后台进程代码中，可以看出“$Property”变量以及“$Mounts”变量频繁被创建，销毁。而ROLE对象的getModule方法是这样写的

复制代码
//ROLE对象的getModule方法
class Role extends Afx_Module_Abstract
{
    public function getModule ($member_class)
    {
        $property_name = '__m' . ucfirst($member_class);
        if (! isset($this->$property_name))
        {
            $this->$property_name = new $member_class($this);
        }
        return $this->$property_name;
    }
}
//Property 类
class Property extends Afx_Module_Abstract
{
    public function __construct ($mRole)
    {
        $this->__mRole = $mRole;
    }
}
复制代码
可以看出getModule方法只是模拟单例，new了一个新对象返回，而他们都继承了Afx_Module_Abstract类。Afx_Module_Abstract类大约代码如下：

复制代码
abstract class Afx_Module_Abstract
{
    public function setAdapter ($_adapter)
    {
        $this->_adapter = $_adapter;
    }
}
复制代码
类Afx_Module_Abstract中关键代码如上，跟DB相关的，就setAdapter一个方法，回到“后台进程A”，setAdapter方法是将Afx_Db_Factory::DbDriver($config['mysql']['driver'])的返回，作为参数传了进来。继续看下Afx_Db_Factory类的代码

复制代码
class Afx_Db_Factory
{
    const DB_MYSQL = 'mysql';
    const DB_MYSQLI = 'mysqli';
    const DB_PDO = 'pdo';

    public static function DbDriver ($type = self::DB_MYSQLI)
    {
        switch ($type)
        {
            case self::DB_MYSQL:
                $driver = Afx_Db_Mysql_Adapter::Instance();
                break;
            case self::DB_MYSQLI:
                $driver = Afx_Db_Mysqli_Adapter::Instance();    //走到这里了
                break;
            case self::DB_PDO:
                $driver = Afx_Db_Pdo_Adapter::Instance();
                break;
            default:
                break;
        }
        return $driver;
    }
}
复制代码
一看就知道是个工厂类，继续看真正的DB Adapter部分代码

复制代码
class Afx_Db_Mysqli_Adapter implements Afx_Db_Adapter
{
    public static function Instance ()
    {
        if (! self::$__instance instanceof Afx_Db_Mysqli_Adapter)
        {
            self::$__instance = new self();    //这里是单例模式，为何新生成了一个mysql的链接呢？
        }
        return self::$__instance;
    }

    public function setConfig ($config)
    {
        $this->__host = $config['host'];
        //...
        $this->__user = $config['user'];
        $this->__persist = $config['persist'];
        if ($this->__persist == TRUE)
        {
            $this->__host = 'p:' . $this->__host;    //这里为持久链接做了处理，支持持久链接
        }
        $this->__config = $config;
    }

    private function __init ()
    {

        $this->__link = mysqli_init();
        $this->__link->set_opt(MYSQLI_OPT_CONNECT_TIMEOUT, $this->__timeout);
        $this->__link->real_connect($this->__host, $this->__user, $this->__pass, $this->__dbname, $this->__port, $this->__socket);
        if ($this->__link->errno == 0)
        {
            $this->__link->set_charset($this->__charset);
        } else
        {
            throw new Afx_Db_Exception($this->__link->error, $this->__link->errno);
        }
    }
}
复制代码
从上面的代码可以看到，我们已经启用长链接了啊，为何频繁建立了这么多链接呢？为了模拟重现这个问题，我在本地开发环境进行测试，无论如何也重现不了，对比了下环境，我的开发环境是windows7、php5.3.x、mysql、libmysql，跟服务器上的不一致，问题很可能出现在mysql跟mysqli的API上，或者是libmysql跟mysqlnd的问题上。为此，我又小心翼翼的翻开PHP源码(5.3.x最新的)，终于功夫不负有心人，找到了这些问题的原因。

复制代码
//在文件ext\mysql\php_mysql.c的907-916行
//mysql_connect、mysql_pconnect都调用它，区别是持久链接标识就是persistent为false还是true
static void php_mysql_do_connect(INTERNAL_FUNCTION_PARAMETERS, int persistent)
{
/* hash it up */
Z_TYPE(new_le) = le_plink;
new_le.ptr = mysql;
//注意下面的if里面的代码
if (zend_hash_update(&EG(persistent_list), hashed_details, hashed_details_length+1, (void *) &new_le, sizeof(zend_rsrc_list_entry), NULL)==FAILURE) {
    free(mysql);
    efree(hashed_details);
    MYSQL_DO_CONNECT_RETURN_FALSE();
}
MySG(num_persistent)++;
MySG(num_links)++;
}
复制代码
从mysql_pconnect的代码中，可以看到，当php拓展mysql api与mysql server建立TCP链接后，就立刻将这个链接存入persistent_list中，下次建立链接是，会先从persistent_list里查找是否存在同IP、PORT、USER、PASS、CLIENT_FLAGS的链接，存在则用它，不存在则新建。

而php的mysqli拓展中，不光用了一个persistent_list来存储链接，还用了一个free_link来存储当前空闲的TCP链接。当查找时，还会判断是否在空闲的free_link链表中存在，存在了才使用这个TCP链接。而在mysqli_closez之后或者RSHUTDOWN后，才将这个链接push到free_links中。(mysqli会查找同IP，PORT、USER、PASS、DBNAME、SOCKET来作为同一标识，跟mysql不同的是，没了CLIENT，多了DBNAME跟SOCKET，而且IP还包括长连接标识“p”)

复制代码
//文件ext\mysqli\mysqli_nonapi.c 172行左右   mysqli_common_connect创建TCP链接(mysqli_connect函数调用时)
do {
    if (zend_ptr_stack_num_elements(&plist->free_links)) {
        mysql->mysql = zend_ptr_stack_pop(&plist->free_links);    //直接pop出来，同一个脚本的下一个mysqli_connect再次调用时，就找不到它了

        MyG(num_inactive_persistent)--;
        /* reset variables */

        #ifndef MYSQLI_NO_CHANGE_USER_ON_PCONNECT
            if (!mysqli_change_user_silent(mysql->mysql, username, passwd, dbname, passwd_len)) {    //(让你看时，你再看)注意看这里mysqli_change_user_silent
        #else
            if (!mysql_ping(mysql->mysql)) {
        #endif
        #ifdef MYSQLI_USE_MYSQLND
            mysqlnd_restart_psession(mysql->mysql);
        #endif
}
//文件ext\mysqli\mysqli_api.c 585-615行
/* {{{ php_mysqli_close */
void php_mysqli_close(MY_MYSQL * mysql, int close_type, int resource_status TSRMLS_DC)
{
    if (resource_status > MYSQLI_STATUS_INITIALIZED) {
        MyG(num_links)--;
    }

    if (!mysql->persistent) {
        mysqli_close(mysql->mysql, close_type);
    } else {
        zend_rsrc_list_entry *le;
        if (zend_hash_find(&EG(persistent_list), mysql->hash_key, strlen(mysql->hash_key) + 1, (void **)&le) == SUCCESS) {
            if (Z_TYPE_P(le) == php_le_pmysqli()) {
                mysqli_plist_entry *plist = (mysqli_plist_entry *) le->ptr;
#if defined(MYSQLI_USE_MYSQLND)
                mysqlnd_end_psession(mysql->mysql);
#endif
                zend_ptr_stack_push(&plist->free_links, mysql->mysql);    //这里在push回去，下次又可以用了

                MyG(num_active_persistent)--;
                MyG(num_inactive_persistent)++;
            }
        }
        mysql->persistent = FALSE;
    }
    mysql->mysql = NULL;

    php_clear_mysql(mysql);
}
/* }}} */
复制代码
MYSQLI为什么要这么做？为什么同一个长连接不能在同一个脚本中复用？
在C函数mysqli_common_connect中看到了有个mysqli_change_user_silent的调用，如上代码，mysqli_change_user_silent对应这libmysql的mysql_change_user或mysqlnd的mysqlnd_change_user_ex，他们都是调用了C API的mysql_change_user来清理当前TCP链接的一些临时的会话变量，未完整写的提交回滚指令，锁表指令，临时表解锁等等(这些指令，都是mysql server自己决定完成，不是php 的mysqli 判断已发送的sql指令然后做响应决定)，见手册的说明The mysqli Extension and Persistent Connections。这种设计，是为了这个新特性，而mysql拓展，不支持这个功能。

从这些代码的浅薄里理解上来看，可以理解mysqli跟mysql的持久链接的区别了，这个问题，可能大家理解起来比较吃力，我后来搜了下，也发现了一个因为这个原因带来的疑惑，大家看这个案例，可能理解起来就非常容易了。Mysqli persistent connect doesn’t work回答者没具体到mysqli底层实现，实际上也是这个原因。 代码如下：

复制代码
<?php
$links = array();
for ($i = 0; $i < 15; $i++) {
    $links[] =  mysqli_connect('p:192.168.1.40', 'USER', 'PWD', 'DB', 3306);
}
sleep(15);
复制代码
查看进程列表里是这样的结果：

复制代码
netstat -an | grep 192.168.1.40:3306
tcp        0      0 192.168.1.6:52441       192.168.1.40:3306       ESTABLISHED
tcp        0      0 192.168.1.6:52454       192.168.1.40:3306       ESTABLISHED
tcp        0      0 192.168.1.6:52445       192.168.1.40:3306       ESTABLISHED
tcp        0      0 192.168.1.6:52443       192.168.1.40:3306       ESTABLISHED
tcp        0      0 192.168.1.6:52446       192.168.1.40:3306       ESTABLISHED
tcp        0      0 192.168.1.6:52449       192.168.1.40:3306       ESTABLISHED
tcp        0      0 192.168.1.6:52452       192.168.1.40:3306       ESTABLISHED
tcp        0      0 192.168.1.6:52442       192.168.1.40:3306       ESTABLISHED
tcp        0      0 192.168.1.6:52450       192.168.1.40:3306       ESTABLISHED
tcp        0      0 192.168.1.6:52448       192.168.1.40:3306       ESTABLISHED
tcp        0      0 192.168.1.6:52440       192.168.1.40:3306       ESTABLISHED
tcp        0      0 192.168.1.6:52447       192.168.1.40:3306       ESTABLISHED
tcp        0      0 192.168.1.6:52444       192.168.1.40:3306       ESTABLISHED
tcp        0      0 192.168.1.6:52451       192.168.1.40:3306       ESTABLISHED
tcp        0      0 192.168.1.6:52453       192.168.1.40:3306       ESTABLISHED
复制代码
这样看代码，就清晰多了，验证我的理解对不对也比较简单，这么一改就看出来了

复制代码
for ($i = 0; $i < 15; $i++) {
    $links[$i] =  mysqli_connect('p:192.168.1.40', 'USER', 'PWD', 'DB', 3306);
    var_dump(mysqli_thread_id($links[$i]));    //如果你担心被close掉了，这是新建的TCP链接，那么你可以打印下thread id，看看是不是同一个ID，就区分开了
    mysqli_close($links[$i])
}
/*
结果如下：
root@cnxct:/home/cfc4n# netstat -antp |grep 3306|grep -v "php-fpm"
tcp        0      0 192.168.61.150:55148    192.168.71.88:3306      ESTABLISHED 5100/php5   
root@cnxct:/var/www# /usr/bin/php5 4.php 
int(224218)
int(224218)
int(224218)
int(224218)
int(224218)
int(224218)
int(224218)
int(224218)
int(224218)
int(224218)
int(224218)
int(224218)
int(224218)
int(224218)
int(224218)
*/
复制代码
如果你担心被close掉了，这是新建的TCP链接，那么你可以打印下thread id，看看是不是同一个ID，就清楚了。(虽然我没回复这个帖子，但不能证明我很坏。)以上是CLI模式时的情况。在FPM模式下时，每个页面请求都会由单个fpm子进程处理。这个子进程将负责维护php与mysql server建立的长链接，故当你多次访问此页面，来确认是不是同一个thread id时，可能会分别分发给其他fpm子进程处理，导致看到的结果不一样。但最终，每个fpm子进程都会分别维持这些TCP链接。

总体来说，mysqli拓展跟mysql拓展的区别是下面几条

持久链接建立方式，mysqli是在host前面增加“p:”两个字符；mysql使用mysql_pconnect函数；。
mysqli建立的持久链接，必须在mysqli_close之后，才会下面的代码复用，或者RSHOTDOWN之后，被下一个请求复用；mysql的长连接，可以立刻被复用
mysqli建立持久链接时，会自动清理上一个会话变量、回滚事务、表解锁、释放锁等操作；mysql不会。
mysqli判断是否为同一持久链接标识是IP，PORT、USER、PASS、DBNAME、SOCKET；mysql是IP、PORT、USER、PASS、CLIENT_FLAGS
好了，知道这个原因，那我们文章开头提到的问题就好解决了，大家肯定第一个想到的是在类似Property的类中，__destruct析构函数中增加一个mysqli_close方法，当被销毁时，就调用关闭函数，把持久链接push到free_links里。如果你这么想，我只能恭喜你，答错了，最好的解决方案就是压根不让它创建这么多次。同事dietoad同学给了个解决方案，对DB ADAPTER最真正单例，并且，可选是否新创建链接。如下代码：

复制代码
// DB FACTORY
class Afx_Db_Factory
{
    const DB_MYSQL = 'mysql';
    const DB_MYSQLI = 'mysqli';
    const DB_PDO = 'pdo';

    static $drivers = array(
        'mysql'=>array(),'mysqli'=>array(),'pdo'=>array()
    );


    public static function DbDriver ($type = self::DB_MYSQLI, $create = FALSE)    //新增$create 参数
    {
        $driver = NULL;
        switch ($type)
        {
            case self::DB_MYSQL:
                $driver = Afx_Db_Mysql_Adapter::Instance($create);
                break;
            case self::DB_MYSQLI:
                $driver = Afx_Db_Mysqli_Adapter::Instance($create);
                break;
            case self::DB_PDO:
                $driver = Afx_Db_Pdo_Adapter::Instance($create);
                break;
            default:
                break;
        }
        self::$drivers[$type][] = $driver;
        return $driver;
    }
}

//mysqli adapter
class Afx_Db_Mysqli_Adapter implements Afx_Db_Adapter
{
    public static function Instance ($create = FALSE)
    {
        if ($create)
        {
            return new self();  //新增$create参数的判断
        }
        if (! self::$__instance instanceof Afx_Db_Mysqli_Adapter)
        {
            self::$__instance = new self();
        }
        return self::$__instance;
    }
}
复制代码
看来，开发环境跟运行环境一致是多么的重要，否则就不会遇到这些问题了。不过，如果没遇到这么有意思的问题，岂不是太可惜了？ (图：天冬)

学习吧，屌丝


$GLOBALS['link0']