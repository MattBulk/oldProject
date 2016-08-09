/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 11/14/13
 * Time: 5:31 PM
 * To change this template use File | Settings | File Templates.
 */
package utils {
import flash.geom.Point;

public class RoadGenerator {

    private var roadTileInside:Point;
    private var roadTileOutside:Point;
    private var arrayRot:Vector.<Point>;
    private var rotationPoint:Point;

    private const angleRot:int = 10;

    private var innerRadius:Number;
    private var outerRadius:Number;
    private var nextRotation:Number;
    private var dxRotation:Number;
    private var dyRotation:Number;

    public var arrayInside:Vector.<Point>;
    public var arrayOutside:Vector.<Point>;


    public function initGenerator(typeArr:Array, radiusArr:Array, startLine:uint):void {

        arrayInside = new Vector.<Point>();
        arrayOutside = new Vector.<Point>();
        arrayRot = new Vector.<Point>();

        const startingPoint:Point = new Point(0, 0);
        const finishingPoint:Point = new Point(35 * Settings.SCALE_FACTOR, 0);
        const rotationPoint:Point = new Point(45 * Settings.SCALE_FACTOR, 0);

        arrayRot.push(rotationPoint);
        arrayOutside.push(startingPoint);
        arrayInside.push(finishingPoint);

        const startingRotation:uint = 180;

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

    //*************************************************** GENERATE ROAD ***************************************************//

    private function line(rot:Number,slice:int):void
    {
        innerRadius = Point.distance(arrayRot[arrayRot.length - 1],arrayInside[arrayInside.length - 1]);
        outerRadius = Point.distance(arrayRot[arrayRot.length - 1],arrayOutside[arrayOutside.length - 1]);

        for (var i:int = 0; i < slice; i++)
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
        }

    }

    private function rightCurve(rot:Number,slice:int):void
    {
        innerRadius = Point.distance(arrayRot[arrayRot.length - 1], arrayInside[arrayInside.length - 1]);
        outerRadius = Point.distance(arrayRot[arrayRot.length - 1], arrayOutside[arrayOutside.length - 1]);

        for (var i:int = 0; i < slice; i++)
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

            rot +=  angleRot;
        }

        findNextPoint((rot - angleRot),innerRadius + outerRadius);
    }

    private function findNextPoint(rot:Number,rad:Number):void
    {

        rotationPoint = new Point();
        dxRotation = Math.cos(Math.PI * rot / 180);
        dyRotation = Math.sin(Math.PI * rot / 180);
        rotationPoint.x = arrayRot[arrayRot.length - 1].x + dxRotation * rad;
        rotationPoint.y = arrayRot[arrayRot.length - 1].y + dyRotation * rad;

        arrayRot.push(rotationPoint);

        nextRotation = rot;
    }

    private function leftCurve(rot:Number,slice:int):void
    {
        innerRadius = Point.distance(arrayRot[arrayRot.length - 1], arrayInside[arrayInside.length - 1]);
        outerRadius = Point.distance(arrayRot[arrayRot.length - 1], arrayOutside[arrayOutside.length - 1]);

        for (var i:int = 0; i < slice; i++)
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

            rot -=  angleRot;
        }

        findNextPoint((rot + angleRot),innerRadius + outerRadius);
    }
}
}
