# ForwardWidgets

<p align="center">
  <img src="https://i.miji.bid/2025/05/08/a7472460007b57687f659b8727f52755.md.jpeg" alt="欢迎使用我的五折码" width="300px"/>
  <br>
  五折码：CHEAP.5
  <br>
  七折码：CHEAP
</p>

### 一、豆瓣我看&豆瓣个性化推荐

<img src="https://i.miji.bid/2025/05/05/ee9c89a97e226fa0cebaae2990b13836.jpeg" style="width:200px" /><img src="https://i.miji.bid/2025/05/05/d1b4ddc054156a87ccd1a4bff8197b53.jpeg" style="width:200px" /><img src="https://i.miji.bid/2025/05/05/ffee8bded4b121831d1b8da95c047bb9.jpeg" style="width:200px" /><img src="https://i.miji.bid/2025/05/05/ad56685688d7cd354b6cfcbed97b3e09.jpeg" style="width:200px" />

其中用户ID和Cookie必填

#### 用户ID获取
<img src="https://i.miji.bid/2025/05/05/de6358e6a8cca3e890f51e5f385e5aaa.png" alt="de6358e6a8cca3e890f51e5f385e5aaa.png" border="0" />
我的豆瓣标签页中有显示用户ID

#### Cookie获取
最好用iPhone网页登陆豆瓣，然后用Loon或者Qx等工具抓包获取Cookie（不清楚Cookie多久失效，所以可能过一段时间需要重新获取填一次）

#### 增加豆瓣片单(TMDB版)
因为type为douban类型的items里依赖豆瓣数据里包含imdb_id，但很多综艺没有设置imdb_id，导致综艺片单识别到的只有个别，所以加了直接查询tmdb的版本

豆瓣的综艺title一般都包含第x季字样，所以用replace做了删除操作

修复下一页

增加doulist支持，并新增下拉选项片单[IMDB MOVIE TOP 250]/[IMDB TV TOP 250]/[意外结局电影]

#### 增加电影推荐(TMDB版)/剧集推荐(TMDB版)
（说明：由于用title查询TMDB，所以不一定能准确匹配正确影片）

#### 增加观影偏好(TMDB版)
又名`找电影/找电视`

应网友要求进行搬迁，详情请看issue：https://github.com/huangxd-/ForwardWidgets/issues/6

#### 新增豆瓣随机想看
从想看列表中无序抽取9个影片（如果想看列表很长，每次打开想看总是刚添加的几个影片显示在前面，增加随机机制，让用户每次从9个想看的影片中挑选一部进行观看）

#### 新增豆瓣影人作品
输入：演员姓名，可筛选，也可自定义，其中筛选类型以下几种，分别列举了50位
```shell
{ title: "国内男演员", value: "cn_actor" },
{ title: "国内女演员", value: "cn_actress" },
{ title: "港台男演员", value: "ht_actor" },
{ title: "港台女演员", value: "ht_actress" },
{ title: "日韩男演员", value: "jk_actor" },
{ title: "日韩女演员", value: "jk_actress" },
{ title: "欧美男演员", value: "ea_actor" },
{ title: "欧美女演员", value: "ea_actress" },
{ title: "国内导演", value: "cn_director" },
{ title: "国外导演", value: "fr_director" },
```
输出：所有该影人的作品
排序：评价/时间

### 二、Trakt我看&Trakt个性化推荐

```shell
几点说明：
1. trakt.js之所以不用官方trakt api，是因为尝试后发现目前生成的token 24小时之后会过期，如果要继续使用，需用上一次返回的refresh_token重新生成，当前插件也没有好的保存方式
2. trakt看过里是包含看了一半的电视的，也就是说正在看的电视也会出现在 看过-电视 里
3. 尝试后发现当前ForwardWidget插件的数据模型里如果type是tmdb，貌似有数据会被缓存覆盖的问题，douban和imdb类型不存在该问题
```

<img src="https://i.miji.bid/2025/05/08/e7bae366ee0d96b8e4cd0fa809ef8d52.md.png" style="width:200px" /><img src="https://i.miji.bid/2025/05/08/63d7160f9ced06ff18de3be8723b884e.md.png" style="width:200px" />

其中用户名和Cookie必填

