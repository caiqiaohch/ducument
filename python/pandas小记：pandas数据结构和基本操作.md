**pandas小记：pandas数据结构和基本操作**

# 创建Series，DataFrame #
## 1，创建Series ##

a，通过列表创建

    obj = Series([4, 7, -5, 3]) 
    obj2 = Series([4, 7, -5, 3], index=['d','b','a','c']) #指定索引

b，通过字典创建Series

    sdata = {'Ohio':35000, 'Texas':7100, 'Oregon':1600,'Utah':500}
    obj3 = Series(sdata)

c，通过字典 + 索引

    states = ['California', 'Ohio', 'Oregon', 'Texas']
    obj4 = Series(sdata, index=states)


指定索引时，跟states索引匹配的那3个值会被找出并放到相应的位置，‘California’对应的sdata值找不到，其结果为NaN。

**基本描述元素**  
Series.values 返回系列为ndarray或ndarray样 
Series.dtype 返回底层数据的dtype对象 
Series.ftype 返回底层数据的ftype对象Series.shape 返回基础数据的形状的元组 
Series.nbytes 返回底层数据中的字节数 
Series.ndim 返回底层数据的维数， 
Series.size 返回底层数据中的元素数量 
Series.strides 返回基础数据的步幅 
Series.itemsize 返回底层数据项的dtype的大小 
Series.base 返回基础对象 
Series.T 返回转置，这是通过定义self 
Series.memory_usage（[index，deep]）

**特性**  
Series和array最直观的不同大概就是index的多样性了，可以是其他任何值，不限于数字  
Series和dict最直观的不同大概也是index的有序性，可以更具index来排序的，dict的排序默认是不支持的

**序列化**
Series.from_csv（path [，sep，parse_dates，…]） - 读取CSV文件（DISCOURAGED，请改用pandas.read_csv()）。  
Series.to_pickle（path） Pickle（序列化）对象到输入文件路径。  
Series.to_csv（[path，index，sep，na_rep，…]） 将系列写入逗号分隔值（csv）文件  
Series.to_dict() 将系列转换为{label - > value}  
Series.to_frame（[name]） 将系列转换为DataFrame  
Series.to_xarray() 从pandas对象返回一个xarray对象。  
Series.to_hdf（path_or_buf，key，\ \ kwargs） - 使用HDFStore将包含的数据写入HDF5文件。  
Series.to_sql（name，con [，flavor，schema，…]） - 将存储在DataFrame中的记录写入SQL数据库。  
Series.to_msgpack（[path_or_buf，encoding]） msgpack（serialize）对象到输入文件路径  
Series.to_json（[path_or_buf，orient，…]） 将对象转换为JSON字符串。  
Series.to_sparse（[kind，fill_value]） 将系列转换为稀疏系列  
Series.to_dense() 返回NDFrame的密集表示（而不是稀疏）  
Series.to_string（[buf，na_rep，…]） 呈现系列的字符串表示形式  
Series.to_clipboard（[excel，sep]） 

**索引迭代方式**
Series.get（key [，default]） 从给定键的对象获取项目（DataFrame列，面板切片等）。  
Series.at 基于快速标签的标量访问器  
Series.iat 快速整数位置标量存取器。  
Series.ix 主要是基于标签位置的索引器，具有整数位置后备。  
Series.loc 纯标签位置索引器，用于按标签选择。  
Series.iloc 纯粹基于整数位置的索引，用于按位置选择。  
Series.iter() 提供对系列的值的迭代  
Series.iteritems() Lazily迭代（索引，值）元组 
 
