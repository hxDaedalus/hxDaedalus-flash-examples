import hxDaedalus.ai.EntityAI;
import hxDaedalus.ai.PathFinder;
import hxDaedalus.ai.trajectory.LinearPathSampler;
import hxDaedalus.data.Mesh;
import hxDaedalus.data.Object;
import hxDaedalus.data.math.Point2D;
import hxDaedalus.data.math.RandGenerator;
import hxDaedalus.factories.RectMesh;
import hxDaedalus.view.SimpleView;

import flash.Lib;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;

typedef UpDownEvent = flash.events.Event;

class Pathfinding03 extends Sprite {
    var mesh: 			Mesh;
    var view: 			SimpleView;
    var entityAI: 		EntityAI;
    var pathfinder: 	PathFinder;
    var path: 			Array<Float>;
    var pathSampler: 	LinearPathSampler;
    var newPath:		Bool = false;
	
    public static function main():Void {
		Lib.current.addChild( new Pathfinding03() );
	}
    
    public function new(){
        super();
        // build a rectangular 2 polygons mesh of 600x600
        mesh = RectMesh.buildRectangle( 600, 600 );
        Lib.current.addChild( this );
		// create a viewport
		var viewSprite = new Sprite();
        view = new SimpleView( viewSprite.graphics );
        addChild( viewSprite );
		var meshView = new SimpleView( graphics );
        // pseudo random generator
        var randGen : RandGenerator;
        randGen = new RandGenerator();
        randGen.seed = 7259;  // put a 4 digits number here  
        // populate mesh with many square objects
        var object : Object;
        var shapeCoords : Array<Float>;
        for( i in 0...50 ){
            object = new Object();
            shapeCoords = new Array<Float>();
            shapeCoords = 	[ -1, -1,  1, -1
							,  1, -1,  1,  1
							,  1,  1, -1,  1
							, -1,  1, -1, -1
							];
            object.coordinates = shapeCoords;
            randGen.rangeMin = 10;
            randGen.rangeMax = 40;
            object.scaleX = randGen.next();
            object.scaleY = randGen.next();
            randGen.rangeMin = 0;
            randGen.rangeMax = 1000;
            object.rotation = (randGen.next() / 1000) * Math.PI / 2;
            randGen.rangeMin = 50;
            randGen.rangeMax = 600;
            object.x = randGen.next();
            object.y = randGen.next();
            mesh.insertObject(object);
        }  // show result mesh on screen  
		meshView.drawMesh( mesh );
        // we need an entity
        entityAI = new EntityAI();
        // set radius as size for your entity
        entityAI.radius = 4;
        // set a position
        entityAI.x = 20;
        entityAI.y = 20;
        // show entity on screen
        view.drawEntity( entityAI );
        // now configure the pathfinder
        pathfinder = new PathFinder();
        pathfinder.entity = entityAI;  // set the entity  
        pathfinder.mesh = mesh;  // set the mesh  
        // we need a vector to store the path
        path = new Array<Float>();
        // then configure the path sampler
        pathSampler = new LinearPathSampler();
        pathSampler.entity = entityAI;
        pathSampler.samplingDistance = 10;
        pathSampler.path = path;
        var s = Lib.current.stage;	
        s.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);// click/drag
        s.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);	
        s.addEventListener(Event.ENTER_FRAME, onEnterFrame);// animate	
        s.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);// key presses
	}
	
    function onMouseUp( event: UpDownEvent ): Void {
		newPath = false;
    }
    
    function onMouseDown( event: UpDownEvent ): Void {
        newPath = true;
    }
    
    function onEnterFrame( event: Event ): Void {
        if( newPath ){
			view.graphics.clear();
			pathfinder.findPath( stage.mouseX, stage.mouseY, path ); // find path !
            view.drawPath( path );	 // show path on screen
            pathSampler.reset();	 // reset the path sampler to manage new generated path
        }
        if( pathSampler.hasNext ) pathSampler.next(); // animate ! move entity
		view.drawEntity( entityAI ); // show entity position on screen
    }
	
    function onKeyDown( event: KeyboardEvent ): Void {
        if( event.keyCode == 27 ) flash.system.System.exit(1); // ESC
    }
	
}
