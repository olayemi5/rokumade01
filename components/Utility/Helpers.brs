sub ReturnToGrid()
    m.videoNode.visible = false
    videocontent = createObject("RoSGNode", "ContentNode")
    m.videoNode.content = videocontent
    m.rowList.SetFocus(true)
end sub