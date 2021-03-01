**Python SqlAlchemy使用方法**

**1.初始化连接**
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
engine = create_engine('mysql://pass@localhost/test'echo=True)
DBSession = sessionmaker(bind=engine)
session = DBSession()
ret=session.execute('desc user')
print ret
# print ret.fetchall()
print ret.first()
mysql://root:pass/test
root是用户名 pass密码 test数据库
session相当于MySQLdb里面的游标
first 相当于fetchone
echo=True 会输出所有的sql

**2.创建表**
from sqlalchemy import Column
from sqlalchemy.types import *
from sqlalchemy.ext.declarative import declarative_base

BaseModel = declarative_base()

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

engine = create_engine('mysql://root:Hs2BitqLYKoruZJbT8SV@localhost/test')
DBSession = sessionmaker(bind=engine)


class User(BaseModel):
    __tablename__ = 'user1'  # 表名
    user_name = Column(CHAR(30), primary_key=True)
    pwd = Column(VARCHAR(20), default='aaa', nullable=False)
    age = Column(SMALLINT(), server_default='12')
    accout = Column(INT())
    birthday = Column(TIMESTAMP())
    article = Column(TEXT())
    height = Column(FLOAT())


def init_db():
    '''
    初始化数据库
    :return:
    '''
    BaseModel.metadata.create_all(engine)


def drop_db():
    '''
    删除所有数据表
    :return:
    '''
    BaseModel.metadata.drop_all(engine)


drop_db()
init_db()
和django的 ORM一样 一旦表被创建了，修改User类不能改变数据库结构，只能用sql语句或删除表再创建来修改数据库结构
sqlalchemy.types里面有所有的数据字段类型，等于sql类型的大写
default参数是插入数据的时候，sqlalchemy自己处理的，server_default才是让mysql处理的

**3.添加记录**
user1=User(user_name='lujianxing',accout=1245678)
session.add(user1)
session.commit()
要commit才能起作用

**4.更新记录**
**1.更新单条记录**

query = session.query(User) 
user = query.get('lujianxing11')
print user.accout
user.accout='987'
session.flush()

**2.更新多条记录**

query = session.query(User)
query.filter(User.user_name=='lujianxing2').update({User.age: '15'})
query.filter(User.user_name=='lujianxing2').update({'age': '16'})
query.filter(User.pwd=='aaa').update({'age': '17'})

**5.删除记录**
query = session.query(User)
user = query.get('lujianxing11')
session.delete(user)
session.flush()
**6.查询**
query = session.query(User)
print query  # 只显示sql语句，不会执行查询
print query[0]  # 执行查询
print query.all()  # 执行查询
print query.first()  # 执行查询
for user in query:  # 执行查询
    print user.user_name
如果字段的类型是数字型，查询出来的type也是数字型的，不是字符串
高级一点的查询：

**# 筛选**
user = query.get(1) # 根据主键获取
print query.filter(User.user_name == 2)  # 只显示sql语句，不会执行查询
print query.filter(User.user_name == 'lujianxing').all()  # 执行查询
print query.filter(User.user_name == 'lujianxing', User.accout == 1245678, User.age > 10).all()  # 

**执行查询**
print query.filter(User.user_name == 'lujianxing').filter(User.accout == 1245678).all()
print query.filter("user_name = 'lujianxing'").all()  # 执行查询
print query.filter("user_name = 'lujianxing' and accout=1245678").all()  # 执行查询
query2 = session.query(User.user_name)  # 返回的结果不是User的实例，而是元组
print query2.all()  # 执行查询
print query2.offset(1).limit(1).all()  # 等于 limit 1,1

**# 排序**
print query2.order_by(User.user_name).all()  
print query2.order_by('user_name').all()  
print query2.order_by(User.user_name.desc()).all()
print query2.order_by(User.user_name, User.accout.desc()).all()
print query2.filter("user_name = 'lujianxing' and accout=1245678").count()

**# 聚合查询**
print session.query(func.count('*')).select_from(User).scalar()
print session.query(func.count('1')).select_from(User).scalar()
print session.query(func.count(User.id)).scalar()
print session.query(func.count('*')).filter(User.id > 0).scalar() # filter() 中包含 User，因此不需要指

**定表**
print session.query(func.count('*')).filter(User.name == 'a').limit(1).scalar() == 1 # 可以用 limit() 限制 count() 的返回数
print session.query(func.sum(User.id)).scalar()
print session.query(func.now()).scalar() # func 后可以跟任意函数名，只要该数据库支持
print session.query(func.current_timestamp()).scalar()
print session.query(func.md5(User.name)).filter(User.id == 1).scalar()