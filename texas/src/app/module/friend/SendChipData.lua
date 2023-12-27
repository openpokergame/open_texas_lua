--可赠送好友筹码数据
local SendChipData = class("SendChipData")
local SHOW_FRIEND = 1 --我关注的
local SHOW_FRIEND_2 = 2 --关注我的

function SendChipData:ctor()
    self.data_ = {}
    self.index_ = 1
end

function SendChipData:addData(index, data)
    self.data_[index] = data
end

function SendChipData:setIndex(index)
    self.index_ = index
end

function SendChipData:getData()
    return self.data_[self.index_]
end

function SendChipData:getMoney()
    return self.data_[self.index_].money
end

function SendChipData:sendChipSuccess(id)
    local data = self.data_[self.index_]
    if data then
        data.cnt = data.cnt - 1
    end

    local other = self.data_[SHOW_FRIEND]
    if self.index_ == SHOW_FRIEND then
        other = self.data_[SHOW_FRIEND_2] or {}
    end

    if other.flist then
        for _, v in ipairs(other.flist) do
            if tonumber(v.uid) == tonumber(id) then
                v.send = 0
                other.cnt = other.cnt - 1
                break
            end
        end
    end
end

function SendChipData:oneKeySend(callback)
    local data = self.data_[self.index_]
    if data and data.cnt > 0 then
        local tm = data.cnt * data.money 
        if tm * 2 > tx.userData.money then
            tx.ui.Dialog.new({
                messageText = sa.LangUtil.getText("FRIEND", "ONE_KEY_SEND_CHIP_TOO_POOR"), 
                hasFirstButton = false
            }):show()

            return
        end

        if data.cnt >= 20 then
            tx.ui.Dialog.new({
                messageText = sa.LangUtil.getText("FRIEND", "ONE_KEY_SEND_CHIP_CONFIRM", data.cnt, sa.formatBigNumber(tm)), 
                callback = function (type)
                    if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                        callback(self.index_)
                    end
                end
            }):show()
        else
            callback(self.index_)
        end
    end
end

--过滤我关注的和关注我的数据信息
function SendChipData:oneKeySendSuccess()
    local data = self.data_[self.index_]
    if data then
        data.cnt = 0
    end

    local other = self.data_[SHOW_FRIEND]
    if self.index_ == SHOW_FRIEND then
        other = self.data_[SHOW_FRIEND_2] or {}
    end

    local idArr = {}
    for _, v in ipairs(data.flist) do
        idArr[tonumber(v.uid)] = true
    end

    if other.flist then
        for _, v in ipairs(other.flist) do
            if idArr[tonumber(v.uid)] then
                v.send = 0
                other.cnt = other.cnt - 1
            end
        end
    end
end

return SendChipData