**其他**  

	
    print("在末尾添加一行数据")
	s_new = s_selfdefined.append(Series({'2017': None}))
	print(s_new)
	
	print("返回无null的数据")
	print(s_new.dropna())
	
	print("使用特定方法填充无值数据:")
	s_has_unknown = s_new.fillna('unknown')
	print(s_has_unknown)
	
	print("字符串替换:")
	s_replaced = s_has_unknown.replace('unknown', 0)
	print(s_replaced)
	
	print("按值从大到小排序：")
	print(s_replaced.sort_values(axis=0, ascending=False))
	
	print("按索引从小到大排序：")
	print(s_replaced.sort_index())`
 

## 2，创建DataFrame ##
a，词典生成

    data = {'state':['Ohio', 'Ohio', 'Ohio', 'Nevada','Nevada'],
    'year':[2000, 2001, 2002, 2011, 2002],
    'pop':[1.5, 1.7, 3.6, 2.4, 2.9]}
    frame = DataFrame(data)
    frame2 = DataFrame(data, columns=['year', 'state', 'pop']) #指定列
    frame3 = DataFrame(data, columns=['year', 'state', 'pop']，
     index=['one', 'two', 'three', 'four', 'five']) #指定列和索引

b，列表生成

    >>> errors = [('c',1,'right'), ('b', 2,'wrong')]
    >>> df = pd.DataFrame(errors)
    >>> df
       0  1  2
    0  c  1  right
    1  b  2  wrong
    >>> df = pd.DataFrame(errors, columns=['name', 'count', 'result'])  #指定列名
    >>> df
      name  count result
    0c  1  right
    1b  2  wrong


c, 嵌套词典（也就是词典的词典）

    pop = {'Nevada':{2001:2.4, 2002:2.9},
       'Ohio':{2000:1.5, 2001:1.7, 2002:3.6}}
    frame4 = DataFrame(pop)
    Out[138]:
      Nevada  Ohio
    2000 NaN   1.5
    2001 2.4   1.7
    2002 2.9   3.6


d，Series组合

    #按行生成DataFrame
    
    In [4]: a = pd.Series([1,2,3]) 
    In [5]: b = pd.Series([2,3,4])
    In [6]: c = pd.DataFrame([a,b]) 
    In [7]: c
    Out[7]:
       0  1  2
    0  1  2  3
    1  2  3  4
    #按列生成DataFrame
    
    In [8]: c = pd.DataFrame({'a':a,'b':b})
    In [9]: c
    Out[9]:
       a  b
    0  1  2
    1  2  3
    2  3  4

**索引**  
DataFrame.head（[n]） 返回前n行  
DataFrame.at 基于快速标签的标量访问器  
DataFrame.iat 快速整数位置标量存取器。  
DataFrame.ix 主要是基于标签位置的索引器，具有整数位置后备。  
DataFrame.loc 纯标签位置索引器，用于按标签选择。  
DataFrame.iloc 纯粹基于整数位置的索引，用于按位置选择。  
DataFrame.insert（loc，column，value [，…] 在指定位置将列插入DataFrame。  
DataFrame.iter() 在信息轴上迭代  
DataFrame.iteritems() 迭代器结束（列名，系列）对。  
DataFrame.iterrows() 将DataFrame行重复为（索引，系列）对。  
DataFrame.itertuples（[index，name]） - 将DataFrame行迭代为namedtuples，索引值作为元组的第一个元素。  
DataFrame.lookup（row_labels，col_labels） DataFrame基于标签的“花式索引”功能。  
DataFrame.pop（item） 返回项目并从框架中删除。  
DataFrame.tail（[n]） 返回最后n行  
DataFrame.xs（键[，axis，level，drop_level]） 从Series / - DataFrame返回横截面（行或列）。  
DataFrame.isin（values） - 返回布尔值DataFrame，显示DataFrame中的每个元素是否包含在值中。  
DataFrame.where（cond [，other，inplace，…]） - 返回一个与self相同形状的对象，其对应的条目来自self，其中cond为True，否则为其他对象。  
DataFrame.mask（cond [，other，inplace，axis，…]） 返回一个与self相同形状的对象，并- 且其对应的条目来自self，其中cond是False，否则是来自其他。  
DataFrame.query（expr [，inplace]） 使用布尔表达式查询框架的列。 

**其他**  
参照上面的Series，差不多

**序列化**  
DataFrame.from_csv（path [，header，sep，…]） - 读取CSV文件（DISCOURAGED，请改用pandas.read_csv()）。  
DataFrame.from_dict（data [，orient，dtype]） - 从类array或dicts的dict构造DataFrame  
DataFrame.from_items（items [，columns，orient]） - 将（键，值）对转换为DataFrame。  
DataFrame.from_records（data [，index，…]） - 将结构化或记录ndarray转换为DataFrame  
DataFrame.info（[verbose，buf，max_cols，…]） DataFrame的简明摘要。  
DataFrame.to_pickle（path） Pickle（序列化）对象到输入文件路径。  
DataFrame.to_csv（[path_or_buf，sep，na_rep，…]） - 将DataFrame写入逗号分隔值（csv）文件  
DataFrame.to_hdf（path_or_buf，key，\ \ kwargs） - 使用HDFStore将包含的数据写入HDF5文件。  
DataFrame.to_sql（name，con [，flavor，…]） - 将存储在DataFrame中的记录写入SQL数据库。  
DataFrame.to_dict（[orient]） 将DataFrame转换成字典。  
DataFrame.to_excel（excel_writer [，…]） 将DataFrame写入excel表  
DataFrame.to_json（[path_or_buf，orient，…]） 将对象转换为JSON字符串。  
DataFrame.to_html（[buf，columns，col_space，…]） - 将DataFrame呈现为HTML表格。  
DataFrame.to_latex（[buf，columns，…]） 将DataFrame呈现为表格环境表。  
DataFrame.to_stata（fname [，convert_dates，…]） - 从数组类对象中写入Stata二进制dta文件的类  
DataFrame.to_msgpack（[path_or_buf，encoding]） - msgpack（serialize）对象到输入文件路径  
DataFrame.to_gbq（destination_table，project_id） 将DataFrame写入Google - BigQuery表格。  
DataFrame.to_records（[index，convert_datetime64]） - 将DataFrame转换为记录数组。  
DataFrame.to_sparse（[fill_value，kind]） 转换为SparseDataFrame  
DataFrame.to_dense() 返回NDFrame的密集表示（而不是稀疏）  
DataFrame.to_string（[buf，columns，…]） - 将DataFrame呈现为控制台友好的表格输出。  
DataFrame.to_clipboard（[excel，sep]） 


## **关键缩写和包导入** ##

在这个速查手册中，我们使用如下缩写：

- df：任意的Pandas DataFrame对象
- s：任意的Pandas Series对象

同时我们需要做如下的引入：


    import pandas as pd
    import numpy as np

## **导入数据**   ##

- pd.read_csv(filename)：从CSV文件导入数据
- pd.read_table(filename)：从限定分隔符的文本文件导入数据  
- pd.read_excel(filename)：从Excel文件导入数据
- pd.read_sql(query, connection_object)：从SQL表/库导入数据
- pd.read_json(json_string)：从JSON格式的字符串导入数据
- pd.read_html(url)：解析URL、字符串或者HTML文件，抽取其中的tables表格
- pd.read_clipboard()：从你的粘贴板获取内容，并传给read_table()
- pd.DataFrame(dict)：从字典对象导入数据，Key是列名，Value是数据



## **导出数据** ##

- df.to_csv(filename)：导出数据到CSV文件  
- df.to_excel(filename)：导出数据到Excel文件
- df.to_sql(table_name, connection_object)：导出数据到SQL表
- df.to_json(filename)：以Json格式导出数据到文本文件


## **创建测试对象** ##

pd.DataFrame(np.random.rand(20,5))：创建20行5列的随机数组成的DataFrame对象  
pd.Series(my_list)：从可迭代对象my_list创建一个Series对象  
df.index = pd.date_range('1900/1/30', periods=df.shape[0])：增加一个日期索引


## **查看、检查数据**   ##

- df.head(n)：查看DataFrame对象的前n行
- df.tail(n)：查看DataFrame对象的最后n行
- df.shape()：查看行数和列数
- http://df.info()：查看索引、数据类型和内存信息
- df.describe()：查看数值型列的汇总统计
- s.value_counts(dropna=False)：查看Series对象的唯一值和计数
- df.apply(pd.Series.value_counts)：查看DataFrame对象中每一列的唯一值和计数


## **数据选取** ##

- df[col]：根据列名，并以Series的形式返回列
- df[[col1, col2]]：以DataFrame形式返回多列
- s.iloc[0]：按位置选取数据
- s.loc['index_one']：按索引选取数据
- df.iloc[0,:]：返回第一行
- df.iloc[0,0]：返回第一列的第一个元素


## **设置值** ##
**根据位置设置**

**loc 和 iloc**

    df.iloc[2,2] = 1111
    df.loc['20130101','B'] = 2222

    # this is also equivalent to ``df1.at['a','A']``
    In [55]: df1.loc['a', 'A']
    # this is also equivalent to ``df1.iat[1,1]``
    In [73]: df1.iloc[1, 1]

**根据条件设置**

如果现在的判断条件是这样, 我们想要更改B中的数, 而更改的位置是取决于 A 的. 对于A大于4的位置. 更改B在相应位置上的数为0.

    df.B[df.A>4] = 0

**按行或列设置 **  

如果对整列做批处理, 加上一列 ‘F’, 并将 F 列全改为 NaN, 如下:

df['F'] = np.nan

## **添加数据 ** ##
用上面的方法也可以加上 Series 序列（但是长度必须对齐）。

df['E'] = pd.Series([1,2,3,4,5,6], index=pd.date_range('20130101',periods=6)) 

## **数据清理** ##

- df.columns = ['a','b','c']：重命名列名
- pd.isnull()：检查DataFrame对象中的空值，并返回一个Boolean数组
- pd.notnull()：检查DataFrame对象中的非空值，并返回一个Boolean数组
- df.dropna()：删除所有包含空值的行
- df.dropna(axis=1)：删除所有包含空值的列
- df.dropna(axis=1,thresh=n)：删除所有小于n个非空值的行
- df.fillna(x)：用x替换DataFrame对象中所有的空值
- s.astype(float)：将Series中的数据类型更改为float类型
- s.replace(1,'one')：用‘one’代替所有等于1的值
- s.replace([1,3],['one','three'])：用'one'代替1，用'three'代替3
- df.rename(columns=lambda x: x + 1)：批量更改列名
- df.rename(columns={'old_name': 'new_ name'})：选择性更改列名
- df.set_index('column_one')：更改索引列
- df.rename(index=lambda x: x + 1)：批量重命名索引
- 这里我们将数据的第3列重命名为“size”：  
df.rename(columns = {df.columns[2]:'size'}, inplace=True)


## **数据处理：Filter、Sort和GroupBy** ##

- df[df[col] > 0.5]：选择col列的值大于0.5的行
- df.sort_values(col1)：按照列col1排序数据，默认升序排列
- df.sort_values(col2, ascending=False)：按照列col1降序排列数据
- df.sort_values([col1,col2], ascending=[True,False])：先按列col1升序排列，后按col2降序排列数据
- df.groupby(col)：返回一个按列col进行分组的Groupby对象
- df.groupby([col1,col2])：返回一个按多列进行分组的Groupby对象
- df.groupby(col1)[col2]：返回按列col1进行分组后，列col2的均值
- df.pivot_table(index=col1, values=[col2,col3], aggfunc=max)：创建一个按列col1进行分组，并计算col2和col3的最大值的数据透视表
- df.groupby(col1).agg(np.mean)：返回按列col1分组的所有列的均值
- data.apply(np.mean)：对DataFrame中的每一列应用函数np.mean
- data.apply(np.max,axis=1)：对DataFrame中的每一行应用函数np.max
- 删除缺失的数据：  
df.dropna(axis=0, how='any')：返回给定轴上标签的对象，逐个丢掉相应数据。

- 替换丢失的数据：  
df.replace(to_replace=None, value=None)
用“value”的值替换“to_replace”中给出的值。

- 检查 NAN  
pd.isnull(object)
检测缺失值（有数值数组中的NaN，对象数组中的None和NaN）

- 删除特征  
df.drop('feature_variable_name', axis=1)
轴为 0 代表行，1 代表列

- 将对象类型转换为 float：  
pd.to_numeric(df["feature_name"], errors='coerce')
将对象类型转换为数字型以便计算（如果它们是字符串的话）

- 将数据转换为 Numpy 数组：  
df.as_matrix()

- 获取数据的头“n”行：  
df.head(n)

- 按特征名称获取数据  
df.loc[feature_name] 

- 将函数应用于数据  
这个函数将数据里“height”一列中的所有值乘以2

`
	
	df["height"].apply(*lambda* height: 2 * height)

	或：
	
	def multiply(x):
	
	 return x * 2
	
	df["height"].apply(multiply)`

- 单独提取某一列  
df["name"].unique()

- 访问子数据  
我们从数据中选择“name”和“size”两列  
new_df = df[["name", "size"]]

- 布尔索引  
这里我们过滤“size”的数据列，以显示等于5的值：  
df[df["size"] == 5]

- 选择某值  
选择“size”列的第一行：  
df.loc([0], ['size'])

## **数据合并** ##

- df1.append(df2)：将df2中的行添加到df1的尾部
- df.concat([df1, df2],axis=1)：将df2中的列添加到df1的尾部，axis 合并方向，axis=0是预设值，因此未设定任何参数时，函数默认axis=0。
- df1.join(df2,on=col1,how='inner')：对df1的列和df2的列执行SQL形式的join
- ignore_index (重置 index) 
- join='outer'为预设值，因此未设定任何参数时，函数默认join='outer'。此方式是依照column来做纵向合并，有相同的column上下合并在一起，其他独自的column个自成列，原本没有值的位置皆以NaN填充。

## **数据统计** ##

- df.describe()：查看数据值列的汇总统计
- df.mean()：返回所有列的均值
- df.corr()：返回列与列之间的相关系数
- df.count()：返回每一列中的非空值的个数
- df.max()：返回每一列的最大值
- df.min()：返回每一列的最小值
- df.median()：返回每一列的中位数
- df.std()：返回每一列的标准差
- d1.idxmin() #最小值的位置，类似于R中的which.min函数
- d1.idxmax() #最大值的位置，类似于R中的which.max函数
- d1.quantile(0.1) #10%分位数
- d1.sum() #求和
- d1.mode() #众数
- d1.var() #方差
- d1.mad() #平均绝对偏差
- d1.skew() #偏度
- d1.kurt() #峰度

## 出图 ##

    import pandas as pd
    import numpy as np
    import matplotlib.pyplot as plt
    # 随机生成1000个数据
    data = pd.Series(np.random.randn(1000),index=np.arange(1000))
     
    # 为了方便观看效果, 我们累加这个数据
    data.cumsum()
    
    # pandas 数据可以直接观看其可视化形式
    data.plot()
    
    plt.show()

(6) 以表格形式打印数据

print(tabulate(print_table, headers=headers))
其中“print_table”是一列list，“headers”是一列字符串抬头

**数据进行遍历**


	import numpy as np
	import pandas as pd
	
	def _map(data, exp):                  
	    for index, row in data.iterrows():   # 获取每行的index、row
	        for col_name in data.columns:
	            row[col_name] = exp(row[col_name]) # 把结果返回给data
	    return data
	
	def _1map(data, exp):
	    _data = [[exp(row[col_name])               # 把结果转换成2级list
	             for col_name in data.columns]
	             for index, row in data.iterrows()
	            ]
	    return _data
	
	
	if __name__ == "__main__":
	    inp = [{'c1':10, 'c2':100}, {'c1':11,'c2':110}, {'c1':12,'c2':120}]
	    df = pd.DataFrame(inp)
	    temp = _map(df, lambda ele: ele+1 )
	    print temp
	
	    _temp = _1map(df, lambda ele: ele+1)
	    res_data = pd.DataFrame(_temp)         # 对2级list转换成DataFrame
	    print res_data


**ValueError: The truth value of a Series is ambiguous. Use a.empty, a.bool(), a.item(), a.any()**

a.empty    if(a.empty):print("!!")    判断a是否为空

a.item()     没有用过，应该a.item(i)  表示第i个节点

a.any()       if(a.any() in [1,2,3,4]):print("!!")    判断 a中的任意一个值是否在[1,2,3,4]中

a.all()         if(a.all() in [1,2,3,4]):print("!!")    判断 a中的所有值是否在[1,2,3,4]中`

