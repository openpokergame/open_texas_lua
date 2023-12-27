local FacebookPluginAdapter = class("FacebookPluginAdapter")
function FacebookPluginAdapter:ctor()
    self.schedulerPool_ = sa.SchedulerPool.new()
    self.cacheData_ = {}   
end

function FacebookPluginAdapter:login(callback)
    self.loginCallback_ = callback
    local delay = false
    local function loginResult()
        if self.loginCallback_ then
            local result = "test"
            result = "EAAGzbM1MSiABAGzda7E318YvZBvB2EqpZCTsCLdss8yCVHc9Cb2MLcKhzij9WM5OXnfahIamfcl89m9OZCx1o2ELQt2v6ZCNRuQZAZBLwURRC4l3YobMDOQgpCyYIQW9OlbolYJGTYC8Qy6QHWAbH3lcF87ZC3SVYsG8ByZAbNZCjtmZCkXoKup5D9C8HboMD5GSihw9B5ReE2CQZDZD"
            local success = (result ~= "canceled" and result ~= "failed")
            if self.loginCallback_ then
                self.loginCallback_(success, result)
            end
        end
    end

    if delay then
        self.schedulerPool_:delayCall(loginResult, 1)
    else
        loginResult()
    end
end

function FacebookPluginAdapter:updateAppRequest()
end

function FacebookPluginAdapter:getInvitableFriends(inviteLimit, callback)
    if callback then
        callback(true, {
                {name="a1",url="50x50/12345_n.jpg", id = "1"},{name="a2",url="50x50/12345_n.jpg", id = "2"},{name="a3",url="50x50/12345_n.jpg", id = "3"},{name="a4",url="50x50/12345_n.jpg", id = "4"},{name="a5",url="50x50/12345_n.jpg", id = "5"},
                {name="a6",url="50x50/12345_n.jpg", id = "6"},{name="a7",url="50x50/12345_n.jpg", id = "7"},{name="a8",url="50x50/12345_n.jpg", id = "8"},{name="a9",url="50x50/12345_n.jpg", id = "9"},{name="a10",url="50x50/12345_n.jpg", id = "10"},
                {name="a11",url="50x50/12345_n.jpg", id = "11"},{name="a12",url="50x50/12345_n.jpg", id = "12"},{name="a13",url="50x50/12345_n.jpg", id = "13"},{name="a14",url="50x50/12345_n.jpg", id = "14"},{name="a15",url="50x50/12345_n.jpg", id = "15"},
                {name="a16",url="50x50/12345_n.jpg", id = "16"},{name="a17",url="50x50/12345_n.jpg", id = "17"},{name="a18",url="50x50/12345_n.jpg", id = "18"},{name="a19",url="50x50/12345_n.jpg", id = "19"},{name="a20",url="50x50/12345_n.jpg", id = "20"},
                {name="a21",url="50x50/12345_n.jpg", id = "21"},{name="a22",url="50x50/12345_n.jpg", id = "22"},{name="a23",url="50x50/12345_n.jpg", id = "23"},{name="a24",url="50x50/12345_n.jpg", id = "24"},{name="a25",url="50x50/12345_n.jpg", id = "25"},
                {name="a26",url="50x50/12345_n.jpg", id = "26"},{name="a27",url="50x50/12345_n.jpg", id = "27"},{name="a28",url="50x50/12345_n.jpg", id = "28"},{name="a29",url="50x50/12345_n.jpg", id = "29"},{name="a30",url="50x50/12345_n.jpg", id = "30"},
                {name="a31",url="50x50/12345_n.jpg", id = "31"},{name="a32",url="50x50/12345_n.jpg", id = "32"},{name="a33",url="50x50/12345_n.jpg", id = "33"},{name="a34",url="50x50/12345_n.jpg", id = "34"},{name="a35",url="50x50/12345_n.jpg", id = "35"},
                {name="a36",url="50x50/12345_n.jpg", id = "36"},{name="a37",url="50x50/12345_n.jpg", id = "37"},{name="a38",url="50x50/12345_n.jpg", id = "38"},{name="a39",url="50x50/12345_n.jpg", id = "39"},{name="a1=40",url="50x50/12345_n.jpg", id = "40"},
                {name="a41",url="50x50/12345_n.jpg", id = "41"},{name="a42",url="50x50/12345_n.jpg", id = "42"},{name="a43",url="50x50/12345_n.jpg", id = "43"},{name="a44",url="50x50/12345_n.jpg", id = "44"},{name="a45",url="50x50/12345_n.jpg", id = "45"},
                {name="a46",url="50x50/12345_n.jpg", id = "46"},{name="a47",url="50x50/12345_n.jpg", id = "47"},{name="a48",url="50x50/12345_n.jpg", id = "48"},{name="a49",url="50x50/12345_n.jpg", id = "49"},{name="a50",url="50x50/12345_n.jpg", id = "50"},
                {name="a51",url="50x50/12345_n.jpg", id = "51"},{name="a52",url="50x50/12345_n.jpg", id = "52"},{name="a53",url="50x50/12345_n.jpg", id = "53"},{name="a54",url="50x50/12345_n.jpg", id = "54"},{name="a55",url="50x50/12345_n.jpg", id = "55"},
            })
    end
end

function FacebookPluginAdapter:logout()
    self.cacheData_ = {}
end

function FacebookPluginAdapter:shareFeed(params, callback)
    callback(true,"")
end

function FacebookPluginAdapter:moreInvite(params, callback)
end

function FacebookPluginAdapter:sendInvites(data, toID, title, message, callback)
    if callback then
        callback(true, {requestId = 123, toIds = "12344455test"})
    end
end

return FacebookPluginAdapter