local P = import(".PROTOCOL")
local GameSocket = import("app.games.texas.net.GameSocket")
local TexasMustGameSocket = class("TexasMustGameSocket", GameSocket)

function TexasMustGameSocket:ctor(proxySocket)
	TexasMustGameSocket.super.ctor(self, proxySocket)
end

function TexasMustGameSocket:getProtocol()
	return P
end

return TexasMustGameSocket