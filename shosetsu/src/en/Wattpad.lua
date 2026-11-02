-- {"id":95556,"ver":"1.0.8","libVer":"1.0.0","author":"Confident-hate","dep":["dkjson>=1.0.1","url>=1.0.0"]}
-- Adapted from shosetsuorg/extensions (src/en/Wattpad.lua 1.0.7, GPL-3.0) for Paraline Raygun:
-- stories and chapters come from Wattpad's own JSON and text endpoints instead of its pages,
-- whose generated class names change with every Wattpad release.
local json = Require("dkjson")
local baseURL = "https://www.wattpad.com"

---@param v Element
local text = function(v)
    return v:text()
end


---@param url string
---@param type int
local function shrinkURL(url)
    return url:gsub("https://www.wattpad.com", "")
end

---@param url string
---@param type int
local function expandURL(url)
    return baseURL .. url
end

local ORDER_BY_FILTER = 3
local ORDER_BY_VALUES = { "Hot", "New"}
local GENRE_FILTER = 2
local GENRE_VALUES = { 
  "Adventure",
  "Contemporarylit",
  "Diverselit",
  "Fanfiction",
  "Fantasy",
  "Historicalfiction",
  "Horror",
  "Humor",
  "Lgbt",
  "Mystery",
  "Newadult",
  "Nonfiction",
  "Paranormal",
  "Poetry",
  "Romance",
  "Sciencefiction",
  "Shortstory",
  "Teenfiction",
  "Thriller",
  "Werewolf"
}

local STATUS_FILTER_KEY = 4
local STATUS_VALUES = { "All", "Completed"}
local STATUS_PARAMS = {"", "&filter=complete"}

local searchFilters = {
    DropdownFilter(GENRE_FILTER, "Genre", GENRE_VALUES),
    DropdownFilter(ORDER_BY_FILTER, "Order by", ORDER_BY_VALUES),
    DropdownFilter(STATUS_FILTER_KEY, "Status (only works with search)", STATUS_VALUES)
}

local encode = Require("url").encode


--- A part's id from its link (`/1666554805-the-title`).
local function partId(chapterURL)
    return chapterURL:match("^/?(%d+)") or chapterURL:match("/(%d+)%-")
end

--- @param chapterURL string @url of the chapter
--- @return string @of chapter
local function getPassage(chapterURL)
    local id = partId(chapterURL)
    -- The whole part as paragraphs, every page of it.
    local response = Request(
            RequestBuilder()
                    :get()
                    :url(baseURL .. "/apiv2/?m=storytext&id=" .. id)
                    :addHeader("Referer", "https://www.wattpad.com/")
                    :build()
    )
    local body = response:body():string()
    local part = json.decode(RequestDocument(
            RequestBuilder()
                    :get()
                    :url(baseURL .. "/api/v3/story_parts/" .. id .. "?fields=title")
                    :build()
    ):text())
    local title = (part and part.title) or ""
    local doc = Document("<h1>" .. title .. "</h1>" .. body)
    doc:select("button"):remove()
    return pageOfElem(doc, true)
end

--- @param data table
local function search(data)
    local queryContent = data[QUERY]
    local page = data[PAGE] - 1
    local status = data[STATUS_FILTER_KEY]
    local statusValue = ""
    if status ~= nil then
        statusValue = STATUS_PARAMS[status+1]
    end
    local query = baseURL .. "/v4/search/stories?query=" .. queryContent .. statusValue .. "&free=1&fields=stories(title,cover,url),nexturl&limit=20&mature=true&offset=" .. page*20
    local response = RequestDocument(GET(query, nil, nil))
    response = json.decode(response:text())
    return map(response["stories"], function(v)
        return Novel {
            title = v.title,
            link = shrinkURL(v.url),
            imageURL = v.cover
        }
    end)
end

local STORY_FIELDS = "title,description,cover,completed,isPaywalled,user(name),tags,parts(id,title,url,isBlocked,createDate)"

--- @param novelURL string @URL of novel
--- @return NovelInfo
local function parseNovel(novelURL)
    local id = novelURL:match("/story/(%d+)")
    local story = json.decode(RequestDocument(
            RequestBuilder()
                    :get()
                    :url(baseURL .. "/api/v3/stories/" .. id .. "?fields=" .. STORY_FIELDS)
                    :addHeader("Referer", "https://www.wattpad.com/")
                    :build()
    ):text())

    local description = story.description or ""
    if story.isPaywalled then
        description = "!! 💰 Contains Paid Chapters !!\n" .. description
    end
    local chapters = {}
    for index, part in ipairs(story.parts or {}) do
        local title = part.title
        if part.isBlocked then
            title = "🔒 " .. title
        end
        chapters[#chapters + 1] = NovelChapter {
            order = index,
            title = title,
            link = shrinkURL(part.url),
            release = part.createDate
        }
    end

    return NovelInfo {
        title = story.title,
        description = description,
        imageURL = story.cover,
        authors = { story.user and story.user.name or "" },
        genres = story.tags or {},
        status = story.completed and NovelStatus.COMPLETED or NovelStatus.PUBLISHING,
        chapters = AsList(chapters)
    }
end

local function parseListing(listingURL)
    local response = RequestDocument(
            RequestBuilder()
                    :get()
                    :url(listingURL)
                    :addHeader("Authorization", "IwKhVmNM7VXhnsVb0BabhS")
                    :build()
    )
    response = json.decode(response:text())
    return map(response["stories"], function(v)
        return Novel {
            title = v.title,
            link = shrinkURL(v.url),
            imageURL = v.cover
        }
    end)
end


local function getListing(data)
    local genre = data[GENRE_FILTER]
    local orderBy = data[ORDER_BY_FILTER]
    local page = data[PAGE] - 1
    local genreValue = ""
    local orderByValue = ""
    if genre ~= nil then
        genreValue = GENRE_VALUES[genre+1]:lower()
    end
    if orderBy ~= nil then
        orderByValue = ORDER_BY_VALUES[orderBy + 1]:lower()
    end
    local url = ""
    if orderByValue == "hot" then
        url = "https://api.wattpad.com/v5/hotlist?tags=" .. genreValue .. "&language=1&limit=20&offset=" .. page*20
    else
        url = "https://www.wattpad.com/v4/stories?fields=stories%28id%2Cuser%28name%2Cavatar%2Cfullname%29%2Ctitle%2Ccover%2Cdescription%2Cmature%2Ccompleted%2CvoteCount%2CreadCount%2Ccategories%2Curl%2CnumParts%2Crankings%2CfirstPartId%2Ctags%2CisPaywalled%29%2CnextUrl%2Ctotal&filter=new&language=1&mature=0&query=%23" .. genreValue .. "&limit=20&offset=" .. page*20
    end
    return parseListing(url)
end



return {
    id = 95556,
    name = "Wattpad",
    baseURL = baseURL,
    imageURL = "https://cdn-icons-png.flaticon.com/512/2111/2111715.png",
    hasSearch = true,
    listings = {
        Listing("Default", true, getListing)
    },

    parseNovel = parseNovel,
    getPassage = getPassage,
    chapterType = ChapterType.HTML,
    search = search,
    shrinkURL = shrinkURL,
    expandURL = expandURL,
    searchFilters = searchFilters
}   