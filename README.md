# KylesGodotPlugins
Main repo for plugins made by me

There's a lot that needs to go here.

The most recent addition is the PostHog plugin. This allows you to record event data and send it to the Mixpanel analytics service through PostHog. All it should require is to setup the constants in the PostHog autoload singleton script according to your parameters.

The demo for Dungeon Generator is pretty complete and it should be fairly straight-forward, so dive in. It is based on this code: http://kidscancode.org/blog/2018/12/godot3_procgen8/ . It should be noted, however, that my version uses autotiling, so the tileset you use must have autotiling enabled. In particular, I used a Tilesetter-generated tileset; if you need to use a different one, there's code in here where you'll see `Vector2(3, 3)`: change that to something that makes sense for your set (in this case, it points to the icon I used to represent the tileset in the editor).

If you want to support me further, you can buy me a ko-fi at https://ko-fi.com/kyleszklenski.
