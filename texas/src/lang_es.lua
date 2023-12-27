local L = {}
local T, T1

L.COMMON        = {}
L.LOGIN         = {}
L.HALL          = {}
L.ROOM          = {}
L.STORE         = {}
L.USERINFO      = {}
L.FRIEND        = {}
L.RANKING       = {}
L.MESSAGE       = {}
L.SETTING       = {}
L.LOGINREWARD   = {}
L.HELP          = {}
L.UPDATE        = {}
L.ABOUT         = {}
L.DAILY_TASK    = {}
L.COUNTDOWNBOX  = {}
L.NEWESTACT     = {}
L.FEED          = {}
L.ECODE         = {}
L.LUCKTURN      = {}
L.SLOT          = {}
L.GIFT          = {}
L.CRASH         = {}
L.MATCH         = {}
L.E2P_TIPS      = {}
L.VIP           = {}
L.WINORLOSE     = {}
L.PRIVTE        = {}
L.ACT           = {}
L.REDBLACK      = {}
L.TUTORIAL      = {}
L.TIPS          = {}
L.SAFE          = {}
L.GOLDISLAND    = {}
L.CHECKOUTGUIDE = {}
L.BIND          = {}
L.PAYGUIDE      = {}

-- tips
L.TIPS.ERROR_INVITE_FRIEND = "Falló de la invitación"
L.TIPS.ERROR_TASK_REWARD = "Falló al recoger la recompensa de la misión"
L.TIPS.ERROR_SEND_FRIEND_CHIP = "Falló al regalar fichas"
L.TIPS.EXCEPTION_SEND_FRIEND_CHIP = "Error al regalar fichas"
L.TIPS.ERROR_BUY_GIFT = "Falló al regalar"
L.TIPS.ERROR_LOTTER_DRAW = "Falló al recoger el cofre misterioso"
L.TIPS.EXCEPTION_LOTTER_DRAW = "Veces insuficientes"
L.TIPS.ERROR_LOGIN_ROOM_FAIL = "Falló al entrar en la habitación"
L.TIPS.ERROR_LOGIN_FACEBOOK = "Falló al iniciar sesión vía FaceBook"
L.TIPS.ERROR_LOGIN_FAILED = "Falló al iniciar sesión"
L.TIPS.ERROR_QUICK_IN = "Falló al obtener la información de la habitación"
L.TIPS.EXCEPTION_QUICK_IN = "Error al obtener la información de la habitación"
L.TIPS.ERROR_SEND_FEEDBACK = "Error del servidor o tiempo de espera de conexión agotado,fallón al enviar comentarios"
L.TIPS.ERROR_FEEDBACK_SERVER_ERROR = "Error del servidor, falló al enviar comentarios"
L.TIPS.ERROR_MATCH_FEEDBACK = "Falló al enviar comentarios"
L.TIPS.EXCEPTION_ACT_LIST = "Error del servidor, falló al cargar los datos del evento"
L.TIPS.EXCEPTION_BACK_CHECK_PWD = "Comproba la contraseña：Error del servidor"
L.TIPS.ERROR_BACK_CHECK_PWD = "Error del servidor o tiempo de espera de conexión agotado, falló al comprobar la contraseña"
L.TIPS.FEEDBACK_UPLOAD_PIC_FAILED = "Falló al enviar comentarios"
L.TIPS.ERROR_LEVEL_UP_REWARD = "Error del servidor o tiempo de espera de conexión agotado, falló al recoger las recompensas"
L.TIPS.WARN_NO_PERMISSION = "Todavía no puede usar esta función, tiene que autorizar en el sistema primero"
L.TIPS.VIP_GIFT = "Sólo está disponible para VIP"
L.TIPS.KAOPU_TIPS = "Fallo de la inicializacion de juego, vuelve a intentarlo por favor"
L.TIPS.INPUT_NUMBER = "请输入纯数字"
L.TIPS.INPUT_NO_EMPTY = "输入不能为空"

-- COMMON MODULE
L.COMMON.LEVEL = "Nivel:"
L.COMMON.ASSETS = "${1}"
L.COMMON.CONFIRM = "Confirmar"
L.COMMON.CANCEL = "Cancelar"
L.COMMON.AGREE = "Aceptar"
L.COMMON.REJECT = "Rechazar"
L.COMMON.RETRY = "Reintentar"
L.COMMON.NOTICE = "Atención"
L.COMMON.BUY = "Comprar"
L.COMMON.SEND = "Enviar"
L.COMMON.BAD_NETWORK = "Se ha interrumpido la conexión, por favor verifica el estado de tu conexión a Internet y red"
L.COMMON.REQUEST_DATA_FAIL = "Se ha interrumpido la conexión, por favor verifica el estado de tu conexión a Internet y red, haga clic para volver a intentarlo"
L.COMMON.ROOM_FULL = "Demasiados veedores, por favor cambia por otra habitación "
L.COMMON.USER_BANNED = "Su cuenta está bloqueada, por favor contacta con GM o comentar"
L.COMMON.SHARE = "Compartir"
L.COMMON.GET_REWARD = "Recoger recompensas"
L.COMMON.BUY_CHAIP = "Comprar"
L.COMMON.SYSTEM_BILLBOARD = "Anuncio"
L.COMMON.DELETE = "Borrar"
L.COMMON.CHECK = "Ver"
L.COMMON.CONGRATULATIONS = "Felicidades"
L.COMMON.REWARD_TIPS = "Felicidades, ha obtenido {1}"
L.COMMON.GET = "Recoger"
L.COMMON.CLICK_GET = "Toca para recoger"
L.COMMON.ALREADY_GET = "Reclamado"
L.COMMON.NEXT_GET = "La próxima vez"
L.COMMON.LOGOUT = "Cerrar sesión"
L.COMMON.LOGOUT_DIALOG_TITLE = "Confirmar"
L.COMMON.NOT_ENOUGH_MONEY_TO_PLAY_NOW_MSG = "Por lo menos {1} fichas, por favor agrega más fichas y vuelve a intentarlo"
L.COMMON.USER_SILENCED_MSG = "Su cuenta está bloqueada, por favor contacta con GM (Ayuda-Comentarios)"
L.COMMON.USER_NEED_RELOGIN = "Error en la operación. Por favor inicia sesión e intenta de nuevo, o contacta con nuestro servicio de atención al cliente"
L.COMMON.BLIND_BIG_SMALL = "Ciega:{1}/{2}"
L.COMMON.NOT_ENOUGH_DIAMONDS = "Diamantes insuficientes"
L.COMMON.FANS_URL = appconfig.FANS_URL
L.COMMON.NOT_ENOUGH_MONEY = "Fichas insuficientes, recarga y vuelve a intentar"
L.COMMON.NOT_FINISH = "No completado"

-- android 右键退出游戏提示
L.COMMON.QUIT_DIALOG_TITLE = "Salir del juego"
L.COMMON.QUIT_DIALOG_MSG = "¿Deseas salir del juego? Quédate plis~\\(≧▽≦)/~"
L.COMMON.QUIT_DIALOG_MSG_A = "¿De verdad quieres salir?\n Recuerdas que inicia sesión mañana, podrás recibir más regalos’"
L.COMMON.QUIT_DIALOG_CONFIRM = "Salir del juego"
L.COMMON.QUIT_DIALOG_CANCEL = "Volver al juego"
L.COMMON.GAME_NAMES = {
    [1] = "Texas hold'em",
    [2] = "Palestra",
    [3] = "Omaha",
    [4] = "Baccarat",
    [5] = "ALL-IN",
}

-- LOGIN MODULE
L.LOGIN.REGISTER_FB_TIPS = "Los nuevos usuarios pueden recoger un paquete registro de relago en los primeros 3 inicios.\nLos usuarios de FaceBook van a recibir más recompensas!"
L.LOGIN.FB_LOGIN = "Iniciar sesión con Facebook"
L.LOGIN.GU_LOGIN = "Jugar como invitado"
L.LOGIN.REWARD_SUCCEED = "Recogido"
L.LOGIN.REWARD_FAIL = "Falló al recoger"
L.LOGIN.LOGINING_MSG = "Iniciando sesión..."
L.LOGIN.CANCELLED_MSG = "Se ha cancelado el inicio de sesión"
L.LOGIN.DOUBLE_LOGIN_MSG = "La cuenta se está utilizando en otro lugar" 
L.LOGIN.LOGIN_DEALING = "Iniciando sesión, por favor espere con paciencia"
L.LOGIN.INIT_SDK = "Inicializando el juego,por favor espere con paciencia"

-- HALL MODULE
L.HALL.USER_ONLINE = "jugadores en linea actual: {1}"
L.HALL.INVITE_TITLE = "Invitar a amigos"
L.HALL.INVITE_FAIL_SESSION = "Error al obtener información de Facebook. Inténtalo de nuevo"
L.HALL.SEARCH_ROOM_INPUT_ROOM_NUMBER_ERROR = "Error del número de la habitación"
L.HALL.MATCH_NOT_OPEN = "Pronto se abrirán Torneos"
L.HALL.NOT_TRACK_TIPS = "No está en línea en este momento, no se puede seguirlo"
L.HALL.TEXAS_LIMIT_LEVEL = "¡Se necesita tener más de lvl.{1}, sube el nivel primero!"
L.HALL.TEXAS_GUIDE_TIPS_1 = "¡Ya es profesional, no juega más con los novatos!"
L.HALL.TEXAS_GUIDE_TIPS_2 = "¡Ya es experto, puede ir a jugar en un lugar correspondiente!"
L.HALL.TEXAS_GUIDE_TIPS_3 = "¡Enhorabuena, ya tiene más fichas! ¿Si quiere cambiar del otro lugar para seguir el juego?"
L.HALL.TEXAS_UPGRADE = "Mejorar enseguida"
L.HALL.TEXAS_STILL_ENTER = "Insistir en entrar"
L.HALL.ROOM_LEVEL_TEXT_ROOMTIP = {
    "Partida primaria", 
    "Partida secundaria",
    "Partida superior",
}
L.HALL.PLAYER_LIMIT_TEXT = {
    "9\n jugadores",
    "6\n jugadores",
}
L.HALL.CHOOSE_ROOM_TYPE = {
    "Normal",
    "Rápida",
}
L.HALL.CHOOSE_ROOM_CITY_NAME = {
    "Bangkok",
    "Seúl",
    "Kuala Lumpur",
    "Shanghái",

    "Moscú",
    "Tokio",
    "Milán",
    "París",
}
L.HALL.CHOOSE_ROOM_MIN_MAX_ANTE = "Minimo {1}/Máximo {2}"
L.HALL.CHOOSE_ROOM_BLIND = "Ciega:{1}/{2}"
L.HALL.GIRL_SHORT_CHAT = {
    "Hola, soy la Crupier(la repartidora de casino), me llamo Victoria",
    "Voy a esperarte en la habitación~",
    "En el juego nos divertimos siempre, ¿no?",
    "¿Qué estás haciendo?",
    "Cariño, ven a jugar",
    "Si te gusta este juego, danos un Like en nuestra Fanpage porfa",
    "Eres genial, buena suerte",
    "Mua~(￣3￣)|~",
    "Recuerda que puedes ganar más fichas gratis si invitas a tus amigos", 
}
L.HALL.CHOOSE_ROOM_LIMIT_LEVEL = "¡Se necesita tener más de lvl.{1}, sube el nivel hasta lvl.{2} en Campo Texas primero!"
L.HALL.OMAHA_HELP_TITLE = "Las reglas del póquer Omaha"
L.HALL.OMAHA_RULE = [[
A cada jugador se le entregan 4 cartas privadas (hole cards) boca abajo.  En la mesa se entregan 5 cartas comunes (community cards) boca arriba.  Los jugadores pueden usar cualquier combinación de exactamente 2 cartas personales y exactamente 3 cartas comunitarias para hacer su mejor mano de 5 cartas. El ranking de las manos es el mismo que en casi todas las variantes de poker. Mas detalles en la esquina derecha de abajo.

A diferencia del Texas Hold’em, el valor de cartas privadas es muy importante en el Omaha.

Diferencias entre Texas Hold'em y Omaha

1. En el Holdem se reparten dos cartas por cada jugador, en Omaha a cada jugador se le repartirán cuatro cartas.
2. Para formar la mejor combinación posible de 5 cartas, los jugadores deben utilizar solamente 2 cartas de las 4 cartas pre-flop y 3 de las cartas comunes.
3. En el Holdem pueden jugar hasta 22 jugadores, en Omaha pueden jugar hasta 11 jugadores.
]]
L.HALL.TRACE_LIMIT_LEVEL = "Falló del seguimiento, sube de nivel hasta lvl.{1} para entrar en la habitación"
L.HALL.TRACE_LIMIT_ANTE = "Falló del seguimiento, para entrar en la habitación, necesitas tener {1} fichas"
L.HALL.OMAHA_ROOM_CITY_NAME = {
    "Canberra",
    "Sydney",
    "España",
    "Canada",
}
L.HALL.TEXAS_MUST_ROOM_CITY_NAME = {
    "Pekín",
    "Mexico",
    "Monte Carlo",
    "Las Vegas",
}
L.HALL.TEXAS_MUST_TITLE = "ALL-IN"
L.HALL.TEXAS_MUST_HELP_TITLE = "德州必下场规则说明"
L.HALL.TEXAS_MUST_RULE = [[
必下场是一种全新的玩法，每位玩家需要在每局游戏一开始的时候投入5倍大盲的前注，底池将膨胀的更快，玩法更加刺激。

玩家进入游戏桌时带入的筹码为一个固定值。当入座玩家每局开始前筹码不够时，系统将自动帮他补充。
]]
L.HALL.SMALL_GAME = "小游戏"

