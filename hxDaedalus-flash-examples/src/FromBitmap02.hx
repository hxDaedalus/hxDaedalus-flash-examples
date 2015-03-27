import hxDaedalus.data.Mesh;
import hxDaedalus.data.Object;
import hxDaedalus.factories.BitmapObject;
import hxDaedalus.factories.RectMesh;
import hxDaedalus.view.SimpleView;
import flash.Lib;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.BitmapData;
import flash.events.KeyboardEvent;
import flash.system.System;

@:bitmap("assets/FromBitmap.png")
class TestImage extends flash.display.BitmapData {}
	
class FromBitmap02 extends Sprite{
    var mesh: 	Mesh;
    var view: 	SimpleView;
    var obj: 	Object;
    var bmp: 	Bitmap;
    
    public static function main():Void {
        Lib.current.addChild( new FromBitmap02() );
    }
    
    public function new(){
        super();
        mesh = RectMesh.buildRectangle( 600, 600 );// build a rectangular 2 polygons mesh of 600x600
        bmp = new Bitmap( new TestImage( 0, 0 ) ); // show the source bmp
		bmp.x = 110;
        bmp.y = 220;
        addChild( bmp );
		var viewSprite = new Sprite();
        view = new SimpleView( viewSprite.graphics ); // create a viewport
        addChild( viewSprite );
        obj = BitmapObject.buildFromBmpData( bmp.bitmapData ); // create an object from bitmap
        obj.x = 110;
        obj.y = 220;
        mesh.insertObject( obj );
        view.drawMesh( mesh ); // display result mesh
        Lib.current.stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDown ); // key presses
    }
    
    function keyDown( event: KeyboardEvent ): Void {
        if( event.keyCode == 27 ) System.exit( 1 );	// ESC
    }
}