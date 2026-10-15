define(["brease"], function({core:{designer:{BaseWidget:{ClassInfo:s}}}}, e) {const classInfo={meta:{className:"widgets.MyWidgets.FileBrowser",parents:["*"],children:[],inheritance:["widgets.MyWidgets.FileBrowser","brease.core.BaseWidget"],creator:"03a37c73f6ace9ed837cf4c693a78189",eventBindingApi:function (w) {
function a(e, f) { w.addServerEventListener(e, f); }
function c(...args) { const [{ action: a }] = args.slice(-1); return w[a](...args); }
return {
click: f => a('Click', f),
disabledClick: f => a('DisabledClick', f),
enableChanged: f => a('EnableChanged', f),
fileDownloaded: f => a('FileDownloaded', f),
fileUploaded: f => a('FileUploaded', f),
focusIn: f => a('FocusIn', f),
focusOut: f => a('FocusOut', f),
onError: f => a('OnError', f),
pathChanged: f => a('PathChanged', f),
selectionChanged: f => a('SelectionChanged', f),
visibleChanged: f => a('VisibleChanged', f),
download: function () { c({ origin: 'action', action: 'Download' }); },
refresh: function () { c({ origin: 'action', action: 'Refresh' }); },
upload: function () { c({ origin: 'action', action: 'Upload' }); },
focus: function () { c({ origin: 'action', action: 'focus' }); },
setEnable: function (a1) { c(a1,{ origin: 'action', action: 'setEnable' }); w._ebFVC({enable: 'getEnable'}, false);},
setMaxFileSize: function (a1) { c(a1,{ origin: 'action', action: 'setMaxFileSize' }); w._ebFVC({maxFileSize: 'getMaxFileSize'}, false);},
setOverwriteCancelText: function (a1) { c(a1,{ origin: 'action', action: 'setOverwriteCancelText' }); w._ebFVC({overwriteCancelText: 'getOverwriteCancelText'}, false);},
setOverwriteConfirmText: function (a1) { c(a1,{ origin: 'action', action: 'setOverwriteConfirmText' }); w._ebFVC({overwriteConfirmText: 'getOverwriteConfirmText'}, false);},
setOverwritePrompt: function (a1) { c(a1,{ origin: 'action', action: 'setOverwritePrompt' }); w._ebFVC({overwritePrompt: 'getOverwritePrompt'}, false);},
setPath: function (a1) { c(a1,{ origin: 'action', action: 'setPath' }); w._ebFVC({path: 'getPath'}, false);},
setStyle: function (a1) { c(a1,{ origin: 'action', action: 'setStyle' }); w._ebFVC({style: 'getStyle'}, false);},
setVisible: function (a1) { c(a1,{ origin: 'action', action: 'setVisible' }); w._ebFVC({visible: 'getVisible'}, false);},
showTooltip: function () { c({ origin: 'action', action: 'showTooltip' }); }
};
},actions:{"Download":{"method":"Download"},"Refresh":{"method":"Refresh"},"Upload":{"method":"Upload"},"Focus":{"method":"focus"},"setAdditionalStyle":{"method":"setAdditionalStyle","parameter":{"styleName":{"name":"styleName","index":0,"type":"StyleReference"}}},"setAllowFolderNavigation":{"method":"setAllowFolderNavigation","parameter":{"value":{"name":"value","index":0,"type":"Boolean"}}},"setConfirmOverwrite":{"method":"setConfirmOverwrite","parameter":{"value":{"name":"value","index":0,"type":"Boolean"}}},"setDialogFontSize":{"method":"setDialogFontSize","parameter":{"value":{"name":"value","index":0,"type":"Integer"}}},"setDialogWidth":{"method":"setDialogWidth","parameter":{"value":{"name":"value","index":0,"type":"Integer"}}},"setEditable":{"method":"setEditable","parameter":{"editable":{"name":"editable","index":0,"type":"Boolean"},"metaData":{"name":"metaData","index":1,"type":"Object"}}},"SetEnable":{"method":"setEnable","parameter":{"value":{"name":"value","index":0,"type":"Boolean"}}},"setFontSize":{"method":"setFontSize","parameter":{"value":{"name":"value","index":0,"type":"Integer"}}},"SetMaxFileSize":{"method":"setMaxFileSize","parameter":{"maxFileSize":{"name":"maxFileSize","index":0,"type":"Integer"}}},"setOmitDisabledClick":{"method":"setOmitDisabledClick"},"SetOverwriteCancelText":{"method":"setOverwriteCancelText","parameter":{"text":{"name":"text","index":0,"type":"String"}}},"SetOverwriteConfirmText":{"method":"setOverwriteConfirmText","parameter":{"text":{"name":"text","index":0,"type":"String"}}},"SetOverwritePrompt":{"method":"setOverwritePrompt","parameter":{"text":{"name":"text","index":0,"type":"String"}}},"setParentCoWiId":{"method":"setParentCoWiId","parameter":{"value":{"name":"value","index":0,"type":"String"}}},"setParentEnableState":{"method":"setParentEnableState"},"setParentVisibleState":{"method":"setParentVisibleState"},"SetPath":{"method":"setPath","parameter":{"path":{"name":"path","index":0,"type":"String"}}},"setRowHeight":{"method":"setRowHeight","parameter":{"value":{"name":"value","index":0,"type":"Integer"}}},"setShowDate":{"method":"setShowDate","parameter":{"value":{"name":"value","index":0,"type":"Boolean"}}},"setShowSize":{"method":"setShowSize","parameter":{"value":{"name":"value","index":0,"type":"Boolean"}}},"SetStyle":{"method":"setStyle","parameter":{"value":{"name":"value","index":0,"type":"StyleReference"}}},"setTabIndex":{"method":"setTabIndex","parameter":{"value":{"name":"value","index":0,"type":"Number"}}},"SetVisible":{"method":"setVisible","parameter":{"value":{"name":"value","index":0,"type":"Boolean"}}},"ShowTooltip":{"method":"showTooltip"}},properties:{}}};if(s.classExtension) {classInfo.classExtension = s.classExtension;}if(e) {classInfo.classExtension = e;}return classInfo;});
