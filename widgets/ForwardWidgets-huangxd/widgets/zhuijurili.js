// 追剧日历组件
WidgetMetadata = {
    id: "zhuijurili",
    title: "追剧日历(今/明日播出、周历、各项榜单、今日推荐)",
    modules: [
        {
            id: "todayPlay",
            title: "今日播出",
            requiresWebView: false,
            functionName: "loadTmdbItems",
            cacheDuration: 21600,
            params: [
                {
                    name: "sort_by",
                    title: "类型",
                    type: "enumeration",
                    value: "今天播出的剧集",
                    enumOptions: [
                        {
                            title: "剧集",
                            value: "今天播出的剧集",
                        },
                        {
                            title: "番剧",
                            value: "今天播出的番剧",
                        },
                        {
                            title: "国漫",
                            value: "今天播出的国漫",
                        },
                        {
                            title: "综艺",
                            value: "今天播出的综艺",
                        },
                    ],
                },
            ],
        },
        {
            id: "tomorrowPlay",
            title: "明日播出",
            requiresWebView: false,
            functionName: "loadTmdbItems",
            cacheDuration: 21600,
            params: [
                {
                    name: "sort_by",
                    title: "类型",
                    type: "enumeration",
                    value: "明天播出的剧集",
                    enumOptions: [
                        {
                            title: "剧集",
                            value: "明天播出的剧集",
                        },
                        {
                            title: "番剧",
                            value: "明天播出的番剧",
                        },
                        {
                            title: "国漫",
                            value: "明天播出的国漫",
                        },
                        {
                            title: "综艺",
                            value: "明天播出的综艺",
                        },
                    ],
                },
            ],
        },
        {
            id: "weekPlay",
            title: "播出周历",
            requiresWebView: false,
            functionName: "loadWeekTmdbItems",
            cacheDuration: 21600,
            params: [
                {
                    name: "sort_by",
                    title: "类型",
                    type: "enumeration",
                    value: "juji_week.json",
                    enumOptions: [
                        {
                            title: "剧集",
                            value: "juji_week.json",
                        },
                        {
                            title: "番剧",
                            value: "fanju_week.json",
                        },
                        {
                            title: "国漫",
                            value: "guoman_week.json",
                        },
                        {
                            title: "综艺",
                            value: "zongyi_week.json",
                        },
                    ],
                },
                {
                    name: "weekday",
                    title: "周几",
                    type: "enumeration",
                    value: "All",
                    belongTo: {
                        paramName: "sort_by",
                        value: ["juji_week.json", "fanju_week.json", "guoman_week.json", "zongyi_week.json"],
                    },
                    enumOptions: [
                        {
                            title: "全部",
                            value: "All",
                        },
                        {
                            title: "周一",
                            value: "Monday",
                        },
                        {
                            title: "周二",
                            value: "Tuesday",
                        },
                        {
                            title: "周三",
                            value: "Wednesday",
                        },
                        {
                            title: "周四",
                            value: "Thursday",
                        },
                        {
                            title: "周五",
                            value: "Friday",
                        },
                        {
                            title: "周六",
                            value: "Saturday",
                        },
                        {
                            title: "周日",
                            value: "Sunday",
                        },
                    ],
                },
            ],
        },
        {
            id: "todayReCommand",
            title: "今日推荐",
            requiresWebView: false,
            functionName: "loadTmdbItems",
            cacheDuration: 43200,
            params: [
                {
                    name: "sort_by",
                    title: "类型",
                    type: "constant",
                    value: "今日推荐",
                },
            ],
        },
        {
            id: "rank",
            title: "各项榜单",
            requiresWebView: false,
            functionName: "loadTmdbItems",
            cacheDuration: 86400,
            params: [
                {
                    name: "sort_by",
                    title: "类型",
                    type: "enumeration",
                    value: "现正热播",
                    enumOptions: [
                        {
                            title: "现正热播",
                            value: "现正热播",
                        },
                        {
                            title: "人气 Top 10",
                            value: "人气 Top 10",
                        },
                        {
                            title: "新剧雷达",
                            value: "新剧雷达",
                        },
                        {
                            title: "热门国漫",
                            value: "热门国漫",
                        },
                        {
                            title: "已收官好剧",
                            value: "已收官好剧",
                        },
                        {
                            title: "华语热门",
                            value: "华语热门",
                        },
                        {
                            title: "本季新番",
                            value: "本季新番",
                        },
                    ],
                },
            ],
        },
        {
            id: "area",
            title: "地区榜单",
            requiresWebView: false,
            functionName: "loadTmdbItems",
            cacheDuration: 86400,
            params: [
                {
                    name: "sort_by",
                    title: "地区",
                    type: "enumeration",
                    value: "国产剧",
                    enumOptions: [
                        {
                            title: "国产剧",
                            value: "国产剧",
                        },
                        {
                            title: "日剧",
                            value: "日剧",
                        },
                        {
                            title: "英美剧",
                            value: "英美剧",
                        },
                        {
                            title: "番剧",
                            value: "番剧",
                        },
                        {
                            title: "韩剧",
                            value: "韩剧",
                        },
                        {
                            title: "港台剧",
                            value: "港台剧",
                        },
                    ],
                },
            ],
        },
    ],
    version: "1.0.4",
    requiredVersion: "0.0.1",
    description: "解析追剧日历今/明日播出剧集/番剧/国漫/综艺、周历、各项榜单、今日推荐等【五折码：CHEAP.5;七折码：CHEAP】",
    author: "huangxd",
    site: "https://github.com/huangxd-/ForwardWidgets"
};