-- ROOM MODULE
L.ROOM.OPR_TYPE = {
    "PASAR",
    "RETIRARSE",
    "IGUALAR",
    "SUBIR",
}
L.ROOM.MY_MONEY = "Mi dinero {1} {2}"
L.ROOM.INFO_UID = "ID {1}"
L.ROOM.INFO_LEVEL = "Lvl.{1}"
L.ROOM.INFO_WIN_RATE = "Victoria%: {1}%"
L.ROOM.INFO_SEND_CHIPS = "Regalar fichas"
L.ROOM.ADD_FRIEND = "Seguir"
L.ROOM.DEL_FRIEND = "Dejar de seguir"
L.ROOM.FORBID_CHAT = "Bloquear"
L.ROOM.CANCEL_FORBID_CHAT = "Bloqueado"
L.ROOM.NO_SEND_CHIP_TIPS = "No se puede regalar"
L.ROOM.ADD_FRIEND_SUCC_MSG = "Agregado"
L.ROOM.ADD_FRIEND_FAILED_MSG = "Error al agregar"
L.ROOM.DELE_FRIEND_SUCCESS_MSG = "Borrado"
L.ROOM.DELE_FRIEND_FAIL_MSG = "Error al borrar"
L.ROOM.SEND_CHIP_NOT_NORMAL_ROOM_MSG = "Sólo en Campo Normal que se puede regalar fichas"
L.ROOM.SELF_CHIP_NO_ENOUGH_SEND_DELEAR = "Fichas insuficientes"
L.ROOM.SEND_CHIP_NOT_IN_SEAT = "Por favor,siéntese para poder regalar fichas"
L.ROOM.SEND_CHIP_NOT_ENOUGH_CHIPS = "Falta de dinero"
L.ROOM.SEND_CHIP_TOO_OFTEN = "Por favor, inténtalo más tarde"
L.ROOM.SEND_CHIP_TOO_MANY = "Se ha llegado al limite"
L.ROOM.SEND_HDDJ_IN_MATCH_ROOM_MSG = "En Torneos no se puede enviar artículos relacionarse"
L.ROOM.SEND_HDDJ_NOT_IN_SEAT = "Por favor,siéntese para poder enviar artículos relacionarse"
L.ROOM.SEND_HDDJ_NOT_ENOUGH = "Ya no tiene suficientes artículos, puede hacer su compra en la tienda"
L.ROOM.SEND_HDDJ_FAILED = "Error al enviar artículos relacionarse, por favor vuelve a intentar"
L.ROOM.SEND_EXPRESSION_MUST_BE_IN_SEAT = "Por favor,siéntese para poder enviar la emotición"
L.ROOM.SEND_CHAT_MUST_BE_IN_SEAT = "Por favor,siéntate primero y inténtalo otra vez"
L.ROOM.CHAT_FORMAT = "{1}: {2}"
L.ROOM.ROOM_INFO = "{1} {2}:{3}/{4}"
L.ROOM.NORMAL_ROOM_INFO = "{1}({2} jugadores)  No.:{3}  Ciega:{4}/{5}"
L.ROOM.PRIVATE_ROOM_INFO = "Habitación privada({1}人)  No.:{2}  Ciega:{3}/{4}"
L.ROOM.PRIVTE_INFO = "Tiempo Restante: {1}"
L.ROOM.SEND_BIG_LABA_MESSAGE_FAIL = "Error al enviar altavoz"
L.ROOM.NOT_ENOUGH_LABA = "Falta de altavoz"
L.ROOM.CHAT_MAIN_TAB_TEXT = {
    "Mensajes",
    "Historial de chat"
}
L.ROOM.USER_CARSH_REWARD_DESC = "Obtiene {1} fichas como la subvención de bancarrota y solo tiene tres oportunidades de obtenerla."
L.ROOM.USER_CARSH_BUY_CHIP_DESC = "También puede comprar de inmediato, ganar o perder es solo una cuestión de un instante"
L.ROOM.USER_CARSH_REWARD_COMPLETE_DESC = "Ha recibido todas las subvenciones de bancarrota, puede comprar más fichas en la tienda o recoger fichas gratis si inicia sesión todos los días."
L.ROOM.USER_CARSH_REWARD_COMPLETE_BUY_CHIP_DESC = "En la vida jamás se pierde, simplemente se gana o se aprende para después poder ganar algo mejor. Compra unas fichas y volvemos a la batalla"
L.ROOM.WAIT_NEXT_ROUND = "Por favor espere la próxima partida"
L.ROOM.LOGIN_ROOM_FAIL_MSG = "Falló al entrar en la habitación"
L.ROOM.BUYIN_ALL_POT= "Total del premio"
L.ROOM.BUYIN_3QUOT_POT = "3/4 del pozo del premio"
L.ROOM.BUYIN_HALF_POT = "1/2 del pozo del premio"
L.ROOM.BUYIN_TRIPLE = "X3"
L.ROOM.CHAT_TAB_SHORTCUT = "Chat rápido"
L.ROOM.CHAT_TAB_HISTORY = "Historial de chat"
L.ROOM.INPUT_HINT_MSG = "Mensaje de texto"
L.ROOM.INPUT_ALERT = "Por favor ingrese un mensaje válido"
L.ROOM.CHAT_SHIELD = "Ha bloqueado el chat de {1}"
L.ROOM.CHAT_SHORTCUT = {
  "¡Hola! ", 
  "Dése prisa",
  "¡ALL IN!",
  "Calma, calma...",
  "Uy, qué fuerte",
  "El tormento soy yoooo",
  "Muchas gracias por el regalo",
  "Qué interesante jugar contigo",
  "Ficha, ficha, ficha",
  "No se si tengo mala suerte, o tengo muy mala suerte",
  "¡Ya dejen de pelear!",
  "¿Tienes novio/a?",
  "Mala suerte, mejor me voy a la otra habitación",
  "Soy nuevo, me cuidan porfa",
  "Buena suerte hoy",
  "Regalame dinero por favor",
  "IGUALAR! ALL-IN！",
  "Compra unas fichas y seguimos",
  "¿Puedo ver tus cartas?",
  "Disculpe, ya me voy"
}
L.ROOM.VOICE_TOOSHORT = "El tiempo es demasiado corto"
L.ROOM.VOICE_TOOLONG = "El tiempo es demasiado largo"
L.ROOM.VOICE_RECORDING = "Está grabando, presiona hacia arriba para cancelar"
L.ROOM.VOICE_CANCELED = "Cancelado"
L.ROOM.VOICE_TOOFAST = "Por favor, inténtalo más tarde"
--荷官反馈
L.ROOM.DEALER_SPEEK_ARRAY = {
    "¡Gracias, {1}! ¡Te deseo lo mejor!",
    "¡Gracias, {1}! ¡La mejor de las suertes!",
    "Gracias a {1}",
}
--买入弹框
L.ROOM.BUY_IN_TITLE = "Apostar"
L.ROOM.BUY_IN_BALANCE_TITLE = "Saldos de su cuenta:"
L.ROOM.BUY_IN_MIN = "Cantidad mín"
L.ROOM.BUY_IN_MAX = "Cantidad máx"
L.ROOM.BUY_IN_AUTO = "Apostar auto. cuando menos de la ciega grande"
L.ROOM.BUY_IN_AUTO_MIN = "Apostar auto. cuando menos de la cantidad min"
L.ROOM.BUY_IN_BTN_LABEL = "Apostar para sentarse"
L.ROOM.ADD_IN_TITLE = "Añadir fichas"
L.ROOM.ADD_IN_BTN_LABEL = "Apostar"
L.ROOM.ADD_IN_BTN_TIPS = "Por favor,siéntese para añadir más fichas"
L.ROOM.ADD_IN_BTN_TIPS_2 = "Falta de ficha, no puede añadir más"
L.ROOM.ADD_IN_BTN_TIPS_3 = "No se puede subir las apuestas porque se ha llegado al límite"
L.ROOM.ADD_IN_SUC_TIPS = "Listo, se va a añadir {1} ficha(s) más en la próxima partida"
L.ROOM.BACK_TO_HALL = "Volver a Lobby"
L.ROOM.CHANGE_ROOM = "Nueva mesa"
L.ROOM.SETTING = "Ajustes"
L.ROOM.SIT_DOWN_NOT_ENOUGH_MONEY = "La cantidad de las fichas es menor que el mínimo de esta habitación, puede cambiar la mesa o agregar más fichas"
L.ROOM.AUTO_CHANGE_ROOM = "Nueva mesa"
L.ROOM.USER_INFO_ROOM = "Info personal"
L.ROOM.CHARGE_CHIPS = "Apostar más"
L.ROOM.ENTERING_MSG = "Cargando...Por favor espere.\nLos ganadores deben tener la habilidad y el coraje"
L.ROOM.OUT_MSG = "Saliendo...Por favor espere"
L.ROOM.CHANGING_ROOM_MSG = "Cambiando.."
L.ROOM.CHANGE_ROOM_FAIL = "Error al cambiar la habitación, ¿quiere volver a intentar?"
L.ROOM.STAND_UP_IN_GAME_MSG = "Aún está en la partida, ¿Está seguro de que quiere levantarse?"
L.ROOM.LEAVE_IN_GAME_MSG = "Aún está en la partida, ¿Está seguro de que quiere salir?"
L.ROOM.RECONNECT_MSG = "Conectando..."
L.ROOM.OPR_STATUS = {
    "Retirarse",
    "ALL IN",
    "Igualar",
    "Igualar {1}",
    "Ciega pequeña",
    "Ciega grande",
    "Ver",
    "Subir {1}",
    "Subir",
}
L.ROOM.AUTO_CHECK = "Pasar auto."
L.ROOM.AUTO_CHECK_OR_FOLD = "Pasar o retirarse"
L.ROOM.AUTO_FOLD = "Retirarse auto."
L.ROOM.AUTO_CALL_ANY = "Igualar cualquier apuesta"
L.ROOM.FOLD = "Retirarse"
L.ROOM.ALL_IN = "ALL IN"
L.ROOM.CALL = "Igualar"
L.ROOM.CALL_NUM = "Igualar {1}"
L.ROOM.SMALL_BLIND = "Ciega pequeña"
L.ROOM.BIG_BLIND = "Ciega grande"
L.ROOM.RAISE = "Subir"
L.ROOM.RAISE_NUM = "Subir {1}"
L.ROOM.CHECK = "Ver"
L.ROOM.BLIND3 = "3x Ciega grande"
L.ROOM.BLIND4 = "4x Ciega grande"
L.ROOM.TABLECHIPS = "1x El pozo"
L.ROOM.TIPS = {
    "Consejos: los usuarios invitados pueden hacer clic en sus avatares o el icono de género para cambiar el avatar y el sexo",
    "Experiencia: cuando tus cartas son más pequeñas que las del otro jugador, vas a perder todas tus fichas",
    "Maestro: Todos los maestros, antes de jugar en Texas, deben ser un novato del juego de Texas",
    "Apuesta cuando tienes buenas cartas, toma la iniciativa.",
    "Presta atención a los oponentes y cuídate de su engaño.",
    "A jugar con ímpetu, no temas a nadie.", 
    "Maneja bien tu estado de ánimo, gana lo que debes ganar",
    "Los usuarios invitados pueden personalizar sus avatares.",
    "Consejos: En la configuración puede establecer si se sienta automáticamente.",
    "Consejos: En la configuración puede establecer la vibración",
    "Aguantar todo es para All In",
    "El impulso es un demonio, debe acostumbrar a los cambios y siempre muestra una actitud elástica, la fortuna golpeará a la puerta.",
    "Cambia el asiento si no tiene buena suerte. ",
    "Perder la apuesta no es horrible. Perder la confianza es lo más horrible.",
    "No puedes controlar ganar o perder, pero puedes controlar cuánto ganas o pierdes.",
    "Use Artículo Relacionarse para despertar a los jugadores que no responden.",
    "¿Buena suerte o mala suerte? No importa, pero el conocimiento te acompañará toda tu vida",
    "Asustar es un gran truco para la victoria, pero debe ser selectivo",
    "Las apuestas están ligadas al pozo. No sólo mires los números.",
    "All In es una táctica. No es fácil.",
    








    
}
L.ROOM.SHOW_HANDCARD = "Mostrar las cartas privadas"
L.ROOM.SERVER_UPGRADE_MSG = "Actualizando, espere por favor..."
L.ROOM.KICKED_BY_ADMIN_MSG = "Fue expulsado de la habitación por el administrador"
L.ROOM.KICKED_BY_USER_MSG = "Fue expulsado de la habitación por el usuario {1}"
L.ROOM.TO_BE_KICKED_BY_USER_MSG = "Fue expulsado de la habitación por el usuario {1}, volverá automáticamente a Lobby al terminar esta partida"
L.ROOM.BET_LIMIT = "Falló al apostar, su apuesta de cada partida no puede exceder en la máxima apuesta 100M"
L.ROOM.BET_LIMIT_1 = "Falló al apostar, su apuesta de cada partida no puede exceder en la máxima apuesta {1}"
L.ROOM.NO_BET_STAND_UP = "Se levantó automáticamente porque no tenía ninguna acción en las 3 partidas"
L.ROOM.PRE_BLIND = "前注"

T = {}
L.ROOM.SIT_DOWN_FAIL_MSG = T
T["IP_LIMIT"] = "Falló al sentarse, no puede sentarse el mismo IP"
T["SEAT_NOT_EMPTY"] = "Falló al sentarse, la mesa ya tiene jugadores sentados."
T["TOO_RICH"] = "Falló al sentarse, con tantas fichas mejor va a jugar en otros campos"
T["TOO_POOR"] = "Falló al sentarse, no tiene suficientes fichas para entrar en las habitaciones de veterano"
T["NO_OPER"] = "Se levantó automáticamente porque no tenía ninguna acción en la partida, ya más de 3 veces. Pero puede volver a sentarse"
L.ROOM.SERVER_STOPPED_MSG = "El juego está en mantenimiento, espere con paciencia por favor"
L.ROOM.GUIDEHEIGHT = "Se puede ganar más en campo {1}"
L.ROOM.GUIDELOW = "Se puede reducir pérdidas en campo {1}"
L.ROOM.CARD_POWER_DESC = [[
El indicador de potencia se basa únicamente en las 2 cartas privadas y el pozo,es solo como referencia.

Se puede usar gratuitamente en la Partida Primaria. Si es VIP, puede usarlo sin restricción en cualquier campo.

Puede desactivar la forma predeterminada manualmente, también puede volver a activarla desde la configuración.
]]

--STORE
L.STORE.TOP_LIST = {
    "Fichas",
    "Diamantes",
    "Artículos",
    "VIP"
}
L.STORE.NOT_SUPPORT_MSG = "No se admite pagar con su cuenta"
L.STORE.PURCHASE_SUCC_AND_DELIVERING = "El pago se ha completado correctamente, su orden será enviada pronto, por favor espere..."
L.STORE.PURCHASE_CANCELED_MSG = "Pago cancelado"
L.STORE.PURCHASE_FAILED_MSG = "Este pago no se puede completar, vuelve a intentarlo por favor"
L.STORE.PURCHASE_FAILED_MSG_2 = "Por favor ingresa el número de tarjeta y la contraseña"
L.STORE.PURCHASE_FAILED_MSG_3 = "Había usado esta tarjeta"
L.STORE.PURCHASE_FAILED_MSG_4 = "Tarjeta no válida"
L.STORE.DELIVERY_FAILED_MSG = "Ha ocurrido un problema con la red, el sistema volverá a intentarlo la próxima vez cuando entra en la tienda"
L.STORE.DELIVERY_SUCC_MSG = "Se ha enviado su orden con éxito, gracias por su compra"
L.STORE.TITLE_STORE = "Tienda"
L.STORE.TITLE_CHIP = "Fichas"
L.STORE.TITLE_PROP = "Artículo Relacionarse"
L.STORE.TITLE_MY_PROP = "Mis artículos"
L.STORE.TITLE_HISTORY = "Historial de compras"
L.STORE.RATE_DIAMONDS = "1{2}={1} Diamante(s)"
L.STORE.RATE_CHIP = "1{2}={1} Ficha(s)"
L.STORE.RATE_PROP = "1{2}={1} Artículo(s)"
L.STORE.FORMAT_DIAMONDS = "{1} Diamante(s)"
L.STORE.FORMAT_CHIP = "{1} Ficha(s)"
L.STORE.FORMAT_PROP = "{1} Artículo(s)"
L.STORE.FORMAT_HDDJ = "{1} Artículo(s) Relacionarse"
L.STORE.FORMAT_DLB = "{1} Altavoz(ces)"
L.STORE.FORMAT_LPQ = "{1} Cupon(es) de regalo"
L.STORE.FORMAT_DHQ = "{1} Cupon(es) canjeable(s)"
L.STORE.FORMAT_MYB = "{1} Moneda(s) Hormiga"
L.STORE.HDDJ_DESC = "Se puede usar {1} Artículo(s) Relacionarse en la partida"
L.STORE.DLB_DESC = "Se puede enviar {1} mensaje(s) en el mundo"
L.STORE.BUY = "Comprar"
L.STORE.USE = "Usar"
L.STORE.BUY_DESC = "Comprar {1}"
L.STORE.RECORD_STATUS = {
    "Pedido Realizado",
    "Pedido Enviado",
    "Reembolsado",
}
L.STORE.NO_PRODUCT_HINT = "No hay mercaderías"
L.STORE.NO_BUY_HISTORY_HINT = "No hay historial de compras"
L.STORE.BUSY_PURCHASING_MSG = "Está comprando, espere por favor..."
L.STORE.CARD_INPUT_SUBMIT = "TOP UP"
L.STORE.BLUEPAY_CHECK = "¿Está seguro de que desea comprar {2} con {1}?"
L.STORE.GENERATE_ORDERID_FAIL = "Solicitud no procesada, vuelve a intentarlo por favor"
L.STORE.INPUT_NUM_EMPTY = "¡Por favor ingresa de nuevo el número de tarjeta!"
L.STORE.INPUT_PASSWORD_EMPTY = "¡Por favor ingresa de nuevo la contraseña!"
L.STORE.INPUT_NUM_PASSWORD_EMPTY = "¡La contraseña o el número de tarjeta está vació, por favor llena todos los datos!"
L.STORE.INPUT_CRAD_NUM = "Por favor ingresa el número de tarjeta"
L.STORE.INPUT_CRAD_PASSWORD = "Por favor ingresa la contraseña"
L.STORE.QUICK_MORE = "Más información"
L.STORE.REAL_TAB_LIST = {
    "Cupón Regalo",
    "Cupón Canjeable",
    "Moneda Hormiga"
}
L.STORE.REAL_ADDRESS_BTN = "Dirección"
L.STORE.REAL_EXCHANGE_BTN = "Canjear"
L.STORE.ADDRESS_POP_TITLE = "Editar dirección"
L.STORE.REAL_TIPS = "Asegúrese de ingresar su nombre real y la información de contacto para ponerse en contacto cuando obtenga premio."
L.STORE.REAL_TIPS_2 = "Por favor completa la información"
L.STORE.REAL_SAVE = "Guardar"
L.STORE.REAL_TITLES = {
    "Consignatario:",
    "Teléfono:",
    "Dirección",
    "Cód. postal:",
    "Correo electrónico:",
}
L.STORE.REAL_PLACEHOLDER = {
    "Nombre y Apellidos",
    "Teléfono",
    "Asegúrese de ingresar la dirección completa, incluye la provincia, la ciudad, la calle, el número del apto y el número de casa",
    "Cód. postal",
    "Correo electrónico",
}
L.STORE.EXCHANGE_REAL_SUCCESS = "¡Felicidades! Ha cambiado {1} con éxito, se lo enviaremos lo antes posible."
L.STORE.EXCHANGE_REAL_FAILED_1 = "No tiene suficiente {1}, necesita {3} para cambiar {2}"
L.STORE.EXCHANGE_REAL_FAILED_2 = "¡Falló al canjear, vuelve a intentarlo!"
L.STORE.TAB_LIST = {
    "Tienda",
    "Canjear",
}
L.STORE.CASH_CARD_TITLE = "Canjear la tarjeta de prepago"
L.STORE.CASH_CARD_TIPS_1 = "Ingrese su número de teléfono, debe ser real, verdadero y efectivo.\nLe enviaremos la información de la tarjeta de recarga a su teléfono móvil."
L.STORE.CASH_CARD_TIPS_2 = "Por favor ingrese el número de teléfono"
L.STORE.CASH_CARD_TIPS_3 = "Por favor ingrese el número de teléfono"
L.STORE.CASH_CARD_TIPS_4 = "El número de teléfono que ingresó es {1} - {2} - {3}, le enviaremos la información de la tarjeta de prepago a este número."

