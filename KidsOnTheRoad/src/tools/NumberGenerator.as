package tools
{
	public class NumberGenerator
	{
		public static function makeSequence(MAXLength:int, GAP:int, maxObject:int):Array
		{
			var baseNumber:Array = new Array();
			var randNumber:Array = new Array();
			var startNumber:int = 1;
			
			for(var i:int = startNumber; i<= MAXLength; i++) baseNumber[i] = i;
			
			baseNumber.splice(0,1);
			
			startNow:for(i= 0; i<= maxObject; i++) {
				
				var tempRandom:int = startNumber + GAP * (i - startNumber);
				
				if(tempRandom > MAXLength) break startNow;
				else randNumber.push(baseNumber[tempRandom]);																																											
			}
			
			for(i=0; i<randNumber.length; i++) if(randNumber[i] == undefined) randNumber.splice(i,1);
			
			randNumber.sort(Array.NUMERIC); //use this is array block is i++ form.
			
			return randNumber;	
		}
		
	}
}