const API_SUFFIXES = {
    home1: [
        "今天播出的剧集", "今天播出的番剧",
        "明天播出的剧集", "明天播出的番剧",
        "现正热播", "人气 Top 10", "新剧雷达",
        "热门国漫", "已收官好剧"
    ],
    home0: [
        "华语热门", "本季新番", "今日推荐",
        "国产剧", "日剧", "英美剧", "番剧", "韩剧", "港台剧"
    ]
};

const areaTypes = ["国产剧", "日剧", "英美剧", "番剧", "韩剧", "港台剧"];

// 生成反向映射，便于快速查找
const suffixMap = {};
Object.entries(API_SUFFIXES).forEach(([suffix, values]) => {
    values.forEach(value => suffixMap[value] = suffix);
});

// 基础获取TMDB数据方法
async function fetchTmdbData(id, mediaType) {
    const tmdbResult = await Widget.tmdb.get(`/${mediaType}/${id}`, {
        headers: {
            "User-Agent":
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
        },
    });
    //打印结果
    // console.log("搜索内容：" + key)
    if (!tmdbResult) {
        console.log("搜索内容失败：", `/${mediaType}/${id}`);
        return null;
    }
    console.log("tmdbResults:" + JSON.stringify(tmdbResult, null, 2));
    // console.log("tmdbResults.total_results:" + tmdbResults.total_results);
    // console.log("tmdbResults.results[0]:" + tmdbResults.results[0]);
    return tmdbResult;
}

async function fetchImdbItems(scItems) {
    const promises = scItems.map(async (scItem) => {
        // 模拟API请求
        if (!scItem || (!scItem.id && !scItem.tmdb_id)) {
            return null;
        }

        const mediaType = scItem.hasOwnProperty('isMovie') ? (scItem.isMovie ? 'movie' : 'tv') : 'tv';

        const tmdbData = await fetchTmdbData(scItem.id ?? scItem.tmdb_id, mediaType);

        if (tmdbData) {
            return {
                id: tmdbData.id,
                type: "tmdb",
                title: tmdbData.title ?? tmdbData.name,
                description: tmdbData.overview,
                releaseDate: tmdbData.release_date ?? tmdbData.first_air_date,
                backdropPath: tmdbData.backdrop_path,
                posterPath: tmdbData.poster_path,
                rating: tmdbData.vote_average,
                mediaType: mediaType,
            };
        } else {
            return null;
        }
    });

    // 等待所有请求完成
    const items = (await Promise.all(promises)).filter(Boolean);

    return items;
}

async function fetchDefaultData(sort_by) {
    const url_prefix = "https://zjrl-1318856176.cos.accelerate.myqcloud.com";
    let url = `${url_prefix}/${suffixMap[sort_by]}.json`;

    const response = await Widget.http.get(url, {
        headers: {
            "User-Agent":
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
        },
    });

    console.log("请求结果:", response.data);

    if (response.data) {
        let data;
        let items;
        if (sort_by === "今日推荐") {
            data = response.data.find(item => item.type === "1s");
            items = data.content;
        } else if (areaTypes.includes(sort_by)) {
            data = response.data.find(item => item.type === "category");
            items = data.content.find(item => item.title === sort_by).data;
        } else {
            data = response.data.find(item => item.title === sort_by);
            items = data.content;
        }
        console.log("items: ", items);

        const tmdbIds = await fetchImdbItems(items);

        console.log("tmdbIds: ", tmdbIds);

        return tmdbIds;
    }
    return [];
}

async function fetchOtherData(typ, sort_by) {
    const whichDay = sort_by.includes("今天") ? "today" : "tomorrow";
    const response = await Widget.http.get(`https://gist.githubusercontent.com/huangxd-/5ae61c105b417218b9e5bad7073d2f36/raw/${typ}_${whichDay}.json`, {
        headers: {
            "User-Agent":
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
        },
    });

    console.log("请求结果:", response.data);

    const tmdbIds = await fetchImdbItems(response.data);

    console.log("tmdbIds: ", tmdbIds);

    return tmdbIds;
}

async function loadTmdbItems(params = {}) {
    const sort_by = params.sort_by || "";

    let res;
    if (sort_by === "今天播出的国漫" || sort_by === "明天播出的国漫") {
        res = await fetchOtherData("guoman", sort_by);
    } else if (sort_by === "今天播出的综艺" || sort_by === "明天播出的综艺") {
        res = await fetchOtherData("zongyi", sort_by);
    } else {
        res = await fetchDefaultData(sort_by);
    }

    return res;
}

async function fetchWeekData(weekday, sort_by) {
    const response = await Widget.http.get(`https://gist.githubusercontent.com/huangxd-/5ae61c105b417218b9e5bad7073d2f36/raw/${sort_by}`, {
        headers: {
            "User-Agent":
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
        },
    });

    console.log("请求结果:", response.data);

    let items;
    if (weekday === "All") {
        items = [
            ...response.data.Monday,
            ...response.data.Tuesday,
            ...response.data.Wednesday,
            ...response.data.Thursday,
            ...response.data.Friday,
            ...response.data.Saturday,
            ...response.data.Sunday,
        ];
    } else {
        items = response.data[weekday];
    }

    const tmdbIds = await fetchImdbItems(items);

    console.log("tmdbIds: ", tmdbIds);

    return tmdbIds;
}

async function loadWeekTmdbItems(params = {}) {
    const weekday = params.weekday || "";
    const sort_by = params.sort_by || "";

    let res = await fetchWeekData(weekday, sort_by);

    return res;
}