--vip
L.VIP.SEND_EXPRESSIONS_FAILED = "Tienes menos de 5,000 fichas, por el momento no puedes usar la emotición VIP"
L.VIP.SEND_EXPRESSIONS_TIPS = "Todavía no eres un usuario VIP. Para usar la emotición se necesita descontar las fechas correspondientes. ¡Hazte VIP y úsalo gratis, también puedes disfrutar muchos privilegios y descuentos!"
L.VIP.BUY_PROP = "Comprar artículos"
L.VIP.OPEN_VIP = "Ser VIP"
L.VIP.COST_CHIPS = "Gasta {1} fichas"
L.VIP.LIST_TITLE = {
    "Precio",
    -- "Tarjeta Expulsar",
    "Indicador vip",
    "Regalo vip",
    "Artículo vip",
    "Emotición vip",
    -- "Descuento habitación privada",
    -- "Oferta bancarrota",
    -- "Experiencia",
    "Inicia sesión todos los días",
    "Obtén fichas enseguida",
}
L.VIP.NOT_VIP = "No comprado"
L.VIP.AVAILABLE_DAYS = "Quedan {1} día(s)"
L.VIP.OPEN_BTN = "Comprar {1} diamantes"
L.VIP.AGAIN_BTN = "Comprar {1} diamantes más"
L.VIP.CONTINUE_BUY = "Seguir comprando"
L.VIP.BROKE_REWARD = "Se regala {1}% más, {2} veces al día"
L.VIP.LOGINREWARD = "{1} x 31 días"
L.VIP.PRIVATE_SALE = "{1}% de descuento"
L.VIP.SEND_PROPS_TIPS_1 = "Uso gratis del artículo relacionarse para VIP"
L.VIP.SEND_PROPS_TIPS_2 = "Los artículos relacionarse se han agotado, puedes gastar diamantes para seguir usando los artículos. ¡Hazte VIP y úsalo gratis, también puedes disfrutar muchos privilegios y descuentos!"
-- L.VIP.KICK_CARD = "Tarjeta Expulsar"
-- L.VIP.KICK_SUCC = "Expulsado con éxito, el jugador será expulsado de la mesa después de  terminar esta partida"
-- L.VIP.KICK_FAILED = "Falló al expulsar, vuelve a intentarlo"
-- L.VIP.KICKED_TIP = "Perdón, el jugador {1} te ha expulsado, vas a salir de la mesa después de terminar esta partida"
-- L.VIP.KICKER_TOO_MUCH = "Ha alcanzado el número máximo de veces, por favor, siga las reglas, está prohibido expulsión intencional"
-- L.VIP.KICKED_ENTER_AGAIN = "Has sido expulsado de esta habitación y no puedes ingresar en 20 minutos. Puedes elegir otra habitación o comenzar de nuevo rápidamente."
L.VIP.BUY_SUCCESS = "¡Felicidades, ya eres VIP!"
L.VIP.BUY_FAILED = "Falló al comprar VIP, vuelve a intentarlo"
L.VIP.BUY_FAILED_TIPS = "¡No tiene suficientes diamantes, por favor compra diamantes primero!"
L.VIP.BUY_TIPS_1 = "Va a gastar {2} para comprar {1}"
L.VIP.BUY_TIPS_2 = "Todavía es VIP{1}, si elige \"Seguir comprando\", abandonará todos los privilegios de VIP{2} y será VIP{3}, ¿está seguro?"
L.VIP.BUY_TIPS_3 = "Ahora es VIP{1}, si quiere prolongar el VIP {2} día(s), le costará {3} diamantes"
L.VIP.LEVEL_NAME = {
    "Lord",
    "Nobleza",
    "Artistocracia",
    "Hidalguía",
}
L.VIP.NO_VIP_TIPS = "Todavía no es VIP. ¿Si quiere ser VIP y disfruta los privilegios y descuentos?"
L.VIP.CARD_POWER_TIPS = "Todavía no es VIP. Si quiere"
L.VIP.CARD_POWER_OPEN_VIP = "activarlo enseguida"
L.VIP.VIP_AVATAR = "VIP Avatar GIF"
L.VIP.NOR_AVATAR = "Avatar normal"
L.VIP.SET_AVATAR_SUCCESS = "Avatar agregado"
L.VIP.SET_AVATAR_FAILED_1 = "Falló al poner avatar, vuelve a intentarlo"
L.VIP.SET_AVATAR_FAILED_2 = "Su nivel de VIP no es suficiente, por favor selecciona otros avatares"
L.VIP.SET_AVATAR_TIPS = [[
Todavía no es un usuario VIP, solo puede ver la vista previa del avatar, debe ser VIP para usar el avatar exclusivo para VIP. Después de ser VIP también puede recibir una gran cantidad de fichas gratuitas y muchos privilegios de recarga.

¿Quiere ser VIP enseguida？
]]

-- login reward
L.LOGINREWARD.FB_REWARD_TIPS    = "iniciar sesión con facebook para recoger"
L.LOGINREWARD.FB_REWARD         = "{1}x200%={2}"
L.LOGINREWARD.REWARD_BTN        = "Recoger {1}"
L.LOGINREWARD.GET_REWARD_FAILED = "¡Falló al inscribirse, vuelve a intentarlo!"
L.LOGINREWARD.VIP_REWARD_TIPS   = "Recompensa inicio VIP"

-- USERINFO MODULE
L.USERINFO.MY_PROPS_TIMES = "X{1}"
L.USERINFO.EXPERIENCE_VALUE = "{1}/{2}"
L.USERINFO.BOARD_RECORD_TAB_TEXT = {
    "Partidas regulares",
    "Sit&Go",
    "Campeonato",
}
L.USERINFO.BOARD_SORT = {
    "Ordenar por tiempo",
    "Ordenar por éxito",
}
L.USERINFO.NO_RECORD = "No hay record"
L.USERINFO.LAST_GAME = "Anterior"
L.USERINFO.NEXT_GAME = "Siguiente"
L.USERINFO.PLAY_TOTOAL_COUNT = "Partida:"
L.USERINFO.PLAY_START_RATE = "VPIP%:"
L.USERINFO.WIN_TOTAL_RATE = "Victoria%:"
L.USERINFO.SHOW_CARD_RATE = "Muestra%: "
L.USERINFO.MAX_CARD_TYPE = "Mejor mano"
L.USERINFO.JOIN_MATCH_NUM = "Partidas jugadas"
L.USERINFO.GET_REWARD_NUM = "Veces de obtener premio"
L.USERINFO.MATCH_BEST_SCORE = "Mejor resultado del campeonato"
L.USERINFO.MY_CUP = "Trofeo"
L.USERINFO.NO_CHECK_LINE = "No completado"
L.USERINFO.BOARD = "Record de partidas"
L.USERINFO.MY_PACK = "Mochila"
L.USERINFO.ACHIEVEMENT_TITLE = "Logros"
L.USERINFO.REAL_STORE = "Canjear"
L.USERINFO.LINE_CHECK_NO_EMPTY = "¡Por favor ingresa de nuevo el id de Line!"
L.USERINFO.NICK_NO_EMPTY = "¡Por favor ingresa de nuevo el nombre!"
L.USERINFO.LINE_CHECK_ONECE = "Solo se puede pedir la verificación una vez al día"
L.USERINFO.LINE_CHECK_FAIL = "¡Fallo al pedir la verificación, vuelve a intentarlo!"
L.USERINFO.LINE_CHECK_SUCCESS = "Verificado"
L.USERINFO.GET_BOARD_RECORD_FAIL = "!Error al obtener la información del éxito, cierre la ventana y vuelve a intentarlo!"
L.USERINFO.PACKAGE_INFO = {
    {
        title = "Artículos relacionarse",
        desc = "Artículos que se pueden lanzar a otros jugadores en la mesa",
    },
    {
        title = "Altavoz",
        desc = "Usarlo para hablar en todo el servidor",
    },
    {
        title = "Cupón Canjeable",
        desc = "Canjearlo para obtener regalo correspondiente",
    },
    {
        title = "Cupón Regalo",
        desc = "Usarlo para obtener regalo",
    },
    {
        title = "Moneda Hormiga",
        desc = "Es un tipo de moneda digital muy valiosa",
    },
}
L.USERINFO.MARK_TEXT = {
    "El Pagador",
    "El Maníaco",
    "El TAG",
    "Tight débil",
    "La Roca",
    "Loose-agresivo",
    "Loose-pasivo",
    "Personalización",
}
L.USERINFO.MARK_TITLE = "Marcar"
L.USERINFO.MARK_TIPS = "Toca para marcar"
L.USERINFO.MARK_SUCCESS = "Marcado"
L.USERINFO.MARK_FAIL = "Falló al marcar, vuelve a intentarlo"
L.USERINFO.MARK_NO_EMPTY = "Por favor vuelve a marcar"
L.USERINFO.UPLOAD_PIC_NO_SDCARD = "No se puede agregar avatar sin tarjeta SD"
L.USERINFO.UPLOAD_PIC_PICK_IMG_FAIL = "Falló al obtener la imagen"
L.USERINFO.UPLOAD_PIC_UPLOAD_FAIL = "Falló al agregar el avatar, vuelve a intentarlo por favor"
L.USERINFO.UPLOAD_PIC_IS_UPLOADING = "Agregando, espere un momento..."
L.USERINFO.UPLOAD_PIC_UPLOAD_SUCCESS = "Avatar agregado"
L.USERINFO.CHOOSE_COUNTRY_TITLE = "选择国家"
L.USERINFO.COUNTRY_LIST = {
    {
        title = "Asia",
        list = {
            "Emiratos Arabes Unidos",
            "Macau",
            "Pakistán",
            "Filipinas",
            "Kazajstán",
            "Corea",
            "Laos",
            "Malasia",
            "Myanmar",
            "Japon",
            "Taiwán",
            "Tailandia",
            "Hong Kong",
            "Singapur",
            "Israel",
            "India",
            "Indonesia",
            "Vietnam",
            "China",
        }
    },
    {
        title = "América del Norte",
        list = {
            "Panama",
            "Costa rica",
            "Cuba",
            "Canada",
            "Estados Unidos",
            "Mexico",
        }
    },
    {
        title = "Sudamérica",
        list = {
            "Argentina",
            "Paraguay",
            "Brasil",
            "Colombia",
            "Peru",
            "Venezuela",
            "Uruguayo",
            "Chile",
        }
    },
    {
        title = "Europa",
        list = {
            "Austria",
            "Bielorrusia",
            "Bélgica",
            "Polonia",
            "Alemania",
            "Rusia",
            "Francia",
            "Finlandia",
            "Países Bajos",
            "Republica checa",
            "Croacia",
            "Lituania",
            "Rumania",
            "Monaco",
            "Portugal",
            "Suecia",
            "Suiza",
            "Serbia",
            "Eslovenia",
            "Ucrania",
            "España",
            "Grecia",
            "Hungría",
            "Italia",
            "Reino Unido",
        }
    },
    {
        title = "Oceanía",
        list = {
            "Australia",
            "Nueva zelanda",
        }
    },
    {
        title = "Africa",
        list = {
            "Congo",
            "Ghana",
            "Zimbabwe",
            "Sudáfrica",
            "Nigeria",
            "Senegal",
        }
    },
}

-- FRIEND MODULE
L.FRIEND.TITLE = "Amigos"
L.FRIEND.NO_FRIEND_TIP = "Todavía no tiene amigos"
L.FRIEND.SEND_CHIP = "Regalar fichas"
L.FRIEND.RECALL_CHIP = "Hacer volver +{1}"
L.FRIEND.ONE_KEY_SEND_CHIP = "1-clic a regalar"
L.FRIEND.ONE_KEY_RECALL = "1-clic a hacer volver"
L.FRIEND.ONE_KEY_SEND_CHIP_TOO_POOR = "No tiene suficiente ficha, por favor añade más fichas primero y vuelve a intentarlo"
L.FRIEND.ONE_KEY_SEND_CHIP_CONFIRM = "¿Está seguro de que desea regalar un total de {2} fichas a {1} amigo(s)?"
L.FRIEND.ADD_FULL_TIPS = "El sistema borrará a los amigos que ya dejaron el juego hace mucho tiempo porque se ha llegado al límite de {1}"
L.FRIEND.SEND_CHIP_WITH_NUM = "Regalar {1} fichas"
L.FRIEND.SEND_CHIP_SUCCESS = "Ha regalado {1} fichas a su amigo"
L.FRIEND.SEND_CHIP_PUSH = "¡{1} te ha regalado 10K fichas, ven a recoger!"
L.FRIEND.SEND_CHIP_TOO_POOR = "No tiene suficiente ficha, por favor compra más fichas en la tienda y vuelve a intentarlo"
L.FRIEND.SEND_CHIP_COUNT_OUT = "Hoy le ha regalado fichas a este amigo, volverá a intentarlo mañana"
L.FRIEND.SELECT_ALL = "Todos"
L.FRIEND.SELECT_NUM = "{1} amigos"
L.FRIEND.DESELECT_ALL = "Cancelar"
L.FRIEND.SEND_INVITE = "Invitar"
L.FRIEND.INVITE_SENDED = "Invitado"
L.FRIEND.INVITE_SUBJECT = "¡A ti te va a encantar!"
L.FRIEND.CALL_FRIEND_TO_GAME = "¡Ven, es absolutamente perfecto este juego!"
L.FRIEND.INVITE_CONTENT = "Te recomiendo un juego de póquer emocionante y divertido. Te daré un paquete con 150 mil de bonificación. ¡Regístrate ya, ven a jugar conmigo!"..appconfig.SAHRE_URL
L.FRIEND.INVITE_SELECT_TIP = "Has seleccionado {1} amigos. Envía la invitación para obtener {2} fichas como regalos"
L.FRIEND.INVITE_SELECT_TIP_1 = "Has seleccionado"
L.FRIEND.INVITE_SELECT_TIP_2 = "amigos. Envía la invitación para obtener"
L.FRIEND.INVITE_SELECT_TIP_3 = "fichas"
L.FRIEND.INVITE_SUCC_TIP = "Has obtenido {1} fichas por enviar la invitación"
L.FRIEND.INVITE_SUCC_FULL_TIP = "Invitación enviada. Hoya ha obtenido {1} regalos"
L.FRIEND.INVITE_FULL_TIP = "La invitación de Facebook ha llegado al límite. Puede seleccionar el código de invitación para invitar y obtener más regalos"
L.FRIEND.RECALL_SUCC_TIP = "Has obtenido {1} regalos, podrás obtener {2} fichas más si tu amigo inicie sesión"
L.FRIEND.RECALL_FAILED_TIP = "Falló al enviar, vuelve a intentarlo por favor"
L.FRIEND.INVITE_LEFT_TIP = "¡Aún puedes invitar {1} amigo(s)!"
L.FRIEND.CANNOT_SEND_MAIL = "La cuenta no ha vinculado con el correo electrónico. ¿Quiere ir a vincularlo?"
L.FRIEND.CANNOT_SEND_SMS = "¡Perdón! No se puede enviar mensajes."
L.FRIEND.MAIN_TAB_TEXT = {
    "Seguidos",
    "Seguidores",
    "Más amigos",
}
L.FRIEND.INVITE_EMPTY_TIP = "Por favor selecciona amigos primero"
L.FRIEND.TOO_MANY_FRIENDS_TO_ADD_FRIEND_MSG = "Tu amigo ha llegado al límite de {1}. Borra unos de ellos y vuelve a agregarlo"
L.FRIEND.SEARCH_FRIEND = "Por favor ingresa el nombre de amigo de FB"
L.FRIEND.INVITE_REWARD_TIPS_1 = "Invita"
L.FRIEND.INVITE_REWARD_TIPS_2 = "amigos para obtener"
L.FRIEND.INVITE_REWARD_TIPS_3 = ",más amigos más regalos. Podrás obtener más si ellos inicien sesión"
L.FRIEND.SEARCH = "Buscar"
L.FRIEND.CLEAR = "Borrar"
L.FRIEND.INPUT_USER_ID = "Toca para ingresar la ID del jugador"
L.FRIEND.INPUT_USER_ID_NO_EXIST = "La ID que ingresó no existe. Confirme y vuelva a ingresarla."
L.FRIEND.NO_SEARCH_SELF = "No se puede buscar su ID, por favor vuelva a ingresar"
L.FRIEND.NO_LINE_APP = "No ha instalado la aplicación Line, invite a los amigos por otros métodos"
L.FRIEND.INVITE_REWARD_TIPS = "Podrá recibir un súper paquete regalo al llegar la meta, haga clic en el paquete para ver los detalles.\nHa invitado a {1} amigo(s) y ha obtenido {2} fichas."
L.FRIEND.INVITE_FB_FRIEND_TITLE = "Invitar amigos de FB"
L.FRIEND.INVITE_FB_FRIEND_CONTENT = "Envíe todos los días para obtener {1} fichas.\nSi los amigos han recibido la invitación podrá recibir {2} fichas más"
L.FRIEND.INVITE_CODE_TITLE = "Código de invitación"
L.FRIEND.INVITE_CODE_CONTENT = "Si los amigos han recibido la invitación podrá recibir {1} fichas\nLos amigos de sus amigos podrán recibir {2} fichas"
L.FRIEND.GET_REWARD_TIPS_1 = "¡Felicidades, ha obtenido el regalo de invitación!"
L.FRIEND.GET_REWARD_TIPS_2 = "¡Todavía faltan {1} para recoger la recompensa, haga clic en el botón para invitar más amigos!"
L.FRIEND.ROOM_INVITE_TITLE = "Invitar a jugar"
L.FRIEND.ROOM_INVITE_SUCCTIPS = "La invitación ha sido enviada, espere con paciencia"
L.FRIEND.ROOM_INVITE_TAB = {
    "En línea",
    "Amigos",
}
L.FRIEND.ROOM_INVITE_TIPS_CON = "{1} te invita a {2}{3} a jugar"
L.FRIEND.ROOM_INVITE_PLAY_DES = [[
Haga clic en el botón abajo para enviar el enlace a un amigo o un grupo para invitar a todos a jugar juntos.

El amigo puede hacer clic después de instalar la aplicación o actualizar la página para ingresar directamente a la habitación.
]]

