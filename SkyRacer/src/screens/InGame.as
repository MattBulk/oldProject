package screens
{
	import com.genome2d.components.GCamera;
	import com.genome2d.components.GComponent;
	import com.genome2d.components.particles.GSimpleEmitter;
	import com.genome2d.components.renderables.GSimpleShape;
	import com.genome2d.components.renderables.GSprite;
	import com.genome2d.components.renderables.GTextureText;
	import com.genome2d.core.GNode;
	import com.genome2d.core.GNodeFactory;
	import com.genome2d.core.GNodePool;
	import com.genome2d.core.Genome2D;
	import com.genome2d.signals.GMouseSignal;
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.GTextureAlignType;
	import com.genome2d.textures.factories.GTextureFactory;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import components.Obstacles;
	import components.PowerUps;
	import components.RotateToMouse;
	
	import events.NavigationEvent;
	
	import nodes.Brake;
	import nodes.Cloud;
	import nodes.TheCar;
	
	import utils.NumberGenerator;
	import utils.deg2rad;
	import utils.rad2deg;
	
	public class InGame extends GComponent
	{
		// VECTOR ARRAYS
		private var arrayInside:Vector.<Point >;
		private var arrayOutside:Vector.<Point >;
		private var arrayRot:Vector.<Point >;
		private var arrayTiles:Vector.<GSimpleShape >;
		private var arrayPoints:Vector.<Point >;
		private var arrayCloud:Vector.<Cloud>;
		private var arraySpinal:Vector.<Point>;
		private var arrayItems:Vector.<PowerUps>;
		private var arrayObstacles:Vector.<Obstacles>;
		// ROAD
		private var vertices:Vector.<Number>;
		private var uvs:Vector.<Number>;
		private var shape:GSimpleShape;
		private var texture:GTexture = Assets.tileTexture;
		private var roadTileInside:Point;
		private var roadTileOuside:Point;
		private var middleTexture:Number;
		private var pt:Point;
		private var tilePoint:Point;
		private var curveTypeLeft:Number;
		private var curveTypeRight:Number;
		private var lineType:Number;
		private var curveTypeLeftTot:Number = 0;
		private var curveTypeRightTot:Number = 0;
		private var spinalRot:Number;
		private var spinalCheckPoint:Point;
		// ROADWORLD
		private const angleRot:int = 10;
		private var startingPoint:Point;
		private var finishingPoint:Point;
		private var insidePoint:Point;
		private var outsidePoint:Point;
		private var rotationPoint:Point;
		private var spinalPoint:Point;
		private var roadWorld:GNode;
		private var theRoad:GNode;
		private var theCar:TheCar;
		private var carPos:Point;
		private var offRoad:Boolean;
		// GENERATE ROAD
		private var innerRadius:Number;
		private var outerRadius:Number;
		private var startingRotation:Number;
		private var nextRotation:Number;
		private var dxRotation:Number;
		private var dyRotation:Number;
		private var generateRoadRatio:int;
		// CAMERA VARS
		private var camera:GCamera;
		private var camera2:GCamera;
		private var theNumberFactorP:int = 0;
		private var theNumberFactorN:int = 0;
		private var STAGEHEIGHT:int;
		private var STAGEWIDTH:int;
		private var scaleFactor:Number;
		private var gap:Number;
		private var fl_TimerRoad:Timer;
		private var fl_TimerCloud:Timer;
		private var seconds:int = 0;
		// GUI VARS
		private var gui:GNode;
		private var textDistance:GTextureText;
		private var scoreDistanceText:GTextureText;
		private var theScoreText:GTextureText;
		private var TheScoreUpText:GTextureText;
		private var moneyText:GTextureText;
		private var moneyIntText:GTextureText;
		private var fuelTexture:GTexture = GTextureFactory.createFromColor("red", 0xFF0000, 1, 10);
		private var fuelBar:GSprite;
		private var scoreDistance:int;
		private var scorePoints:int;
		private var money:int;
		private var arrowLeft:GSprite;
		private var arrowRight:GSprite;
		private var arrowTexture:GTexture = Assets.allTexture[0].getTexture("arrow");
		private var brakeBtn:Brake;
		// CLOUD VARS
		private var cloud:Cloud;
		private var cloudTexture:GTexture = Assets.allTexture[0].getTexture("cloud_tile");
		private var cloudArr:Array = [new Point(15,5), new Point(5,5), new Point(4,4), new Point(3,3)];
		private var randomCloudNum:int;
		private var cloudPool:GNodePool;
		private var cloudRatio:Number;
		private var nextRotationCloud:Number;
		private var pointPolar:Point;
		// POWER UPS
		private var powerUp:PowerUps;
		private var itemsPoint:Point;
		private var itemsPool:GNodePool;
		private var wings:Boolean;
		private var fl_TimerSuper:Timer;
		private var timerSupers:int = 5;
		private var ONPOWERUP:Boolean;
		private var POWERUPTYPE:int;
		private var generatePowerUpRatio:int;
		// EMITTERS
		private var particleTexture:GTexture = Assets.allTexture[0].getTexture("particle_pixel");
		private var particleTexture2:GTexture = Assets.allTexture[0].getTexture("particle_car_exp");
		private var particleTextureTower:GTexture = Assets.allTexture[0].getTexture("particle_tower_exp");
		private var itemEmitter:GSimpleEmitter;
		private var carEmitter:GSimpleEmitter;
		// OBSTACLES
		private var obstacle:Obstacles;
		private var obstaclePool:GNodePool;
		private var obstaclePoint:Point;
		private var arrayBlock:Array;
		private var obstacleRot:Number;
		private var jump:Boolean;
		private var randomRatio:Number;
		// OTHER VARS
		private var gameOverScreen:GameOver;
		private var GAMEOVERSTATE:String;
		private var GAMEMODE:String;
		private var STATEMODE:String;
		private var currentSpeed:Number;
		private var brakeOn:Boolean;
		
		private var INTERSECT:Boolean;
		
		public function InGame(p_node:GNode)
		{
			super(p_node);
			
			init();
			
			if(!SkyRacer.MAIN.MUTE) SkyRacer.MAIN.SM.setVolume(.5, "../sounds/MAIN.mp3");
		}
		
		private function init():void {
			
			STAGEWIDTH = Genome2D.getInstance().stage.stageWidth;
			STAGEHEIGHT = Genome2D.getInstance().stage.stageHeight;
			
			arrayInside = new Vector.<Point>();
			arrayOutside = new Vector.<Point>();
			arrayRot = new Vector.<Point>();
			arrayPoints = new Vector.<Point>();
			arrayTiles = new Vector.<GSimpleShape>();
			arrayCloud = new Vector.<Cloud>;
			arraySpinal = new Vector.<Point>();
			arrayItems = new Vector.<PowerUps>();
			arrayObstacles = new Vector.<Obstacles>;
			
			roadWorld = GNodeFactory.createNode("world");
			theRoad = GNodeFactory.createNode("theroad");
			gui = GNodeFactory.createNode("gui");
			
			camera = GNodeFactory.createNodeWithComponent(GCamera) as GCamera;
			camera.node.transform.setPosition(0,0);
			camera.mask = 1;
			camera2 = GNodeFactory.createNodeWithComponent(GCamera) as GCamera;
			camera2.node.transform.setPosition(STAGEWIDTH * .5, STAGEHEIGHT * .5);
			camera2.mask = 2;
			
			Genome2D.getInstance().root.addChild(roadWorld);
			Genome2D.getInstance().root.addChild(camera.node);
			Genome2D.getInstance().root.addChild(camera2.node);
			Genome2D.getInstance().root.addChild(gui);
			
			roadWorld.cameraGroup = 1;
			gui.cameraGroup = 2;
			
			roadWorld.addChild(theRoad);
			roadWorld.putChildToBack(theRoad);
			roadWorld.cameraGroup = 1;
			
			startingPoint = new Point(roadWorld.transform.x, STAGEHEIGHT + 300);
			finishingPoint = new Point(roadWorld.transform.x + 350, STAGEHEIGHT + 300);
			rotationPoint = new Point(roadWorld.transform.x + 450, STAGEHEIGHT + 300);
			
			arrayRot.push(rotationPoint);
			arrayOutside.push(startingPoint);
			arrayInside.push(finishingPoint);
			
			theCar = GNodeFactory.createNodeWithComponent(TheCar) as TheCar;
			carPos = new Point(roadWorld.transform.x, roadWorld.transform.y);
			
			roadWorld.addChild(theCar.node);
			roadWorld.putChildToFront(theCar.node);
			
			middleTexture = texture.width >> 1;
			theCar.node.transform.setPosition(middleTexture + 10, 500);
			TweenLite.from(theCar.node.transform , 2, {y : 600, onComplete:createGUI});
			
			initTheEmitter();
			
			spinalCheckPoint = new Point(0, 0);
			
			//SET LEVEL 
			generateRoadRatio = 5;
			generatePowerUpRatio = 3;
			randomRatio = .5;
			currentSpeed = (theCar.node.getComponent(RotateToMouse) as RotateToMouse).maxSpeed;
			
			//POOLS
			cloud = GNodeFactory.createNodeWithComponent(Cloud) as Cloud;
			cloudPool = new GNodePool(cloud.node.getPrototype(), 0, 5);
			generateTheStartingCloud();
			
			powerUp = GNodeFactory.createNodeWithComponent(PowerUps) as PowerUps;
			itemsPool = new GNodePool(powerUp.node.getPrototype(), 0, 5);
			
			obstacle = GNodeFactory.createNodeWithComponent(Obstacles) as Obstacles;
			obstaclePool = new GNodePool(obstacle.node.getPrototype(), 0, 5);
			
			//SCALE FACTOR
			scaleFactor = .9;
			camera.zoom = scaleFactor;
			gap = 150 * (2 - scaleFactor) + 30 * (3 - scaleFactor);
			
			//CREATE FIRST METERS OF ROAD
			startingRotation = 180;
			rightCurve(startingRotation, 1);
			line(nextRotation + 90, randomRange(10, 20));
			arrayOutside.splice(0,1);
			arrayInside.splice(0,1);
			generateRoad(1);
			
			//ADD THE GAME STATE AND START THE GAME'S TIMER
			this.node.core.stage.addEventListener(events.NavigationEvent.GAME_STATE, gameState, false, 0, true);
			this.node.core.stage.addEventListener(events.NavigationEvent.GAME_STATE_CAR, changeState, false, 0, true);
			
			GAMEMODE = "IDLE";
			
			fl_TimerRoad = new Timer(80);
			fl_TimerRoad.addEventListener(TimerEvent.TIMER, fn_TimerRoad, false, 0, true);
			fl_TimerRoad.start();
			
			fl_TimerCloud = new Timer(3000);
			fl_TimerCloud.addEventListener(TimerEvent.TIMER, fn_TimerCloud, false, 0, true);
			fl_TimerCloud.start();
			
			fl_TimerSuper = new Timer(1000, timerSupers);
			fl_TimerSuper.addEventListener(TimerEvent.TIMER_COMPLETE, fn_TimerSuperComplete, false, 0, true);
			fl_TimerSuper.addEventListener(TimerEvent.TIMER, fn_TimerSuper, false, 0, true);
		}
		
		//*************************************************** GUI ***************************************************//
		
		private function createGUI():void
		{
			gui.transform.setPosition(20,20);
			// TODO Auto Generated method stub
			textDistance = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			textDistance.setTextureAtlas(Assets.allTexture[1]);
			textDistance.text = "DISTANCE:";
			textDistance.node.transform.setPosition(0,5);
			textDistance.node.transform.setScale(.3, .3);
			textDistance.node.transform.alpha = .8;
			gui.addChild(textDistance.node);
			
			scoreDistanceText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			scoreDistanceText.setTextureAtlas(Assets.allTexture[1]);
			scoreDistanceText.text = "0";
			scoreDistanceText.node.transform.setPosition(160,0);
			scoreDistanceText.node.transform.setScale(.4, .4);
			gui.addChild(scoreDistanceText.node);
			
			theScoreText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			theScoreText.setTextureAtlas(Assets.allTexture[1]);
			theScoreText.text = "SCORE:";
			theScoreText.node.transform.setPosition(0,35);
			theScoreText.node.transform.setScale(.3, .3);
			theScoreText.node.transform.alpha = .8;
			gui.addChild(theScoreText.node);
			
			TheScoreUpText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			TheScoreUpText.setTextureAtlas(Assets.allTexture[1]);
			TheScoreUpText.text = "0";
			TheScoreUpText.node.transform.setPosition(160,30);
			TheScoreUpText.node.transform.setScale(.4, .4);
			gui.addChild(TheScoreUpText.node);
			
			moneyText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			moneyText.setTextureAtlas(Assets.allTexture[1]);
			moneyText.text = "MONEY:";
			moneyText.node.transform.setPosition(0,65);
			moneyText.node.transform.setScale(.3, .3);
			moneyText.node.transform.alpha = .8;
			gui.addChild(moneyText.node);
			
			moneyIntText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			moneyIntText.setTextureAtlas(Assets.allTexture[1]);
			moneyIntText.text = "0";
			moneyIntText.node.transform.setPosition(160,60);
			moneyIntText.node.transform.setScale(.4, .4);
			gui.addChild(moneyIntText.node);
			
			fuelBar = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			fuelBar.setTexture(fuelTexture);
			fuelTexture.alignTexture(GTextureAlignType.TOP_LEFT);
			fuelBar.node.transform.scaleX = STAGEWIDTH - 20;
			fuelBar.node.transform.setPosition(0, -20);
			fuelBar.node.transform.alpha = .6;
			gui.addChild(fuelBar.node);
			
			scorePoints = 0;
			money = 0;
			
			arrowLeft = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			arrowLeft.setTexture(arrowTexture);
			arrowLeft.node.transform.setPosition(arrowTexture.width >> 1, STAGEHEIGHT * .5 - 20);
			arrowLeft.blendMode = 4;
			gui.addChild(arrowLeft.node);
			
			arrowRight = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
			arrowRight.setTexture(arrowTexture);
			arrowRight.node.transform.setPosition(STAGEWIDTH - 35 - (arrowTexture.width >> 1), STAGEHEIGHT * .5 - 20);
			arrowRight.node.transform.rotation = deg2rad(180);
			arrowRight.blendMode = 4;
			gui.addChild(arrowRight.node);
			
			brakeBtn = GNodeFactory.createNodeWithComponent(Brake) as Brake;
			brakeBtn.node.transform.setPosition(-50, STAGEHEIGHT * 0.96);
			brakeBtn.node.mouseEnabled = true;
			brakeBtn.node.onMouseClick.add(onBrake);
			
			gui.addChild(brakeBtn.node);
			
			TweenLite.from(gui.transform , 1, {y : -100});
		}
		
		private function gameState(evt:NavigationEvent):void {
			
			GAMEMODE = evt.params.id;
			if(GAMEMODE == "GAMEOVERSCREEN") gameOver("PIT");
		}
		
		private function changeState(evt:NavigationEvent):void {
			
			STATEMODE = evt.params.id;
			if(STATEMODE == "JUMPOFF") {
				jump = false;
				SkyRacer.MAIN.SM.setVolume(.6, "../sounds/CARRUN.mp3");
			}
		}
		
		//*************************************************** BRAKE ***************************************************//
		
		private function onBrake(signal:GMouseSignal):void
		{
			if((theCar.node.getComponent(RotateToMouse) as RotateToMouse).BRAKEON == true || wings) return;
			else {
				(theCar.node.getComponent(RotateToMouse) as RotateToMouse).BRAKEON = true;
				brakeBtn.node.transform.color = 0xFF0000;
				TweenLite.delayedCall(1, brakeOff);
				SkyRacer.MAIN.SM.playSound("../sounds/CARBRAKE.mp3");
			}
		}
		
		private function brakeOff():void
		{
			(theCar.node.getComponent(RotateToMouse) as RotateToMouse).BRAKEON = false;
			brakeBtn.node.transform.color = 0xFFFFFF;
		}
		
		//*************************************************** CLOUDS ***************************************************//
		
		private function generateTheStartingCloud():void
		{
			for(var c:int=0; c<2; c++) {
				
				cloud = cloudPool.getNext().getComponent(Cloud) as Cloud;
				cloud.init(cloudArr[0], cloudTexture);
				cloud.node.transform.setPosition(-300 * (1 + c), 450 - (100 * c));
				cloud.node.transform.setScale(3, 3);
				roadWorld.addChild(cloud.node);
				arrayCloud.push(cloud);
			}
		}
		
		private function generateCloud():void
		{
			cloud = cloudPool.getNext().getComponent(Cloud) as Cloud;
			randomCloudNum = Math.ceil(Math.random() * (cloudArr.length - 1));
			cloud.init(cloudArr[randomCloudNum], cloudTexture);
		 	roadWorld.addChild(cloud.node);
			
			if(Math.random() > .7) {
				roadWorld.putChildToBack(cloud.node);
				cloudRatio = 2;
			}
			else cloudRatio = Math.random();
			
			nextRotationCloud = Math.atan2((arrayInside[arrayInside.length-1].y - arrayOutside[arrayOutside.length-1].y),(arrayInside[arrayInside.length-1].x - arrayOutside[arrayOutside.length-1].x));
			
			pointPolar = new Point();
			pointPolar.x = Math.sin(nextRotationCloud) * 300;
			pointPolar.y = Math.cos(nextRotationCloud) * 300;
			
			cloud.node.transform.setPosition(arraySpinal[arraySpinal.length-1].x + pointPolar.x, arraySpinal[arraySpinal.length-1].y + pointPolar.y);
			cloud.node.transform.setScale(1.5 + cloudRatio, 1.5 + cloudRatio);
			cloud.node.transform.alpha = .5;
			arrayCloud.push(cloud);
		}
		
		//*************************************************** GAME LOOP ***************************************************//
		
		override public function update(p_deltaTime:Number, p_parentTransformUpdate:Boolean, p_parentColorUpdate:Boolean):void {
			
			super.update(p_deltaTime, p_parentTransformUpdate, p_parentColorUpdate);
			
			switch (GAMEMODE)
			{
				case "IDLE":
					carPos.setTo(theCar.node.transform.x, theCar.node.transform.y);
					camera.node.transform.setPosition(carPos.x, carPos.y);
					break;
				case "PLAY":
					carPos.setTo(theCar.node.transform.x, theCar.node.transform.y);                        
					camera.node.transform.setPosition(carPos.x, carPos.y);
					windRose(rad2deg(theCar.node.transform.rotation), p_deltaTime);
					if(!wings) checkOnRoad();
					checkObstacles();
					checkPowerUp();
					scoreDistance += .6 * (p_deltaTime * 0.1);
					scoreDistanceText.text = scoreDistance.toString();
					break;
				case "GAMEOVER":
					carPos.setTo(theCar.node.transform.x, theCar.node.transform.y);
					carEmitter.node.transform.setPosition(carPos.x, carPos.y);
					camera.node.transform.setPosition(carPos.x, carPos.y);
					camera.node.transform.rotation += 0.01;
					camera.zoom += 0.01;
					break;
				case "NOFUEL":
					carPos.setTo(theCar.node.transform.x, theCar.node.transform.y);
					camera.node.transform.setPosition(carPos.x, carPos.y);
					carEmitter.node.transform.setPosition(carPos.x, carPos.y);
					checkOnRoad();
					if((theCar.node.getComponent(RotateToMouse) as RotateToMouse).maxSpeed <= 0) {
						(theCar.node.getComponent(RotateToMouse) as RotateToMouse).maxSpeed = 0;
						theCar.node.removeComponent(RotateToMouse);
						gameOver("NOFUEL");
						GAMEMODE = "GAMEOVERSCREEN";
					}
					else {
						(theCar.node.getComponent(RotateToMouse) as RotateToMouse).maxSpeed -= .01;
						camera.zoom += 0.005;
					}
					break;
			}
		}
		
		private function windRose(whichRotation:Number, touchDelta:Number):void {
			
			whichRotation = ( whichRotation + 180) % 360 - ( 180 * whichRotation / Math.abs(whichRotation ) );
			
			if(whichRotation > 0 && whichRotation < 180) {
				
				if(theNumberFactorP < gap) theNumberFactorP += touchDelta * .08;
				else theNumberFactorP = gap;
				camera.node.transform.setPosition(theCar.node.transform.x, theCar.node.transform.y + theNumberFactorP);
				theNumberFactorN = 0;
			}
			if(whichRotation < 0 && whichRotation > -180) {
				
				if(theNumberFactorN < gap) theNumberFactorN += touchDelta * .08;
				else theNumberFactorN = gap;
				camera.node.transform.setPosition(theCar.node.transform.x, theCar.node.transform.y - theNumberFactorN); 
				theNumberFactorP = 0;
			}
		}
		
		//*************************************************** TIMERS ***************************************************//
		
		private function fn_TimerRoad(evt:TimerEvent):void
		{
			if(arrayInside.length < 30) {
				if(scoreDistance < 600 ) generateRoad(1);
				else if(POWERUPTYPE == 4) generateRoad(-Math.ceil(Math.random() * 3));
				
				else generateRoad(Math.ceil(Math.random() * generateRoadRatio));
				
				if(curveTypeLeftTot / curveTypeRightTot > 1.3) {
					
					generateRoad(0);
					curveTypeLeftTot = curveTypeRightTot = 0;
				}
			}
				
			createQuad();
			
			if(arraySpinal.length > 3) checkSpinalCord();
			
			removeQuad();
			
			if(Point.distance(arraySpinal[arraySpinal.length - 1], carPos) < 1200) fl_TimerRoad.delay = 30;
			else if(POWERUPTYPE == 4) fl_TimerRoad.delay = 300;
			
			else fl_TimerRoad.delay = 80;
		}
		
		private function removeQuad():void
		{
			if (arrayTiles.length > 100)  {
				
				if(Point.distance(arraySpinal[0], carPos) > 300) {
					theRoad.removeChild(arrayTiles[0].node);
					arrayTiles.splice(0,1);
					
					arraySpinal.splice(0,1);
					for (var i:int=3; i>0; i--) {
						
						if(arrayObstacles.length > 0) {
							obstaclePoint = new Point(arrayObstacles[0].node.transform.x, arrayObstacles[0].node.transform.y);
							
							if(Point.distance(arrayPoints[0], obstaclePoint) == 0) {
								
								arrayObstacles[0].disposeMe();
								arrayObstacles.splice(0,1);
							}
						}
						arrayPoints.splice(0,1);
					}
				}
				else return;
			}
		}
		
		private function checkSpinalCord():void
		{
			spinalRot = Math.atan2((arraySpinal[arraySpinal.length - 1].y - arraySpinal[arraySpinal.length - 2].y),(arraySpinal[arraySpinal.length - 1].x - arraySpinal[arraySpinal.length - 2].x));
			
			var dxSpinal:Number = Math.sin( -spinalRot + deg2rad(90)) * 200;
			var dySpinal:Number = Math.cos( -spinalRot + deg2rad(90)) * 200;
			
			spinalCheckPoint.x = arraySpinal[arraySpinal.length - 1].x + dxSpinal;
			spinalCheckPoint.y = arraySpinal[arraySpinal.length - 1].y + dySpinal;
			
			

			inter:for (var i:int=arraySpinal.length-1; i>0; i--) {
				
				if(INTERSECT) return;
				
				else if(Point.distance(arraySpinal[i], spinalCheckPoint) < 100 && Point.distance(arraySpinal[arraySpinal.length - 1], carPos) < 1200) {
					
					INTERSECT = true;
					addBridge();
					break inter;
				}
			}
		}
		
		private function addBridge():void {
			
			obstacleRot = Math.atan2((arrayInside[0].y - arrayOutside[0].y), (arrayInside[0].x - arrayOutside[0].x));
			
			powerUp = itemsPool.getNext().getComponent(PowerUps) as PowerUps;
			powerUp.init(10);
			powerUp.node.transform.rotation = obstacleRot;
			powerUp.node.transform.setPosition(arraySpinal[arraySpinal.length - 1].x, arraySpinal[arraySpinal.length - 1].y);
			theRoad.addChild(powerUp.node);
			arrayItems.push(powerUp);
			TweenLite.delayedCall(1, resetIntersect);
		}
		
		private function resetIntersect():void { INTERSECT = false }		
		
		private function createQuad():void {
			
			shape = GNodeFactory.createNodeWithComponent(GSimpleShape) as GSimpleShape;
			shape.setTexture(texture);
			
			shape.blendMode = 1;
			shape.node.transform.alpha = .9;
			
			vertices = new <Number>[arrayInside[0].x, arrayInside[0].y, arrayOutside[0].x, arrayOutside[0].y, arrayOutside[1].x, arrayOutside[1].y,
									arrayOutside[1].x, arrayOutside[1].y,arrayInside[1].x, arrayInside[1].y, arrayInside[0].x, arrayInside[0].y];
			
			// Initialize texture coordinates
			uvs = new <Number>[1,1,0,1,0,0,
							   0,0,1,0,1,1];
			
			// Initialize shape with our vertices and coords
			shape.init(vertices, uvs);
			theRoad.addChild(shape.node);
			theRoad.putChildToBack(shape.node);
			
			spinalPoint = Point.interpolate(arrayInside[0],arrayOutside[1], .5);
			arraySpinal.push(spinalPoint);
			
			arrayTiles.push(shape);
			arrayOutside.splice(0,1);
			arrayInside.splice(0,1);
			
			if(GAMEMODE == "PLAY") {
				
				if(fuelBar.node.transform.scaleX <= 1) {
					theCar.wings.node.active = false;
					fl_TimerRoad.stop();
					fl_TimerCloud.stop();
					fl_TimerSuper.stop();
					GAMEMODE = "NOFUEL";
					SkyRacer.MAIN.SM.playSound("../sounds/CANRUN.mp3");
				}
				else fuelBar.node.transform.scaleX -= 1;
			}
			
		}
		
		private function fn_TimerCloud(evt:TimerEvent):void
		{
			seconds++;
			
			if(seconds % 12 == 0 && !ONPOWERUP) {
				
				scaleFactor = .5 + Math.ceil(Math.random() * 5) / 10;
				camera.zoom = scaleFactor;
				gap = 150 * (2 - scaleFactor) + 30 * (3 - scaleFactor);
			}
			
			if(seconds % 10 == 0) createPowerUp(0);
			
			if(seconds % 3 == 0 && seconds % 10 != 0 && !ONPOWERUP) createPowerUp(Math.ceil(Math.random() * generatePowerUpRatio));
			
			generateCloud();
			
			if(arrayCloud.length > 5) {
				
				TweenLite.to(arrayCloud[0].node.transform, 1, {alpha:0, onComplete:arrayCloud[0].disposeMe});
				arrayCloud.splice(0,1);
			}
			
			//LEVEL CHECKER
			if(seconds == 30) {
				
				generateRoadRatio = 6;
				generatePowerUpRatio = 4;
				randomRatio = .6;
				(theCar.node.getComponent(RotateToMouse) as RotateToMouse).maxSpeed += .05;
				currentSpeed = (theCar.node.getComponent(RotateToMouse) as RotateToMouse).maxSpeed;
			}
			
			if(seconds == 90) {
				
				randomRatio = .7;
				(theCar.node.getComponent(RotateToMouse) as RotateToMouse).maxSpeed += .05;
				currentSpeed = (theCar.node.getComponent(RotateToMouse) as RotateToMouse).maxSpeed;
			}
			
			if(seconds == 120) {
				
				randomRatio = .8;
				(theCar.node.getComponent(RotateToMouse) as RotateToMouse).maxSpeed += .05;
				currentSpeed = (theCar.node.getComponent(RotateToMouse) as RotateToMouse).maxSpeed;
			}
		}
	
		private function fn_TimerSuper(evt:TimerEvent):void
		{
			if(POWERUPTYPE == 4) updateScore(10);
			if(fl_TimerSuper.currentCount == fl_TimerSuper.repeatCount - 1) {
				if(POWERUPTYPE == 2) {
					
					TweenMax.to(theCar.wings.node.transform, .2, {alpha:0, repeat:5, onComplete:setAlphaBack});
					theCar.wings.frames = ["wings_03","wings_02","wings_01","wings_00"];
					theCar.wings.play();
				}
			}
		}
		
		private function setAlphaBack():void { theCar.wings.node.transform.alpha = 1 }
		
		private function fn_TimerSuperComplete(evt:TimerEvent):void
		{
			if(POWERUPTYPE == 1) {
				(theCar.node.getComponent(RotateToMouse) as RotateToMouse).maxSpeed = currentSpeed;
			}
			else if(POWERUPTYPE == 2) {
				
				wings = false;
				theCar.wings.node.active = false;
				TweenLite.to(theCar.node.transform, .5, {scaleX:1, scaleY:1});
				theCar.theCar.gotoFrame(0);
				theCar.wings.frames = ["wings_00","wings_01","wings_02","wings_03"];
				SkyRacer.MAIN.SM.stopSound("../sounds/JET.mp3");
				SkyRacer.MAIN.SM.playSound("../sounds/CARRUN.mp3", 0, -1);
			}
			else if(POWERUPTYPE == 4) {
				
				(theCar.node.getComponent(RotateToMouse) as RotateToMouse).DRIFTING = false;
				(theCar.node.getComponent(RotateToMouse) as RotateToMouse).speed = .2;
				scaleFactor = .6;
				camera.zoom = scaleFactor;
				gap = 150 * (2 - scaleFactor) + 30 * (3 - scaleFactor);
			}
			
			ONPOWERUP = false;
			POWERUPTYPE == 0;
			
			fl_TimerSuper.stop();
			fl_TimerSuper.reset();
		}
		
		//*************************************************** POWER UPS ***************************************************//
		
		private function createPowerUp(type:int):void {
			
			powerUp = itemsPool.getNext().getComponent(PowerUps) as PowerUps;
			powerUp.init(type);
			
			powerUp.node.transform.setPosition(arraySpinal[arraySpinal.length - 1].x, arraySpinal[arraySpinal.length - 1].y);
			theRoad.addChild(powerUp.node);
			arrayItems.push(powerUp);
		}
		
		//*************************************************** BLOCKS ***************************************************//
		
		private function addBlock():void {
			
			obstacleRot = Math.atan2((arrayInside[arrayInside.length-1].y - arrayOutside[arrayOutside.length-1].y),(arrayInside[arrayInside.length-1].x - arrayOutside[arrayOutside.length-1].x));

			for(var i:int=arrayBlock.length-1; i>=0; i--) {
				
				obstacle = obstaclePool.getNext().getComponent(Obstacles) as Obstacles;
				obstacle.init(Math.ceil(Math.random() * 3));
				obstacle.node.transform.rotation = obstacleRot;
				obstacle.node.transform.setPosition(arrayPoints[arrayPoints.length - arrayBlock[i]].x, arrayPoints[arrayPoints.length - arrayBlock[i]].y);
				
				theRoad.addChild(obstacle.node);
				obstacle.node.transform.visible = false;
				arrayObstacles.push(obstacle);
			}
		}
		
		private function addPit():void {
			
			obstacleRot = Math.atan2((arrayInside[arrayInside.length-1].y - arrayOutside[arrayOutside.length-1].y),(arrayInside[arrayInside.length-1].x - arrayOutside[arrayOutside.length-1].x));

			for(var i:int=arrayBlock.length-1; i>=0; i--) {
				
				if(i == arrayBlock.length-1) {
					obstacle = obstaclePool.getNext().getComponent(Obstacles) as Obstacles;
					obstacle.init(0);
					obstacle.node.transform.rotation = obstacleRot;
					obstacle.node.transform.setPosition(arrayPoints[arrayPoints.length - arrayBlock[i]].x, arrayPoints[arrayPoints.length - arrayBlock[i]].y);
				}
				else {
					obstacle = obstaclePool.getNext().getComponent(Obstacles) as Obstacles;
					obstacle.init(1);
					obstacle.node.transform.rotation = obstacleRot;
					obstacle.node.transform.setPosition(arrayPoints[arrayPoints.length - arrayBlock[i]].x, arrayPoints[arrayPoints.length - arrayBlock[i]].y);
				}
				
				theRoad.addChild(obstacle.node);
				obstacle.node.transform.visible = false;
				arrayObstacles.push(obstacle);
			}
		}
		
		//*************************************************** COLLISIONS ***************************************************//
		
		private function checkOnRoad():void
		{
			offRoad = false;
			
			for(var o:int=arraySpinal.length-1; o>=0; o--) {
				
				if (Point.distance(carPos, arraySpinal[o]) < middleTexture * 1.1) offRoad = true;
			}
			
			if(offRoad == false) {
				
				if((theCar.node.getComponent(RotateToMouse) as RotateToMouse).ONJUMP) {
					theCar.theCar.node.active = true;
					theCar.theCarJump.node.active = false;
				}
				stopAfterCrash();
				SkyRacer.MAIN.SM.stopSound("../sounds/CARRUN.mp3");
				SkyRacer.MAIN.SM.playSound("../sounds/SCREAM.mp3");
				GAMEMODE = "GAMEOVER";
				theCar.gameOver();
				
				roadWorld.putChildToBack(theCar.node);
			}
			
		}
		
		//*************************************************** OBSTACLES ***************************************************//
		
		private function checkObstacles():void {
			
			for (var i:int=arrayObstacles.length-1; i>=0; i--)
			{
				obstaclePoint = new Point(arrayObstacles[i].node.transform.x, arrayObstacles[i].node.transform.y);
				
				if(Point.distance(arraySpinal[arraySpinal.length - 1], obstaclePoint) < 150) arrayObstacles[i].node.transform.visible = true;
					
				if(Point.distance(carPos, obstaclePoint) < 60 && !wings && arrayObstacles[i].node.transform.visible == true &&
					Point.distance(carPos, obstaclePoint) > 40 && !wings && arrayObstacles[i].node.transform.visible == true) {
					
					if(arrayObstacles[i].obstacleType == 0) {
						
						jump = true;
						theCar.jump();
						updateScore(10);
						break;
					}
				}
				else if(Point.distance(carPos, obstaclePoint) < 30 && !wings && arrayObstacles[i].node.transform.visible == true) {
					
					if(arrayObstacles[i].obstacleType == 1 && !jump) {
						
						stopAfterCrash();
						arrayObstacles[i].node.transform.alpha = .8;
						theCar.gameOver();
						roadWorld.putChildToBack(theCar.node);
						GAMEMODE = "GAMEOVER";
						SkyRacer.MAIN.SM.stopSound("../sounds/CARRUN.mp3");
						SkyRacer.MAIN.SM.playSound("../sounds/SCREAM.mp3");
					}
					
					else if(arrayObstacles[i].obstacleType == 2) {
						
						SkyRacer.MAIN.SM.playSound("../sounds/OBSTACLEHIT.mp3");
						SkyRacer.MAIN.SM.stopSound("../sounds/CARRUN.mp3");
						stopAfterCrash();
						createParticleObstacle(obstaclePoint.x, obstaclePoint.y);
						(theCar.node.getComponent(RotateToMouse) as RotateToMouse).maxSpeed = .2;
						arrayObstacles[i].container.setTexture(Assets.allTexture[0].getTexture("obstacle_2b"));
						theCar.node.transform.rotation += .2;
						GAMEMODE = "NOFUEL";
					}
					
					else if(arrayObstacles[i].obstacleType == 3) {
						
						TweenLite.to(arrayObstacles[i].node.transform, .5, {alpha:.3}); 
						arrayObstacles[i].container.setTexture(Assets.allTexture[0].getTexture("obstacle_3b"));
						TweenLite.to(arrayObstacles[i].node.transform, 1, {alpha:1});
						arrayObstacles[i].node.transform.setScale(1.2,1.2);
						
						if(Math.random() > .5) theCar.node.transform.rotation -= .09;
						
						else theCar.node.transform.rotation += .09;
						
						arrayObstacles[i].node.transform.rotation = theCar.node.transform.rotation + theCar.theCar.node.transform.rotation;
					}
					
				}
			}
		}
		
		private function stopAfterCrash():void {
			
			roadWorld.addChild(carEmitter.node);
			carEmitter.node.transform.setPosition(carPos.x, carPos.y);
			carEmitter.emit = true;
			
			fl_TimerRoad.stop();
			fl_TimerCloud.stop();
			fl_TimerSuper.stop();
		}
		
		//*************************************************** POWER UP CHECK ***************************************************//
		
		private function checkPowerUp():void
		{
			for (var i:int=arrayItems.length-1; i>=0; i--)
			{
				itemsPoint = new Point(arrayItems[i].node.transform.x, arrayItems[i].node.transform.y);
				
				if(Point.distance(carPos, itemsPoint) < 80) {
					
					if(arrayItems[i].powerUpType == 0) {
						
						createParticle(carPos.x, carPos.y, 0xFF0000);
						fuelBar.node.transform.scaleX += STAGEWIDTH * .4;
						if(fuelBar.node.transform.scaleX > STAGEWIDTH - 20) fuelBar.node.transform.scaleX = STAGEWIDTH - 20;
						arrayItems[i].disposeMe();
						arrayItems.splice(i,1);
						SkyRacer.MAIN.SM.playSound("../sounds/PICKUP.mp3");
						
					}
					
					else if(arrayItems[i].powerUpType == 1 && !jump) {
						
						createParticle(carPos.x, carPos.y, 0x1E90FF);
						(theCar.node.getComponent(RotateToMouse) as RotateToMouse).maxSpeed += .1;
						scaleFactor = .6;
						camera.zoom = scaleFactor;
						gap = 150 * (2 - scaleFactor) + 30 * (3 - scaleFactor);
						ONPOWERUP = true;
						POWERUPTYPE = arrayItems[i].powerUpType;
						fl_TimerSuper.repeatCount = 15;
						fl_TimerSuper.start();
						arrayItems[i].disposeMe();
						arrayItems.splice(i,1);
						SkyRacer.MAIN.SM.playSound("../sounds/PICKUP.mp3");
					}
					
					else if(arrayItems[i].powerUpType == 2 && !jump) {
						
						createParticle(carPos.x, carPos.y, 0x5A308B);
						wings = true;
						theCar.wings.node.active = true;
						theCar.wings.play();
						TweenLite.to(theCar.node.transform, .5, {scaleX:1.1, scaleY:1.1});
						theCar.theCar.gotoFrame(1);
						SkyRacer.MAIN.SM.stopSound("../sounds/CARRUN.mp3");
						SkyRacer.MAIN.SM.playSound("../sounds/JET.mp3", 0, -1);
						ONPOWERUP = true;
						POWERUPTYPE = arrayItems[i].powerUpType;
						fl_TimerSuper.repeatCount = 10;
						fl_TimerSuper.start();
						arrayItems[i].disposeMe();
						arrayItems.splice(i,1);
						SkyRacer.MAIN.SM.playSound("../sounds/PICKUP.mp3");
					}
					
					else if(arrayItems[i].powerUpType == 3) {
						
						createParticle(carPos.x, carPos.y, 0x00FF7F); 
						money += 5;
						moneyIntText.text = money.toString();
						arrayItems[i].disposeMe();
						arrayItems.splice(i,1);
						SkyRacer.MAIN.SM.playSound("../sounds/PICKUP.mp3");
					}
					
					else if(arrayItems[i].powerUpType == 4 && !jump) {
						
						createParticle(carPos.x, carPos.y, 0x000000);
						(theCar.node.getComponent(RotateToMouse) as RotateToMouse).startDrift(carPos.x, carPos.y);
						ONPOWERUP = true;
						for (var o:int=arrayObstacles.length-1; o>=0; o--)
						{
							arrayObstacles[o].disposeMe();
							arrayObstacles.splice(o,1);
						}
						scaleFactor = 1;
						camera.zoom = scaleFactor;
						gap = 150 * (2 - scaleFactor) + 30 * (3 - scaleFactor);
						POWERUPTYPE = arrayItems[i].powerUpType;
						fl_TimerSuper.repeatCount = 60;
						fl_TimerSuper.start();
						arrayItems[i].disposeMe();
						arrayItems.splice(i,1);
						SkyRacer.MAIN.SM.playSound("../sounds/PICKUP.mp3");
					}
					
					updateScore(100);
				}
				
				if(Point.distance(carPos, itemsPoint) < 150 && Point.distance(carPos, itemsPoint) > 80) {
					
					if(arrayItems[i].powerUpType == 10 && !jump) {
						
						jump = true;
						theCar.jump();
					}
				}
				
				if(Point.distance(arraySpinal[0], itemsPoint) == 0) {
					
					arrayItems[0].disposeMe();
					arrayItems.splice(0,1);
				}
			}
		}
		
		private function updateScore(score:int):void {
			
			scorePoints += score;
			TheScoreUpText.text = scorePoints.toString();
		}
		
		//*************************************************** EMITTER ***************************************************//
		
		private function initTheEmitter():void {
			
			itemEmitter = GNodeFactory.createNodeWithComponent(GSimpleEmitter) as GSimpleEmitter;
			itemEmitter.setTexture(particleTexture);
			itemEmitter.emit = false;
			itemEmitter.emission = 15;
			itemEmitter.energy = 1;
			itemEmitter.initialVelocity = 100;
			itemEmitter.initialVelocityVariance = 30;
			itemEmitter.dispersionAngleVariance = 2 * Math.PI;
			itemEmitter.initialScale = .8;
			itemEmitter.initialScaleVariance = .25;
			itemEmitter.endScale = 2;
			itemEmitter.initialAlpha = .2;
			
			carEmitter = GNodeFactory.createNodeWithComponent(GSimpleEmitter) as GSimpleEmitter;
			carEmitter.setTexture(particleTexture2);
			carEmitter.emit = false;
			carEmitter.emission = 15;
			carEmitter.emissionVariance = 0;
			carEmitter.energy = 2;
			carEmitter.energyVariance = 0;
			carEmitter.dispersionAngle = -1.8;
			carEmitter.dispersionAngleVariance = 0.54;
			carEmitter.dispersionXVariance = 2;
			carEmitter.dispersionYVariance = -2;
			carEmitter.initialScale = .5;
			carEmitter.endScale = 2.5;
			carEmitter.initialScaleVariance = 0.25;
			carEmitter.endScaleVariance = 0.25;
			carEmitter.initialVelocity = 98;
			carEmitter.initialVelocityVariance = 10;
			carEmitter.initialAcceleration = 0;
			carEmitter.initialAccelerationVariance = 0;
			carEmitter.initialAngle = 0;
			carEmitter.initialAngleVariance = 3.14;
			carEmitter.initialColor = 0xFFFFFF;
			carEmitter.endColor = 0x000000;
			carEmitter.initialAlpha = 1;
			carEmitter.initialAlphaVariance = 0;
			carEmitter.endAlpha = .9;
			carEmitter.endAlphaVariance = .5;
			carEmitter.initialRed = 1.06;
			carEmitter.initialRedVariance = 0;
			carEmitter.endGreen = 0;
			carEmitter.endGreenVariance = 0;
			carEmitter.initialBlue = 1;
			carEmitter.initialBlueVariance = 0;
			carEmitter.endBlue = 0;
			carEmitter.endBlueVariance = 0;
					
		}
		
		protected function createParticle(p_x:int, p_y:int, color:int):void {
			
			itemEmitter.node.transform.setPosition(p_x,p_y);
			itemEmitter.initialColor = color;
			itemEmitter.endColor = color;
			itemEmitter.emit = true;
			theRoad.addChild(itemEmitter.node);
			
			itemEmitter.forceBurst();
		}
		
		protected function createParticleObstacle(p_x:int, p_y:int):void {
			
			itemEmitter.node.transform.setPosition(p_x,p_y);
			itemEmitter.setTexture(particleTextureTower);
			itemEmitter.initialColor = 0xFFFFFF;
			itemEmitter.endColor = 0xFFFFFF;
			itemEmitter.emit = true;
			theRoad.addChild(itemEmitter.node);
			
			itemEmitter.forceBurst();
		}
		
		//*************************************************** GENERATE ROAD	***************************************************//
		
		private function generateRoad(type:int):void
		{
			switch (type) {
				
				case -3:
					curveTypeLeft = 19;
					curveTypeRight = 19;
					lineType = 5;
					leftCurve(nextRotation - startingRotation, curveTypeLeft);
					rightCurve(nextRotation - startingRotation, curveTypeRight);
					line(nextRotation + 90, lineType);
					break;
				case -2 :
					curveTypeLeft = randomRange(7, 12);
					curveTypeRight = randomRange(11, 17);
					lineType = randomRange(10, 15);
					leftCurve(nextRotation - startingRotation, curveTypeLeft);
					rightCurve(nextRotation - startingRotation, curveTypeRight);
					curveTypeLeft = randomRange(13, 18);
					curveTypeRight = randomRange(9, 12);
					leftCurve(nextRotation - startingRotation, curveTypeLeft);
					rightCurve(nextRotation - startingRotation, curveTypeRight);
					line(nextRotation + 90, lineType);
					break;
				case -1 :
					curveTypeLeft = 15;
					curveTypeRight = 15;
					lineType = randomRange(5, 7);
					leftCurve(nextRotation - startingRotation, curveTypeLeft);
					rightCurve(nextRotation - startingRotation, curveTypeRight);
					line(nextRotation + 90, lineType);
					break;
				case 0 :
					curveTypeLeft = 2;
					curveTypeRight = 20;
					lineType = randomRange(5, 10);
					leftCurve(nextRotation - startingRotation, curveTypeLeft);
					rightCurve(nextRotation - startingRotation, curveTypeRight);
					line(nextRotation + 90, lineType);
					break;
				case 1 :
					curveTypeLeft = randomRange(10, 19);
					curveTypeRight = randomRange(5, 15);
					lineType = randomRange(10, 20);
					leftCurve(nextRotation - startingRotation, curveTypeLeft);
					rightCurve(nextRotation - startingRotation, curveTypeRight);
					line(nextRotation + 90, lineType);
					if(Math.random() < randomRatio) {
						arrayBlock = [16,17,18,19,20,21,22,23,24,26];
						addPit();
					}
					break;
				case 2 :
					curveTypeLeft = randomRange(8, 10);
					curveTypeRight = randomRange(10, 15);
					lineType = randomRange(20, 35);
					
					leftCurve(nextRotation - startingRotation, curveTypeLeft);
					rightCurve(nextRotation - startingRotation, curveTypeRight);
					line(nextRotation + 90, lineType);
					if(lineType > 25) {
						arrayBlock = NumberGenerator.makeSequence(randomRange(150,300), randomRange(10,30), randomRange(3,7));
						addBlock();
					}
					break;
				case 3 :
					curveTypeLeft = 19;
					curveTypeRight = 19;
					lineType = 20;
					leftCurve(nextRotation - startingRotation, curveTypeLeft);
					rightCurve(nextRotation - startingRotation, curveTypeRight);
					line(nextRotation + 90, lineType);
					if(Math.random() < randomRatio) {
						arrayBlock = NumberGenerator.makeSequence(randomRange(150,250), randomRange(10,30), randomRange(3,7));
						addBlock();
					}
					break;
				case 4 :
					curveTypeLeft = randomRange(15, 20);
					curveTypeRight = randomRange(10, 15);
					lineType = randomRange(10, 15);
					leftCurve(nextRotation - startingRotation, curveTypeLeft);
					rightCurve(nextRotation - startingRotation, curveTypeRight);
					curveTypeLeft = randomRange(5, 25);
					if(curveTypeLeft > 18) curveTypeRight = 5;
					else curveTypeRight = randomRange(5, 15);
					lineType = randomRange(10, 15);
					leftCurve(nextRotation - startingRotation, curveTypeLeft);
					rightCurve(nextRotation - startingRotation, curveTypeRight);
					line(nextRotation + 90, lineType);
					if(Math.random() < randomRatio) {
						arrayBlock = [6,19,20,28,30];
						addPit();
					}
					break;
				case 5 :
					curveTypeLeft = randomRange(7, 12);
					curveTypeRight = randomRange(11, 17);
					lineType = randomRange(10, 15);
					leftCurve(nextRotation - startingRotation, curveTypeLeft);
					rightCurve(nextRotation - startingRotation, curveTypeRight);
					curveTypeLeft = randomRange(13, 19);
					curveTypeRight = randomRange(9, 12);
					leftCurve(nextRotation - startingRotation, curveTypeLeft);
					rightCurve(nextRotation - startingRotation, curveTypeRight);
					line(nextRotation + 90, lineType);
					if(Math.random() < randomRatio) {
						arrayBlock = [10,11,30];
						addBlock();
					}
					break;
				case 6 :
					curveTypeLeft = 15;
					curveTypeRight = 15;
					lineType = randomRange(10, 15);
					leftCurve(nextRotation - startingRotation, curveTypeLeft);
					rightCurve(nextRotation - startingRotation, curveTypeRight);
					leftCurve(nextRotation - startingRotation, curveTypeLeft);
					rightCurve(nextRotation - startingRotation, curveTypeRight);
					line(nextRotation + 90, lineType);
					if(Math.random() < randomRatio) {
						arrayBlock = [13,14,15,16,17,18,19,20,21,23];
						addPit();
					}
					break;
			}
			
			curveTypeLeftTot += curveTypeLeft;
			curveTypeRightTot += curveTypeRight;
			
		}
		
		private function randomRange(min:Number, max:Number):Number
		{
			return Math.floor(Math.random() * (max - min) + min);
		}
		
		private function line(rot:Number, slice:int):void
		{
			innerRadius = Point.distance(arrayRot[arrayRot.length - 1],arrayInside[arrayInside.length - 1]);
			outerRadius = Point.distance(arrayRot[arrayRot.length - 1],arrayOutside[arrayOutside.length - 1]);
			
			for (var i:int=0; i<slice; i++)
			{
				dxRotation = Math.cos(Math.PI * rot / 180);
				dyRotation = Math.sin(Math.PI * rot / 180);
				// add Tile
				roadTileInside = new Point();
				roadTileInside.x = arrayInside[arrayInside.length - 1].x + dxRotation * outerRadius;
				roadTileInside.y = arrayInside[arrayInside.length - 1].y + dyRotation * outerRadius;
				
				roadTileOuside = new Point();
				roadTileOuside.x = arrayOutside[arrayOutside.length - 1].x + dxRotation * outerRadius;
				roadTileOuside.y = arrayOutside[arrayOutside.length - 1].y + dyRotation * outerRadius;
				
				rotationPoint = new Point();
				rotationPoint.x = arrayRot[arrayRot.length - 1].x + dxRotation * outerRadius;
				rotationPoint.y = arrayRot[arrayRot.length - 1].y + dyRotation * outerRadius;
				arrayRot.push(rotationPoint);
				
				arrayInside.push(roadTileInside);
				arrayOutside.push(roadTileOuside);
				
				var increase:Number = 0.3;
				
				for (var X:int=3; X>0; X--)
				{
					pt = Point.interpolate(arrayInside[arrayInside.length - 1],arrayOutside[arrayOutside.length - 1], increase);
					tilePoint = new Point();
					tilePoint.x = pt.x;
					tilePoint.y = pt.y;
					arrayPoints.push(tilePoint);
					increase +=  0.2;
				}
			}
			
		}
		
		private function rightCurve(rot:Number, slice:int):void
		{
			innerRadius = Point.distance(arrayRot[arrayRot.length - 1], arrayInside[arrayInside.length - 1]);
			outerRadius = Point.distance(arrayRot[arrayRot.length - 1], arrayOutside[arrayOutside.length - 1]);
			
			for (var i:int=0; i<slice; i++)
			{
				dxRotation = Math.cos(Math.PI * rot / 180);
				dyRotation = Math.sin(Math.PI * rot / 180);
				
				roadTileInside = new Point();
				roadTileInside.x = arrayRot[arrayRot.length - 1].x + dxRotation * innerRadius;
				roadTileInside.y = arrayRot[arrayRot.length - 1].y + dyRotation * innerRadius;
				
				roadTileOuside = new Point();
				roadTileOuside.x = arrayRot[arrayRot.length - 1].x + dxRotation * outerRadius;
				roadTileOuside.y = arrayRot[arrayRot.length - 1].y + dyRotation * outerRadius;
				
				arrayInside.push(roadTileInside);
				arrayOutside.push(roadTileOuside);
				
				var increase:Number = 0.3;
				
				for (var X:int=3; X>0; X--)
				{
					pt = Point.interpolate(arrayInside[arrayInside.length - 1],arrayOutside[arrayOutside.length - 1],increase);
					tilePoint = new Point();
					tilePoint.x = pt.x;
					tilePoint.y = pt.y;
					arrayPoints.push(tilePoint);
					increase +=  0.2;
				}
				
				rot +=  angleRot;
			}
			
			findNextPoint(rot - angleRot, innerRadius + outerRadius);
		}
		
		private function findNextPoint(rot:Number, rad:Number):void
		{
			
			rotationPoint = new Point();
			dxRotation = Math.cos(Math.PI * rot / 180);
			dyRotation = Math.sin(Math.PI * rot / 180);
			rotationPoint.x = arrayRot[arrayRot.length - 1].x + dxRotation * rad;
			rotationPoint.y = arrayRot[arrayRot.length - 1].y + dyRotation * rad;
			
			arrayRot.push(rotationPoint);
			
			nextRotation = rot;
		}
		
		private function leftCurve(rot:Number, slice:int):void
		{
			innerRadius = Point.distance(arrayRot[arrayRot.length - 1], arrayInside[arrayInside.length - 1]);
			outerRadius = Point.distance(arrayRot[arrayRot.length - 1], arrayOutside[arrayOutside.length - 1]);
			
			for (var i:int=0; i<slice; i++)
			{
				dxRotation = Math.cos(Math.PI * rot / 180);
				dyRotation = Math.sin(Math.PI * rot / 180);
				
				roadTileInside = new Point();
				roadTileInside.x = arrayRot[arrayRot.length - 1].x + dxRotation * innerRadius;
				roadTileInside.y = arrayRot[arrayRot.length - 1].y + dyRotation * innerRadius;
				
				roadTileOuside = new Point();
				roadTileOuside.x = arrayRot[arrayRot.length - 1].x + dxRotation * outerRadius;
				roadTileOuside.y = arrayRot[arrayRot.length - 1].y + dyRotation * outerRadius;
				
				arrayInside.push(roadTileInside);
				arrayOutside.push(roadTileOuside);
				
				var increase:Number = 0.3;
				
				for (var X:int=3; X>0; X--)
				{
					pt = Point.interpolate(arrayInside[arrayInside.length - 1],arrayOutside[arrayOutside.length - 1], increase);
					tilePoint = new Point();
					tilePoint.x = pt.x;
					tilePoint.y = pt.y;
					arrayPoints.push(tilePoint);
					increase +=  0.2;
				}
				
				rot -=  angleRot;
			}
			
			findNextPoint(rot + angleRot, innerRadius + outerRadius);
		}
		
		//*************************************************** GAMEOVER	***************************************************//
		
		private function gameOver(state:String):void {
			
			if(!SkyRacer.MAIN.MUTE) SkyRacer.MAIN.SM.setVolume(0, "../sounds/MAIN.mp3");
			GAMEOVERSTATE = state;
			gameOverScreen = GNodeFactory.createNodeWithComponent(GameOver) as GameOver;
			gameOverScreen.setTheScore(scoreDistance, scorePoints, money);
			Genome2D.getInstance().root.addChild(gameOverScreen.node);
			gameOverScreen.node.cameraGroup = 2;
			if(GAMEOVERSTATE == "PIT") {
				theCar.node.dispose();
				carEmitter.dispersionAngleVariance = 2 * Math.PI;
				carEmitter.forceBurst();
			}
			fuelTexture.dispose();
			brakeBtn.bgTexture.dispose();
			gui.disposeChildren();
			gui.dispose();
			
		}
		
		public function backToMain():void {
			
			carEmitter.dispose();
			if(GAMEOVERSTATE == "NOFUEL") theCar.node.dispose();
			theRoad.disposeChildren();
			theRoad.dispose();
			roadWorld.disposeChildren();
			roadWorld.dispose();
			camera.node.dispose();
			camera2.node.dispose();
			
			fl_TimerRoad.removeEventListener(TimerEvent.TIMER, fn_TimerRoad);
			fl_TimerCloud.removeEventListener(TimerEvent.TIMER, fn_TimerCloud);
			fl_TimerSuper.removeEventListener(TimerEvent.TIMER_COMPLETE, fn_TimerSuperComplete);
			this.node.core.stage.removeEventListener(events.NavigationEvent.GAME_STATE, gameState);
			
		}
		
	}
}