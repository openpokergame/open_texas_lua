local EventObject = class("EventObject")

function EventObject:ctor()
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
end

return EventObject