-- RANKING MODULE
L.RANKING.TITLE = "Ranking"
L.RANKING.TRACE_PLAYER = "Seguir"
L.RANKING.GET_REWARD_BTN = "Recoger"
L.RANKING.NOT_DATA_TIPS = "Todavía no hay datos"
L.RANKING.NOT_IN_CHIP_RANKING = "Su ranking: >20. Todavía está fuera del ranking. ¡Ánimo!"
L.RANKING.IN_RANKING = "Su ranking: {1}. ¡Ánimo!"
L.RANKING.IN_RANKING_NO_1 = "Su ranking: 1. ¡Invencible pero solo! "
L.RANKING.MAIN_TAB_TEXT = {
    "Ranking amigo",
    "Ranking Mundial",
}
L.RANKING.SUB_TAB_TEXT_FRIEND = {
    "Ranking Ganancia Ayer",
    "Ranking Riqueza",
}
L.RANKING.SUB_TAB_TEXT_GLOBAL = {
    "Ranking Ganancia Ayer",
    "Ranking Riqueza",
}

-- SETTING MODULE
L.SETTING.TITLE = "Configuración"
L.SETTING.NICK = "Nick"
L.SETTING.LANGUAGE = "Idioma"
L.SETTING.EXCHANGE = "Código"
L.SETTING.LOGOUT = "Cerrar sesión"
L.SETTING.FB_LOGIN = "Inicia sesión +19999"
L.SETTING.SOUND_VIBRATE = "Sonidos y vibración"
L.SETTING.SOUND = "Sonido"
L.SETTING.BG_SOUND = "Tono de fondo"
L.SETTING.CHATVOICE = "Tono de mensaje"
L.SETTING.VIBRATE = "Vibración"
L.SETTING.AUTO_SIT = "Auto Sentarse"
L.SETTING.AUTO_BUYIN = "Apostar automáticamente si es menos de la ciega grande"
L.SETTING.CARD_POWER = "Indicador"
L.SETTING.APP_STORE_GRADE = "Regalanos cinco estrellas si te ha gustado la APP"
L.SETTING.CHECK_VERSION = "Actualización"
L.SETTING.CURRENT_VERSION = "Versión actual: V{1}"
L.SETTING.ABOUT = "Acerca de"
L.SETTING.PUSH_NOTIFY = "Notificaciones"
L.SETTING.PUSH_TIPS = [[
El sistema regalará aleatoriamente una gran cantidad de fichas gratuitas todos los días, por orden de llegada hasta agotar disponibilidad, puede toca para obtener después de activarlo.

Haga clic en el botón Confirmar, encuentre la notificación—Activarla, y puede recoger código gratis.
]]

--HELP
L.HELP.TITLE = "Ayuda"
L.HELP.FANS = "Fanpage Oficial"
L.HELP.LINE = "OpenPoker"
L.HELP.MAIN_TAB_TEXT = {
    "Cómo jugar",
    "Explicación de Términos",
    "Nivel",
    "Preguntas frecuentes",
    "Comentarios",
}

L.HELP.PLAY_SUB_TAB_TEXT = {
    "Instrucciones",
    "Reglas",
    "Controles",
    "Botones",
}

L.HELP.LEVEL_RULE = "Juega cartas para obtener experiencia. Si gana en Campo Normal+2, pierde +1. No se puede obtener experiencia en el campo especial por ejemplo los Torneos"
L.HELP.LEVEL_TITLES = {
    "Nivel",
    "Títulos",
    "Experiencia",
    "Recompensa",
}

L.HELP.FEED_BACK_SUB_TAB_TEXT = {
    "Recarga",
    "Cuenta",
    "BUG",
    "Sugerencia",
}

L.HELP.GAME_WORDS_SUB_TAB_TEXT = {
    "Instrucción de datos",
    "Tipo de jugador marcado",
}

L.HELP.FEED_BACK_SUCCESS = "¡Gracias por tus comentarios!"
L.HELP.FEED_BACK_FIAL = "¡Falló al dejar comentarios, vuelve a intentarlo!"
L.HELP.UPLOADING_PIC_MSG = "Subiendo imagen, espere un momento…"
L.HELP.MUST_INPUT_FEEDBACK_TEXT_MSG = "Por favor ingrese el contenido de comentarios."
L.HELP.MATCH_QUESTION = "Problema de partida"
L.HELP.FAQ = {
    {
        "Se ha agotado la fecha, pero todavía quiero seguir jugando, ¿qué puedo hacer?",
        "Haga clic en la tienda que está a la derecha del avatar para comprar más ficas",
    },
    {
        "¿Por qué no puedo regalar la moneda del juego?",
        "Un jugador solo puede regalar 5,000 al día. En la lista de amigos, un jugador solo se puede regalar 500 al día.",
    },
    {
        "¿Dónde puedo obtener fichas gratis?",
        "Hay diferentes eventos: Recompensas de inicio de sesión, Recompensas en línea, Recompensas de tareas, Recompensas para los fans, Evento de invitar amigos, etc.",
    },
    {
        "¿Cómo comprar fichas?",
        "Haga clic en el botón Tienda para seleccionar lo que necesita",
    },
    {
        "¿Cómo ser fan?",
        "Haga clic en el botón Configuración, hay una entrada de nuestra Fanpage, o haga clic en el enlace "..appconfig.FANS_URL .." / \n El sistema siempre envía beneficios a los fans",
    },
    {
        "¿Cómo cerrar la sesión?",
        "Haga clic en el botón Configuración y seleccione Cerrar sesión.",
    },
    {
        "¿Cómo cambiar el nombre, el avatar y el sexo?",
        "Haga clic en el avatar y hay más opciones",
    },
    {
        "¿Qué es la certificación de Line?",
        "Agregue el número de line oficial: OpenPoker, después de la certificación, se va a mostrar su id de Line en el juego, así puede hacer más amigos.",
    }
}

L.HELP.PLAY_DESC = {
    "cartas privadas",
    "cartas comunes",
    "Combinación",
    "JugadorA",
    "JugadorB",
    "EL FLOP",
    "EL TURN",
    "EL RIVER",
    "FULL WIN",
    "DOBLE PAREJA LOSE",
}

L.HELP.PLAY_DESC_2 = "Cada jugador tiene 2 cartas personales, la Crupier va a repartir 3 veces en total son 5 cartas comunes. El objetivo del juego es alcanzar la mejor combinación posible de 5 cartas sacadas de entre 5 cartas comunes y 2 cartas personales. "

L.HELP.RULE_DESC = {
    "Escalera real",
    "Escalera de color",
    "Póquer",
    "Full",
    "Color",
    "Escalera",
    "Trío",
    "Doble pareja",
    "Pareja",
    "Carta alta",
}
L.COMMON.CARD_TIPS = "Mostrar pistas"
L.COMMON.TEXAS_CARD_TYPE = L.HELP.RULE_DESC
T = {}
L.COMMON.CARD_TYPE = T
T[1] = ""
T[2] = L.HELP.RULE_DESC[10]
T[3] = L.HELP.RULE_DESC[9]
T[4] = L.HELP.RULE_DESC[8]
T[5] = L.HELP.RULE_DESC[7]
T[6] = L.HELP.RULE_DESC[6]
T[7] = L.HELP.RULE_DESC[5]
T[8] = L.HELP.RULE_DESC[4]
T[9] = L.HELP.RULE_DESC[3]
T[10] = L.HELP.RULE_DESC[2]
T[11] = L.HELP.RULE_DESC[1]

L.HELP.RULE_DESC_NOTES = {
    "La combinación formada por las cinco cartas correlativas más altas de un mismo palo",
    "5 cartas consecutivas del mismo palo",
    "4 cartas de un mismo valor + 1 carta individual",
    "3 cartas iguales (Trio) + otras 2 iguales (pareja). ",
    "5 cartas del mismo palo",
    "5 cartas consecutivas de palos diferentes",
    "3 cartas iguales en su valor + 2 restantes que no forman pareja.",
    "2 pares de cartas + 1 carta individual",
    "2 cartas iguales + 3 diferentes.",
    "5 cartas individuales",
}
L.HELP.OPERATING_DESC = {
    "Menú",
    "Comprar fichas",
    "Pot + Side-Pot",
    "Banca",
    "Cartas comunes",
    "Cartas personales",
    "Mostrar pistas",
    "Interface de operación",
    "Llevar fichas",
    "Clasificación y Tasa de combinaciones",
    "Pareja",
    "Subir",
    "Igualar",
    "Retirarse",
}

L.HELP.FEED_BACK_HINT = {
    "Por favor proporcione la información más detallada del pago para que podamos solucionar el problema rápidamente",
    "Por favor proporcione su ID de usuario para que podamos resolver el problema. La ID está abajo de su avatar.",
    "Perdón, cualquier problema escríbenos, lo solucionaremos lo antes posible. Muchas gracias.",
    "Cualquier comentario o sugerencia será bienvenida y contribuirá a mejorar nuestros servicios.",
}

L.HELP.PLAY_BTN_DESC = {
    {
        title="Pasar", --看牌
        desc="Si no hay nadie apuesta, da la decisión al siguiente jugador.", --在无人下注的情况下选择把决定"让"给下一位。
        type = 1
    },
    {
        title="Retirarse", --弃牌
        desc="Deja pasar la oportunidad de continuar el juego", --放弃继续牌局的机会。
        type = 1
    },
    {
        title="Igualar", --跟注
        desc=" Igualar la apuesta", --跟随众人押上同等的注额
        type = 1
    },
    {
        title="Subir", --加注
        desc="Subir la apuesta", --把现有的注金抬高
        type = 1
    },
    {
        title="ALL IN", --全下
        desc="Apostar todas tus fichas, el resto de tu stack, en una sola apuesta.", --一次把手上的筹码全部押上。
        type = 1
    },
    {
        title="Pasar o Retirarse", --看或弃牌
        desc="Elige Pasar primero, después si necesita apostar elige Retirarse", --首先看牌,如果需要下注则选择弃牌
        type = 2
    },
    {
        title="Retirarse", --弃牌
        desc="Auto Retirarse", --自动弃牌
        type = 2
    },
    {
        title="Igualar cualquier apuesta", --跟任何注
        desc="Igualar cualquier apuesta", --字段选择跟任何注
        type = 2
    },
}

L.HELP.PLAY_DATA_DESC = {
    {
        title="VPIP%", --入池率/入局率
        desc="VPIP(También se llama VP). Esta estadística refleja la media porcentual de las veces que tu oponente suma dinero al bote de forma voluntaria.", --VPIP（通常缩写为VP）是玩家主动向底池中投入筹码的比率。
    },
    {
        title="PFR%", --翻牌前加注率
        desc="PFR es el porcentaje que hace referencia al aumento de las apuestas en el pre-flop.", --PFR即翻牌前加注,指的是一个玩家翻牌前加注的比率。
    },
    {
        title="AF", --激进度
        desc="AF significa literalmente \"factor de agresividad\", aunque es importante aclarar que se trata de agresividad post flop. Relaciona los movimientos (bet, call, raise) del jugador en su juego post-flop.", --AF即是用来衡量一个玩家打牌激进程度的数值。
    },
    {
        title="3b%", --再次加注率
        desc="Esta cifra hace referencia al porcentaje que muestra las veces que un jugador abandona la mano de cada tres turnos de apuestas.También se llama 3bet.", --即在他人下注,有人加注之后的再加注,由于是一轮下注中的第三次加注,故称3bet。
    },
    {
        title="STL%", --偷盲率
        desc="Stealing Blinds(El Robo de Ciega) es un ataque a las ciegas en forma de una subida desde una mano floja en la última posición, después de que todos los demás jugadores se hayan retirado.", --Stealing Blinds即偷盲,是指一个玩家单纯的为了赢得盲注而加注。
    },
    {
        title="CB", --持续下注率
        desc="También se llama Cbet. Esta estadística te muestra si tu oponente suele, o no, continuar apostando sobre el flop.", --Cbet即持续下注,是指一个玩家在前一轮主动下注或加注后,在当前这一轮再次主动下注。
    },
    {
        title="WTSD%", --摊牌率
        desc="Este porcentaje hace referencia a la asiduidad con la que tu oponente llega al showdown después de haber visto el flop.", --WTSD即摊牌率,是指一个玩家看到翻牌圈并玩到摊牌的百分比。
    },
    {
        title="BB/100", --百手盈利率
        desc="BB/100 es la cantidad de BB (Big Blinds) Ciegas grandes que ganas cada 100 manos jugadas", --BB/100（百手盈利率）：BB是Big Blind（大盲注）的简称,BB/100用以衡量玩家每玩100手牌局的盈亏。
    },
}

L.HELP.PLAYER_TYPE_DESC = {
    {
        title="El Pagador", --跟注站
        desc="No importa cuál sea nuestro movimiento o apuesta, el \"pagador\" se limitará a hacer call (pagar).", --只会被动的跟注
    },
    {
        title="El Maníaco", --疯子
        desc="El maníaco es poco selectivo y muy agresivo.", --疯狂的玩家,热衷于诈唬,非常激进
    },
    {
        title="El TAG(Tiburón)", --紧凶型（鲨鱼）
        desc="Una selección de manos iniciales muy reducida y aumentando la agresividad con manos fuertes.", --玩的很紧且具有一定的攻击性。
    },
    {
        title="Tight débil(Ratón)", --紧弱型（老鼠）
        desc="No sabe afrontar la agresividad y normalmente tiene demasiado miedo como para tomar la decisión adecuada.", --玩的很紧,较胆小,容易被诈唬吓跑的玩家
    },
    {
        title="La Roca", --岩石型
        desc="La roca se caracteriza por no jugar prácticamente nada.", --非常紧且被动。你不会在这种对手身上得到太多行动
    },
    {
        title="Loose-agresivo", --黄色警报
        desc="El jugador loose-agresivo va a muchas manos y las juega de forma agresiva.", --玩太多牌,而且容易高估自己的牌力。
    },
    {
        title="Loose-pasivo", --松弱鱼
        desc="El jugador loose-pasivo va a muchas manos pre-flop y hace mucho call post-flop.", --玩太多牌,而翻牌后打法又很被动
    },
}

--UPDATE
L.UPDATE.TITLE = "Descubre nueva versión"--发现新版本
L.UPDATE.DO_LATER = "Más tarde"--以后再说
L.UPDATE.UPDATE_NOW = "Actualiza ahora"--立即升级
L.UPDATE.HAD_UPDATED = "Ya es la última versión"--您已经安装了最新版本

--ABOUT
L.ABOUT.TITLE = "Acerca de"--关于
L.ABOUT.UID = "ID de jugador: {1}"--当前玩家ID: {1}
L.ABOUT.VERSION = "Versión: V{1}" --版本号: V{1}
L.ABOUT.FANS = "Fanpage Oficial:\n" .. appconfig.FANS_URL--官方粉丝页:\n
L.ABOUT.SERVICE = "Términos de servicio y políticas de privacidad"--服务条款与隐私策略
L.ABOUT.COPY_RIGHT = "Copyright © 2024 OpenPoker Technology CO., LTD All Rights Reserved."

--DAILY_TASK
L.DAILY_TASK.TITLE = "Misión"--任务
L.DAILY_TASK.SIGN = "Inscribirse"--签到
L.DAILY_TASK.GO_TO = "Ir a completar"--去完成
L.DAILY_TASK.GET_REWARD = "Recoger Recompensa"--领取奖励
L.DAILY_TASK.HAD_FINISH = "Completado"--已完成
L.DAILY_TASK.TAB_TEXT = {
    "Misión", --任务
    "Logros", --成就
}

