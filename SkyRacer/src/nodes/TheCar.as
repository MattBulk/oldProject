package nodes
{
	import com.genome2d.components.GComponent;
	import com.genome2d.components.renderables.GMovieClip;
	import com.genome2d.core.GNode;
	import com.genome2d.core.GNodeFactory;
	import com.genome2d.core.Genome2D;
	import com.greensock.TweenLite;
	
	import components.RotateToMouse;
	
	import events.NavigationEvent;
	
	import utils.deg2rad;
	
	//DROP SHADOW ON MOBILE KILLS IPAD 1 AND IPOD 4th
	
	public class TheCar extends GComponent
	{
		public var theCar:GMovieClip;
		public var theCarJump:GMovieClip;
		public var wings:GMovieClip;
		//private var dropShadow:GDropShadowPP;
		private var rotateToMouse:RotateToMouse;
		
		public function TheCar(p_node:GNode)
		{
			super(p_node);
			
			wings = GNodeFactory.createNodeWithComponent(GMovieClip) as GMovieClip;
			wings.setTextureAtlas(Assets.allTexture[0]);
			wings.frameRate = 5;
			wings.frames = ["wings_00","wings_01","wings_02","wings_03"];
			wings.repeatable = false;
			wings.stop();
			wings.node.transform.setPosition(-20,0);
			wings.node.active = false;
			wings.node.transform.rotation = deg2rad(90);
			this.node.addChild(wings.node);
			
			theCar = GNodeFactory.createNodeWithComponent(GMovieClip) as GMovieClip;
			theCar.setTextureAtlas(Assets.allTexture[0]);
			theCar.frameRate = 30;
			theCar.frames = ["image_00000", "image_00001", "image_00002", "image_00003", "image_00004", "image_00005", "image_00006", "image_00007", "image_00008", "image_00009",
							 "image_00010", "image_00011", "image_00012", "image_00013", "image_00014", "image_00015", "image_00016", "image_00017", "image_00018", "image_00019",
							 "image_00020",	"image_00021", "image_00022", "image_00023", "image_00024", "image_00025", "image_00026", "image_00027", "image_00028", "image_00029",
							 "image_00030", "image_00031", "image_00032", "image_00033", "image_00034", "image_00035", "image_00036", "image_00037", "image_00038", "image_00039",
							 "image_00041", "image_00042"];
			theCar.repeatable = false;
			theCar.stop();
			theCar.node.transform.setScale(1, 1);
			//dropShadow = new GDropShadowPP(3,3,3,2);
			//dropShadow.color=0x4D4D4D;
			//theCar.node.postProcess = dropShadow;
			theCar.node.transform.setPosition(-20,0);
			theCar.node.transform.rotation = deg2rad(90);
			this.node.addChild(theCar.node);
			
			theCarJump = GNodeFactory.createNodeWithComponent(GMovieClip) as GMovieClip;
			theCarJump.setTextureAtlas(Assets.allTexture[0]);
			theCarJump.frameRate = 40;
			theCarJump.frames = ["jump_00000", "jump_00001", "jump_00002", "jump_00003", "jump_00004", "jump_00005", "jump_00006", "jump_00007", "jump_00008", "jump_00009",
								 "jump_00010", "jump_00011", "jump_00012", "jump_00013", "jump_00014", "jump_00015", "jump_00016", "jump_00017", "jump_00018", "jump_00019",
								 "jump_00020", "jump_00021", "jump_00022", "jump_00023", "jump_00024", "jump_00025", "jump_00026", "jump_00027", "jump_00028", "jump_00029",
								 "jump_00030"];
			theCarJump.repeatable = false;
			theCarJump.stop();
			theCarJump.node.active = false;
			theCarJump.node.transform.setPosition(-20,0);
			theCarJump.node.transform.rotation = deg2rad(90);
			this.node.addChild(theCarJump.node);
			
			rotateToMouse = this.node.addComponent(RotateToMouse) as RotateToMouse;
			
			
		}
		
		public function gameOver():void {
			
			//theCar.node.postProcess = null;
			if((this.node.getComponent(RotateToMouse) as RotateToMouse).ONJUMP) TweenLite.killTweensOf(theCarJump.node.transform);
			(this.node.getComponent(RotateToMouse) as RotateToMouse).maxSpeed = .3;
			theCar.play();
			TweenLite.to(theCar.node.transform, 1.5, {scaleX:.4, scaleY:.4, onComplete:removeMe})
			
		}
		
		private function removeMe():void {
			
			this.node.removeComponent(RotateToMouse);
			Genome2D.getInstance().stage.dispatchEvent(new NavigationEvent(NavigationEvent.GAME_STATE, {id: "GAMEOVERSCREEN"}, true));
		}
		
		public function jump():void {
			
			SkyRacer.MAIN.SM.setVolume(.2, "../sounds/CARRUN.mp3");
			SkyRacer.MAIN.SM.playSound("../sounds/JUMP.mp3");
			
			(this.node.getComponent(RotateToMouse) as RotateToMouse).ONJUMP = true;
			(this.node.getComponent(RotateToMouse) as RotateToMouse).speed = .6;
			(this.node.getComponent(RotateToMouse) as RotateToMouse).maxSpeed = .7;
			theCar.node.active = false;
			theCarJump.node.active = true;
			theCarJump.play();
			TweenLite.to(theCarJump.node.transform, .3, {scaleX:1.1, scaleY:1.1});
			TweenLite.to(theCarJump.node.transform, .3, {scaleX:1, scaleY:1, delay:.3, onComplete:returnFromJump});
		}
		
		private function returnFromJump():void {
			
			(this.node.getComponent(RotateToMouse) as RotateToMouse).ONJUMP = false;
			theCar.node.active = true;
			theCarJump.node.active = false;
			theCarJump.gotoFrame(0);
			(this.node.getComponent(RotateToMouse) as RotateToMouse).speed = .6;
			(this.node.getComponent(RotateToMouse) as RotateToMouse).maxSpeed = .8;
			Genome2D.getInstance().stage.dispatchEvent(new NavigationEvent(NavigationEvent.GAME_STATE_CAR, {id: "JUMPOFF"}, true));
		}
		
	}
}