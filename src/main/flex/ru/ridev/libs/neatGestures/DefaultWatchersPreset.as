/**
 * @author Vladimir Ignatyev (vignatyev@flexis.ru)
 */
package ru.ridev.libs.neatGestures {

/**
 * Default preset for library. Of course, you can override this settings by providing
 * your parameters to watchers' constructors.
 * */
public class DefaultWatchersPreset {
	/**
	 * Long-press duration (in ms)
	 * */
	public static const LONG_MOUSE_DOWN_DELAY:Number = 670;

	/**
	 * Maximal shift of pointing device, that cause cancelling of gestures (in pixels)
	 * */
	public static const MAXIMUM_SHIFT:Number = 10;

	/**
	 * Time delay, during which only one MOUSE_DOWN is waiting. If more than one MOUSE_DOWN or MOUSE_UP
	 * events caught, gesture will be cancelled
	 * */
	public static const FILTERED_MOUSE_DOWN_DELAY:Number = 30;

	/**
	 * Click duration.
	 * */
	public static const FILTERED_CLICK_TIME:Number = 150;

	/**
	 * Double-click duration (in ms)
	 * */
	public static const DOUBLE_CLICK_TIME:Number = 500;
}
}
