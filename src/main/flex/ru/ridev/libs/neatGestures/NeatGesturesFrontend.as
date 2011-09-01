/**
 * @author Vladimir Ignatyev (vignatyev@flexis.ru)
 */
package ru.ridev.libs.neatGestures {
import flash.events.IEventDispatcher;

import ru.ridev.libs.neatGestures.defaultWatchers.FilteredClickWatcher;
import ru.ridev.libs.neatGestures.defaultWatchers.FilteredMouseDownWatcher;
import ru.ridev.libs.neatGestures.defaultWatchers.LongMouseDownWatcher;
import ru.ridev.libs.neatGestures.defaultWatchers.MultiClickWatcher;
import ru.ridev.libs.neatGestures.defaultWatchers.OptimizedMouseMoveWatcher;

/**
 * Sample front-end class for use in application.
 * You should provide it sourceDispatcher - the object at which you want to listen for neat gestures events.
 * */
public class NeatGesturesFrontend {
	protected var sourceDispatcher:IEventDispatcher;

	protected var _optimizedMouseMoveWatcher:OptimizedMouseMoveWatcher;
	protected var _filteredMouseDownWatcher:FilteredMouseDownWatcher;
	protected var _longMouseDownWatcher:LongMouseDownWatcher;
	protected var _filteredClickWatcher:FilteredClickWatcher;
	protected var _filteredDoubleClickWatcher:MultiClickWatcher;

	public function NeatGesturesFrontend(sourceDispatcher:IEventDispatcher) {
		this.sourceDispatcher = sourceDispatcher;
	}

	protected function initHandlers():void {
		_filteredMouseDownWatcher = new FilteredMouseDownWatcher(sourceDispatcher);
		_filteredDoubleClickWatcher = new MultiClickWatcher(sourceDispatcher);
		_longMouseDownWatcher = new LongMouseDownWatcher(sourceDispatcher);
		_optimizedMouseMoveWatcher = new OptimizedMouseMoveWatcher(sourceDispatcher);
		_filteredClickWatcher = new FilteredClickWatcher(sourceDispatcher);
	}

	public function get filteredMouseDownWatcher():FilteredMouseDownWatcher {
		return _filteredMouseDownWatcher;
	}

	public function get longMouseDownWatcher():LongMouseDownWatcher {
		return _longMouseDownWatcher;
	}

	public function get filteredClickWatcher():FilteredClickWatcher {
		return _filteredClickWatcher;
	}

	public function get optimizedMouseMoveWatcher():OptimizedMouseMoveWatcher {
		return _optimizedMouseMoveWatcher;
	}

	public function get filteredDoubleClickWatcher():MultiClickWatcher {
		return _filteredDoubleClickWatcher;
	}
}
}
