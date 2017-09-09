"use strict"

# http://phaser.io/examples/v2/arcade-physics/platformer-basics

{Phaser, SpriteGUI} = this
{mixin} = Phaser.Utils

bg = undefined
caption = undefined
cursors = undefined
droid = undefined
guis = []
hearts = undefined
jumpButton = undefined
jumpTimer = 0
pack = undefined
player = undefined
rocks = undefined
score = 0

emitHeart = (_player, _pack) ->
  hearts
    .at _pack.body
    .emitParticle()
  return

window.GAME = new (Phaser.Game)
  antialias: no
  height: 600
  renderer: Phaser.CANVAS
  # resolution: 1
  scaleMode: Phaser.ScaleManager.NO_SCALE
  # transparent: false
  width: 600
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
      @createCaption()
      player.bringToTop()
      droid.bringToTop()
      caption.bringToTop()
      @addInput()
      guis.push new Phaser.SpriteGUI bg, {width: 300, name: "tileSprite"}, {include: ["key", "name", "x", "y", "position", "tilePosition", "tileScale"]}
      guis.push new Phaser.SpriteGUI player, {width: 300, name: "sprite"}
      guis.push new Phaser.SpriteGUI pack, {width: 300, name: "spriteWithInput"}
      return

    update: ->
      {physics, world} = @game
      # physics.arcade.overlap player, pack, emitHeart
      physics.arcade.collide player, rocks
      physics.arcade.collide player, droid, -> score += 1
      @updatePlayer()
      world.wrap droid, droid.width
      caption.text = "Score: #{score} • [R]estart"
      return

    shutdown: ->
      for gui in guis
        console.info "destroy", gui
        gui.destroy()
      return

    # Helpers

    addInput: ->
      {game} = this
      keyboard = @input.keyboard
      cursors = keyboard.createCursorKeys()
      jumpButton = keyboard.addKey Phaser.Keyboard.SPACEBAR
      keyboard.addKey(Phaser.KeyCode.R).onUp.add game.state.restart, game.state
      return

    createBg: ->
      bg = @add.tileSprite 0, 0, this.game.width, this.game.height, "background"
      bg.alpha = 0.5
      bg.name = "tileSprite"
      bg.tilePosition.x = @rnd.between 0, 120
      bg

    createCaption: ->
      caption = @add.text 5, 5, "",
        fill: "white"
        font: "bold 24px monospace"

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
      pack.inputEnabled = yes
      pack.input.useHandCursor = yes
      pack.input.enableDrag()
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
