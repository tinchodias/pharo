do/undo
redo
	editor selection start moveRight: startDelta.
	editor selection end moveRight: endDelta.
	editor notifySelectionChange: editor selection
	