-- count down box
L.COUNTDOWNBOX.TITLE = "Cofre de cuenta atrás"--倒计时宝箱
L.COUNTDOWNBOX.SITDOWN = "Siéntate para comenzar la cuenta atrás"--坐下才可以继续计时。
L.COUNTDOWNBOX.FINISHED = "Hoy ha recogido todos los cofres, mañana también hay"--您今天的宝箱已经全部领取,明天还有哦。
L.COUNTDOWNBOX.NEEDTIME = "Juega {1}mins {2}s más para obtener {3}."--再玩{1}分{2}秒,您将获得{3}。
L.COUNTDOWNBOX.REWARD = "Felicidades ha obtenido el cofre {1}"--恭喜您获得宝箱奖励{1}
L.COUNTDOWNBOX.TIPS = "Invita a amigos al juego con éxito\npuedes obtener recompensas dobles"--成功邀请好友进游戏\n可以得到翻倍奖励

-- act
L.NEWESTACT.NO_ACT = "Todavía no hay evento"--暂无活动
L.NEWESTACT.LOADING = "Cargando...Por favor espere con paciencia"--请您稍安勿躁,图片正在加载中...
L.NEWESTACT.TITLE = "Eventos"--活动
L.NEWESTACT.PLAY_CARD_TIME = "Tiempo:{1}"
L.NEWESTACT.PLAY_CARD_TITLE = "Juega más y gana más"
L.NEWESTACT.PLAY_CARD_TIPS_1 = "Todavía faltan {1} partida para reclamar {2} fichas. ¿Está seguro de que quiere levantarse?"
L.NEWESTACT.PLAY_CARD_TIPS_2 = "Todavía faltan {1} partida para reclamar {2} fichas. ¿Está seguro de que quiere salir?"
L.NEWESTACT.PLAY_CARD_LIST_TITLE = {
    "Ciegas",
    "Tiempo",
    "Num. Partidas",
    "Recompensas"
}
L.NEWESTACT.PAY_TIPS = "Después de terminar el evento, las recompensas se enviarán directamente a su barra de info."
L.NEWESTACT.PAY_COUNT = "Recargado"
L.NEWESTACT.PAY_TIPS_1 = "Recargue más de "
L.NEWESTACT.PAY_TIPS_2 = ",podrá obtener"
L.NEWESTACT.HOLIDAY_TAB_TEXT = {
    "领取处",
    "兑换处"
}
L.NEWESTACT.HOLIDAY_REWARD_LIMIT = "可兑换{1}/{2}次"
L.NEWESTACT.HOLIDAY_NO_LIMIT = "无限制"
L.NEWESTACT.HOLIDAY_SHAKE_TAB_TEXT = {
    "送筹码",
    "摇一摇"
}
L.NEWESTACT.HOLIDAY_SHAKE_TIPS = "{1} 颗心 = {2} 次"
L.NEWESTACT.HOLIDAY_SHAKE_PLAY_TIPS = "活动期间每天可以免费摇一次"
L.NEWESTACT.HOLIDAY_SHAKE_TIMES = "摇一摇{1}次"
L.NEWESTACT.HOLIDAY_SHAKE_BTN = "摇一摇"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_BTN = "赠送"
L.NEWESTACT.HOLIDAY_SHAKE_RANKING_TITLE = {
    "排名",
    "牛郎",
    "赠送筹码",
    "织女"
}
L.NEWESTACT.HOLIDAY_SHAKE_RANKING = "排行榜"
L.NEWESTACT.HOLIDAY_SHAKE_RANKING_TIPS = "今日赠送筹码排行,明天重新排行"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_RECORD = "赠送记录"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_FRIEND = "好友列表"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_NAME_1 = "织女ID"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_NAME_2 = "赠送筹码"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_1 = "选择好友或者输入ID"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_2 = "最低赠送{1}"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_3 = "请输入玩家ID"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_4 = "请输入赠送的筹码数量"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_5 = "不能给自己赠送筹码"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_6 = "赠送筹码不能超过身上携带的数量"
L.NEWESTACT.HOLIDAY_SHAKE_EDIT_TIPS_7 = "你携带的筹码不足{1}"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_FAILED_1 = "赠送失败,请重试"
L.NEWESTACT.HOLIDAY_SHAKE_SEND_FAILED_2 = "玩家ID无效,请重新赠送"

--feed
L.FEED.SHARE_SUCCESS = "Compartido"--分享成功
L.FEED.SHARE_FAILED = "Falló al compartir"--分享失败
L.FEED.NO_CLIENT_TIPS = "No ha instalado la aplicación {1}, invite a los amigos por otros métodos"--您没有安装{1}应用,请使用其他方式邀请
L.FEED.COPY_TIPS = "Copiado, puede pegar en las otras aplicaciones para compartirlo"--分享内容已复制,您可以直接粘贴到其他应用发送给好友
L.FEED.SHARE_LINK = appconfig.SAHRE_URL
L.FEED.WHEEL_REWARD = {
    name = "Recibí un premio {1} en la Rueda de Open Póquer. ¡Ven a jugar conmigo!", --我在开源德州扑克的幸运转转转获得了{1}的奖励,快来和我一起玩吧！
    caption = "Gana premio en la Rueda, 100% Seguro", --开心转转转100%中奖
    link = L.FEED.SHARE_LINK .. "&feed=1",
    picture = appconfig.FEED_PIC_URL.."1.jpg",
    message = "",
}
L.FEED.WHEEL_ACT = {
    name = "Ven a jugar la Rueda conmigo, hay 3oportunidades todos los días ", --快来和我一起玩开心转转转吧,每天登录就有三次机会！
    caption = "Gana premio en la Rueda, 100% Seguro",  --开心转转转100%中奖
    link = L.FEED.SHARE_LINK .. "&feed=2",
    picture = appconfig.FEED_PIC_URL.."2.jpg", 
    message = "",
}
L.FEED.LOGIN_REWARD = {
    name = "¡Genial! He recogido {1} fichas en Open Póquer! ¡Ven a jugar conmigo!", --太棒了!我在开源德州扑克领取了{1}筹码的奖励,快来和我一起玩吧！
    caption = "Las recompensas de inicio de sesión se envían todos los días", --登录奖励天天送不停
    link = L.FEED.SHARE_LINK .. "&feed=3",
    picture = appconfig.FEED_PIC_URL.."3.jpg",
    message = "",
}
L.FEED.INVITE_FRIEND = {
    name = "Open Póquer, el juego más nuevo y popular, todos los amigos están jugando, ¡Únete a nosotros!", --开源德州扑克,最新最火爆的德扑游戏,小伙伴们都在玩,快来加入我们一起玩吧！
    caption = "Juego solo para genios - Open Póquer", --聪明人的游戏-开源德州扑克
    link = L.FEED.SHARE_LINK .. "&feed=4",
    picture = appconfig.FEED_PIC_URL.."4.jpg",
    message = "",
}
L.FEED.EXCHANGE_CODE = {
    name = "He recogido las recompensas de {1} con el código de Fanpage de Open Póquer! ¡Ven a jugar conmigo!", --我用开源德州扑克粉丝页的兑换码换到了{1}的奖励,快来和我一起玩吧！
    caption = "Código de regalo para los fans", --粉丝奖励兑换有礼
    link = L.FEED.SHARE_LINK .. "&feed=5",
    picture = appconfig.FEED_PIC_URL.."5.jpg",
    message = "",
}
L.FEED.COUNT = {
    name = "¡Qué fuerte! ¡Gané {1} fichas en Open Póquer y no pude evitar ostentar!", --太强了！我在开源德州扑克赢得了{1}的筹码,忍不住炫耀一下！
    caption = "Ganó mucho", --赢了好多啊
    link = L.FEED.SHARE_LINK .. "&feed=6",
    picture = appconfig.FEED_PIC_URL.."6.jpg",
    message = "",
}
L.FEED.ACTIVE = {
    name = "¡Genial, únete al Open Póquer conmigo. ¡Hay muchos eventos todos los días!",--太棒了,赶紧和我一起加入开源德州扑克吧,精彩活动天天有！
    caption = "{1} Eventos",--{1}活动
    link = L.FEED.SHARE_LINK .. "&feed=7",
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message = "",
}
L.FEED.ACTIVE_DONE = {
    name = "Obtuve un premio {1} en Open Póquer. ¡Ven a jugar conmigo!", --我在开源德州扑克中获得了{1}的奖励,赶快来加入一起玩吧！
    caption = "{1} Eventos",--{1}活动
    link = L.FEED.SHARE_LINK .. "&feed=8",
    picture = appconfig.FEED_PIC_URL.."8.jpg",
    message = "",
}
L.FEED.ACHIEVEMENT_REWARD = {
    name = "Completé el logro {1} en Open Póquer y gané {2} como recompensas. ¡Ven,ven a jugar! ",--我在开源德州扑克完成了{1}的成就,获得了{2}的奖励,快来和我一起玩吧！
    caption = "{1}",
    link = L.FEED.SHARE_LINK .. "&feed=9",
    picture = appconfig.FEED_PIC_URL.."9.jpg",
    message = "",
}
L.FEED.UPGRADE_REWARD = {
    name = "Genial, acabo de subir mi nivel hasta lvl.{1} en Open Póquer y recibí {2} como recompensas. ¡Ven a jugar conmigo!", --太棒了,我刚刚在开源德州扑克成功升到了{1}级,领取了{2}的奖励,快来膜拜吧！
    caption = "Sube nivel y recibe las recompensas", --升级领取大礼
    link = L.FEED.SHARE_LINK .. "&feed=LV{1}",
    picture = appconfig.FEED_PIC_URL.."LV{1}.jpg",
    message = "",
}
L.FEED.MATCH_COMPLETE = {
    name = "¡Obtuve el {2} puesto en {1} en Open Póquer, vamos a jugar juntos!", --我在开源德州扑克{1}中获得第{2}名,赶快来一起玩吧！
    caption = "¡Vamos a competir!", --一起来比赛！
    link = L.FEED.SHARE_LINK .. "&feed=11",
    picture = appconfig.FEED_PIC_URL.."11.jpg",
    message = "",
}
L.FEED.RANK_REWARD = {
    name = "¡Genial, ayer gané {1} fichas en Open Póquer, vamos a jugar juntos!", --太棒了!我昨天在开源德州扑克里赢得了{1}筹码,快来和我一起玩吧!
    caption = "¡Gané otra vez!", --又赢钱了！
    link = L.FEED.SHARE_LINK .. "&feed=12",
    picture = appconfig.FEED_PIC_URL.."12.jpg",
    message = "",
}
L.FEED.BIG_POKER = {
    name = "¡Qué suerte! He ganado {1} en Open Póquer. ¡Únete a nosotros!", --手气真好!我在开源德州扑克拿到{1},聪明人的游戏,快来加入一起玩吧！
    caption = "{1}",--牌型
    link = L.FEED.SHARE_LINK .. "&feed=13",
    picture = appconfig.FEED_PIC_URL.."13.jpg",
    message = "",
}
L.FEED.PRIVATE_ROOM = {
    name = "¡Estoy esperando por ti en mi habitación privada, No.{1}, clave {2}, toca para unirte!", --我在开源德州扑克开好私人房等你来战,房间号{1},密码{2},点击立即加入！
    caption = "Ya empezo",--开房打牌了,牌型
    link = L.FEED.SHARE_LINK,
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message = "",
}
L.FEED.NO_PWD_PRIVATE_ROOM = {
    name = "¡Estoy esperando por ti en mi habitación privada, No.{1},toca para unirte!", --我在开源德州扑克开好私人房等你来战,房间号:{1},点击立即加入！
    caption = "Ya empezo",--开房打牌了,牌型
    link = L.FEED.SHARE_LINK,
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message = "",
}
L.FEED.NORMAL_ROOM_INVITE = {
    name = "¡Estoy esperando por ti en la {1}habitación{2}, toca para unirte!", --我在{1}房间{2}打牌,速速来战！
    caption = "Ven a jugar a las cartas",--打牌啦,牌型
    link = L.FEED.SHARE_LINK,
    picture = appconfig.FEED_PIC_URL.."7.jpg",
    message = "",
}
L.FEED.INVITE_CODE = {
    name = "Descubrí un juego más divertido de Texas Hold'em, te recomiendo muchísimo, descarga el juego e ingrese mi código de invitación {1} podrás otbener los regalos especiales", --发现一个目前最好玩的德州扑克游戏,推荐你和我一起玩,下载游戏输入我的邀请码{1}就有特别大奖领取.
    caption = "",
    link = appconfig.INVITE_GIFT_URL,
    picture = appconfig.FEED_PIC_URL.."gift.jpg",
    message = "",
}
L.FEED.INVITE_CODE_REWARD = {
    name = "¡Muchas gracias a {1}! He obtenido un paquete de invitación con {2} fichas en , únete a nosotros!", --太感谢好友{1}！我在开源德州获得了{2}筹码的邀请礼包,快来加入我们一起玩吧
    caption = "Open Póquer-Paquete de invitación ", --开源德州扑克-免费的邀请大礼包
    link = L.FEED.SHARE_LINK .. "&feed=gift",
    picture = appconfig.FEED_PIC_URL.."gift.jpg",
    message = "",
}

-- message
L.MESSAGE.TITLE = "Mensajes" --消息
L.MESSAGE.TAB_TEXT = {
    "Mensajes de amigos", --好友消息
    "Mensajes de sistema",--系统消息
}
L.MESSAGE.EMPTY_PROMPT = "No hay historial de chat" --您现在没有消息记录
L.MESSAGE.SEND_CHIP = "Regalar"--回赠
L.MESSAGE.ONE_KEY_GET = "1-clic a recoger"--一键领取
L.MESSAGE.ONE_KEY_GET_AND_SEND = "1-clic a recoger y regalar"--一键领取并回赠
L.MESSAGE.GET_REWARD_TIPS = "Felicidades, ha obtenido {1} y ha regalado {2} a su amig@"--恭喜您获得了{1},成功给好友赠送了{2}

--奖励兑换码
L.ECODE.TITLE = {
    "Mi código de invitación",--我的邀请码
    "Canjear",--奖励兑换
}
L.ECODE.EDITDEFAULT = "Por favor ingrese el código de regalo de 6 dígitos o el código de invitación de 8 dígitos"
L.ECODE.FANS_DESC = "Sigue nuestra Fanpage para obtener código de regalo gratis, también hay muchos eventos en la página oficial, gracias por su atención."--关注粉丝页可免费领取奖励兑换码,我们还会不定期在官方粉丝页推出各种精彩活动,谢谢关注。
L.ECODE.FANS = "Dirección de Fanpage"--粉丝页地址
L.ECODE.EXCHANGE = "Canjear"--兑  奖
L.ECODE.ERROR_FAILED = "¡Error al ingresar el código, vuelve a intentarlo!"--兑换码输入错误,请重新输入！
L.ECODE.ERROR_INVALID="Falló al canjear, su código de canje ha expirado."--兑奖失败,您的兑换码已经失效。
L.ECODE.ERROR_USED = "Falló al canjear, cada código solo puede canjearse una vez"--兑奖失败,每个兑换码只能兑换一次。
L.ECODE.ERROR_END= "Falló a recoger, el regalo de esta vez ha sido agotado, ven más temprano la próxima vez"--领取失败,本次奖励已经全部领光了,关注我们下次早点来哦
L.ECODE.FAILED_TIPS = "¡Falló al canjear, vuelve a intentarlo!"--兑奖失败,请重试！
L.ECODE.NO_INPUT_SELF_CODE = "No puede ingresar tu código de invitación. Confírmalo bien y vuelva a ingresar"--您不能输入自己的邀请码,请确认后重新输入
L.ECODE.MAX_REWARD_TIPS = "Máxima adquisición"--最大获取
L.ECODE.INVITE_REWARD_TIPS = [[
1. Enviales el código de invitación a los amigos
2. Avisales a los amigos que ingresen tu código de invitación en 3 días, si no, el código va a expirar
3. Después los amigos pueden obtener {2} paquete de novato, al mismo tiempo puedes recoger {1} fichas, si los amigos invitan a los demás y obtendrás {3} fichas más por cada invitación.
]]
L.ECODE.INVITE_REWARD_RECORD = "Ha invitado {1} amigos hoy y ha obtenido {2} fichas"--您已邀请了{1}位好友,获得了{2}筹码的邀请奖励
L.ECODE.MY_CODE = "Mi código de invitación"--我的邀请码
L.ECODE.COPY_CODE = "Haga clic para copiar"--点击复制
L.ECODE.INVITE_REWARD_TIPS_1 = "Excelente, ha recogido"--太棒了,领取成功
L.ECODE.INVITE_REWARD_TIPS_2 = "Ha obtenido {1} fichas \n Su amig@ {2} ha obtenido {3} fichas"--您获得了{1}筹码的好友邀请奖励\n您的好友{2},也获得了{3}的邀请奖励
L.ECODE.INVITE_BTN_NAME = "Quiero invitar a mis amigos"--我也要去邀请
L.ECODE.INVITE_TIPS = "Puede hacer clic en el botón para enviar el código"--您可以点击按钮通过以下方式发送邀请码
L.ECODE.INVITE_TITLES = {
    "Seguir la Fanpage para obtener código",--关注粉丝页获取兑换码
    "Enviar mi código de invitación para obtener código",--发送我的邀请码获取邀请奖励
}

