/**
 * @author Vladimir Ignatyev (vignatyev@flexis.ru)
 */
package ru.ridev.libs.neatGestures.defaultWatchers {
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

import ru.ridev.libs.neatGestures.BaseWatcher;
import ru.ridev.libs.neatGestures.DefaultWatchersPreset;
import ru.ridev.libs.neatGestures.NeatMouseEvent;

public class LongMouseDownWatcher extends BaseWatcher {
	private var timer:Timer;
	private var emitingMouseEvent:NeatMouseEvent;
	private var emitingEventTarget:IEventDispatcher;
	private var maximumShift:Number = 0;
	private var longMouseDownTime:Number = 0;

	public function LongMouseDownWatcher(sourceDispatcher:IEventDispatcher, eventName:String = "", maximumShift:Number = 0, longMouseDownTime:Number = 0) {
		setup(eventName, maximumShift, longMouseDownTime);
		super(sourceDispatcher, this.eventName);
	}

	private function setup(eventName:String, maximumShift:Number, longMouseDownTime:Number):void {
		if (maximumShift == 0) {
			this.maximumShift = DefaultWatchersPreset.MAXIMUM_SHIFT;
		}
		if (longMouseDownTime == 0) {
			this.longMouseDownTime = DefaultWatchersPreset.LONG_MOUSE_DOWN_DELAY;
		}
		if (eventName == "") {
			this.eventName = NeatMouseEvent.LONG_MOUSE_DOWN;
		} else {
			this.eventName = eventName;
		}

		timer = new Timer(this.longMouseDownTime);
		timer.addEventListener(TimerEvent.TIMER, timer_timerHandler);
	}

	protected function cancelWatching(event:Event = null):void {
		timer.stop();
		_sourceDispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, cancelWatchingIfMovedLot);
		_sourceDispatcher.removeEventListener(MouseEvent.MOUSE_UP, cancelWatching);
		_sourceDispatcher.addEventListener(MouseEvent.MOUSE_DOWN, sourceDispatcher_mouseDownHandler)
	}

	override protected function setupListeners():void {
		_sourceDispatcher.addEventListener(MouseEvent.MOUSE_DOWN, sourceDispatcher_mouseDownHandler)
	}

	override protected function removeListeners():void {
		_sourceDispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, sourceDispatcher_mouseDownHandler)
		cancelWatching();
	}

	protected function timer_timerHandler(event:TimerEvent):void {
		emitingEventTarget.dispatchEvent(emitingMouseEvent);
		cancelWatching();
	}

	protected function sourceDispatcher_mouseDownHandler(event:MouseEvent):void {
		_sourceDispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, sourceDispatcher_mouseDownHandler)
		_sourceDispatcher.addEventListener(MouseEvent.MOUSE_MOVE, cancelWatchingIfMovedLot);
		_sourceDispatcher.addEventListener(MouseEvent.MOUSE_UP, cancelWatching);

		emitingMouseEvent = fromMouseEvent(eventName, event);
		emitingEventTarget = event.target as IEventDispatcher;
		timer.start();
	}

	protected function cancelWatchingIfMovedLot(event:MouseEvent):void {
		if (Math.pow(event.localX - emitingMouseEvent.localX, 2) +
				Math.pow(event.localY - emitingMouseEvent.localY, 2) >
				Math.pow(maximumShift, 2)) {
			cancelWatching(event);
		}
	}
}
}
