"use strict"

# http://phaser.io/examples/v2/arcade-physics/platformer-basics

{Phaser, SpriteGUI} = this
{mixin} = Phaser.Utils

bg = undefined
cursors = undefined
droid = undefined
droidGui = undefined
jumpButton = undefined
jumpTimer = 0
hearts = undefined
pack = undefined
packGui = undefined
player = undefined
playerGui = undefined
rocks = undefined

emitHeart = (_player, _pack) ->
  hearts
    .at _pack.body
    .emitParticle()
  return

window.GAME = new (Phaser.Game)
  antialias: no
  height: 480
  renderer: Phaser.CANVAS
  # resolution: 1
  scaleMode: Phaser.ScaleManager.SHOW_ALL
  # transparent: false
  width: 320
  state:

    init: ->
      {game} = this
      game.forceSingleUpdate = off
      game.time.desiredFps = 30
      return

    preload: ->
      @load.baseURL = "example/assets/"
      @load.spritesheet "droid", "droid.png", 32, 32
      @load.spritesheet "dude", "dude.png", 32, 48
      @load.image "background"
      @load.image "firstaid"
      @load.image "heart"
      @load.image "rock"
      return

    create: ->
      {physics, world} = @game
      {arcade} = physics
      Phaser.Canvas.setImageRenderingCrisp @game.canvas, true
      world.setBounds 0, 0, 320, 600
      arcade.checkCollision =
        up:    off
        down:  on
        left:  off
        right: off
      arcade.gravity.set 0, 500
      @createBg()
      @createPlayer()
      @createDroid()
      @createRocks()
      @createPack()
      @createHearts()
      text = @createCaption()
      player.bringToTop()
      droid.bringToTop()
      text.bringToTop()
      @addInput()
      playerGui = new SpriteGUI player, width: 300
      droidGui = new SpriteGUI droid, width: 300
      packGui = new SpriteGUI pack, width: 300
      return

    update: ->
      {physics, world} = @game
      physics.arcade.overlap player, pack, emitHeart
      physics.arcade.collide [pack, player], [droid, rocks]
      @updatePlayer()
      world.wrap droid, droid.width
      return

    shutdown: ->
      playerGui.destroy()
      droidGui.destroy()
      packGui.destroy()
      return

    # Helpers

    addInput: ->
      {game} = this
      keyboard = @input.keyboard
      cursors = keyboard.createCursorKeys()
      jumpButton = keyboard.addKey Phaser.Keyboard.SPACEBAR
      keyboard.addKey(Phaser.KeyCode.R).onUp.add game.state.restart, game.state
      keyboard.addKey(Phaser.KeyCode.T).onUp.add game.step, game
      keyboard.addKey(Phaser.KeyCode.S).onUp.add (->
        if game.stepping then game.disableStep() else game.enableStep()
        return
      ), game
      return

    createBg: ->
      bg = @add.tileSprite 0, 0, 600, 600, "background"
      bg.alpha = 0.5
      bg.tilePosition.x = @rnd.between 0, 120
      bg

    createCaption: ->
      @add.text(5, 5, "[R]estart / ±[S]tep / s(T)ep forward",
        fill: "white"
        font: "bold 12px monospace")

    createDroid: ->
      {physics, world} = this
      droid = @add.sprite world.randomX, world.height * 0.5, "droid"
      droid.name = "droid"
      physics.enable droid
      mixin
        allowGravity: no
        bounce: x: 0.5, y: 0.5
        mass: 2
        maxVelocity: x: 100, y: 100
        velocity: x: 50, y: 0
      , droid.body
      droid.body.setSize droid.width, droid.height / 2, 0, droid.height / 2
      droid.animations.add "!", [ 0, 1, 2, 3 ], 5, true
      droid.animations.play "!"
      droid

    createHearts: ->
      hearts = @add.emitter 0, 0, 1
        .setAlpha 0, 1, 1000, "Quad.easeInOut", yes
        .setRotation 0, 0
        .setScale 0, 1, 0, 1, 1000, "Quad.easeInOut", yes
        .setXSpeed 0, 0
        .setYSpeed -100, -50
        .makeParticles "heart"
      hearts.gravity = -500
      hearts

    createPack: ->
      {physics, world} = this
      pack = @add.sprite world.randomX, world.randomY, "firstaid"
      pack.name = "pack"
      physics.enable pack
      mixin
        bounce: x: 0.25, y: 0.25
        collideWorldBounds: yes
        drag: x: 500, y: 0
        mass: 0.5
      , pack.body
      pack.inputEnabled = yes
      pack.input.useHandCursor = yes
      pack.input.enableDrag()
      pack.events.onDragStart.add -> pack.body.enable = off
      pack.events.onDragStop .add -> pack.body.enable = on
      pack

    createPlayer: ->
      player = @add.sprite 32, 32, "dude"
      player.name = "player"
      @camera.follow player
      @physics.enable player
      mixin
        bounce: x: 0.5, y: 0.25
        collideWorldBounds: true
        drag: x: 250, y: 0
        maxVelocity: x: 250,  y: 1000
      , player.body
      player.body.setSize 8, 32, 12, 16
      player.animations.add "left", [ 0, 1, 2, 3 ], 10, true
      player.animations.add "turn", [ 4 ], 20, true
      player.animations.add "right", [ 5, 6, 7, 8 ], 10, true
      player

    createRocks: ->
      {physics, world} = this
      rocks = @add.group()
      r = undefined
      i = 4
      while i-- > 0
        r = @add.sprite world.randomX, (1 - (i * 0.25)) * world.height, "rock"
        r.anchor.set 0.5
        physics.enable r
        r.body.moves = no
        r.body.immovable = yes
        rocks.add r
      rocks

    updatePlayer: ->
      {time, world} = @game
      maxVelocity = player.body.maxVelocity
      velocity = player.body.velocity
      animations = player.animations
      onFloor = player.body.blocked.down or player.body.touching.down
      if cursors.left.isDown
        velocity.x -= maxVelocity.x / 10
      else if cursors.right.isDown
        velocity.x += maxVelocity.x / 10
      switch true
        when velocity.x > 0
          animations.play "right"
        when velocity.x < 0
          animations.play "left"
        else
          animations.stop null, true
      if jumpButton.isDown and onFloor and time.now > jumpTimer
        velocity.y = -maxVelocity.y / 2
        jumpTimer = time.now + 500
      world.wrap player, null, null, true, false
      return