--大转盘
L.LUCKTURN.RULE_TEXT =[[
1.Cada {1} horas se puede jugar una vez gratis
2.También se puede jugar una vez con 1 diamante
3.Gana fichas gratuitas todos los días, 100% Seguro
]]
L.LUCKTURN.COST_DIAMOND = "Jugar con 1 diamante"--花费1个颗钻石
L.LUCKTURN.BUY_DIAMOND = "Comprar diamantes"--购买钻石
L.LUCKTURN.COUNTDOWN_TIPS = "Ha usado todas las oportunidades gratuitas \n Puede volver a jugar después de {1} \n También puede usar 1 diamante para jugarla"--您今天的免费次数已用完\n您可以等待{1}再来\n您也可以花费一颗钻石转一次
L.LUCKTURN.LOTTERY_FAILED = "Falló al jugar, por favor verifica el estado de tu conexión a Internet y red y vuelve a intentarlo"--抽奖失败,请检查网络连接断开后重试
L.LUCKTURN.CHIP_REWARD_TIPS = "{1} ha ganado:{2} fichas"--{1}中了:筹码 {2}
L.LUCKTURN.PROPS_REWARD_TIPS = "{1} ha ganado:{2} artículos"--{1}中了:道具 {2}
L.LUCKTURN.VIP_REWARD = "VIP{2}{1} día(s) "--{1}天{2}VIP特权

--老虎机
L.SLOT.NOT_ENOUGH_MONEY = "Falló al jugar Slots, no tienes suficientes fichas"--老虎机购买失败,你的筹码不足
L.SLOT.NOT_ENOUGH_MIN_MONEY = "Tienes menos de 5 mil fichas para jugar Slots, por favor recarga primero"--您的总筹码数不足5000,暂时无法下注老虎机,请充值后重试。
L.SLOT.BUY_FAILED = "Falló al jugar Slots, vuelve a intentarlo"--老虎机购买失败,请重试
L.SLOT.PLAY_WIN = "Has ganado {1} fichas"--你赢得了{1}筹码
L.SLOT.TOP_PRIZE = "{1} ha ganado {2} fichas en Slots"--玩家 {1} 玩老虎机抽中大奖,获得筹码{2}
L.SLOT.FLASH_TIP = "Primer premio：{1}"--头奖：{1}
L.SLOT.FLASH_WIN = "Has ganado：{1}"--你赢了：{1}
L.SLOT.AUTO = "Auto"--自动
L.SLOT.HELP_TIPS = "Premio = Apuestas x Porcentaje de devolución\nMás apuestas más premios. Lo más alto es {1}"--奖金=下注筹码*回报率\n下注越多,奖励越高.最高{1}

--GIFT
L.GIFT.TITLE = "Regalo"--礼物
L.GIFT.SET_SELF_BUTTON_LABEL = "Aplicar a mi regalo"--设为我的礼物
L.GIFT.BUY_TO_TABLE_GIFT_BUTTON_LABEL = "Comprarlo para los compañeros de mesa x{1}"--买给牌桌x{1}
L.GIFT.CURRENT_SELECT_GIFT_BUTTON_LABEL = "El regalo que selecciona ahora"--你当前选择的礼物
L.GIFT.PRESENT_GIFT_BUTTON_LABEL = "Regalar"--赠送
L.GIFT.DATA_LABEL = "día(s)"--天
L.GIFT.SELECT_EMPTY_GIFT_TOP_TIP = "Por favor selecciona el regalo"--请选择礼物
L.GIFT.BUY_GIFT_SUCCESS_TOP_TIP = "Has comprado el regalo con éxito"--购买礼物成功
L.GIFT.BUY_GIFT_FAIL_TOP_TIP = "Falló al comprar regalo"--购买礼物失败
L.GIFT.SET_GIFT_SUCCESS_TOP_TIP = "Aplicado con éxito"--设置礼物成功
L.GIFT.SET_GIFT_FAIL_TOP_TIP = "Falló al aplicar"--设置礼物失败
L.GIFT.PRESENT_GIFT_SUCCESS_TOP_TIP = "Regalado"--赠送礼物成功
L.GIFT.PRESENT_GIFT_FAIL_TOP_TIP = "Falló al regalar"--赠送礼物失败
L.GIFT.PRESENT_TABLE_GIFT_SUCCESS_TOP_TIP = "Regalado"--赠送牌桌礼物成功
L.GIFT.PRESENT_TABLE_GIFT_FAIL_TOP_TIP = "Falló al regalar"--赠送牌桌礼物失败
L.GIFT.NO_GIFT_TIP = "Todavía no hay regalo"--暂时没有礼物
L.GIFT.MY_GIFT_MESSAGE_PROMPT_LABEL = "Haz clic para seleccionar y mostrar el regalo en la mesa"--点击选中既可在牌桌上展示才礼物
L.GIFT.BUY_GIFT_FAIL_TIPS = "Falló al comprar regalo, no tienes suficientes fichas"--您的场外筹码不足,购买礼物失败
L.GIFT.PRESENT_GIFT_FAIL_TIPS = "Falló al regalar, no tienes suficientes fichas"--您的场外筹码不足,赠送礼物失败
L.GIFT.PRESENT_TABLE_GIFT_FAIL_TIPS = "Falló al regalar, no tienes suficientes fichas"--您的场外筹码不足,赠送牌桌礼物失败
L.GIFT.SUB_TAB_TEXT_SHOP_GIFT = {
    "Otros ítems", --精品
    "Comida",--食物
    "Carro",--跑车
    "Flor",--鲜花
}

L.GIFT.SUB_TAB_TEXT_MY_GIFT = {
    "Para mí", --自己购买
    "Para los compañeros de mesa",--牌友赠送
    "Para alguien especial",--特别赠送
}

L.GIFT.MAIN_TAB_TEXT = {
    "Regalo de la tienda", --商城礼物
    "Regalo VIP",--VIP礼物
    "Mi regalo",--我的礼物
}

-- 破产
L.CRASH.PROMPT_LABEL = "Obtendrá {1} fichas de la subvención de bancarrota y podrá disfrutar la Oferta Bancarrota por tiempo limitado. También puede obtener fichas gratis por invitar amigos."--您获得了{1}筹码的破产救济金,同时获得限时破产优惠充值一次,您也可以立即邀请好友获取免费筹码。
L.CRASH.THIRD_TIME_LABEL = "Es la última vez que puede obtener la subvención de bancarrota, esta vez ha obtenido {1} fichas, además puede disfrutar la Oferta Bancarrota por tiempo limitado hoy. También puede obtener fichas gratis por invitar amigos."--您获得最后一次{1}筹码的破产救济金,同时获得当日限时充值优惠一次,您也可以立即邀请好友获取免费筹码。
L.CRASH.OTHER_TIME_LABEL = "Ha recibido todas las subvenciones de bancarrota, ganar o perder es solo una cuestión de un instante. ¡La Oferta Bancarrota es por tiempo limitado, no espere más!"--您已经领完所有破产救济金了,输赢只是转瞬的事,限时特惠机会难得,立即充值重振雄风！
L.CRASH.TITLE = "¡Está en bancarrota!" --你破产了！
L.CRASH.REWARD_TIPS = "No importa la bancarrota, hay subvención que se puede recibir"--破产没有关系,还有救济金可以领取
L.CRASH.CHIPS = "{1} fichas"--{1}筹码
L.CRASH.GET = "Recoger"--领取
L.CRASH.GET_REWARD = "Ha obtenido {1} fichas"--获得{1}筹码
L.CRASH.GET_REWARD_FAIL = "Falló al recoger las fechas"--领取筹码失败
L.CRASH.RE_SIT_DOWN = "Volver a sentarse"--重新坐下
L.CRASH.PROMPT_LABEL_1 = "No se preocupe, hemos preparado {1} fichas como la subvención de bancarrota para usted"--不要灰心,系统为您准备了{1}筹码的破产救济
L.CRASH.PROMPT_LABEL_2 = "Además puede disfrutar la Oferta Bancarrota por tiempo limitado"--同时您还获得当日充值优惠一次立即充值重振雄风
L.CRASH.PROMPT_LABEL_3 = "También puede obtener muchas fichas gratis por invitar amigos."--您也可以邀请好友或者明天再来领取大量免费筹码
L.CRASH.PROMPT_LABEL_4 = "Le regalamos una Oferta Bancarrota, es por tiempo limitado, ¡no espere más!"--我们赠送您当日限时充值优惠大礼包一次,机不可失
L.CRASH.PROMPT_LABEL_5 = "Ha recibido todas las subvenciones de bancarrota, todo irá bien, crack"--您已经领完了所有的破产礼包 输赢乃兵家常事,不要灰心

--E2P_TIPS
L.E2P_TIPS.SMS_SUCC = "Tu mensaje ha sido enviado, por favor espera con paciencia"--短信已发送成功,正在充值 请稍等.
L.E2P_TIPS.NOT_SUPPORT = "No se puede recargar mediante easy2pay en su celular, por favor prueba a usar otro método"--你的手机暂时无法完成easy2pay充值,请选择其他渠道充值
L.E2P_TIPS.NOT_OPERATORCODE = "El operador de telefonía móvil no admite el uso de easy2pay,por favor prueba a usar otro método"--easy2pay暂时不支持你的手机运营商,请选择其他渠道充值
L.E2P_TIPS.SMS_SENT_FAIL = "Error al enviar SMS. Por favor checa si tiene suficiente saldo para pagar la cuota"--短信发送失败,请检查你的手机余额是否足额扣取
L.E2P_TIPS.SMS_TEXT_EMPTY = "Mensaje en blanco, por favor pruebe a usar otro método y comuníquese con la empresa"--短信内容为空,请选择其他渠道充值并联系官方
L.E2P_TIPS.SMS_ADDRESS_EMPTY = "Sin objetivo, por favor pruebe a usar otro método y comuníquese con la empresa"--没有发送目标,请选择其他渠道充值并联系官方
L.E2P_TIPS.SMS_NOSIM = "Sin tarjeta SIM, no se puede usar easy2pay, por favor pruebe a usar otro método"--没有SIM卡,无法使用easy2pay渠道充值,请选择其他渠道充值
L.E2P_TIPS.SMS_NO_PRICEPOINT = "Sin objetivo, por favor pruebe a usar otro método y comuníquese con la empresa"--没有发送目标,请选择其他渠道充值并联系官方
L.E2P_TIPS.PURCHASE_TIPS = "Vas a comprar {1}, en total son {2} USD(El precio no incluye el IVA), se deducirá de tu saldo"--您将要购买{1},共花费{2}铢（不含7%增值税）,将会从您的话费里扣除
L.E2P_TIPS.BANK_PURCHASE_TIPS = "Vas a comprar {1}, en total son {2} USD(El precio no incluye el IVA), se deducirá de tu saldo de tarjeta bancaria"--您将要购买{1},共花费{2}铢（不含7%增值税）,将会从您的银行卡里扣除

-- 比赛场
L.MATCH.MONEY = "Fichas"--筹码
L.MATCH.JOINMATCHTIPS = "La competición que regístrate está a punto de empezar, ¿si quieres entrar en la habitación ahora?"--您报名参赛的比赛已经开始准备,是否现在进入房间进行比赛
L.MATCH.JOIN_MATCH_FAIL = "Falló al participar, por favor participa en otras competiciones"--加入比赛失败,请参加其他比赛吧！
L.MATCH.MATCH_END_TIPS = "Ya terminó la competición, por favor participa en otras competiciones"--当前比赛已经结束,请参加其他比赛吧！
L.MATCH.MATCHTIPSCANCEL = "No más avisos"--不再提示
L.MATCH.CHANGING_ROOM_MSG = "Esperando a que terminen las otras mesas"--正在等待其他桌子结束
L.MATCH.MATCH_NAME = "Nombre"--比赛名称
L.MATCH.MATCH_REWARD = "Recompensas"--奖励内容
L.MATCH.MATCH_PLAYER = "Participantes"--参赛人数
L.MATCH.MATCH_COST = "Tarifa de registro + tarifa de servicio"--报名费+服务费
L.MATCH.REGISTER = "Registrarse"--报名
L.MATCH.REGISTERING = "Se está\napuntando"--正在\n报名
L.MATCH.REGISTERING_2 = "Se está apuntando"--正在报名
L.MATCH.UNREGISTER = "Cancelar\napuntarse"--取消\n报名
L.MATCH.UNREGISTER_2 = "Cancelar apuntarse"--取消报名
L.MATCH.RANKING = "Su ranking"--您的排名
L.MATCH.REGISTER_COST = "Tarifa de parámetro:"--参数费:
L.MATCH.SERVER_COST = "Tarifa de servicio:"
L.MATCH.TOTAL_MONEY = "Patrimonio total:"--您的总资产:
L.MATCH.MATCH_INFO = "Competición actual"--本场赛况
L.MATCH.START_CHIPS = "Fichas iniciales:"--初始筹码:
L.MATCH.START_BLIND = "Ciegas iniciales:{1}/{2}"--初始盲注:{1}/{2}
L.MATCH.MATCH_TIME = "Tiempo:{1}"--参赛时间:{1}
L.MATCH.RANKING_TITLE = "Ranking"--名次
L.MATCH.REWARD_TITLE = "Premio"--奖励
L.MATCH.LEVEL_TITLE = "Nivel"--级别
L.MATCH.BLIND_TITLE = "Ciega"--盲注
L.MATCH.PRE_BLIND_TITLE = "Ante"--前注
L.MATCH.ADD_BLIND_TITLE = "El tiempo de subir ciega"--涨盲时间
L.MATCH.RANKING_INFO = "Ranking actual:{1}"--当前排名第{1}名
L.MATCH.SNG_HELP_TITLE = "Reglas de SNG"--SNG比赛规则
L.MATCH.MTT_HELP_TITLE = "Reglas de  MTT"--MTT比赛规则
L.MATCH.SNG_RANKING_INFO = "Promedio de ficha: {1}"--均筹: {1}
L.MATCH.MTT_RANKING_INFO = "{1}/{2} Promedio de ficha: {3}"--{1}/{2} 均筹: {3}
L.MATCH.ADD_BLIND_TIME = "El tiempo de subir ciega: {1}"--涨盲时间: {1}
L.MATCH.WAIT_MATCH = "Espera para comenzar "--等待开赛
L.MATCH.ADD_BLIND_TIPS_1 = "Subir"--将在下一局涨盲
L.MATCH.ADD_BLIND_TIPS_2 = "La próxima partida se subirá la ciega hasta {1}/{2}"--下一局将升盲至{1}/{2}
L.MATCH.BACK_HALL = "Volver a la sala"--返回大厅
L.MATCH.PLAY_AGAIN = "Otra vez"--再来一局
L.MATCH.LEFT_LOOK = "Quedar para mirar"--留下旁观
L.MATCH.CLOSE = "Cerrar"--关闭
L.MATCH.REWARD_TIPS = "Ha obtenido {1}\n{2}"--您获得了{1}的奖励\n{2}
L.MATCH.REWARD_PLAYER = "Num. para recoger recompensas "--奖励人数
L.MATCH.MATCH_CUR_TIME = "Duración"--比赛用时
L.MATCH.CUR_LEVEL_TITLE = "Nivel actual:{1}/{2}"--当前级别:{1}/{2}
L.MATCH.NEXT_LEVEL_TITLE = "Nivel siguiente"--下一级别
L.MATCH.AVERAGE_CHIPS_TITLE = "Promedio de fichas"--平均筹码
L.MATCH.FORMAT_BLIND = "{1}/{2}"
L.MATCH.EXPECT_TIPS = "Pronto vendrá"--敬请期待
L.MATCH.NOT_ENOUGH_MONEY = "No tiene suficientes fichas para apuntarse, por favor añade más fichas primero y vuelve a intentarlo"--您的筹码不足报名,请去商城补充筹码后重试
L.MATCH.PLAYER_NUM_TIPS = "Esperando, aún falta(n) {1} persona(s)"--等待开赛中,还差{1}人
L.MATCH.PLAYER_NUM_TIPS_1 = "Esperando, aún faltan"--等待开赛中,还差
L.MATCH.PLAYER_NUM_TIPS_2 = " persona(s)"--人
L.MATCH.MAINTAIN = "Está en mantenimiento"--当前比赛正在维护
L.MATCH.ROOM_INFO = "{1}:{2}/{3}"
L.MATCH.REWARD_TEXT = {
    "¡Buen trabajo! ¡Compártelo ahora!",--你太棒了！立即分享炫耀下吧!
    "¡Qué fuerte! ¡Compártelo con tus amigos!",--没想到你这么强！呼朋唤友告诉小伙伴们吧！
    "¡Excelente, una partida más!",--太牛了,再来一局吧！
}
L.MATCH.NO_REWARD_TEXT = {
    "¡Ánimo que todo se puede!",--再接再厉,继续加油！
    "¡Desarrolla el éxito desde el fracaso!",--失败是成功之母,继续努力！
    "¡Sólo falta poco, más paciencia la próxima vez!",--就差一点点,下次多点耐心！
}
L.MATCH.SNG_RULE = {
    {
        title = "¿Qué es un SNG - Sit&Go?",--什么是SNG-坐满即玩?
        content = "Los torneos Sit and Go son pequeños torneos de mesas simples que se celebran constantemente en Betfair Poker. Todos los jugadores pueden obtener la misma cantidad de fichas. El juego continúa hasta que sólo queda un jugador. Se paga a los jugadores según la posición en la que terminen, no según la cantidad de fichas que tienen en un momento dado.",
    },
    {
        title = "Reglas de SNG:",--SNG比赛规则:
        content = [[
1. Empezará en el momento en que esté lleno de jugadores(6 o 9 personas)
2. Todos reciben la misma cantidad de fichas(solo para esta partida)
3. No se puede poner más fichas cuando ya comienza la partida, los que pierdan sus fichas, quedan fuera del torneo.
4. El primer jugador que pierda sus fichas está en último lugar.
5. Terminará la partida cuando quedan _ jugadores, el último jugador es campeón de la partida
6. Todos los torneos Sit and Go experimentan un aumento constante de las ciegas para forzar a la acción
]]
    }
}
L.MATCH.MTT_RULE = {
    {
        title = "¿Qué es un MTT - Los torneos multi-mesa?",--什么是MTT-多桌锦标赛?
        content = "MTT (Multi Table Tournament) es una competición de poker en la que todos los jugadores empiezan con el mismo número de fichas y juegan entre ellos hasta que un jugador haya eliminado al resto y por consiguiente ganado todas las fichas."
    },
    {
        title = "Reglas de MTT:",--MTT比赛规则:
        content = [[
1. Cuando el número de participantes sea menor que el número mínimo de jugadores, el juego será cancelado.
2. Todos reciben la misma cantidad de fichas(solo para esta partida)
3. Ante: Todos los jugadores que participen en los torneos tendrán que apostar las antes.
4. Volver a comprar fichas: Antes del comienzo de la competición(que permite a volver a comprar fichas) y cuando solo tiene las fichas iniciales, puede darle clic en el botón para volver a pagar la tarifa de registro y comprar otra vez las fichas iniciales, las veces dependen de la competición. También puede volver a comprar fichas cuando perdió todas las fichas.
5. Añadir fichas: Cuando está en la competición(que permite añadir fichas), puede darle clic en el botón para volver a pagar la tarifa de registro y comprar otra vez las fichas, las veces dependen de la competición. También puede volver a comprar fichas cuando perdió todas las fichas.
6. Si dos (o más) jugadores de la misma mesa son eliminados en la misma mano, el jugador que comenzó la mano con más fichas (o sus cartas son más grandes) obtiene la posición final más alta. 
7. Todos los torneos continuarán hasta que un jugador gane todas las fichas, es decir, el último jugador es campeón de la partida
8. Todos los torneos MTT experimentan un aumento constante de las ciegas para forzar a la acción
]]
    }
}
L.MATCH.TAB_TEXT= {
    "Sinopsis",--概述
    "Ranking",--排名
    "Ciega",--盲注
    "Recompensas",--奖励
}
L.MATCH.ROOM_TAB_TEXT_1= {
    "Sinopsis",--概述
    "Estado",--赛况
    "Ranking",--排名
    "Ciega",--盲注
    "Recompensas",--奖励
}
L.MATCH.ROOM_TAB_TEXT_2= {
    "Estado",--赛况
    "Ranking",--排名
    "Ciega",--盲注
    "Recompensas",--奖励
}