**pandas.read_csv参数整理**
 
读取CSV（逗号分割）文件到DataFrame  
也支持文件的部分导入和选择迭代  
更多帮助参见：http://pandas.pydata.org/pandas-docs/stable/io.html  
参数：
filepath_or_buffer : str，pathlib。str, pathlib.Path, py._path.local.LocalPath or any object with a read() method (such as a file handle or StringIO)
可以是URL，可用URL类型包括：http, ftp, s3和文件。对于多文件正在准备中
本地文件读取实例：://localhost/path/to/table.csv
 
sep : str, default ‘,’  
指定分隔符。如果不指定参数，则会尝试使用逗号分隔。分隔符长于一个字符并且不是‘\s+’,将使用python的语法分析器。并且忽略数据中的逗号。正则表达式例子：'\r\t'
 
delimiter : str, default None  
定界符，备选分隔符（如果指定该参数，则sep参数失效）
 
delim_whitespace : boolean, default False.  
指定空格(例如’ ‘或者’ ‘)是否作为分隔符使用，等效于设定sep='\s+'。如果这个参数设定为Ture那么delimiter 参数失效。
在新版本0.18.1支持
 
header : int or list of ints, default ‘infer’  
指定行数用来作为列名，数据开始行数。如果文件中没有列名，则默认为0，否则设置为None。如果明确设定header=0 就会替换掉原来存在列名。header参数可以是一个list例如：[0,1,3]，这个list表示将文件中的这些行作为列标题（意味着每一列有多个标题），介于中间的行将被忽略掉（例如本例中的2；本例中的数据1,2,4行将被作为多级标题出现，第3行数据将被丢弃，dataframe的数据从第5行开始。）。
注意：如果skip_blank_lines=True 那么header参数忽略注释行和空行，所以header=0表示第一行数据而不是文件的第一行。
 
