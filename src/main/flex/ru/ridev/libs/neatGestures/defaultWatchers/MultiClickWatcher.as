/**
 * @author Vladimir Ignatyev (vignatyev@flexis.ru)
 */
package ru.ridev.libs.neatGestures.defaultWatchers {
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

import ru.ridev.libs.neatGestures.BaseWatcher;
import ru.ridev.libs.neatGestures.DefaultWatchersPreset;
import ru.ridev.libs.neatGestures.NeatMouseEvent;

[Event(type="ru.ridev.libs.neatGestures.NeatMouseEvent")]
[Event(name="neatDoubleClick", type="ru.ridev.libs.neatGestures.NeatMouseEvent")]
public class MultiClickWatcher extends BaseWatcher {
	private var timer:Timer;
	private var emitingMouseEvent:NeatMouseEvent;
	private var emitingEventTarget:IEventDispatcher;
	private var mouseDowns:Number = 0;
	private var mouseUps:Number = 0;
	private var clickCount:Number;
	private var started:Boolean = false;
	private var shifted:Boolean = false;
	private var maximumShift:Number = 0;

	public function MultiClickWatcher(sourceDispatcher:IEventDispatcher, eventName:String = "", multiClickTime:Number = 0, clickCount:Number = 2) {
		setup(eventName, maximumShift, multiClickTime, clickCount);
		super(sourceDispatcher, this.eventName);

	}

	private function setup(eventName:String, maximumShift:Number, multiClickTime:Number, clickCount:Number = 2):void {
		if (maximumShift == 0) {
			this.maximumShift = DefaultWatchersPreset.MAXIMUM_SHIFT;
		}

		if (eventName == "") {
			this.eventName = NeatMouseEvent.DOUBLE_CLICK;
		} else {
			this.eventName = eventName;
		}

		this.clickCount = clickCount;

		timer = new Timer(multiClickTime == 0 ? DefaultWatchersPreset.DOUBLE_CLICK_TIME : multiClickTime);
		timer.addEventListener(TimerEvent.TIMER, timer_timerHandler);
	}

	override protected function setupListeners():void {
		_sourceDispatcher.addEventListener(MouseEvent.MOUSE_DOWN, _sourceDispatcher_mouseDownHandler);
		_sourceDispatcher.addEventListener(MouseEvent.MOUSE_UP, _sourceDispatcher_mouseUpHandler)
	}

	override protected function removeListeners():void {
		_sourceDispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, _sourceDispatcher_mouseDownHandler);
		_sourceDispatcher.removeEventListener(MouseEvent.MOUSE_UP, _sourceDispatcher_mouseUpHandler)
	}


	protected function timer_timerHandler(event:TimerEvent):void {
		cancelWatching()
	}

	private function get canTrigger():Boolean {
		return (mouseDowns == mouseUps) && mouseDowns == clickCount;
	}

	private function startHandling(event:MouseEvent):void {
		started = true;
		timer.start();
		emitingMouseEvent = fromMouseEvent(eventName, event)
		emitingEventTarget = IEventDispatcher(event.target);
		shifted = false;
	}

	private function _sourceDispatcher_mouseUpHandler(event:MouseEvent):void {
		mouseUps++;
	}

	private function _sourceDispatcher_mouseDownHandler(event:MouseEvent):void {
		mouseDowns++;
		if (!started) {
			startHandling(event);
		}

		if (Math.pow(event.localX - emitingMouseEvent.localX, 2) +
				Math.pow(event.localY - emitingMouseEvent.localY, 2) >
				Math.pow(maximumShift, 2)) {
			shifted = true;
		}
	}

	private function cancelWatching():void {
		timer.stop();

		if (canTrigger && !shifted) {
			emitingEventTarget.dispatchEvent(emitingMouseEvent);
		}

		started = shifted = false;
		mouseDowns = mouseUps = 0;
	}
}
}
