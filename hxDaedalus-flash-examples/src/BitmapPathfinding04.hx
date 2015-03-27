import hxDaedalus.ai.EntityAI;
import hxDaedalus.ai.PathFinder;
import hxDaedalus.ai.trajectory.LinearPathSampler;
import hxDaedalus.data.Mesh;
import hxDaedalus.data.Object;
import hxDaedalus.factories.BitmapObject;
import hxDaedalus.factories.RectMesh;
import hxDaedalus.view.SimpleView;
import flash.display.MovieClip;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.Lib;

@:bitmap("assets/galapagosBW.png")
class GalapagosBW extends flash.display.BitmapData {}

@:bitmap("assets/galapagosColor.png")
class GalapagosColor extends flash.display.BitmapData {}

class BitmapPathfinding04 extends Sprite{
	var mesh:  			Mesh;
	var view:  			SimpleView;
	var entityAI: 		EntityAI;
	var pathfinder:		PathFinder;
	var path: 			Array<Float>;
	var pathSampler: 	LinearPathSampler;
	var obj: 			Object;
	var bmp:			Bitmap;
	var overlay:		Bitmap;
    var newPath:		Bool = false;
	
	public static function main(): Void {
		Lib.current.addChild( new BitmapPathfinding04() );	
	}

	public function new(){
		super(); 
		// build a rectangular 2 polygons mesh
		mesh = RectMesh.buildRectangle( 1024, 780 );
		bmp = new Bitmap(new GalapagosBW(0, 0));// show the source bmp
		bmp.x = 0;
		bmp.y = 0;
        overlay = new Bitmap(new GalapagosColor(0, 0));	// show the image bmp
		overlay.x = 0;
		overlay.y = 0;
		addChild( overlay );
		var viewSprite = new Sprite();
		view = new SimpleView( viewSprite.graphics );
		addChild( viewSprite );
		var bd = bmp.bitmapData;
		obj = BitmapObject.buildFromBmpData( bd, 1.8 ); // create an object from bitmap
		obj.x = 0;
		obj.y = 0;
		var s = haxe.Timer.stamp();
		mesh.insertObject( obj );
		//trace("meshInsert: " + (haxe.Timer.stamp() - s));
		view.drawMesh( mesh ); // display result mesh
		overlay.bitmapData.draw( viewSprite ); // stamp it on the overlay bitmap
		entityAI = new EntityAI(); // we need an entity
		entityAI.radius = 4; // set radius size for your entity
		entityAI.x = 50; // set a position
		entityAI.y = 50; //
		view.drawEntity( entityAI, false ); // show entity on screen
		pathfinder = new PathFinder(); // now configure the pathfinder
		pathfinder.entity = entityAI; // set the entity
		pathfinder.mesh = mesh; // set the mesh
		path = new Array<Float>(); // we need a vector to store the path
		pathSampler = new LinearPathSampler(); // then configure the path sampler
		pathSampler.entity = entityAI;
		pathSampler.samplingDistance = 10;
		pathSampler.path = path;
		var s = Lib.current.stage;
		s.addEventListener( MouseEvent.MOUSE_DOWN, 	onMouseDown  );// click/drag
		s.addEventListener( MouseEvent.MOUSE_UP, 	onMouseUp 	 );
		s.addEventListener( Event.ENTER_FRAME, 		onEnterFrame );// animate
		s.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown	 );// key presses
	}
	
    function onMouseUp( event: MouseEvent ): Void {
		newPath = false;
    }
    
    function onMouseDown( event: MouseEvent ): Void {
        newPath = true;
    }
    
    function onEnterFrame( event: Event ): Void {
		if( newPath ){
			view.graphics.clear();
            pathfinder.findPath( stage.mouseX, stage.mouseY, path );// find path !
            view.drawPath( path );// show path on screen
            pathSampler.reset(); // reset the path sampler to manage new generated path
        }
        if( pathSampler.hasNext ) pathSampler.next(); // animate ! move entity  
		view.drawEntity( entityAI ); // show entity position on screen
    }
	
	function onKeyDown( event: KeyboardEvent ): Void {
		if( event.keyCode == 27 ) flash.system.System.exit( 1 ); // ESC
	}
	
}