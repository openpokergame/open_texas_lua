#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "cocos2d.h"
#include "lua_module_register.h"
// #include "MobClickCpp.h"

// extra lua module
#include "cocos2dx_extra.h"
#include "lua_extensions/lua_extensions_more.h"
#include "luabinding/lua_cocos2dx_extension_filter_auto.hpp"
#include "luabinding/lua_cocos2dx_extension_nanovg_auto.hpp"
#include "luabinding/lua_cocos2dx_extension_nanovg_manual.hpp"
#include "luabinding/cocos2dx_extra_luabinding.h"
#include "luabinding/HelperFunc_luabinding.h"
// #include "umeng/umeng_lua_binding.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "luabinding/cocos2dx_extra_ios_iap_luabinding.h"
#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
extern "C" {
    int luaopen_webview(lua_State *L);
}
#endif

using namespace CocosDenshion;

USING_NS_CC;
using namespace std;

static void quick_module_register(lua_State *L)
{
    luaopen_lua_extensions_more(L);

    lua_getglobal(L, "_G");
    if (lua_istable(L, -1))//stack:...,_G,
    {
        register_all_quick_manual(L);
        // extra
        luaopen_cocos2dx_extra_luabinding(L);
        register_all_cocos2dx_extension_filter(L);
        register_all_cocos2dx_extension_nanovg(L);
        register_all_cocos2dx_extension_nanovg_manual(L);
        luaopen_HelperFunc_luabinding(L);
		// lua_register_mobclick_module(L);
		
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        luaopen_cocos2dx_extra_ios_iap_luabinding(L);
#endif
    }
    lua_pop(L, 1);
}

//
AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();
}

//if you want a different context,just modify the value of glContextAttrs
//it will takes effect on all platforms
void AppDelegate::initGLContextAttrs()
{
    //set OpenGL context attributions,now can only set six attributions:
    //red,green,blue,alpha,depth,stencil
    GLContextAttrs glContextAttrs = { 8, 8, 8, 8, 24, 8 };

    GLView::setGLContextAttrs(glContextAttrs);
}

bool AppDelegate::applicationDidFinishLaunching()
{
    // initialize director
    auto director = Director::getInstance();
	director->setProjection(Director::Projection::_2D);
    
    auto glview = director->getOpenGLView();
    if(!glview) {
        string title = "OpenPoker";
        glview = cocos2d::GLViewImpl::create(title.c_str());
        director->setOpenGLView(glview);
        director->startAnimation();
    }
   
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    lua_State* L = engine->getLuaStack()->getLuaState();
    lua_module_register(L);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    lua_cpcall(L,luaopen_webview,NULL);
#endif
    // use Quick-Cocos2d-X
    quick_module_register(L);

    LuaStack* stack = engine->getLuaStack();

#if 1

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	// load framework
#ifdef CC_TARGET_OS_IPHONE
    if (sizeof(long) == 4) {
        stack->loadChunksFromZIP("res/framework_precompiled.zip");
    } else {
        stack->loadChunksFromZIP("res/framework_precompiled64.zip");
    }
#else
    stack->loadChunksFromZIP("res/framework_precompiled.zip");
#endif
#endif
    // use luajit bytecode package
    int x=0;
    char y[17];
    char *z = y;
    *(z++)=0x4F;         //O  0x4F 79
    *(z++)=y[x++]+0x21;  //p  0x70 112
    *(z++)=y[x++]-0x0B;  //e  0x65 101
    *(z++)=y[x++]+0x09;  //n  0x6E 110
    *(z++)=y[x++]-0x1A;  //T  0x54 84
    *(z++)=y[x++]+0x11;  //e  0x65 101
    *(z++)=y[x++]+0x13;  //x  0x78 120
    *(z++)=y[x++]-0x17;  //a  0x61 97
    *(z++)=y[x++]+0x12;  //s  0x73 115
    *(z++)=y[x++]-0x33;  //@  0x40 64
    *(z++)=y[x++]+0x2A;  //j  0x6A 106
    *(z++)=y[x++]-0x09;  //a  0x61 97
    *(z++)=y[x++]+0x02;  //c  0x63 99
    *(z++)=y[x++]+0x08;  //k  0x6B 107
    *(z++)=y[x++]+0x0D;  //x  0x78 120
    *(z++)=y[x++]+0x00;  //x  0x78 120
    *(z++)=y[x]-0x44;    //0  0x30 48
    // stack->setXXTEAKeyAndSign("OpenTexas@jackxx", "741x");
    stack->setXXTEAKeyAndSign(y, "741x");

#ifdef CC_TARGET_OS_IPHONE
    if (sizeof(long) == 4) {
        stack->loadChunksFromZIP("res/game.zip");
    } else {
        stack->loadChunksFromZIP("res/game64.zip");
    }
#else
    
    stack->loadChunksFromZIP("res/game.zip");
#endif
    stack->executeString("require 'main'");
#else // #if 0
    // use discrete files
    engine->executeScriptFile("src/main.lua");
#endif

    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();
    Director::getInstance()->pause();

    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
    SimpleAudioEngine::getInstance()->pauseAllEffects();

    Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("APP_ENTER_BACKGROUND_EVENT");
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->resume();
    Director::getInstance()->startAnimation();

    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
    SimpleAudioEngine::getInstance()->resumeAllEffects();

    Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("APP_ENTER_FOREGROUND_EVENT");
}