-- 输赢统计
L.WINORLOSE.TITLE = "Perfecto"--太棒了
L.WINORLOSE.YING = "Has ganado"--你赢了
L.WINORLOSE.CHOUMA = "{1} fichas"--{1}筹码
L.WINORLOSE.INFO_1 = "Num Partidas:{1}"--局数:{1}
L.WINORLOSE.INFO_2 = "Max./partida:{1}"--单局最大赢得:{1}
L.WINORLOSE.RATE5 = "Si te ha gustado la APP, regalanos 5 estrellas. ¡Muchas gracias!"--喜欢我们的游戏给5星好评,您的鼓励是我们持续优化的最大动力
L.WINORLOSE.NOW = "Apoyar ahora mismo"--立即支持
L.WINORLOSE.LATER = "Más tarde"--以后再说
L.WINORLOSE.SHARE = "Compartir"--分享
L.WINORLOSE.CONTINUE = "继续游戏"

-- 私人房
L.PRIVTE.ROOM_NAME = "Habitación privada"--私人房
L.PRIVTE.FINDTITLE = "Buscar"--查找房间
L.PRIVTE.CREATTITLE = "Crear"--创建房间
L.PRIVTE.INPUTROOMIDTIPS = "Ingrese el número de la habitación por favor"--请输入房间号
L.PRIVTE.ENTERROOM = "Entra ya"--立即进入
L.PRIVTE.TYPETIPS = "Duración de apostar:\n Campo Normal{1}s \n Campo Rápido{2}s"--下注思考时间:\n普通场{1}秒\n快速场{2}秒
L.PRIVTE.CREATEROOM = "Empieza ya"--立即开始
L.PRIVTE.CREATFREE = "Partida gratis"--限免开局
L.PRIVTE.INPUTPWDTIPS = "Por favor ingresa la clave, o deja espacio que significa que no tiene clave"--请输入房间密码,留空即无密码
L.PRIVTE.TIMEHOUR = "{1}hr(s)"--{1}小时
L.PRIVTE.PWDPOPTIPS = "Ingresa la contraseña válida"--请输入有效密码
L.PRIVTE.PWDPOPTITLE = "Ingresa la contraseña"--请输入密码
L.PRIVTE.PWDPOPINPUT = "Ingresa la contraseña"--请输入密码
L.PRIVTE.NOTIMETIPS = "Quedan{1}s, por favor vuelve a crear"--当前房间所剩时间{1}秒,即将解散,请重新创建！
L.PRIVTE.TIMEEND = "El tiempo ha sido agotado, por favor vuelve a crear"--当前房间时间已用完解散,请返回大厅重新创建！
L.PRIVTE.ENTERBYID = "Ingresa el número de la habitación para entrar"--输入房间号进入
L.PRIVTE.OWNER = "Dueño"--房主
L.PRIVTE.ROOMID = "NO.:{1}"--房间号:{1}
L.PRIVTE.LEFTDAY = "{1}día(s)"--{1}天
L.PRIVTE.LEFTHOUR = "{1}hr(s)"--1}小时
L.PRIVTE.LEFTMIN = "{1}min(s)"--{1}分钟
L.PRIVTE.ENTERLOOK = "Mirar"--围观
L.PRIVTE.ENTERPLAY = "Sentarse"--坐下
L.PRIVTE.ENTEREND = "Ya terminó"--已结束
L.PRIVTE.ENTERENDTIPS = "¡Ya no existe esta habitación, por favor entra en la otras habitaciones!"--当前房间已解散,请进入其他房间！
L.PRIVTE.ENTERCHECK = "¿Quiere entrar en esta habitación?"--您要加入此房间么?
L.PRIVTE.CHECKCREATE = "No hay habitación, crea una nueva"--暂无房间,创建新房间
L.PRIVTE.ROOMMAXTIPS = "¡Ha llegado al límite el número de habitación privada!"--您创建的私人房已经达到上限！

--活动
L.ACT.CHRISTMAS_HITRATE = "Exactitud{1}  Combo Max.{2}"--准确率{1}  最多连击{2}
L.ACT.CHRISTMAS_HITWIN = "Súper rápido, venció a {1} personas en este evento"--手速超快, 您在本活动中击败{1}的人
L.ACT.CHRISTMAS_FEED = {
    name = "¿Gané {1} fichas con una velocidad súper rápida, vencí a {2} personas y quiere aceptar el desafío?",--我以超快手速获得了{1}筹码,击败了{2}的人,敢来和我拼手速吗？
    caption = "Toca el regalo para obtener fichas, 100% seguro",--点礼物得筹码100%中奖
    link = L.FEED.SHARE_LINK .. "&feed=14",
    picture = appconfig.FEED_PIC_URL.."14.jpg",
    message = "",
}
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_1 = "Feliz Navidad, sacuda el teléfono y toca los regalos"--圣诞节快乐,摇晃手机点礼物
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_2 = "Feliz año nuevo, sacuda el teléfono y toca los regalos"--新年快乐,摇晃手机点礼物
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_3 = "Los regalos ya van a caer, ¿estás listo?"--礼物即将降落,准备好点击了吗？
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_4 = "Vuelve a probar mañana"--明天再来吧
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_5 = "Feliz Festival de la Primavera, sacuda el teléfono y toca los regalos"--春节快乐,摇晃手机点礼物
L.ACT.CHRISTMAS_HALL_GIRL_CHAT_6 = "七夕快乐，摇一摇，点击礼物有大惊喜哦。"

--红黑大战
L.REDBLACK.BET_DOUBLE = "Multiplicar"--加倍
L.REDBLACK.BET_LAST = "Repetir"--重复上局
L.REDBLACK.SELECTED_BET_TIPS = "Por favor selecciona la zona afortunada"--请选择幸运区域
L.REDBLACK.SELECTED_BET_END_TIPS = "Listo"--选择完毕
L.REDBLACK.START_GAME_TIPS = "El juego está a punto de comenzar({1})"--游戏即将开始({1})
L.REDBLACK.BET_FAILD = "No tiene suficientes monedas, falló al apostar"--您的游戏币不足,下注失败
L.REDBLACK.BET_FAILD_2 = "No tiene suficientes monedas para apostar {1} en esta partida, se ha cambiado a {2}"--您的游戏币不足当前所选的下注额度{1},已经自动切换到{2}
L.REDBLACK.BET_FAILD_TIMES_OUT = "Falló al apostar, se acabó el tiempo"--下注时间已到,下注失败
L.REDBLACK.BET_LIMIT_TIPS = "Falló al apostar, no puede apostar más de {1} en esta partida"--下注失败,当局下注不能超过{1}
L.REDBLACK.ALL_PLAYER = "En total hay {1} persona(s) en esta habitación"--当前房间共有 {1} 人
L.REDBLACK.RECENT_TREND = "Tendencia de moda:"--近期走势:
L.REDBLACK.TODAY_COUNT = "Estadística de Hoy:"--今日统计:
L.REDBLACK.WIN_LOSE = "Ganar o perder"--胜 负
L.REDBLACK.HAND_CARD = "cartas personales"--手 牌
L.REDBLACK.WIN_CARD_TYPE = "Mano ganadora"--获胜牌型
L.REDBLACK.COUNT_TIPS_1 = "Victoria Gold:{1}"--金象胜利:{1}
L.REDBLACK.COUNT_TIPS_2 = "Victoria Silver:{1}"--银象胜利:{1}
L.REDBLACK.COUNT_TIPS_3 = "Empate:{1}"--平局:{1}
L.REDBLACK.COUNT_TIPS_4 = "Suited Connector:{1}"--同花连牌:{1}
L.REDBLACK.COUNT_TIPS_5 = "AA:{1}"--对A:{1}
L.REDBLACK.COUNT_TIPS_6 = "Full:{1}"--葫芦:{1}
L.REDBLACK.COUNT_TIPS_7 = "Póquer/Escalera de color/Escalera real:{1}"--金刚/皇家/同花顺:{1}
L.REDBLACK.SUB_TAB_TEXT = {
    "Tendencia",--胜负走势
    "Reglas del juego",--游戏规则
}
L.REDBLACK.RULE = [[
¡Elija a los jugadores que apoya y gane más recompensas!

Reglas básicas:

1. Se reparten cartas personas para Gold y Silver primero, y después se reparten 5 cartas comunes, y se muestra una de ellas.

2. Los jugadores pueden apoyar a cualquier facción o zona según la información pública

3. Muestran las cartas comunes y las cartas privadas y les dan las recompensas según el resultado y la zona.

Hay un límite para la inversión diaria. ¡Emplea tácticas flexibles y apoya a tus jugadores favoritos!
]]

--新手引导
L.TUTORIAL.SETTING_TITLE = "Tutorial"--新手教学
L.TUTORIAL.FIRST_IN_TIPS = [[
Te damos la bienvenida a Súper Póquer
Victoria va a enseñarte a jugar este juego popular paso a paso. Puedes omitir la guía si ya conoces el juego, si no, haz clic para comenzar a enseñar.

¡La primera vez que completes el tutorial también podrás recibir 8,000 fichas!
]]
L.TUTORIAL.FIRST_IN_BTN1 = "Omitir"--跳过引导
L.TUTORIAL.FIRST_IN_BTN2 = "Comenzar a enseñar"--开始教学
L.TUTORIAL.END_AWARD_TIPS = "Termina el tutorial para recoger las recompensas"--完成教程领取筹码
L.TUTORIAL.FINISH_AWARD_TIPS = "Felicidades, ha obtenido {1} fichas del Paquete Tutorial, puede volver a aprender o empezar enseguida"--恭喜你,您获得了{1}筹码的新手教学礼包,您可以选择再来一遍或者立即开始
L.TUTORIAL.FINISH_NOAWARD_TIPS = "¡Ya es experto, puede volver a aprender o empezar enseguida!"--您已经是德州扑克高手啦,您可以选择再来一遍或者立即开始
L.TUTORIAL.FINISH_FIRST_BTN = "Volver a aprender"--重新学习
L.TUTORIAL.FINISH_SECOND_BTN = "Empieza ya"--快速开始
L.TUTORIAL.SKIP = "Omitir"--跳 过
L.TUTORIAL.NEXT_STEP = "Siguiente"--下一步
L.TUTORIAL.GUESS_TRUE_13 = "Correcto, ahora tienes un par de (A), bastante grande.\n\nToca en cualquier lugar de la pantalla para apostar en la ronda siguiente"--答对了,您现在有一对(A),挺大的。\n\n点击任意位置进入下一轮下注
L.TUTORIAL.GUESS_TRUE_22 = "Correcto, ahora tienes dos pares de (A/9).\n\nToca en cualquier lugar de la pantalla para apostar en la ronda siguiente"--答对了,您现在有两对(A/9)。\n\n点击任意位置进入下一轮下注
L.TUTORIAL.GUESS_TRUE_27 = "Correcto, ahora tienes el Full (9/A).\n\nToca en cualquier lugar de la pantalla para apostar en la ronda siguiente"--答对了,您现在是葫芦(9/A)。\n\n点击任意位置进入下一轮下注
L.TUTORIAL.GUESS_FLASE = "Incorrecto,piénsalo..."--错啦,再仔细想想...
L.TUTORIAL.RE_SELECT = "Volver a elegir"--重选
L.TUTORIAL.TIPS = {
    "Salir del menú",--退出菜单
    "Comprar fichas",--购买筹码
    "Darle clic para ver la información,regalar fichas o usar artículos",--点击查看他人信息 赠送筹码 使用互动道具
    "Cartas comunes",--公共牌
    "Darle clic para abrir el Slots",--滑出或者点击打开老虎机
    "Mi avatar",--我的头像
    "Mis cartas privadas",--我的手牌
    "Botón de operación",--操作按钮
    "Darle clic para charlar o enviar emotición",--点击聊天 发送表情
}
L.TUTORIAL.ROOM_STEP_1 = "¡Te damos la bienvenida a Open Póquer! Termina el tutorial para recoger {1} fichas gratis, sólo para la primera vez.\n\nToca en cualquier lugar de la pantalla para seguir"--欢迎来到开源德州扑克！首次完成新手引导即可获赠{1}筹码。\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_2 = "Al comienzo de cada partida la Crupier reparte 2 cartas privadas a cada jugador que solo el jugador puede ver.\n\nToca en cualquier lugar de la pantalla para seguir"--游戏开始荷官会给每个人发两张手牌,只有自己可见。\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_3 = "Y después va a repartir 5 cartas comunes que todos los juegadores pueden ver.\n\nToca en cualquier lugar de la pantalla para seguir"--之后会逐步发出5张公牌,公牌所有玩家都可以看到。\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_4 = "El objetivo es formar la mejor combinación de 5 cartas, a partir de las 7 de las que disponemos: nuestras 2 cartas en mano (cartas privadas), y las 5 cartas comunes (públicas o comunitarias), vamos a ver el orden de las diferentes combinaciones de cartas: Escalera Real(La más alta) -> Carta alta(La más baja)"--你最后成牌是从公牌和手牌中选5张组成的最大牌型构成,牌型大小如图所示(皇家同花顺最大->高牌最小)
L.TUTORIAL.ROOM_STEP_5 = "Ahora tiene la combinación más fuerte del poker, es decir \"Escalera Real\"(5 cartas del mismo palo en orden consecutivo, desde el 10 hasta el As.), el cursor brillante es la mejor combinación.\n\nToca en cualquier lugar de la pantalla para seguir"--您当前组成的最大牌型则是皇家同花顺(5张相同花色顺子10 J Q K A),光标闪烁处就是选中的最大牌组合。\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_6 = "¿Me entiendes?\n¡Ahora, vamos a practicar!\n\n Toca en cualquier lugar de la pantalla para seguir"--都掌握了吗？\n下面我们正式开始一局吧！\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_7 = "Puedes tomar decisiones en esta zona cuando es tu turno.\n\nToca en cualquier lugar de la pantalla para seguir"--此处是玩牌操作区域,轮到你操作时,可以根据自己的牌选择相应操作。\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_8 = "¡Es tu turno! Se ven bien tus cartas.\n\nToca en cualquier lugar de la pantalla para seguir"--现在轮到你了,你当前的牌还不错! \n\n点击按钮选择跟注
L.TUTORIAL.ROOM_STEP_11= "Los 2 jugadores se han decidido a igualar la apuesta (call), parece que no tienen la combinación buena, ahora se reparten 3 cartas comunes.\n\nToca en cualquier lugar de la pantalla para seguir"--其他两个玩家都选择CALL,看样也没什么好牌,现在发前三张公牌。\n\n点击任意位置进入下一步
L.TUTORIAL.ROOM_STEP_13= "Ahora tienes la nueva combinación, ¿adivinas cuál es?"--三张公牌发完,你组成了新的牌型,猜猜你现在的牌型是什么？
L.TUTORIAL.ROOM_STEP_14= "Venga, ahora te toca a ti, piénsalo bien, quizá tenga el \"Color(5 cartas del mismo palo), mejor seleccionamos \"Pasar\"\", "--又轮到你了,先想想下一步怎么操作,别人有可能会是同花(梅花),先选择一把看牌
L.TUTORIAL.ROOM_STEP_16= "El jugador {1} ha seleccionado \"Subir\", ten cuidado, si selecciona \"Subir\", quiza tenga una combinación fuerte."--玩家{1}选择了加注,加注一般有比较强的牌力,要小心,先静观其变吧
L.TUTORIAL.ROOM_STEP_18= "El jugador {1} ha seleccionado \"Retirarse\" que significa que pierde todas sus apuestas de esta partida. Pero es lógico cuando no tiene buenas cartas."--玩家{1}选择了弃牌,弃牌就意味着这一局输掉所有已经下注的筹码,当牌力不够的时候选择弃牌比较合理
L.TUTORIAL.ROOM_STEP_19= "Tu turno. ¡Bien, tienes un par de (A)! Aposta la misma cantidad apostada en la ciega grande (CALL), vamos a ver la cuarta carta común."--又轮到你了,当前牌力不错一对(A),CALL下看第四张公牌
L.TUTORIAL.ROOM_STEP_22= "Bueno, ahora tienes la nueva combinación, ¿adivinas cuál es?"--四张公牌发完,你又组成了新的牌型,猜猜你现在的牌型是什么？
L.TUTORIAL.ROOM_STEP_23= "Sólo quedan 2 jugadores, ahora tienes dos pares de (A/9), está bien, puedes apostar {1} fichas más."--游戏只剩两个玩家了,你现在有两对(A/9),牌力不错,可以加注{1}试试
L.TUTORIAL.ROOM_STEP_25= "{1} también subir la apuesta, vamos a ver la quinta carta."--{1}也选择跟住,游戏将发第五张公牌
L.TUTORIAL.ROOM_STEP_27= "Ya tienes la combinación final. ¿A ver qué es?"--五张公牌都发完啦,你的最终牌型也确定了,你的最终牌型是什么？
L.TUTORIAL.ROOM_STEP_29= "{1} ha decidido \"ALL_IN\", quizá tenga cartas muy buenas. ¡Pero tienes Full, también es muy fuerte! ¡ALL IN!"--{1}ALL_IN了,预测牌力不小,但你葫芦(9/A)也很大,跟了!
L.TUTORIAL.ROOM_STEP_32= "{1} tiene \"Color\", pero tienes \"Full\" (Full>Color). ¡Has ganado todas las fichas de esta partida!"--最后亮牌了,{1}是同花,你是葫芦,你赢了(葫芦>同花)！您获得了底池所有的筹码！
L.TUTORIAL.ROOM_STEP_34= "Estos son otros elementos del juego, puedes explotarlos después."--这是游戏的其他元素,需要你自己去探索啦

