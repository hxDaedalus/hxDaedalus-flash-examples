import hxDaedalus.ai.EntityAI;
import hxDaedalus.ai.PathFinder;
import hxDaedalus.ai.trajectory.LinearPathSampler;
import hxDaedalus.data.ConstraintSegment;
import hxDaedalus.data.Edge;
import hxDaedalus.data.Mesh;
import hxDaedalus.data.Object;
import hxDaedalus.data.math.Point2D;
import hxDaedalus.data.math.RandGenerator;
import hxDaedalus.data.Vertex;
import hxDaedalus.factories.RectMesh;
import hxDaedalus.view.SimpleView;
import flash.Lib;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;


typedef UpDownEvent = MouseEvent;

class GridMaze05 extends Sprite {
    var mesh: 			Mesh;
    var view: 			SimpleView;
	var entityView:		SimpleView;
	var meshView:		SimpleView;
    var entityAI: 		EntityAI;
    var pathfinder: 	PathFinder;
    var path: 			Array<Float>;
    var pathSampler: 	LinearPathSampler;
    var newPath:		Bool = false;
	var rows:			Int = 15;
	var cols:			Int = 15;
    
    public static function main(): Void {
       Lib.current.addChild( new GridMaze05() );
    }
    
    public function new(){
       	super();
		// build a rectangular 2 polygons mesh of 600x600
        mesh = RectMesh.buildRectangle( 600, 600 );
		// create a viewport
		meshView = new SimpleView( graphics );
		var viewSprite = new Sprite();
        view = new SimpleView( viewSprite.graphics );
        addChild( viewSprite );
		var entitySprite = new Sprite();
		entityView = new SimpleView( entitySprite.graphics );
		addChild( entitySprite );
		GridMaze.generate( 600, 600, cols, rows );
		mesh.insertObject( GridMaze.object );
		var v = meshView;
		var rad = GridMaze.tileWidth * .3;
		v.constraintsWidth = 4;
        v.drawMesh( mesh );
        // we need an entity
        entityAI = new EntityAI();
        // set radius as size for your entity
        entityAI.radius = rad;
        // set a position
        entityAI.x = GridMaze.tileWidth / 2;
        entityAI.y = GridMaze.tileHeight / 2;
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
        pathSampler.samplingDistance = 12;
        pathSampler.path = path;
		var s = Lib.current.stage;
       	s.addEventListener( MouseEvent.MOUSE_DOWN, 	onMouseDown	 );	// click/drag
       	s.addEventListener( MouseEvent.MOUSE_UP, 	onMouseUp	 );
       	s.addEventListener( Event.ENTER_FRAME, 		onEnterFrame );	// animate
       	s.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown	 );	// key presses
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
			var mx = stage.mouseX;
			var my = stage.mouseY;	
            pathfinder.findPath( mx, my, path ); // find path !
            view.drawPath( path ); // show path on screen
            pathSampler.reset(); // reset the path sampler to manage new generated path
        }
        if( pathSampler.hasNext ) pathSampler.next(); // animate ! move entity
		entityView.drawEntity( entityAI, true ); // show entity position on screen
    }
    
    function onKeyDown( event: KeyboardEvent ): Void {
		var keyCode = event.keyCode;
        if( keyCode == 27 ){  // ESC
			flash.system.System.exit(1);
        }else if( keyCode == 32 ){ // SPACE
			reset( true );
		}else if( keyCode == 13 ){ // ENTER
			reset( false );
		}
    }
	
	function reset(newMaze:Bool = false):Void {
		var seed = Std.int( Math.random() * 10000 + 1000 );
		if( newMaze ){
			mesh = RectMesh.buildRectangle( 600, 600 );
			GridMaze.generate( 600, 600, 30, 30, seed );
			var mazeObj = GridMaze.object;
			mazeObj.scaleX = .92;
			mazeObj.scaleY = .92;
			mazeObj.x = 23;
			mazeObj.y = 23;
			mesh.insertObject( mazeObj );
		}
        entityAI.radius = GridMaze.tileWidth * .27;
		var v = meshView;
		v.drawMesh( mesh, true );
		pathfinder.mesh = mesh;
		entityAI.x = GridMaze.tileWidth / 2;
		entityAI.y = GridMaze.tileHeight / 2;
		entityView.graphics.clear();
		view.graphics.clear();
		path = [];
		pathSampler.path = path;
	}
}