names : array-like, default None  
用于结果的列名列表，如果数据文件中没有列标题行，就需要执行header=None。默认列表中不能出现重复，除非设定参数mangle_dupe_cols=True。
 
index_col : int or sequence or False, default None  
用作行索引的列编号或者列名，如果给定一个序列则有多个行索引。
如果文件不规则，行尾有分隔符，则可以设定index_col=False 来是的pandas不适用第一列作为行索引。
 
usecols : array-like, default None  
返回一个数据子集，该列表中的值必须可以对应到文件中的位置（数字可以对应到指定的列）或者是字符传为文件中的列名。例如：usecols有效参数可能是 [0,1,2]或者是 [‘foo’, ‘bar’, ‘baz’]。使用这个参数可以加快加载速度并降低内存消耗。
 
as_recarray : boolean, default False  
不赞成使用：该参数会在未来版本移除。请使用pd.read_csv(...).to_records()替代。
返回一个Numpy的recarray来替代DataFrame。如果该参数设定为True。将会优先squeeze参数使用。并且行索引将不再可用，索引列也将被忽略。
 
squeeze : boolean, default False  
如果文件值包含一列，则返回一个Series
 
prefix : str, default None  
在没有列标题时，给列添加前缀。例如：添加‘X’ 成为 X0, X1, ...
 
