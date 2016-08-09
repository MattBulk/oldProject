package components
{
	import com.genome2d.components.GComponent;
	import com.genome2d.components.renderables.GTextureText;
	import com.genome2d.core.GNode;
	import com.genome2d.core.GNodeFactory;
	import com.genome2d.core.Genome2D;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import events.NavigationEvent;
	
	import utils.deg2rad;
	import utils.rad2deg;
	
	public class RotateToMouse extends GComponent
	{
		
		private const accel:Number = .0015;
		private const decel:Number = .0002;
		private const turnSpeed:Number = .2;
		
		public var maxSpeed:Number = .7;
		public var speed:Number = 0;
		public var ONJUMP:Boolean;
		public var BRAKEON:Boolean;
		
		private var thisAngle:Number;
		private var carMove:Number;
		private var dxCar:Number;
		private var dyCar:Number;
		private var STAGEWIDTH:int;
		private var STAGEHEIGHT:int;
		private var touchX:Number;
		private var touchY:Number;
		private var fl_TimerInstance:Timer;
		private var secondsToPass:int = 3;
		private var GO:Boolean;
		private var motorBrakeTimer:Number = 0;
		private var brakeNum:Number = 0.001;
		
		// DRIFTING
		public var DRIFTING:Boolean;
		
		private var positionX:Number = 0;
		private var positionY:Number = 0;
		private var velocityX:Number = 0;
		private var velocityY:Number = 0;
		
		private var angularVelocity:Number = 0;
		private var angularDrag:Number = .90;
		private var power:Number = .8;
		
		private const RAD:Number = Math.PI/180;
		private const drag:Number = .92;
		private const turningSpeed:Number = .35;

		private var label:GTextureText;
		
		public function RotateToMouse(p_node:GNode)
		{
			super(p_node);
			
			STAGEWIDTH = Genome2D.getInstance().stage.stageWidth;
			STAGEHEIGHT = Genome2D.getInstance().stage.stageHeight;
			this.node.transform.rotation = deg2rad(-90);
			
			this.node.core.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
			this.node.core.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUP, false, 0, true);
			
			fl_TimerInstance = new Timer(1000);
			fl_TimerInstance.addEventListener(TimerEvent.TIMER, fl_TimerHandler, false, 0, true);
			fl_TimerInstance.start();
			
			label = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			label.setTextureAtlas(Assets.allTexture[1]);
			label.text = "3";
			label.node.transform.setPosition(300, 250);
			label.node.transform.setScale(2, 2);
			label.node.transform.rotation = deg2rad(90);
			node.addChild(label.node);
			SkyRacer.MAIN.SM.playSound("../sounds/SECOND.mp3");
		}
		
		protected function fl_TimerHandler(evt:TimerEvent):void
		{
			secondsToPass--;
			
			if(secondsToPass == 2) {label.text = "2"; SkyRacer.MAIN.SM.playSound("../sounds/SECOND.mp3");}
			if(secondsToPass == 1) {label.text = "1"; SkyRacer.MAIN.SM.playSound("../sounds/SECOND.mp3");}
			if(secondsToPass == 0) { label.text = "GO"; label.node.transform.setPosition(200, -140); SkyRacer.MAIN.SM.playSound("../sounds/GO.mp3");}
			if(secondsToPass == -1) {
				node.removeChild(label.node);
				label.dispose();
				SkyRacer.MAIN.SM.playSound("../sounds/CARRUN.mp3", 0, -1);
				SkyRacer.MAIN.SM.setVolume(.6, "../sounds/CARRUN.mp3");
				SkyRacer.MAIN.SM.playSound("../sounds/SKID.mp3");
				GO = true;
				Genome2D.getInstance().stage.dispatchEvent(new NavigationEvent(NavigationEvent.GAME_STATE, {id: "PLAY"}, true));
				fl_TimerInstance.stop();
				fl_TimerInstance.removeEventListener(TimerEvent.TIMER, fl_TimerHandler);
			}
			
		}
		
		protected function mouseUP(evt:MouseEvent):void
		{
			touchX = STAGEWIDTH * .5;
			motorBrakeTimer = 0;
			brakeNum = .001;
		}
		
		protected function mouseDown(evt:MouseEvent):void
		{
			if(ONJUMP) return;
			
			else {
				touchX = Genome2D.getInstance().stage.mouseX;
				touchY = Genome2D.getInstance().stage.mouseY;
			}
		}
		
		override public function update(p_deltaTime:Number, p_parentTransformUpdate:Boolean, p_parentColorUpdate:Boolean):void {
			
			super.update(p_deltaTime, p_parentTransformUpdate, p_parentColorUpdate);
			
			if(GO && !DRIFTING) {
				getInput(p_deltaTime);
				checkMotorBrake();
			}
			if(DRIFTING) driftLoop();
			
		}
		
		//*************************************************** NORMAL DRIVING ***************************************************//
		
		private function checkMotorBrake():void
		{
			if(motorBrakeTimer > 100) brakeNum += 0.002;
			
			if(motorBrakeTimer < -100) brakeNum += 0.002;
		}
		
		private function getInput(touchDelta:Number):void
		{
			
			
			if(BRAKEON) speed -= decel * touchDelta; 
			else speed += accel * touchDelta;
			
			if(touchX > STAGEWIDTH * .5 + STAGEWIDTH * .1 && touchY < STAGEHEIGHT * .8) {
				
				this.node.transform.rotation += deg2rad((speed + brakeNum) * turnSpeed * touchDelta);
				motorBrakeTimer += touchDelta;
			}
		
			if(touchX < STAGEWIDTH * .5 - STAGEWIDTH * .1 && touchY < STAGEHEIGHT * .8) {
				
				this.node.transform.rotation -= deg2rad((speed + brakeNum) * turnSpeed * touchDelta);
				motorBrakeTimer -= touchDelta;
			}
			
			if (speed > maxSpeed)
			{
				speed = maxSpeed;
			}
			else if (speed > 0)
			{
				speed -=  decel * touchDelta;
				if (speed < 0)
				{
					speed = 0;
				}
			}
			else if (speed < 0)
			{
				speed +=  decel * touchDelta;
				if (speed > 0)
				{
					speed = 0;
				}
			}
			// if moving, then move car and check status
			if (speed != 0)
			{
				moveCar(touchDelta);
			}	
		}
		
		protected function moveCar(touchDelta:Number):void {
			
			thisAngle = rad2deg(this.node.transform.rotation);
			carMove = (speed - brakeNum) * touchDelta;
			dxCar = Math.cos(Math.PI * thisAngle / 180) * carMove;
			dyCar = Math.sin(Math.PI * thisAngle / 180) * carMove;
			
			this.node.transform.x = this.node.transform.x + dxCar;
			this.node.transform.y = this.node.transform.y + dyCar;
						
		}
		
		//*************************************************** DRIFTING ***************************************************//
		
		public function startDrift(carX:Number, carY:Number):void {
			
			positionX = carX;
			positionY = carY;
			DRIFTING = true;
		}
		private function driftLoop():void {
			
			positionX -= velocityX;
			positionY -= velocityY;
			velocityX *= drag;
			velocityY *= drag;
			
			this.node.transform.rotation += angularVelocity * RAD;
			
			angularVelocity *= angularDrag;
			
			velocityX += Math.sin(-this.node.transform.rotation + deg2rad(-90)) * power;
			velocityY += Math.cos(-this.node.transform.rotation + deg2rad(-90)) * power;
			
			if(touchX > STAGEWIDTH * .5 + STAGEWIDTH * .1) {
				angularVelocity += turningSpeed;
				if(!SkyRacer.MAIN.SM.isPlaying("../sounds/SKID.mp3")) SkyRacer.MAIN.SM.playSound("../sounds/SKID.mp3");
			}
			if(touchX < STAGEWIDTH * .5 - STAGEWIDTH * .1) {
				angularVelocity -= turningSpeed;
				if(!SkyRacer.MAIN.SM.isPlaying("../sounds/SKID.mp3")) SkyRacer.MAIN.SM.playSound("../sounds/SKID.mp3");
			}
			
			this.node.transform.x = positionX;
			this.node.transform.y = positionY;
		}
	}
}