/**
 * @author Vladimir Ignatyev (vignatyev@flexis.ru)
 */
package ru.ridev.libs.neatGestures {
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;

/**
 * Base class for all custom gestures watchers
 * */
public class BaseWatcher extends EventDispatcher {
	protected var _sourceDispatcher:IEventDispatcher;
	protected var eventName:String;

	public function BaseWatcher(sourceDispatcher:IEventDispatcher, eventName:String) {
		super();
		_sourceDispatcher = sourceDispatcher;
		this.eventName = eventName;
		enabled = true;
	}

	protected var _enabled:Boolean;
	public function get enabled():Boolean {
		return _enabled;
	}

	public function set enabled(value:Boolean):void {
		if (value != _enabled) {
			_enabled = value;
			if (value) {
				setupListeners();
			} else {
				removeListeners();
			}
		}
	}

	/**
	 * Removes listeners from sourceDispatcher, added by watcher
	 * */
	protected function removeListeners():void {
		throw new ArgumentError("removeListeners not implemented!")
	}

	/**
	 * Adds listeners to sourceDispatcher
	 * */
	protected function setupListeners():void {
		throw new ArgumentError("setupListeners not implemented!")
	}

	public function set sourceDispatcher(value:IEventDispatcher):void {
		if (value != _sourceDispatcher) {
			removeListeners();
			_sourceDispatcher = value;
			setupListeners();
		}
	}

	/**
	 * Shortcut for creating NeatMouseEvents from MouseEvent
	 * */
	public function fromMouseEvent(type:String, event:MouseEvent):NeatMouseEvent {
		return new NeatMouseEvent(type,
				event.bubbles, event.cancelable, event.localX, event.localY, event.relatedObject, event.ctrlKey,
				event.altKey, event.shiftKey, event.buttonDown, event.delta)
	}
}
}
