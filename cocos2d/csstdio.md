    local ui_activity = cc.uiloader:load("test_ui.csb")
    local uiz= ui_activity:getChildren()
    local actz_ui = uiz[1]
    actz_ui:removeFromParent()
    window:addChild(actz_ui)
    actz_ui:setTouchEnabled(true)
    actz_ui:setClippingEnabled(true)

    local panTop = cc.uiloader:seekNodeByName(actz_ui, "TextField_1")
    local Button_1 = cc.uiloader:seekNodeByName(actz_ui, "Button_1")


    local centButton = ccui.Button:create("login/btn_RedButton+N_normal.png", "login/btn_RedButton+N_select.png")
    centButton:setName("centButton")
    window:addChild(centButton)

    local centButton2 = ccui.Button:create("login/btn_RedButton+N_normal.png", "login/btn_RedButton+N_select.png")
    centButton2:setName("centButton")
    window:addChild(centButton2)
    centButton2:setPosition(100,100)