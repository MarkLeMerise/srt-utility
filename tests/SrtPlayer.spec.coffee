###
 * Tests the SrtFile model
###

SrtPlayer = require '../src/scripts/SrtPlayer'
SrtFile = require '../src/scripts/SrtFile'
SrtPacket = require '../src/scripts/SrtPacket'

describe 'SrtPlayer', ->
	player = null

	createSrtFile = ->
		packet1 = new SrtPacket(1, 1, 'subtitle')
		packet1.setMarkers(200, 250)

		packet2 = new SrtPacket(1, 2, 'subtitle2')
		packet2.setMarkers(275, 300)

		return new SrtFile [packet1, packet2]

	beforeEach ->
		player = new SrtPlayer
		player.setSource(createSrtFile())

	afterEach -> player = null


	it 'should set the source file', ->
		expect(player).to.exist
		expect(player.getSourceFile()).to.exist.and.to.be.an.instanceof(SrtFile)


	it 'should start playback successfully', ->
		expect(player.start()).to.be.true


	it 'should not start playback if the source file has no packets', ->
		player = new SrtPlayer
		expect(player.start()).to.be.false


	it 'should emit a "start" event when started', (done) ->
		player.on('start', ->
			expect(player.isPlaying()).to.be.true
			done()
		).start()


	it 'should emit a "packet" event when the playhead is within 15 ms of the packet\'s starting timestamp', (done) ->
		this.timeout(0)

		player.on('packet', (event) ->
			expect(event.playhead).to.be.gte(200).and.to.be.lte(215)
			player.stop()
			done()
		).start()


	it 'should emit a "void" event once the playhead moves outside a packet\'s timestamp range', (done) ->
		this.timeout(0)

		player.on('void', (event) ->
			expect(event.playhead).to.be.gte(250).and.to.be.lte(275)
			player.stop()
			done()
		).start()


	it 'should emit a "stop" event when stopped', (done) ->
		this.timeout(0)

		player.on('stop', (event) ->
			expect(event.playhead).to.be.gt 0
			expect(player.isPlaying()).to.be.false
			done()
		)

		player.start()
		setTimeout(player.stop, 150)
