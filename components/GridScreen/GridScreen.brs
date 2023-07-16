' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' entry point of GridScreen
' Note that we need to import this file in GridScreen.xml using relative path.
sub Init()
    m.rowList = m.top.FindNode("rowList")
    m.rowList.SetFocus(true)
    ' label with item description
    m.descriptionLabel = m.top.FindNode("descriptionLabel")
    ' label with item title
    m.titleLabel = m.top.FindNode("titleLabel")
    m.videoUrl = m.top.findNode("videoUrl")
    
    m.videoNode = m.top.findNode("campaignVideoNode")
    
    m.okClickCheckLabel = m.top.findNode("okClickCheckLabel")
    
    ' observe rowItemFocused so we can know when another item of rowList will be focused
    m.rowList.ObserveField("rowItemFocused", "OnItemFocused")
    m.rowList.ObserveField("rowItemSelected", "onRowItemSelectedChanged")
    m.videoNode.ObserveField("state", "onVideoStateChanged")

end sub

sub OnItemFocused() ' invoked when another item is focused
    focusedIndex = m.rowList.rowItemFocused ' get position of focused item
    row = m.rowList.content.GetChild(focusedIndex[0]) ' get all items of row
    item = row.GetChild(focusedIndex[1]) ' get focused item
    ' update description label with description of focused item
    m.descriptionLabel.text = item.description
    ' update title label with title of focused item
    m.titleLabel.text = item.title
    ' adding length of playback to the title if item length field was populated
    if item.length <> invalid
        m.titleLabel.text += " | " + GetTime(item.length)
    end if
    
    m.videoUrl.text = "URL " + item.videoUrl
end sub

' this method convert seconds to mm:ss format
' getTime(138) returns 2:18
function GetTime(length as Integer) as String
    minutes = (length \ 60).ToStr()
    seconds = length MOD 60
    if seconds < 10
       seconds = "0" + seconds.ToStr()
    else
       seconds = seconds.ToStr()
    end if
    return minutes + ":" + seconds
end function

sub onRowItemSelectedChanged()
    print "selected"

    focusedIndex = m.rowList.rowItemFocused ' get position of focused item
    row = m.rowList.content.GetChild(focusedIndex[0]) ' get all items of row
    item = row.GetChild(focusedIndex[1]) ' get focused item
    
    videocontent = createObject("RoSGNode", "ContentNode")

    videocontent.title = item.title
    videocontent.streamformat = item.videoType
    videocontent.url = item.videoUrl
      
    m.videoNode.content = videocontent
    m.videoNode.visible = true
    m.videoNode.setFocus(true)

    m.videoNode.control = "play"
end sub

sub ReturnToGrid()
    m.videoNode.visible = false
    videocontent = createObject("RoSGNode", "ContentNode")
    m.videoNode.content = videocontent
    m.rowList.SetFocus(true)
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
  handled = false
  if press then
    if (key = "back") then
      ReturnToGrid()
      handled = true
    else
      handled = true
    end if
  end if
  return handled
end function

function onVideoStateChanged(event as Object)
    newState = event.getData()
    print newState
    if newState <> invalid
        if newState = "finished"
            ReturnToGrid()
        end if
    end if
end function

