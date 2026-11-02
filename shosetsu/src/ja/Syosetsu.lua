-- {"id":3,"ver":"2.2.6","libVer":"1.0.0","author":"Bigrand, Doomsdayrs","dep":["url>=1.0.0"]}
-- Adapted from shosetsuorg/extensions (src/ja/Syosetsu.lua 2.2.5, GPL-3.0) for Paraline Raygun:
-- search results in the desktop layout too, and chapters with Syosetsu's current markup.

local baseURL = "https://yomou.syosetu.com"
local passageURL = "https://ncode.syosetu.com"

local encode = Require("url").encode

local function getTotalPages(html)
	local lastPageLink = html:select(".c-pager__item--last"):attr("href")
	if lastPageLink then
		local totalPages = tonumber(lastPageLink:match("p=(%d+)"))

		return totalPages or 1
	end
	return 1
end

---@param url string
local function shrinkURL(url)
	return url:gsub(passageURL, "")
end

---@param url string
local function expandURL(url)
	return passageURL .. url
end

local function parseResults(document)
	-- The desktop layout: each result is a box whose heading links to the novel.
	local results = mapNotNil(document:select(".searchkekka_box"), function(v)
		local linkElement = v:selectFirst(".novel_h a")
		if not linkElement then
			return nil
		end
		return Novel({
			title = linkElement:text(),
			link = shrinkURL(linkElement:attr("href"))
		})
	end)
	if #results > 0 then
		return results
	end
	-- The phone layout, served to phone browsers.
	return mapNotNil(document:select(".smpnovel_list"), function(v)
		local titleElement = v:selectFirst(".novel_h")
		local linkElement = v:selectFirst(".read_button")

		if not titleElement or not linkElement then
			return nil
		end

		return Novel({
			title = titleElement:text(),
			link = shrinkURL(linkElement:attr("href"))
		})
	end)
end

local function search(data)
	local url = baseURL .. "/search.php?&word=" .. encode(data[0]) .. "&type=re&p=" .. data[PAGE]
	local document = GETDocument(url)

	return parseResults(document)
end

local function parseListing(filter, data)
	if data[PAGE] == 0 then
		data[PAGE] = 1
	end

	local url = baseURL .. filter .. data[PAGE]
	local document = GETDocument(url)

	return parseResults(document)
end

local function getPassage(chapterURL)
	local document = GETDocument(passageURL .. chapterURL)
	local titleElement = document:selectFirst(".p-novel__subtitle-episode")
		or document:selectFirst(".p-novel__title")
	-- The body holds the author's foreword, the chapter and the afterword; the first
	-- `.p-novel__text` alone is only the foreword when there is one.
	local chapter = document:selectFirst(".p-novel__body") or document:selectFirst(".p-novel__text")
	if titleElement then
		chapter:prepend("<h1>" .. titleElement:text() .. "</h1>")
	end

	return pageOfElem(chapter, false)
end

local function parseNovel(novelURL, loadChapters)
	local document = GETDocument(passageURL .. novelURL)
	local author = { document:selectFirst(".p-novel__author a"):text() }

	if not author[1] then
		error("Error: Author not found!")
	end

	local title = document:selectFirst(".p-novel__title"):text()

	local descriptionElement = document:selectFirst(".p-novel__summary")
	local description = ""
	if descriptionElement then
		description = tostring(descriptionElement):gsub("<br%s*/?>", "\n")
		:gsub("<[^>]->", "")
		:gsub("\n%s*\n+", "\n\n")
		:gsub("^%s+", "")
		:gsub("%s+$", "")
	end

	local NovelInfo = NovelInfo {
		title = title,
		link = novelURL,
		language = "jpn",
		description = description,
		authors = author
	}

	if loadChapters then
		local chapters = {}
		local totalPages = getTotalPages(document)
		for page = 1, totalPages do
			local pageURL = novelURL .. "?p=" .. page

			local pageDocument = GETDocument(passageURL .. pageURL)
			map(pageDocument:select(".p-eplist__sublist"), function(v)
				local chap = NovelChapter()
				local chapterElement = v:selectFirst(".p-eplist__subtitle")
				local chapTitle = chapterElement:text()
				local link = chapterElement:attr("href")
				local release = v:selectFirst(".p-eplist__update"):text()

				chap:setTitle(chapTitle)
				chap:setLink(link)
				chap:setRelease(release)
				table.insert(chapters, chap)
			end)
		end
		NovelInfo:setChapters(AsList(chapters))
	end

	return NovelInfo 
end

return {
	id = 3,
	name = "Syosetsu",
	baseURL = baseURL,
	imageURL = "https://gitlab.com/shosetsuorg/extensions/-/raw/dev/icons/Syosetsu.png",
	hasCloudFlare = false,
	hasSearch = true,
	chapterType = ChapterType.HTML,
	getPassage = getPassage,
	parseNovel = parseNovel,
	shrinkURL = shrinkURL,
	expandURL = expandURL,
	search = search,
	isSearchIncrementing = true,
	startIndex = 1,

	listings = {
		Listing("Most Weekly Views", true, function(data)
			return parseListing("/search.php?type=re&order=weekly&p=", data)
		end),
		Listing("Latest Published", true, function(data)
			return parseListing("/search.php?type=re&order=new&notnizi=1&p=", data)
		end),
		Listing("Most Bookmarked", true, function(data)
			return parseListing("/search.php?type=re&order=favnovelcnt&p=", data)
		end),
		Listing("Most Reviews", true, function(data)
			return parseListing("/search.php?type=re&order=reviewcnt&p=", data)
		end),
		Listing("Highest Overall Points", true, function(data)
			return parseListing("/search.php?type=re&order=hyoka&p=", data)
		end),
		Listing("Highest Daily Points", true, function(data)
			return parseListing("/search.php?type=re&order=dailypoint&p=", data)
		end),
		Listing("Highest Weekly Points", true, function(data)
			return parseListing("/search.php?type=re&order=weeklypoint&p=", data)
		end),
		Listing("Highest Monthly Points", true, function(data)
			return parseListing("/search.php?type=re&order=monthlypoint&p=", data)
		end),
		Listing("Highest Quarterly Points", true, function(data)
			return parseListing("/search.php?type=re&order=quarterpoint&p=", data)
		end),
		Listing("Highest Yearly Points", true, function(data)
			return parseListing("/search.php?type=re&order=yearlypoint&p=", data)
		end),
		Listing("Most Raters", true, function(data)
			return parseListing("/search.php?type=re&order=hyokacnt&p=", data)
		end),
		Listing("Most Words", true, function(data)
			return parseListing("/search.php?type=re&order=lengthdesc&p=", data)
		end),
		Listing("Oldest Published", true, function(data)
			return parseListing("/search.php?type=re&order=generalfirstup&p=", data)
		end),
		Listing("Oldest Updates", true, function(data)
			return parseListing("/search.php?type=re&order=old&p=", data)
		end)
	}
}