mangle_dupe_cols : boolean, default True  
重复的列，将‘X’...’X’表示为‘X.0’...’X.N’。如果设定为false则会将所有重名列覆盖。
 
dtype : Type name or dict of column -> type, default None  
每列数据的数据类型。例如 {‘a’: np.float64, ‘b’: np.int32}
 
engine : {‘c’, ‘python’}, optional  
Parser engine to use. The C engine is faster while the python engine is currently more feature-complete.
使用的分析引擎。可以选择C或者是python。C引擎快但是Python引擎功能更加完备。
 
converters : dict, default None  
列转换函数的字典。key可以是列名或者列的序号。
 
true_values : list, default None  
Values to consider as True
 
false_values : list, default None  
Values to consider as False
 
skipinitialspace : boolean, default False  
忽略分隔符后的空白（默认为False，即不忽略）.
 
skiprows : list-like or integer, default None  
需要忽略的行数（从文件开始处算起），或需要跳过的行号列表（从0开始）。
 
skipfooter : int, default 0  
从文件尾部开始忽略。 (c引擎不支持)
 
skip_footer : int, default 0  
不推荐使用：建议使用skipfooter ，功能一样。
 
nrows : int, default None  
需要读取的行数（从文件头开始算起）。
 
na_values : scalar, str, list-like, or dict, default None  
一组用于替换NA/NaN的值。如果传参，需要制定特定列的空值。默认为‘1.#IND’, ‘1.#QNAN’, ‘N/A’, ‘NA’, ‘NULL’, ‘NaN’, ‘nan’`.
 