#### 用户名获取
在网页上登录你的Trakt，查看url如下 https://trakt.tv/users/xxxx/watchlist ，其中users后面跟的就是你的用户名，填了用户名后还是获取不到数据的请在Trakt设置里打开隐私开关

#### Cookie获取
最好用iPhone网页登陆Trakt，然后用Loon或者Qx等工具抓包获取Cookie（不清楚Cookie多久失效，所以可能过一段时间需要重新获取填一次），一般找_traktsession=xxxx长这样的Cookie

#### 新增Trakt随机想看
从想看列表中无序抽取9个影片（如果想看列表很长，每次打开想看总是刚添加的几个影片显示在前面，增加随机机制，让用户每次从9个想看的影片中挑选一部进行观看）

### 三、Trakt片单&Trakt追剧日历
`说明：追剧日历只是尝鲜版，j佬到时候应该会在APP内嵌追剧功能 :)`

<img src="https://i.miji.bid/2025/05/12/d88147b5a3764acc1037a16ac736835b.png" style="width:200px" /><img src="https://i.miji.bid/2025/05/12/a918ef099ae6b3c0babb6ce2b6eb071d.png" style="width:200px" />

其中用户名/片单列表名/Cookie同上，另外追剧日历中新增参数开始日期/天数/排序方式

> 片单示例 
https://trakt.tv/users/giladg/lists/latest-4k-releases?sort=added,asc

```shell
用户名：giladg
片单列表名：latest-4k-releases
```

#### 排序依据
```shell
rank：排名算法
added：添加时间
title：标题
released：发布日期
runtime：内容时长
popularity：流行度
random：随机
```

#### 排序方向
asc：正序 or desc：反序

> Trakt追剧日历会将个人watched, collected, or watchlisted中的节目在日历中呈现，具体可查看 https://trakt.tv/calendars/my/shows-movies

#### 开始日期
填数字，0表示今天，-1表示昨天，1表示明天，插件内会自动转换成相应日期

#### 天数
填数字，表示从开始日期的n天内的时间区间，最大值33天

#### 排序方式
如有时间区间[2025-05-01, 2025-05-07]

日期升序：返回 从 2025-05-01 -> 2025-05-07 的节目信息

日期降序：返回 从 2025-05-07 -> 2025-05-01 的节目信息

### 四、豆瓣想看/已看数据迁移Trakt脚本

#### 使用教程
`说明：可能有部分会迁移失败`
1. 先将`douban2trakt.py`脚本中的几个必填参数填上
```shell
# 豆瓣用户ID
DOUBAN_USER_ID = ""
# TRAKT API APPS的Client ID，请前往 https://trakt.tv/oauth/applications/new 创建
TRAKT_CLIENT_ID = ""
# TRAKT抓包获取的x-csrf-token，需有增删改操作的接口才有
TRAKT_X_CSRF_TOKEN = ""
# TRAKT抓包获取的cookie
TRAKT_COOKIE = ""
```
2. 执行脚本
```shell
# 迁移想看列表
python douban2trakt.py --type watchlist
# 迁移已看列表和打分，因为豆瓣是5分制，Trakt是10分制，所以会做乘以2操作后打分
python douban2trakt.py --type watched
```

### 五、直播（电视+网络）
`只能说是尝鲜版，有挺多问题的，看j佬有没有时间优化下 :)`
```shell
没有统一ping，不知道哪些会超时，也没预览
没有分类显示的地方
小组件已经添加的情况下，没有搜索入口
#有些源播放会闪退，不知道是什么原因，可能是缓冲太大？#
#插件有缓存，如果不清缓存，会老是打开同一个时间点#
```
当前支持直播源内没有自带台标的情况下引用台名对应台标

<img src="https://i.miji.bid/2025/05/17/31b417b1edf82192b1edaa752aa18504.jpeg" style="width:200px" /><img src="https://i.miji.bid/2025/05/17/9685eb351a2c5892b647dbd9c33532f5.jpeg" style="width:200px" /><img src="https://i.miji.bid/2025/05/17/fe4ed1f17a9fb5e2b3808b4f6a0c7ae2.jpeg" style="width:600px" /><img src="https://i.miji.bid/2025/05/17/bc5bbe2a8efa99eba6ca0c72e4681a79.jpeg" style="width:600px" />

#### 订阅链接
内嵌了几个公开源，也可以自定义

