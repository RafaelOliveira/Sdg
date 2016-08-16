package sdg.manager;

import kha.input.Mouse;

class Mouse extends Manager
{
	public static var init:Bool = false;

	// x and y not scaled
	public static var rawX:Int = 0;
	public static var rawY:Int = 0;

	// x and y scaled to the backbuffer
	public static var x:Int = 0;
	public static var y:Int = 0;

	// deltas of x and y
	public static var dx:Int = 0;
	public static var dy:Int = 0;

	// x and y inside the world (adjusted with the camera)
	public static var wx:Int = 0;
	public static var wy:Int = 0;

	static var mousePressed:Map<Int, Bool>;
	static var mouseHeld:Map<Int, Bool>;
	static var mouseUp:Map<Int, Bool>;
	static var mouseCount:Int = 0;
	static var mouseJustPressed:Bool = false;

	public function new():Void
	{
		super();

		kha.input.Mouse.get().notify(onMouseStart, onMouseEnd, onMouseMove, onMouseWheel);

		mousePressed = new Map<Int, Bool>();
		mouseHeld = new Map<Int, Bool>();
		mouseUp = new Map<Int, Bool>();

		init = true;
	}

	override public function update():Void
	{
		for (key in mousePressed.keys())
			mousePressed.remove(key);

		for (key in mouseUp.keys())
			mouseUp.remove(key);

		mouseJustPressed = false;
	}

	override public function reset():Void
	{
		super.reset();

		for (key in mousePressed.keys())
			mousePressed.remove(key);

		for (key in mouseHeld.keys())
			mouseHeld.remove(key);

		for (key in mouseUp.keys())
			mouseUp.remove(key);
	}

	function onMouseStart(index:Int, x:Int, y:Int):Void
	{
		// trace("onMouseStart : " + index + " , " + x + " , " + y);
		
		updateMouseData(x, y, 0, 0);

		mousePressed.set(index, true);
		mouseHeld.set(index, true);

		mouseCount++;

		mouseJustPressed = true;
	}

	function onMouseEnd(index:Int, x:Int, y:Int):Void
	{
		updateMouseData(x, y, 0, 0);

		mouseUp.set(index, true);
		mouseHeld.remove(index);

		mouseCount--;
	}

	function onMouseMove(x:Int, y:Int, dx:Int, dy:Int):Void
	{
		updateMouseData(x, y, dx, dy);
	}

	function updateMouseData(x:Int, y:Int, dx:Int, dy:Int):Void
	{
		Mouse.rawX = x;
		Mouse.rawY = y;
		Mouse.x = Std.int(x / Sdg.gameScale);
		Mouse.y = Std.int(y / Sdg.gameScale);
		Mouse.dx = Std.int(dx / Sdg.gameScale);
		Mouse.dy = Std.int(dy / Sdg.gameScale);
		Mouse.wx = Std.int((x + Sdg.screen.camera.x) / Sdg.gameScale);
		Mouse.wy = Std.int((y + Sdg.screen.camera.y) / Sdg.gameScale);
	}

	function onMouseWheel(delta:Int):Void
	{
		// TODO
		trace("onMouseWheel : " + delta);
	}

	inline public static function isPressed(index:Int=0):Bool
	{
		return init && mousePressed.exists(index);
	}

	inline public static function isHeld(index:Int=0):Bool
	{
		return init && mouseHeld.exists(index);
	}

	inline public static function isUp(index:Int=0):Bool
	{
		return init && mouseUp.exists(index);
	}

	inline public static function isAnyHeld():Bool
	{
		return init && (mouseCount > 0);
	}

	inline public static function isAnyPressed():Bool
	{
		return init && mouseJustPressed;
	}	
}