keep_default_na : bool, default True  
如果指定na_values参数，并且keep_default_na=False，那么默认的NaN将被覆盖，否则添加。
 
na_filter : boolean, default True  
是否检查丢失值（空字符串或者是空值）。对于大文件来说数据集中没有空值，设定na_filter=False可以提升读取速度。
 
verbose : boolean, default False  
是否打印各种解析器的输出信息，例如：“非数值列中缺失值的数量”等。
 
skip_blank_lines : boolean, default True  
如果为True，则跳过空行；否则记为NaN。
 
parse_dates : boolean or list of ints or names or list of lists or dict, default False  
boolean. True -> 解析索引
list of ints or names. e.g. If [1, 2, 3] -> 解析1,2,3列的值作为独立的日期列；
list of lists. e.g. If [[1, 3]] -> 合并1,3列作为一个日期列使用
dict, e.g. {‘foo’ : [1, 3]} -> 将1,3列合并，并给合并后的列起名为"foo"
 
infer_datetime_format : boolean, default False  
如果设定为True并且parse_dates 可用，那么pandas将尝试转换为日期类型，如果可以转换，转换方法并解析。在某些情况下会快5~10倍。
 
keep_date_col : boolean, default False  
如果连接多列解析日期，则保持参与连接的列。默认为False。
 
