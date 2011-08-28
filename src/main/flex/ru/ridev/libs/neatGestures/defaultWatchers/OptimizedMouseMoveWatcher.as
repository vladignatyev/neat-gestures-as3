/**
 * @author Vladimir Ignatyev (vignatyev@flexis.ru)
 */
package ru.ridev.libs.neatGestures.defaultWatchers {
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;

import ru.ridev.libs.neatGestures.BaseWatcher;
import ru.ridev.libs.neatGestures.NeatMouseEvent;

[Event(type="flash.events.MouseEvent", name="mouseMove")]
public class OptimizedMouseMoveWatcher extends BaseWatcher {
	private var cachedMouseEvent:MouseEvent;
	private var cachedEventTarget:IEventDispatcher;
	private var invalidated:Boolean = false;
	private var blockDefaultMouseMove:Boolean;

	public function OptimizedMouseMoveWatcher(sourceDispatcher:IEventDispatcher, blockDefaultMouseMove:Boolean = false) {
		super(sourceDispatcher, NeatMouseEvent.MOUSE_MOVE);
		this.blockDefaultMouseMove = blockDefaultMouseMove;
	}

	override protected function setupListeners():void {
		_sourceDispatcher.addEventListener(Event.ENTER_FRAME, dispatcher_enterFrameHandler);
		_sourceDispatcher.addEventListener(MouseEvent.MOUSE_MOVE, dispatcher_mouseMoveHandler);
	}

	override protected function removeListeners():void {
		_sourceDispatcher.removeEventListener(Event.ENTER_FRAME, dispatcher_enterFrameHandler);
		_sourceDispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, dispatcher_mouseMoveHandler);
	}

	private function dispatcher_enterFrameHandler(event:Event):void {
		if (invalidated) {
			cachedEventTarget.dispatchEvent(cachedMouseEvent);
			invalidated = false;
		}
	}

	private function dispatcher_mouseMoveHandler(event:MouseEvent):void {
		cachedMouseEvent = fromMouseEvent(NeatMouseEvent.MOUSE_MOVE, event);
		cachedEventTarget = event.target as IEventDispatcher;
		invalidated = true;
		if (blockDefaultMouseMove) {
			event.stopImmediatePropagation();
		}
	}
}
}