--保险箱
L.SAFE.TITLE = "Caja fuerte"--保险箱
L.SAFE.TAB_TEXT = {
    "Moneda",--游戏币
    "Diamante",--钻石
}
L.SAFE.SAVE_MONEY = "Depositar"--存入
L.SAFE.GET_MONEY = "Sacar"--取出
L.SAFE.SET_PASSWORD = "Establecer contraseña"--设置密码
L.SAFE.CHANGE_PASSWORD = "Cambiar contraseña"--修改密码
L.SAFE.MY_SAFE = "Mi caja fuerte"--我的保险箱
L.SAFE.MY_PURSE = "Efectivo"--我的携带
L.SAFE.SET_PASSWORD_TIPS_1 = "Nueva contraseña"--请输入新密码
L.SAFE.SET_PASSWORD_TIPS_2 = "Confirmar contraseña"--请再次新输入密码
L.SAFE.SET_PASSWORD_TIPS_3 = "La contraseña que has confirmado no es igual que la otra, vuelve a intentarlo"--两次输入密码不一致,请重新输入
L.SAFE.SET_PASSWORD_TIPS_4 = "La contraseña está vacía, vuelve a intentarlo"--密码不能为空,请重新输入！
L.SAFE.SET_PASSWORD_TIPS_5 = "Por favor ingrese la contraseña para abrir la caja fuerte"--请输入密码,打开保险箱
L.SAFE.FORGET_PASSWORD = "¿Olvidaste tu contraseña?"--忘记密码
L.SAFE.VIP_TIPS_1 = "Todavía no es VIP. ¿Si quiere ser VIP y disfruta los privilegios y descuentos?"--您还不是VIP用户,暂时无法使用,是否立即成为VIP,还有超多优惠和特权.
L.SAFE.VIP_TIPS_2 = "Ya no es VIP. ¿Si quiere ser VIP y disfruta los privilegios y descuentos?"--您的VIP已经过期,暂时无法存入,是否立即成为VIP,还有超多优惠和特权.
L.SAFE.SET_PASSWORD_SUCCESS = "Establecido con éxito"--设置密码成功!
L.SAFE.SET_PASSWORD_FAILED = "Falló al establecer contraseña, vuelve a intentar"--设置密码失败,请重试!
L.SAFE.CHANGE_PASSWORD_SUCCESS = "¡La solicitud de cambio de contraseña se efectuó correctamente!"--修改密码成功!
L.SAFE.CHANGE_PASSWORD_FAILED = "Falló al cambiar contraseña, vuelve a intentarlo"--修改密码失败,请重试!
L.SAFE.CHECK_PASSWORD_ERROR = "Contraseña incorrecta, vuelve a intentarlo"--输入的密码错误,请重新输入!
L.SAFE.CHECK_PASSWORD_FAILED = "Error al verificar la contraseña, vuelve a intentarlo"--验证密码失败,请重试!
L.SAFE.SAVE_MONEY_FAILED = "Falló al depositar, vuelve a intentarlo"--存钱失败,请重试!
L.SAFE.GET_MONEY_FAILED = "Falló al sacar dinero, vuelve a intentarlo"--取钱失败,请重试!
L.SAFE.INPUT_MONEY_TIPS = "Por favor ingrese una cifra más de 0 para depositar"--请输入大于0的数值,进行存取.
L.SAFE.SET_EMAIL = "Establecer correo"--设置安全邮箱
L.SAFE.SET_EMAIL_BTN = "Toca para establecer"--点击设置
L.SAFE.CHANGE_EMAIL_BTN = "Cambiar correo"--修改邮箱
L.SAFE.SET_EMAIL_TIPS_1 = "Para proteger mejor su propiedad, por favor, vincule el correo electrónico para asegurarse de recibir el correo. El correo se puede usar para restablecer la contraseña y otras operaciones.\nTambién podrá recibir 20 mil monedas si vincula el correo."--为了更好的保护您的财产,请绑定常用邮箱,以确保收到邮件.邮件可以用于重置密码等操作.\n首次绑定还可以奖励20K游戏币.
L.SAFE.SET_EMAIL_TIPS_2 = "Vinculado con éxito"--您已经成功绑定邮箱!
L.SAFE.SET_EMAIL_TIPS_3 = "Correo electrónico,por ejemplo: openpokerxxx@gmail.com"--电子邮箱,例如openpokerxxx@gmail.com
L.SAFE.SET_EMAIL_TIPS_4 = "Por favor ingrese el correo correcto"--请输入正确的邮箱格式!
L.SAFE.SET_EMAIL_TIPS_5 = "Todavía no has establecido el correo, después de establecer puedes recuperar la contraseña por correo electrónico"--你还没有设置安全邮箱,设置后可通过邮箱找回密码
L.SAFE.SET_EMAIL_TIPS_6 = "Has establecido el correo: {1}"--您已经设置了安全邮箱:{1}
L.SAFE.SET_EMAIL_SUCCESS = "Vinculado con éxito"--绑定邮箱成功!
L.SAFE.SET_EMAIL_TIPS_FAILED = "Falló al vincular, vuelve a intentarlo"--绑定邮箱失败,请重试!
L.SAFE.RESET_PASSWORD_TIPS_1 = "Se ha enviado la información de restablecimiento. Abra el correo electrónico y haga clic en el enlace para confirmar."--重置信息已提交,请立即登录邮箱点击链接验证.
L.SAFE.RESET_PASSWORD_TIPS_2 = "Establezca una nueva contraseña y haga clic en Confirmar, el sistema enviará un enlace de verificación a su correo, haga clic en el enlace en 5 minutos para restablecerla"--设置新的密码,点击确定,系统将发送验证链接到您的安全邮箱,5分钟内点击链接激活即可重置成功.
L.SAFE.RESET_PASSWORD_TIPS_3 = "Lo sentimos mucho, esta función no esta disponible porque no ha vinculado el correo, por favor contacte con nuestro servicio de atención al cliente."--对不起,由于您没有绑定邮箱,所以无法此功能.请您联系客服.
L.SAFE.RESET_PASSWORD_TIPS_4 = "Falló al enviar la información de restablecimiento, vuelve a intentarlo"--重置信息提交失败,请重试.
L.SAFE.RESET_PASSWORD = "Restablecer contraseña"--重置密码
L.SAFE.CLEAN_PASSWORD = "Borrar contraseña"--清空密码
L.SAFE.CLEAN_PASSWORD_SUCCESS = "Borrado con éxito"--清空密码成功!
L.SAFE.CLEAN_PASSWORD_FAILED = "Falló al borrar la contraseña, vuelve a intentarlo"--清空密码失败,请重试!

--夺金岛
L.GOLDISLAND.TITLE = "Isla Oro"--夺金岛
L.GOLDISLAND.RULE_BTN = "Reglas"--详细规则
L.GOLDISLAND.BUY_BTN = "Comprar para la partida siguiente"--购买下局
L.GOLDISLAND.ALREADY_BUY = "Ha comprado"--已购买
L.GOLDISLAND.PRICE = "{1} fichas/vez"--{1}筹码/次
L.GOLDISLAND.AUTO_BUY = "Auto Comprar"--自动购买
L.GOLDISLAND.BUY_SUCCESS = "Ha comprado la Isla Oro de la partida siguiente"--买入下一局夺金岛成功
L.GOLDISLAND.BUY_FAILED = "Faltan fichas, no puede comprar la Isla Oro de la partida siguiente"--您身上的筹码不足以购买下一局的夺金岛了
L.GOLDISLAND.BUY_TIPS = "Debe sentarse primero si quiere comprar la Isla Oro de la partida siguiente"--必须坐下,才能购买下一局的夺金岛
L.GOLDISLAND.RULE_TITLE = "Instrucción"--夺金岛规则说明
L.GOLDISLAND.RULE_POOL = "Recompensas:"--奖池:
L.GOLDISLAND.RULE_DESC = [[
1. Sólo se puede agregar la Isla Oro cuando se siente en una partida con la Ciega más de 3000, la tarifa de registro es 2000 fichas por partida(La deducción se le hará directamente de las fichas que lleva), la tarifa de registro será una parte de las recompensas.

2. Después de participar en una partida de la Isla Oro, podrá ganar un montón de fichas si tiene la combinación específica.

Escalera real: 80% del pozo del premio
Escalera de color: 30% del pozo del premio
Póquer: 10% del pozo del premio

3. Entra en vigor después de las 5 cartas comunes se repartieron. No entra en vigor si la partida termina antes, por ejemplo, un jugador se ha retirado o todos los demás jugadores se han retirardo o . El tipo de carta no es válido. El jugador debe jugar hasta el fin para ganar la Isla Oro (no se exige ganar).

4. Recompensas: El sistema agregará automáticamente las fichas ganadoras a la cuenta del jugador.

5. Participación: Haga clic en el icono de la Isla Oro para comprar. Hay 2 opciones: Comprar automáticamente o Comprar 1 vez.
]]
L.GOLDISLAND.REWARD_TITLE = "Felicidades, ha ganado la Isla Oro"--恭喜赢得夺金岛
L.GOLDISLAND.REWARD_BTN = "Ya lo sé"--我知道了
L.GOLDISLAND.CARD_TYPE = "Su combinación:{1}"--您的牌型为:{1}
L.GOLDISLAND.REWARD_NUM = "Ha ganado un {1}% del pozo del premio:"--获得夺金岛{1}%的奖池:
L.GOLDISLAND.REWARD_TIPS = "Ya le enviamos las recompensas a su cuenta personal"--奖金已发送至您的个人账户中
L.GOLDISLAND.BROADCAST_REWARD_TIPS = "Felicidades a {1}, ha obtenido {3} fichas con {2}."--恭喜玩家{1}在夺金岛压中{2}获得{3}筹码的奖金!

--支付引导
L.CHECKOUTGUIDE.BTN_TITLE = "วิธีชำระค่าโทรผ่าน\nGoogle Play"
L.CHECKOUTGUIDE.TITLE = "谷歌官方支付教程"
L.CHECKOUTGUIDE.TAB_TEXT = {
    "话费支付",
    "银行卡支付"
}
L.CHECKOUTGUIDE.SMS_TITLE = "用话费支付(仅支持AIS/DTAC的电话卡)"
L.CHECKOUTGUIDE.SMS_STEP = {
    "进入游戏->选择GooglePlay->点击购买需要的商品->出现下图所示弹框->点击红框中的下拉箭头",
    "点击dtac账户或ais账户(根据您的电话卡而定)",
    "输入谷歌邮箱密码后点击确认",
    "付款成功",
}
L.CHECKOUTGUIDE.CARD_TITLE = "用银行卡付款"
L.CHECKOUTGUIDE.CARD_STEP = {
    "进入游戏->选择GooglePlay->点击购买需要的商品->出现下图所示弹框->点击红框中的下拉箭头",
    "点击添加信用卡或借记卡",
    "添加信用卡或借记卡信息",
    "绑定好银行信息之后,购买筹码时系统会显示确认购买弹框-＞点击购买",
    "输入谷歌邮箱密码后点击确认",
    "付款成功",
}
L.CHECKOUTGUIDE.TRUE_WALLET_TITLE = "用虚拟信用卡付款"
L.CHECKOUTGUIDE.TRUE_WALLET_STEP = "1.下载true wallet\n2.点击we card,开通虚拟信用卡"
L.CHECKOUTGUIDE.TRUE_WALLET_MORE = "更多true wallet信息请看"

--绑定账号
L.BIND.BTN_TITLE = "Aumentar la seguridad de la cuenta+{1}"
L.BIND.TITLE = "Aumentar gratis la seguridad de la cuenta"
L.BIND.BTN_TITLE_2 = {
    "Vincular con Facebook",
    "Vincular con Line",
    "Vincular con VK"
}
L.BIND.ACCOUNT = {
    "Cuenta de Facebook",
    "Cuenta de Line",
    "Cuenta de VK"
}
L.BIND.SUCCESS_TITLE = "“Vinculado”"
L.BIND.FAILED_TITLE = "Fallo al vincular"
L.BIND.GET_REWARD = "Reclamalo enseguida"
L.BIND.GET_REWARD_FAILED = "Fallo al reclamar, intentalo de nuevo por favor"
L.BIND.GET_REWARD_TIPS = "Ha vinculado su cuenta de visitante a {1}, y puede iniciar sesión con cualquier manera, y podrá obtener {2} fichas como recompensas."
L.BIND.FAILED_TIPS = "Lo sentimos mucho, esta cuenta ya se ha registrado\nPuede volver a vincular con otra cuenta o iniciar sesión directamente con la cuenta existente."
L.BIND.FAILED_TIPS_2 = "Fallo al vincular, intentalo de nuevo por favor"
L.BIND.GOTO_LOGIN = "Iniciar sesión"
L.BIND.RETRY = "Volver a vincular"
L.BIND.CANCELED = "Cancelar"

--支付引导
L.PAYGUIDE.FIRST_GOODS_DESC = {
    "送VIP",
    "送动态头像",
}
L.PAYGUIDE.FIRST_GOODS_DESC_2 = {
    "7天 VIP1",
    "动态头像",
    "最高3倍筹码"
}
L.PAYGUIDE.GOTO_STORE = "前往商城充值"
L.PAYGUIDE.GET_CARSH_REWARD = "领取{1}救济金"
L.PAYGUIDE.FIRST_PAY_TIPS = "购买商城任意筹码可以获赠以上礼品"
L.PAYGUIDE.BUY_PRICE_1 = "{1}抢购"
L.PAYGUIDE.BUY_PRICE_2 = "原价{1}"
L.PAYGUIDE.ROOM_FIRST_PAY_TIPS = "首冲仅有一次机会"
return L
