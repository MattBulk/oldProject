﻿package {		import flash.events.EventDispatcher;	import flash.events.IOErrorEvent;	import flash.media.SoundChannel;	import flash.media.SoundTransform;	import flash.media.Sound;	import flash.net.URLRequest;	import flash.utils.getDefinitionByName;			/**	 *	SoundEngine - Singleton controller for sounds. Allows user to adjust all basic properties of sounds.	 *	 *	@langversion ActionScript 3.0	 *	@playerversion Flash 9.0	 *	 *	@author Christopher Griffith	 *	@since  20.10.2008	 */	public class SoundEngine extends EventDispatcher {				//LIST OF SOUND OBJECTS THAT HAVE ALREADY BEEN CREATED		protected var _soundList:Object;		//FLAG SETTING WHETHER ALL NOT ALL SOUNDS ARE MUTED, SO NEW SOUNDS WILL BE MUTED AS WELL		protected var _allMuted:Boolean = false;				//SINGLETON INSTANCE		static private var _instance:SoundEngine;				//CONSTRUCTOR - NOT ACCESSIBLE MORE THAN ONCE		public function SoundEngine(validator:SoundEngineSingleton) {			if (_instance) throw new Error("SoundEngine is a Singleton class. Use getInstance() to retrieve the existing instance.");			_soundList = new Object();		}				/**		 * Returns the instance of the SoundEngine.		 * @return	SoundEngine		 */		static public function getInstance():SoundEngine {			if (!_instance) _instance = new SoundEngine(new SoundEngineSingleton());			return _instance;		}				/*SOUND ENGINE METHODS*/				/**		 * Plays the sound specified by the name parameter. Checks for the sound internally first, and then looks for it as an external file.		 * @param	name		String			The name of the linked Sound in the library, or the URL reference to an external sound.		 * @param	offset		Number			The number of seconds offset the sound should start.		 * @param	loops		int				The number of times the sound should loop. Use -1 for infinite looping.		 * @param	transform	transform		The initial sound transform to use for the sound.		 * @return				SoundChannel	The SoundChannel object created by playing the sound. Can also be retrieved through getChannel method.		 */		public function playSound(name:String, offset:Number = 0, loops:int = 0, transform:SoundTransform = null):SoundChannel {			if (!_soundList[name]) { //SOUND DOES NOT EXIST				var sound:Sound;				var soundClass:Class;				try {					soundClass = getDefinitionByName(name) as Class;				} catch (err:ReferenceError) {					trace("SoundEngine Message: Could not find sound object with name " + name + ".  Attempting to load external file.");				}				if (soundClass) { //INTERNAL REFERENCE FOUND - CREATING SOUND OBJECT					sound = new soundClass() as Sound;				} else { //NO INTERNAL REFERENCE FOUND - WILL ATTEMPT TO LOAD					sound = new Sound(new URLRequest(name));					sound.addEventListener(IOErrorEvent.IO_ERROR, ioError, false, 0, true);				}				_soundList[name] = new SoundEngineObject(name, sound);				_soundList[name].addEventListener(SoundEngineEvent.SOUND_COMPLETE, soundEvent, false, 0, true);				_soundList[name].addEventListener(SoundEngineEvent.SOUND_STOPPED, soundEvent, false, 0, true);			}			var channel:SoundChannel = _soundList[name].play(offset, loops, transform);			if (_allMuted) mute(name);			return channel;		}						protected function ioError(e:IOErrorEvent):void {			trace("SoundEngine Error Message: Failed to load sound: " + e.text);			delete _soundList[e.target.url];			dispatchEvent(new SoundEngineEvent(SoundEngineEvent.SOUND_ERROR, e.target.url));		}				protected function soundEvent(e:SoundEngineEvent):void {			dispatchEvent(e);		}				/**		 * Stops the specified sound.		 * @param	name	String	The name of the sound to stop - use the same name used when calling playSound.		 */		public function stopSound(name:String = null):void {			if (name) {				if (_soundList[name]) {					_soundList[name].stop();				} else {					throw new Error("Sound " + name + " does not exist. You must play a sound before you can stop it.");				}			} else {				for (var i:String in _soundList) {					_soundList[i].stop();				}			}		}				/**		 * Sets the volume of a specific sound, or of all sounds in the Engine.		 * @param	value	Number	The value, from 0 to 1, to set the volume.		 * @param	name	String	The name of the sound to change. Pass nothing to modify all sounds in the Engine.		 */		public function setVolume(value:Number, name:String = null):void {			if (name) {				if (_soundList[name]) {					_soundList[name].volume = Math.max(0, Math.min(1, value));				} else {					throw new Error("Sound " + name + " does not exist.");				}			} else {				for (var i:String in _soundList) _soundList[i].volume = Math.max(0, Math.min(1, value));			}		}				/**		 * Returns the volume level of a given sound.		 * @param	name	String	The name of the sound passed into playSound.		 * @return			Number	The value of the volume of the sound.		 */		public function getVolume(name:String):Number {			if (_soundList[name]) {				return _soundList[name].volume;			} else {				throw new Error("Sound " + name + " does not exist.");			}			return null;		}				/**		 * Sets the pan of a specified sound, or of all sounds in the Engine.		 * @param	value	Number	The value, from -1 to 1, to set the pan.		 * @param	name	String	The name of the sound to change. Pass nothing to modify all sounds in the Engine.		 */			public function setPan(value:Number, name:String = null):void {			if (name) {				if (_soundList[name]) {					_soundList[name].pan = value;				} else {					throw new Error("Sound " + name + " does not exist.");				}			} else {				for (var i:String in _soundList) _soundList[i].pan = value;			}		}				/**		 * Returns the pan of a given sound.		 * @param	name	String	The name of the sound passed into playSound.		 * @return			Number	The value of the pan of the sound.		 */		public function getPan(name:String):Number {			if (_soundList[name]) {				return _soundList[name].pan;			} else {				throw new Error("Sound " + name + " does not exist.");			}			return null;		}				/**		 * Sets the transform of a specified sound, or of all sounds in the Engine.		 * @param	transform	SoundChannel	The sound transform to assign.		 * @param	name		String			The name of the sound to change. Pass nothing to modify all sounds in the Engine.		 */		public function setTransform(transform:SoundTransform, name:String = null):void {			if (name) {				if (_soundList[name]) {					_soundList[name].transform = transform;				} else {					throw new Error("Sound " + name + " does not exist.");				}			} else {				for (var i:String in _soundList) _soundList[i].transform = transform;			}		}				/**		 * Returns the transform of a given sound.		 * @param	name	String			The name of the sound passed into playSound.		 * @return			SoundTransform	A copy of the sound transform applied to the named sound.		 */		public function getTransform(name:String):SoundTransform {			if (_soundList[name]) {				return _soundList[name].transform;			} else {				throw new Error("Sound " + name + " does not exist.");			}			return null;		}				/**		 * Returns the active channel of a given sound.		 * @param	name	String			The name of the sound passed into playSound.		 * @return			SoundTransform	A copy of the sound transform applied to the named sound.		 */		public function getChannel(name:String):SoundChannel {			if (_soundList[name]) {				return _soundList[name].channel;			} else {				throw new Error("Sound " + name + " does not exist.");			}			return null;		}				/**		 * Mutes/unmutes the given sound, or all sounds in the Engine.		 * @param	name	String	The name of the sound to mute/unmute. Leave out to act on all sounds in the Engine.		 */		public function mute(name:String = null):void {			if (name) {				if (_soundList[name]) {					_soundList[name].mute();					if (!_soundList[name].muted) _allMuted = false;				} else {					throw new Error("Sound " + name + " does not exist.");				}			} else {				for (var i:String in _soundList) _soundList[i].mute();				_allMuted = !_allMuted;			}		}				/**		 * Pauses/resumes the given sound, or all sounds in the Engine.		 * @param	name	String	The name of the sound to pause or resume. Leave out to act on all sounds in the Engine.		 */		public function pause(name:String = null):void {			if (name) {				if (_soundList[name]) {					_soundList[name].pause();				} else {					throw new Error("Sound " + name + " does not exist.");				}			} else {				for (var i:String in _soundList) _soundList[i].pause();			}		}				/**		 * Returns whether or not a given sound is currently playing.		 * @param	name	String		The name of the sound to check.		 * @return			Boolean		True if playing, false otherwise. If a sound is only paused, it will still return as playing.		 */		public function isPlaying(name:String):Boolean {			if (_soundList[name]) {				return _soundList[name].playing;			} else throw new Error("Sound " + name + " does not exist.");			return false;		}				/**		 * Returns whether or not a given sound is currently paused.		 * @param	name	String		The name of the sound to check.		 * @return			Boolean		True if sound is paused, false otherwise.		 */		public function isPaused(name:String):Boolean {			if (_soundList[name]) {				return _soundList[name].paused;			} else throw new Error("Sound " + name + " does not exist.");			return false;		}				/**		 * Returns whether or not a given sound is muted.		 * @param	name	String		The name of the sound to check.		 * @return			Boolean		True if muted, false otherwise.		 */		public function isMuted(name:String):Boolean {			if (_soundList[name]) {				return _soundList[name].muted;			} else throw new Error("Sound " + name + " does not exist.");			return false;		}			}	}import flash.events.Event;import flash.events.EventDispatcher;import flash.media.Sound;import flash.media.SoundChannel;import flash.media.SoundTransform;//import com.blockdot.audio.SoundEngineEvent;class SoundEngineObject extends EventDispatcher {		public var name:String;	public var sound:Sound;	public var channel:SoundChannel;		protected var _transform:SoundTransform;	protected var _playing:Boolean = false;	protected var _muted:Boolean = false;	protected var _paused:Boolean = false;	protected var _pauseTime:Number;	protected var _loops:int;	protected var _offset:Number;		public function SoundEngineObject(name:String, sound:Sound) {		this.name = name;		this.sound = sound;	}		public function play(offset:Number = 0, loops:int = 0, transform:SoundTransform = null):SoundChannel {		_offset = offset;		channel = sound.play(_offset, 0, transform);		channel.addEventListener(Event.SOUND_COMPLETE, complete, false, 0, true);		_transform = channel.soundTransform;		_loops = loops;		_playing = true;		return channel;	}		public function stop():void {		channel.stop();		_loops = 0;		_playing = false;		dispatchEvent(new SoundEngineEvent(SoundEngineEvent.SOUND_STOPPED, name));	}		protected function complete(e:Event):void {		if (_loops != 0) {			play(_offset, _loops--, _transform);		} else {			_playing = false;		}		dispatchEvent(new SoundEngineEvent(SoundEngineEvent.SOUND_COMPLETE, name));	}		public function get playing():Boolean {		return _playing;	}		public function get volume():Number {		return channel.soundTransform.volume;	}		public function set volume(value:Number):void {		var tf:SoundTransform = _transform;		tf.volume = value;		_transform = tf;		if (!_muted) channel.soundTransform = _transform;	}		public function get pan():Number {		return channel.soundTransform.pan;	}		public function set pan(value:Number):void {		var tf:SoundTransform = _transform;		tf.pan = value;		_transform = tf;		if (!_muted) channel.soundTransform = _transform;	}		public function get transform():SoundTransform {		return new SoundTransform(transform.volume, transform.pan);	}		public function set transform(tr:SoundTransform):void {		_transform = tr;		if (!_muted) channel.soundTransform = _transform;	}		public function mute():void {		if (_muted) {			channel.soundTransform = _transform;		} else {			channel.soundTransform = new SoundTransform(0, 0);		}		_muted = !_muted;	}		public function get muted():Boolean {		return _muted;	}		public function pause():void {		if (_paused) {			var normalOffset:Number = _offset;			play(_pauseTime, _loops, _transform);			_offset = normalOffset;		} else {			_pauseTime = channel.position;			channel.stop();		}		_paused = !_paused;	}			public function get paused():Boolean {		return _paused;	}	}class SoundEngineSingleton {}