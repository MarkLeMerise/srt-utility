###
 * Tests the SrtFile model
###

SrtFile = require '../src/scripts/SrtFile'
SrtPacket = require '../src/scripts/SrtPacket'

describe 'SrtFile', ->
	srtFile = null

	populateFile = ->
		packet1 = new SrtPacket(1, 1, 'subtitle')
		packet1.setMarkers(1, 120)

		packet2 = new SrtPacket(1, 2, 'subtitle2')
		packet2.setMarkers(121, 240)

		packets = [packet1, packet2]

		srtFile = new SrtFile packets

		return packets


	beforeEach -> srtFile = new SrtFile

	afterEach -> srtFile = null


	describe 'instantation and population', ->
		it 'should exist', -> expect(srtFile).to.exist


		it 'should add an initial set of packets', ->
			populateFile()
			expect(srtFile.packets).to.have.length 2


		it 'should not add a packet if either timestamp is negative', ->
			badPacket = new SrtPacket 1, 1, 'text'
			expect(srtFile.addPacket(badPacket)).to.be.false
			expect(srtFile.packets).to.be.empty


	describe 'packet searching', ->
		packetList = null

		beforeEach -> packetList = populateFile()

		it 'should find a packet by its starting timestamp', ->
			packet = srtFile.findPacket(1)

			expect(packet).to.exist().and.to.equal packetList[0]


		it 'should find a packet by its ending timestamp', ->
			packet = srtFile.findPacket(240)

			expect(packet).to.exist().and.to.equal packetList[1]


		it 'should find a packet if the query falls within a packet\'s timestamp range', ->
			packet = srtFile.findPacket(210)

			expect(packet).to.exist().and.to.equal packetList[1]


		it 'should not find a packet if the query falls outside all packet\'s timestamp ranges', ->
			packet = srtFile.findPacket(250)

			expect(packet).to.be.false


	describe 'last timestamp retrieval', ->
		it 'should return -1 if there are no packets in the file', ->
			expect(srtFile.getLastTimestamp()).to.equal -1


		it 'should set the timestamp renewal flag upon packet addition', ->
			populateFile()
			expect(srtFile.refreshLastTimestamp).to.be.true


		it 'should return the correct timestamp', ->
			populateFile()
			expect(srtFile.getLastTimestamp()).to.equal 240
			expect(srtFile.refreshLastTimestamp).to.be.false