date_parser : function, default None  
用于解析日期的函数，默认使用dateutil.parser.parser来做转换。Pandas尝试使用三种不同的方式解析，如果遇到问题则使用下一种方式。
1.使用一个或者多个arrays（由parse_dates指定）作为参数；
2.连接指定多列字符串作为一个列作为参数；
3.每行调用一次date_parser函数来解析一个或者多个字符串（由parse_dates指定）作为参数。
 
dayfirst : boolean, default False  
DD/MM格式的日期类型
 
iterator : boolean, default False  
返回一个TextFileReader 对象，以便逐块处理文件。
 
chunksize : int, default None  
文件块的大小， See IO Tools docs for more informationon iterator and chunksize.
 
compression : {‘infer’, ‘gzip’, ‘bz2’, ‘zip’, ‘xz’, None}, default ‘infer’  
直接使用磁盘上的压缩文件。如果使用infer参数，则使用 gzip, bz2, zip或者解压文件名中以‘.gz’, ‘.bz2’, ‘.zip’, or ‘xz’这些为后缀的文件，否则不解压。如果使用zip，那么ZIP包中国必须只包含一个文件。设置为None则不解压。
新版本0.18.1版本支持zip和xz解压
 
thousands : str, default None  
千分位分割符，如“，”或者“."
 
