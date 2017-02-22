![Screenshot](https://samme.github.io/phaser-sprite-gui/screenshot.png)

[Demo](https://samme.github.io/phaser-sprite-gui/)

Install
-------

If not using `npm` or `bower`, add [dat.gui](https://github.com/dataarts/dat.gui) and [index.js](index.js) to your project.

Use
---

```javascript
// @create:
var sprite = game.add.sprite();
// …
var gui = new SpriteGUI(sprite);

// @shutdown:
gui.destroy();
```
