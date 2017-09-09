"use strict"

dat    = dat    or window?.dat    or require? "dat.gui"
Phaser = Phaser or window?.Phaser or require? "phaser"

throw new Error "Can't find `dat`"    unless dat
throw new Error "Can't find `Phaser`" unless Phaser

{isArray} = Array

{freeze} = Object

SECOND = 1000

freezeDeep = (obj) ->
  for own val of obj
    freezeDeep val if typeof val is "object"
  freeze obj

CONST = freezeDeep
  alpha:
    range: [0, 1, 0.1]
  anchor:
    range: [0, 1, 0.1]
  angle:
    range: [-180, 180, 5]
    step: 5
  bounce:
    range: [0, 1, 0.1]
  drag:
    range: [0, 1000, 10]
  dragDistanceThreshold:
    range: [0, 10, 1]
  dragOffset:
    range: [-100, 100, 5]
  dragTimeThreshold:
    range: [0, 100, 10]
  friction:
    range: [0, 1, 0.1]
  gravity:
    range: [-1000, 1000, 10]
  health:
    range: [1, 100, 1]
  lifespan:
    range: [0, 10 * SECOND, 100]
  mass:
    range: [0.1, 10, 0.1]
  maxAngular:
    range: [0, 1000, 10]
  maxVelocity:
    range: [0, 10000, 10]
  offset:
    range: [-100, 100, 1]
  rotation:
    range: [-Math.PI, Math.PI, Math.PI / 30]
    step: Math.PI / 30
  pixelPerfectAlpha:
    range: [0, 255, 5]
  priorityID:
    range: [0, 10, 1]
  snap:
    range: [0, 100, 5]
  snapOffset:
    range: [-100, 100, 5]
  scale:
    range: [-10, 10, 0.1]
    min: -10
    max:  10
    step:  0.1

addControllerAndSaveNumericValue = (guiContainer, obj, propName, args) ->
  controller = guiContainer.add obj, propName, args
  controller.onChange saveNumericValue
  controller

addBlendModeController = (guiContainer, obj, propName) ->
  addControllerAndSaveNumericValue guiContainer, obj, propName, Phaser.blendModes

createMap = (arr) ->
  map = {}
  map[key] = yes for key in arr
  map

saveNumericValue = (newValue) ->
  @object[@property] = Number newValue
  return

