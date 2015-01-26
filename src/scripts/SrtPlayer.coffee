###
 * @class SrtPlayer
###

Backbone = require 'backbone'
_ = require 'underscore'
# raf = require 'raf'

module.exports =
	class SrtPlayer
		_animId: null
		_emptyFired: yes
		_currentPacketId: -1
		_isPlaying: no
		_playHead: -1
		_sourceFile: null
		_startTime: null


		###
		 * [constructor description]
		 * @param  {[type]} @_sourceFile [description]
		 * @return {[type]}              [description]
		###
		constructor: (@_sourceFile) -> _.extend(@, Backbone.Events)


		###
		 * [checkForSubtitle description]
		###
		checkForSubtitle: ->
			@_playHead = Date.now() - @_startTime

			# Check if the playhead has exceeded the source file's last timestamp
			# Caching this value is possible is we know the source file won't change
			return @stop() if @_playHead > @_sourceFile.getLastTimestamp()

			packet = @_sourceFile.findPacket(@_playHead)

			if packet
				if packet.index isnt @_currentPacketId
					@_currentPacketId = packet.index
					@_emptyFired = no
					return @trigger('packet', { packet: packet, playhead: @_playHead })
			else
				# Make sure to fire the empty event only once during voids, not on every loop
				return @trigger('void', { playhead: @_playHead }) unless @_emptyFired


			# @_animId = raf(=> @checkForSubtitle) if @_isPlaying


		###
		 * [getSource description]
		 * @return {SrtFile} [description]
		###
		getSourceFile: -> @_sourceFile


		###
		 * [isPlaying description]
		 * @return {Boolean} [description]
		###
		isPlaying: -> @_isPlaying


		###
		 * [setSource description]
		 * @param {SrtFile} @_sourceFile [description]
		###
		setSource: (@_sourceFile) ->
			@_currentPacketId = -1
			@_emptyFired = yes
			@_isPlaying = no
			@_playHead = -1
			@_startTime = null


		###
		 * [start description]
		 * @return {Boolean} True if playback started
		###
		start: ->
			if @_sourceFile and @_sourceFile.getPackets().length
				@_isPlaying = yes
				@_startTime = Date.now()

				@_animId = setInterval(_.bind(@checkForSubtitle, @), 15)
				# @_animId = raf(=> @checkForSubtitle())
				@trigger('start')

			return @_isPlaying


		###
		 * [stop description]
		 * @return {Boolean} True if playback stopped successfully
		###
		stop: ->
			if @_isPlaying
				@_isPlaying = no
				clearInterval(@_animId)
				# raf.cancel(@_animId)
				@trigger('stop', { playhead: @_playHead })

			return not @_isPlaying