新增PlutoTV源
```shell
PlutoTV-阿根廷 (Argentina)
PlutoTV-巴西 (Brazil)
PlutoTV-加拿大 (Canada)
PlutoTV-智利 (Chile)
PlutoTV-德国 (Germany)
PlutoTV-西班牙 (Spain)
PlutoTV-法国 (France)
PlutoTV-英国 (Great Britain)
PlutoTV-意大利 (Italy)
PlutoTV-墨西哥 (Mexico)
PlutoTV-美国 (United States)
```

#### 按组关键字过滤
一个订阅链接可能有上百上千个频道，可以按组名关键字筛选，至于有哪些组，需要自己打开订阅链接看下

增加了正则过滤，如`.*(央视|卫视).*`

#### 按频道名关键字过滤
一个订阅链接可能有上百上千个频道，可以按频道名称关键字筛选，至于有哪些频道，需要自己打开订阅链接看下

增加了正则过滤，如`.*(B站|虎牙|斗鱼).*`

### 六、雅图(每日放送+点播排行榜+评分排行榜)
<img src="https://i.miji.bid/2025/05/18/6c97648fe9aed6398c76c56b28bdd3e5.jpeg" style="width:200px" />

#### 每日放送
`说明：最新的数据只到今天以及前面m天的数据，可以参考官网 http://www.yatu.tv:2082/zuijin.asp `
```shell
类型：动漫/电影/电视剧
开始日期：n天前，0表示今天，-1表示昨天，以此类推
天数：从开始日期开始的后面m天的数据
```

#### 点播排行榜
```shell
类型：连载动漫/剧场动漫/电影/香港电影/欧美电影/电视剧/美剧/综艺
时间：今日/本月/历史
```

#### 评分排行榜
```shell
类型：动漫/电影/电视剧
等级：非常好看/好看/一般/烂片
```

### 七、追剧日历(今/明日播出、各项榜单、今日推荐)
<img src="https://i.miji.bid/2025/05/30/be043310fe0e0beefd21a9b92535a4fe.jpeg" style="width:200px" /><img src="https://i.miji.bid/2025/05/30/961b5c41d77f208ce2556738bc84e60d.jpeg" style="width:200px" /><img src="https://i.miji.bid/2025/05/30/7cd063207fad2ff2f873fcd007c5083e.jpeg" style="width:200px" /><img src="https://i.miji.bid/2025/05/30/923ddad8c2e563f09a406b59635056a7.jpeg" style="width:200px" />

#### 今/明日播出
```shell
类型：今日播出剧集/今日播出番剧/今日播出国漫/今日播出综艺/明日播出剧集/明日播出番剧/明日播出国漫/明日播出综艺
```

#### 播出周历
```shell
类型：剧集/番剧/国漫/综艺
周几：全部/周一/周二/周三/周四/周五/周六/周日
```

#### 各项榜单
```shell
类型：现正热播/人气 Top 10/新剧雷达/热门国漫/已收官好剧/华语热门/本季新番
地区：国产剧/日剧/英美剧/番剧/韩剧/港台剧
```

#### 今日推荐

### 各插件刷新时间列表
```shell
【豆瓣】
豆瓣我看：1小时
豆瓣个性化推荐：12小时
豆瓣片单(TMDB版)：12小时
电影推荐(TMDB版)：24小时
剧集推荐(TMDB版)：24小时
观影偏好(TMDB版)：24小时
豆瓣影人作品：1周

【trakt】
trakt我看：1小时
trakt个性化推荐：12小时
trakt片单：24小时
trakt追剧日历：12小时

【直播(电视+网络)】
订阅链接：6小时
详情页：60秒

【雅图(每日放送+点播排行榜+评分排行榜)】
每日放送：6小时
点播排行榜：6小时
评分排行榜：24小时

【追剧日历(今/明日播出、周历、各项榜单、今日推荐)】
今日播出：6小时
明日播出：6小时
播出周历：6小时
今日推荐：12小时
各项榜单：24小时
地区榜单：24小时
```

### Forward图标库自助上传
请跳转项目：[PicStoreJson](https://github.com/huangxd-/PicStoreJson)

### 📈项目 Star 数增长趋势
#### Star History
[![Star History Chart](https://api.star-history.com/svg?repos=huangxd-/ForwardWidgets&type=Date)](https://www.star-history.com/#huangxd-/ForwardWidgets&Date)
