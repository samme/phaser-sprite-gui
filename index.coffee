"use strict"

{Phaser} = this

@SpriteGUI = Object.freeze class SpriteGUI extends dat.GUI

  @addAnchor = addAnchor = (cn, anchor) ->
    addPoint cn, anchor, 0, 1, 0.1
    cn

  @addAnim = addAnim = (cn, anim) ->
    cn.add(anim, "paused").listen()
    cn.add(anim, "updateIfVisible").listen()
    cn

  @addBody = addBody = (cn, body) ->
    cn.add(body, "allowGravity")
    cn.add(body, "allowRotation")
    cn.add(body, "angularAcceleration", -body.maxAngular, body.maxAngular, 10).listen()
    cn.add(body, "angularDrag", 0, 2 * body.maxAngular, 10).listen()
    cn.add(body, "angularVelocity", -body.maxAngular, body.maxAngular, 10).listen()
    addPoint (cn.addFolder "bounce"), body.bounce, 0, 1, 0.1
    cn.add(body, "collideWorldBounds").listen()
    addPoint (cn.addFolder "drag"), body.drag, 0, 1000, 10
    cn.add(body, "enable").listen()
    addPoint (cn.addFolder "friction"), body.friction, 0, 1, 0.1
    addPoint (cn.addFolder "gravity"), body.gravity, -1000, 1000, 100
    cn.add(body, "immovable").listen()
    cn.add(body, "mass", 0.5, 10, 0.5).listen()
    cn.add(body, "maxAngular", 0, 1000, 10).listen()
    addPoint (cn.addFolder "maxVelocity"), body.maxVelocity, 0, 1000, 10
    cn.add(body, "moves").listen()
    addPoint (cn.addFolder "offset"), body.offset
    cn.add(body, "rotation", -180, 180, 5).listen()
    cn.add(body, "skipQuadTree").listen()
    cn.add(body, "syncBounds").listen()
    addPoint (cn.addFolder "velocity"), body.velocity, -1000, 1000, 10
    cn

  @addInput = addInput = (cn, input) ->
    cn.add(input, "allowHorizontalDrag").listen()
    cn.add(input, "allowVerticalDrag").listen()
    addRect (cn.addFolder "boundsRect"), input.boundsRect if input.boundsRect
    cn.add(input, "dragDistanceThreshold", 0, 10, 1).listen()
    cn.add(input, "draggable").listen()
    addPoint (cn.addFolder "dragOffset"), input.dragOffset, 0, 100
    cn.add(input, "dragStopBlocksInputUp").listen()
    cn.add(input, "dragTimeThreshold", 0, 100, 10).listen()
    cn.add(input, "bringToTop").listen()
    cn.add(input, "enabled").listen()
    cn.add(input, "pixelPerfectAlpha", 0, 255, 5).listen()
    cn.add(input, "pixelPerfectClick").listen()
    cn.add(input, "pixelPerfectOver").listen()
    cn.add(input, "priorityID", 0, 10, 1).listen()
    cn.add input, "reset"
    cn.add(input, "snapOffsetX", -100, 100, 10).listen()
    cn.add(input, "snapOffsetY", -100, 100, 10).listen()
    cn.add(input, "snapOnDrag").listen()
    cn.add(input, "snapOnRelease").listen()
    cn.add(input, "snapX", 0, 100, 5).listen()
    cn.add(input, "snapY", 0, 100, 5).listen()
    cn.add input, "stop"
    cn.add(input, "useHandCursor").listen()
    cn

  @addPoint = addPoint = (cn, point, min, max, step) ->
    cn.add(point, "x", min, max, step).listen()
    cn.add(point, "y", min, max, step).listen()
    cn

  @addRect = addRect = (cn, rect, min = 0, max = 1000, step = 10) ->
    cn.add(rect, "x", min, max, step).listen()
    cn.add(rect, "y", min, max, step).listen()
    cn.add(rect, "width", min, max, step).listen()
    cn.add(rect, "height", min, max, step).listen()
    cn

  @addScale = addScale = (cn, scale, min, max) ->
    addPoint cn, scale, min, max
    cn

  @createMap = createMap = (arr) ->
    map = {}
    map[key] = yes for key in arr
    map

  exclude: null

  include: null

  constructor: (@sprite, params = {}, options = {}) ->
    super params
    if options
      if options.include
        @include = createMap options.include
        @filter = @filterInclude
      else if options.exclude
        @exclude = createMap options.exclude
        @filter = @filterExclude
    @addAll()

  add: (obj, prop) ->
    unless @filter prop
      return
    val = obj[prop]
    unless val?
      console.warn "Skipping property '#{prop}': #{val}"
      return
    else
      super

  listenTo: (obj, prop) ->
    result = @add.apply this, arguments
    if result
      result.listen()
    else
      result

  addAll: ->
    {sprite} = this
    {world} = sprite.game
    {bounds} = world
    {animations} = sprite

    @listenTo(sprite, "alive")
    @listenTo(sprite, "alpha", 0, 1)
    @listenTo(sprite, "autoCull")
    @addAnim() if animations?.frameTotal > 1
    @addAnchor()
    @listenTo(sprite, "blendMode", Phaser.blendModes)
    @add(sprite, "bringToTop")
    @addBody() if sprite.body and sprite.body.type is Phaser.Physics.ARCADE
    @listenTo(sprite, "cacheAsBitmap")
    @addPoint "cameraOffset", sprite.cameraOffset # TODO
    @listenTo(sprite, "checkWorldBounds")
    @listenTo(sprite, "debug")
    @listenTo(sprite, "exists")
    @listenTo(sprite, "fixedToCamera")
    @listenTo(sprite, "frame", animations.frameData.getFrameIndexes())
    @listenTo(sprite, "frameName")
    @listenTo(sprite, "health", 0, sprite.maxHealth)
    @addInput() if sprite.input
    @listenTo(sprite, "key")
    @add(sprite, "kill")
    @listenTo(sprite, "lifespan", 0, 10000, 100)
    @add(sprite, "moveDown")
    @add(sprite, "moveUp")
    @listenTo(sprite, "name")
    @listenTo(sprite, "outOfBoundsKill")
    @listenTo(sprite, "outOfCameraBoundsKill")
    @listenTo(sprite, "renderable")
    @add(sprite, "reset")
    @add(sprite, "revive")
    @listenTo(sprite, "rotation", -Math.PI, Math.PI, Math.PI / 30)
    @add(sprite, "sendToBack")
    @addScale()
    @listenTo(sprite, "smoothed")
    @listenTo(sprite, "tint")
    @listenTo(sprite, "visible")
    @listenTo(sprite, "x", world.bounds.left, world.bounds.right)
    @listenTo(sprite, "y", world.bounds.top, world.bounds.bottom)
    @listenTo(sprite, "z")
    return

  addAnchor: ->
    addAnchor (@addFolder "anchor"), @sprite.anchor if @filter "anchor"

  addAnim: ->
    addAnim (@addFolder "animations"), @sprite.animations if @filter "animations"

  addBody: ->
    addBody (@addFolder "body"), @sprite.body if @filter "body"

  addInput: ->
    addInput (@addFolder "input"), @sprite.input if @filter "input"

  addPoint: (name, point, min, max, step) ->
    addPoint (@addFolder name), point, min, max, step

  addScale: ->
    addScale (@addFolder "scale"), @sprite.scale, (@sprite.scaleMin or -5), (@sprite.scaleMax or 5) if @filter "scale"

  filter: ->
    yes

  filterExclude: (name) ->
    console.log "#{@exclude[name] and 'skip' or 'keep'} #{name}"
    not @exclude[name]

  filterInclude: (name) ->
    console.log "#{@include[name] and 'keep' or 'skip'} #{name}"
    @include[name]