spriteProps = (sprite) ->
  {world} = sprite.game
  {bounds} = world
  {animations, body, input} = sprite
  {width, height} = sprite.texture.frame
  scaleRange = [
    sprite.scaleMin or CONST.scale.min
    sprite.scaleMax or CONST.scale.max
    CONST.scale.step
  ]
  worldRangeX = [bounds.left, bounds.right, 10]
  worldRangeY = [bounds.top, bounds.bottom, 10]
  worldRangeWidth = [0, bounds.width, 10]
  worldRangeHeight = [0, bounds.height, 10]
  worldRect =
    x: worldRangeX
    y: worldRangeY
    width: worldRangeWidth
    height: worldRangeHeight
  freezeDeep {
    alive: yes
    alpha: CONST.alpha.range
    autoCull: yes
    animations:
      if animations.currentAnim
        paused: yes
        stop: yes
        updateIfVisible: yes
      else
        no
    anchor:
      x: CONST.anchor.range
      y: CONST.anchor.range
    blendMode: addBlendModeController
    bringToTop: yes
    body:
      if body and body.type is Phaser.Physics.ARCADE
        allowGravity: yes
        allowRotation: yes
        angularAcceleration: [-body.maxAngular, body.maxAngular, CONST.angle.step]
        angularDrag: [0, 2 * body.maxAngular, CONST.angle.step]
        angularVelocity: [-body.maxAngular, body.maxAngular, CONST.angle.step]
        bounce:
          x: CONST.bounce.range
          y: CONST.bounce.range
        collideWorldBounds: yes
        drag:
          x: CONST.drag.range
          y: CONST.drag.range
        enable: yes
        friction:
          x: CONST.friction.range
          y: CONST.friction.range
        gravity:
          x: CONST.gravity.range
          y: CONST.gravity.range
        immovable: yes
        mass: CONST.mass.range
        maxAngular: CONST.maxAngular.range
        maxVelocity:
          x: CONST.maxVelocity.range
          y: CONST.maxVelocity.range
        moves: yes
        offset:
          x: CONST.offset.range
          y: CONST.offset.range
        rotation: CONST.angle.range
        skipQuadTree: yes
        velocity:
          x: [-body.maxVelocity.x, body.maxVelocity.x]
          y: [-body.maxVelocity.y, body.maxVelocity.y]
      else
        no
    cacheAsBitmap: yes
    cameraOffset:
      x: worldRangeX
      y: worldRangeY
    checkWorldBounds: yes
    debug: yes
    exists: yes
    fixedToCamera: yes
    frame:
      if typeof sprite.frame is "number"
        [0, animations.frameTotal - 1, 1]
      else
        [animations.frameData.getFrameIndexes()]
    frameName: yes
    health: [CONST.health.min, sprite.maxHealth, CONST.health.step]
    input:
      if input
        allowHorizontalDrag: yes
        allowVerticalDrag: yes
        boundsRect:
          if input.boundsRect
            worldRect
          else
            no
        dragDistanceThreshold: CONST.dragDistanceThreshold.range
        draggable: yes
        dragOffset:
          x: CONST.dragOffset.range
          y: CONST.dragOffset.range
        dragStopBlocksInputUp: yes
        dragTimeThreshold: CONST.dragTimeThreshold.range
        bringToTop: yes
        enabled: yes
        pixelPerfectAlpha: CONST.pixelPerfectAlpha.range
        pixelPerfectClick: yes
        pixelPerfectOver: yes
        priorityID: CONST.priorityID.range
        reset: yes
        snapOffsetX: CONST.snapOffset.range
        snapOffsetY: CONST.snapOffset.range
        snapOnDrag: yes
        snapOnRelease: yes
        snapX: CONST.snap.range
        snapY: CONST.snap.range
        stop: yes
        useHandCursor: yes
      else
        no
    key: yes
    kill: yes
    lifespan: CONST.lifespan.range
    maxHealth: CONST.health.range
    moveDown: yes
    moveUp: yes
    name: yes
    outOfBoundsKill: yes
    outOfCameraBoundsKill: yes
    renderable: yes
    reset: yes
    revive: yes
    rotation: CONST.rotation.range
    scale:
      x: scaleRange
      y: scaleRange
    sendToBack: yes
    smoothed: yes
    tilePosition:
      if sprite.tilePosition
        x: [0, width, 1]
        y: [0, height, 1]
      else
        no
    tileScale:
      if sprite.tileScale
        x: CONST.scale.range
        y: CONST.scale.range
      else
        no
    tint: yes
    visible: yes
    x: worldRangeX
    y: worldRangeY
    z: yes
  }

freeze class SpriteGUI extends dat.GUI

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
    val = obj[prop]
    unless val?
      console.warn "Skipping property '#{prop}': #{val}"
      return
    else
      super

  addAll: ->
    @addProps this, @sprite, spriteProps @sprite
    return

  addProps: (guiContainer, obj, props) ->
    for name, args of props
      @addProp guiContainer, obj, name, args
    guiContainer

  addProp: (guiContainer, obj, name, args) ->
    if args is no or not @filter name
      return
    val = obj[name]
    unless val?
      console.warn "Skipping property '#{name}': #{val}"
      return
    if typeof args is "function"
      result = args.call null, guiContainer, obj, name
      args = if isArray result then result else no
    switch
      when args is no
        return
      when args is yes
        field = guiContainer.add obj, name
        unless typeof val is "function"
          field.listen()
      when isArray args
        addArgs = [obj, name].concat args
        guiContainer.add.apply(guiContainer, addArgs).listen()
      when typeof args is "object"
        @addProps guiContainer.addFolder(name), obj[name], args
      else
        console.warn "Nothing to do: #{args}"
    guiContainer

  filter: ->
    yes

  filterExclude: (name) ->
    not @exclude[name]

  filterInclude: (name) ->
    @include[name]

Phaser.SpriteGUI  = SpriteGUI
window?.SpriteGUI = SpriteGUI
module?.exports   = SpriteGUI
