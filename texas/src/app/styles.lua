-- 通用字体风格
styles = {}
local s = styles

s.FONT_COLOR = {}
s.FONT_COLOR.LIGHT_TEXT   = cc.c3b(0xee, 0xee, 0xee)
s.FONT_COLOR.GREY_TEXT    = cc.c3b(0x99, 0x99, 0x99)
s.FONT_COLOR.DARK_TEXT    = cc.c3b(0x0, 0x0, 0x0)
s.FONT_COLOR.GOLDEN_TEXT  = cc.c3b(0xff, 0xd1, 0x00)

s.FONT_COLOR.CONTENT_TEXT  = cc.c3b(0x9b, 0xa9, 0xff) -- 内容字体
s.FONT_COLOR.INPUT_TEXT  = cc.c3b(0x50, 0x4c, 0x8d) --输入框字体
s.FONT_COLOR.CHIP_TEXT  = cc.c3b(0xff, 0xe3, 0x62) --筹码字体
s.FONT_COLOR.DIAMOND  = cc.c3b(0x56, 0xdc, 0x7a) --钻石字体

s.FONT_COLOR.MAIN_TAB_ON  = cc.c3b(0x5d, 0x32, 0x12) --一级tab选中
s.FONT_COLOR.MAIN_TAB_OFF  = cc.c3b(0x6e, 0x6e, 0xc9) --一级tab未选中
s.FONT_COLOR.SUB_TAB_ON  = cc.c3b(0x72, 0x31, 0x01) --二级tab选中
s.FONT_COLOR.SUB_TAB_OFF  = cc.c3b(0x82, 0x82, 0xdb) --二级tab未选中

s.FONT_SIZE = {}
s.FONT_SIZE.TEXT_SMALL   = 20
s.FONT_SIZE.TEXT_NORMAL  = 24
s.FONT_SIZE.TEXT_LARGE   = 28

s.FONT_SIZE.TITLE_SMALL  = 24
s.FONT_SIZE.TITLE_NORMAL = 28
s.FONT_SIZE.TITLE_LARGE  = 32

return styles