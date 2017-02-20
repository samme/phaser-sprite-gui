![Screenshot](https://samme.github.io/phaser-sprite-gui/screenshot.png)

Phaser Sprite GUI
=================

Inspect and manipulate Phaser Sprites (via [dat.gui](https://github.com/dataarts/dat.gui)).

Use
---

Add [dat.GUI](https://github.com/dataarts/dat.gui) and [index.js](index.js).

```javascript
// @create:
var sprite = game.add.sprite();
// …
var gui = new SpriteGUI(sprite);

// @shutdown:
gui.destroy();
```
