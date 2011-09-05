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

[Event(name="neatClick",type="ru.ridev.libs.neatGestures.NeatMouseEvent")]
public class FilteredClickWatcher extends BaseWatcher {
	private var timer:Timer;
	private var emitingMouseEvent:NeatMouseEvent;
	private var emitingEventTarget:IEventDispatcher;
	private var _canTrigger:Boolean;
	private var maximumShift:Number = 0;
	private var filteredClickTime:Number = 0;

	public function FilteredClickWatcher(sourceDispatcher:IEventDispatcher, eventName:String = "", maximumShift:Number = 0, filteredClickTime:Number = 0) {
		setup(eventName, maximumShift, filteredClickTime);
		super(sourceDispatcher, this.eventName);
	}

	private function setup(eventName:String, maximumShift:Number, filteredClickTime:Number):void {
		if (maximumShift == 0) {
			this.maximumShift = DefaultWatchersPreset.MAXIMUM_SHIFT;
		}
		if (filteredClickTime == 0) {
			this.filteredClickTime = DefaultWatchersPreset.FILTERED_CLICK_TIME;
		}
		if (eventName == "") {
			this.eventName = NeatMouseEvent.CLICK;
		} else {
			this.eventName = eventName;
		}

		timer = new Timer(this.filteredClickTime);
		timer.addEventListener(TimerEvent.TIMER, timer_timerHandler);
	}

	protected function cancelWatching(event:Event = null):void {
		_canTrigger = false;
		timer.stop();
		_sourceDispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, cancelWatchingIfMovedLot);
		_sourceDispatcher.removeEventListener(MouseEvent.MOUSE_UP, canTrigger);
		_sourceDispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, canTriggerFalse);

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
		if (_canTrigger) {
			emitingEventTarget.dispatchEvent(emitingMouseEvent);
		}
		cancelWatching();
	}

	protected function sourceDispatcher_mouseDownHandler(event:MouseEvent):void {
		_sourceDispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, sourceDispatcher_mouseDownHandler)
		_sourceDispatcher.addEventListener(MouseEvent.MOUSE_MOVE, cancelWatchingIfMovedLot);

		_sourceDispatcher.addEventListener(MouseEvent.MOUSE_UP, canTrigger, false, 0);

		emitingMouseEvent = fromMouseEvent(eventName, event);
		emitingEventTarget = event.target as IEventDispatcher;
		timer.start();
	}

	private function canTrigger(event:MouseEvent):void {
		_canTrigger = true;
		_sourceDispatcher.addEventListener(MouseEvent.MOUSE_DOWN, canTriggerFalse);
	}

	private function canTriggerFalse(event:MouseEvent):void {
		_canTrigger = false;
		_sourceDispatcher.removeEventListener(MouseEvent.MOUSE_UP, canTrigger);
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
