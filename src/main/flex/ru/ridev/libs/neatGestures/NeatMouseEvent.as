/**
 * @author Vladimir Ignatyev (vignatyev@flexis.ru)
 */
package ru.ridev.libs.neatGestures {
import flash.display.InteractiveObject;
import flash.events.MouseEvent;

/**
 * Event class for storing neat events names
 * */
public class NeatMouseEvent extends MouseEvent {
	public static const CLICK:String = "neatClick";
	public static const MOUSE_DOWN:String = "neatMouseDown";
	public static const LONG_MOUSE_DOWN:String = "neatLongMouseDown";
	public static const DOUBLE_CLICK:String = "neatDoubleClick";
	public static const MOUSE_MOVE:String = "neatMouseMove";

	public function NeatMouseEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false, localX:Number = 0, localY:Number = 0, relatedObject:InteractiveObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, delta:int = 0) {
		super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
	}
}
}
