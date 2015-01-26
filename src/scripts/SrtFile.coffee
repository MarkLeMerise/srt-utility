###
 * @class SrtFile
###

module.exports =
	class SrtFile
		packets: null
		lastTimestamp: null
		refreshLastTimestamp: no

		constructor: (packetList = []) ->
			@packets = []
			@addPacket(packet) for packet in packetList


		###
		 * Adds a single SrtPacket object to the file
		 * @param {SrtPacket} packet The packet object
		###
		addPacket: (packet) ->
			success = no

			if packet.getEnd() >= 0 and packet.getStart() >= 0
				@packets.push(packet)
				success = yes
				@refreshLastTimestamp = yes

			return success


		###
		 * Searches for a packet where the given timestamp falls within its timestamp range
		 * @param  {Integer} timestamp 	The timestamp query
		 * @return {SrtPacket}			Collection of matching packets
		###
		findPacket: (timestamp) ->
			results = @packets.filter((packet) ->
				timestamp >= packet.getStart() and timestamp <= packet.getEnd()
			)

			return results[0] or false


		###
		 * Returns the file's collection of packets
		 * @return {Array} Collection of packets
		###
		getPackets: -> @packets


		###
		 * Returns the largest timestamp found in the file's packets
		 * @return {Integer} The timestamp
		###
		getLastTimestamp: ->
			return -1 unless @packets.length

			if @refreshLastTimestamp or not @lastTimestamp
				@lastTimestamp = Math.max.apply(null, (packet.getEnd() for packet in @packets))
				@refreshLastTimestamp = no

			return @lastTimestamp
