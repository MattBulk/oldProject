/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/16/13
 * Time: 2:25 PM
 * To change this template use File | Settings | File Templates.
 */
package tools {
import utils.*;

import flash.geom.Point;

public class RoadTrailGenerator {

    private var roadTileInside:Point;
    private var roadTileOutside:Point;
    private var arrayRot:Vector.<Point>;
    private var rotationPoint:Point;
    private var pt:Point = new Point(0,0);
    private var tilePoint:Point = new Point(0,0);

    private const angleRot:int = 10;

    private var innerRadius:Number;
    private var outerRadius:Number;
    private var nextRotation:Number;
    private var dxRotation:Number;
    private var dyRotation:Number;

    public var arrayInside:Vector.<Point>;
    public var arrayOutside:Vector.<Point>;
    public var arrayPoints:Vector.<Point>;

    public function initGenerator(typeArr:Array, radiusArr:Array, startLine:uint):void {

        arrayInside = new Vector.<Point>();
        arrayOutside = new Vector.<Point>();
        arrayRot = new Vector.<Point>();
        arrayPoints = new Vector.<Point>();

        const startingPoint:Point = new Point(0, 0);
        const finishingPoint:Point = new Point(350 * Settings.SCALE_FACTOR, 0);
        const rotationPoint:Point = new Point(450 * Settings.SCALE_FACTOR, 0);

        arrayRot.push(rotationPoint);
        arrayOutside.push(startingPoint);
        arrayInside.push(finishingPoint);

        const startingRotation:Number = 180;

        rightCurve(startingRotation, 1);
        line(nextRotation + 90, startLine);

        arrayOutside.splice(0,1);
        arrayInside.splice(0,1);

        for (var i:int = 0; i<=typeArr.length; i++)
        {

            switch (parseFloat(typeArr[i]))
            {

                case 0 :
                    line(nextRotation + 90, radiusArr[i]);
                    break;
                case 1 :
                    leftCurve(nextRotation - startingRotation, radiusArr[i]);
                    break;
                case 2 :
                    rightCurve(nextRotation - startingRotation, radiusArr[i]);
                    break;
            }
        }

    }

    //*************************************************** GENERATE ROAD	***************************************************//


    private function line(rot:Number, slice:int):void
    {
        innerRadius = Point.distance(arrayRot[arrayRot.length - 1], arrayInside[arrayInside.length - 1]);
        outerRadius = Point.distance(arrayRot[arrayRot.length - 1], arrayOutside[arrayOutside.length - 1]);

        for (var i:int=0; i<slice; i++)
        {
            dxRotation = Math.cos(Math.PI * rot / 180);
            dyRotation = Math.sin(Math.PI * rot / 180);
            // add Tile
            roadTileInside = new Point();
            roadTileInside.x = arrayInside[arrayInside.length - 1].x + dxRotation * outerRadius;
            roadTileInside.y = arrayInside[arrayInside.length - 1].y + dyRotation * outerRadius;

            roadTileOutside = new Point();
            roadTileOutside.x = arrayOutside[arrayOutside.length - 1].x + dxRotation * outerRadius;
            roadTileOutside.y = arrayOutside[arrayOutside.length - 1].y + dyRotation * outerRadius;

            rotationPoint = new Point();
            rotationPoint.x = arrayRot[arrayRot.length - 1].x + dxRotation * outerRadius;
            rotationPoint.y = arrayRot[arrayRot.length - 1].y + dyRotation * outerRadius;
            arrayRot.push(rotationPoint);

            arrayInside.push(roadTileInside);
            arrayOutside.push(roadTileOutside);

            var increase:Number = .3;

            for (var X:int=3; X>0; X--)
            {
                pt = Point.interpolate(arrayInside[arrayInside.length - 1], arrayOutside[arrayOutside.length - 1], increase);
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

            roadTileOutside = new Point();
            roadTileOutside.x = arrayRot[arrayRot.length - 1].x + dxRotation * outerRadius;
            roadTileOutside.y = arrayRot[arrayRot.length - 1].y + dyRotation * outerRadius;

            arrayInside.push(roadTileInside);
            arrayOutside.push(roadTileOutside);

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

            roadTileOutside = new Point();
            roadTileOutside.x = arrayRot[arrayRot.length - 1].x + dxRotation * outerRadius;
            roadTileOutside.y = arrayRot[arrayRot.length - 1].y + dyRotation * outerRadius;

            arrayInside.push(roadTileInside);
            arrayOutside.push(roadTileOutside);

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
}
}
