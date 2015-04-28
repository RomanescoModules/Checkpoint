class Checkpoint extends g.RShape
	@Shape = paper.Path.Rectangle
	@rname = 'Checkpoint'
	@rdescription = """Draw checkpoints on a video game area to create a race
	(the players must go through each checkpoint as fast as possible, with the car tool)."""
	@squareByDefault = false

	@parameters: ()->
		return {} 		# we do not need any parameter

	# register the checkpoint if we are on a video game
	initialize: ()->
		@game = g.gameAt(@rectangle.center)
		if @game?
			if @game.checkpoints.indexOf(@)<0 then @game.checkpoints.push(@)
			@data.checkpointNumber ?= @game.checkpoints.indexOf(@)
		return

	# just draw a red rectangle with the text 'Checkpoint N' N being the number of the checkpoint in the videogame
	# we could also prevent users to draw outside a video game
	createShape: ()->
		@data.strokeColor = 'rgb(150,30,30)'
		@data.fillColor = null
		@shape = @addPath(new Path.Rectangle(@rectangle))
		@text = @addPath(new PointText(@rectangle.center.add(0,4)))
		@text.content = if @data.checkpointNumber? then 'Checkpoint ' + @data.checkpointNumber else 'Checkpoint'
		@text.justification = 'center'
		return

	# checks if the checkpoints contains the point, used by the video game to test collisions between the car and the checkpoint
	contains: (point)->
		delta = point.subtract(@rectangle.center)
		delta.rotation = -@rotation
		return @rectangle.contains(@rectangle.center.add(delta))

	# we must unregister the checkpoint before removing it
	remove: ()->
		@game?.checkpoints.remove(@)
		super()
		return

tool = new g.PathTool(Checkpoint, true)