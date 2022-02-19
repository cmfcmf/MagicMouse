preferences
portalsOnRightClick
	<preference: 'Create portals on right click' category: 'MagicMouse' description: 'Whether to create portals instead of sending right click events on right clicks.' type: #Boolean>

	^ PortalsOnRightClick ifNil: [true]