decimal : str, default ‘.’  
字符中的小数点 (例如：欧洲数据使用’，‘).
 
float_precision : string, default None  
Specifies which converter the C engine should use for floating-point values. The options are None for the ordinary converter, high for the high-precision converter, and round_trip for the round-trip converter.
指定
 
lineterminator : str (length 1), default None  
行分割符，只在C解析器下使用。
 
quotechar : str (length 1), optional  
引号，用作标识开始和解释的字符，引号内的分割符将被忽略。
 
quoting : int or csv.QUOTE_* instance, default 0  
控制csv中的引号常量。可选 QUOTE_MINIMAL (0), QUOTE_ALL (1), QUOTE_NONNUMERIC (2) or QUOTE_NONE (3)
 
doublequote : boolean, default True  
双引号，当单引号已经被定义，并且quoting 参数不是QUOTE_NONE的时候，使用双引号表示引号内的元素作为一个元素使用。
 
escapechar : str (length 1), default None  
当quoting 为QUOTE_NONE时，指定一个字符使的不受分隔符限值。
 
comment : str, default None  
标识着多余的行不被解析。如果该字符出现在行首，这一行将被全部忽略。这个参数只能是一个字符，空行（就像skip_blank_lines=True）注释行被header和skiprows忽略一样。例如如果指定comment='#' 解析‘#empty\na,b,c\n1,2,3’ 以header=0 那么返回结果将是以’a,b,c'作为header。
 
encoding : str, default None  
指定字符集类型，通常指定为'utf-8'. List of Python standard encodings
 
dialect : str or csv.Dialect instance, default None  
如果没有指定特定的语言，如果sep大于一个字符则忽略。具体查看csv.Dialect 文档
 
tupleize_cols : boolean, default False  
Leave a list of tuples on columns as is (default is to convert to a Multi Index on the columns)
 
error_bad_lines : boolean, default True  
如果一行包含太多的列，那么默认不会返回DataFrame ，如果设置成false，那么会将改行剔除（只能在C解析器下使用）。
 
warn_bad_lines : boolean, default True  
如果error_bad_lines =False，并且warn_bad_lines =True 那么所有的“bad lines”将会被输出（只能在C解析器下使用）。
 
low_memory : boolean, default True  
分块加载到内存，再低内存消耗中解析。但是可能出现类型混淆。确保类型不被混淆需要设置为False。或者使用dtype 参数指定类型。注意使用chunksize 或者iterator 参数分块读入会将整个文件读入到一个Dataframe，而忽略类型（只能在C解析器中有效）
 
buffer_lines : int, default None  
不推荐使用，这个参数将会在未来版本移除，因为他的值在解析器中不推荐使用
 
compact_ints : boolean, default False  
不推荐使用，这个参数将会在未来版本移除
如果设置compact_ints=True ，那么任何有整数类型构成的列将被按照最小的整数类型存储，是否有符号将取决于use_unsigned 参数
 
use_unsigned : boolean, default False  
不推荐使用：这个参数将会在未来版本移除
如果整数列被压缩(i.e. compact_ints=True)，指定被压缩的列是有符号还是无符号的。
memory_map : boolean, default False  
如果使用的文件在内存内，那么直接map文件使用。使用这种方式可以避免文件再次进行IO操作。

    