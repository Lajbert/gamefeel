package en;

class Bullet extends Entity {
	public static var ALL : Array<Bullet> = [];
	public var speed = 1.0;
	public var ang : Float;

	public function new(e:Entity, offY=0.) {
		super(0,0);
		setPosPixel(e.centerX, e.centerY+offY);
		ALL.push(this);

		hasCollisions = false;
		ang = e.dirToAng() + rnd(0,0.03,true);
		frict = 1;
		gravity = 0;
		radius = 2;
		hei = 0;

		var g = new h2d.Graphics(spr);
		g.beginFill(0xffcc00);
		g.drawRect(-3, -1, 6, 2);
	}

	override function dispose() {
		super.dispose();
		ALL.remove(this);
	}

	function onBulletHitWall(hitX:Float,hitY:Float) {
		if( options.bulletImpactFx )
			fx.hitWall( hitX, hitY, M.radDistance(ang,0)<=M.PIHALF ? -1 : 1 );
		destroy();
	}

	override function update() {
		dx = Math.cos(ang)*0.55*speed;
		dy = Math.sin(ang)*0.55*speed;

		super.update();

		dir = M.radDistance(ang,0)<=M.PIHALF ? 1 : -1;

		// Mobs
		for(e in Mob.ALL) {
			if( e.isAlive() && footX>=e.footX-e.radius && footX<=e.footX+e.radius && footY>=e.footY-e.hei && footY<=e.footY ) {
				e.hit(1, dir);
				if( options.bulletImpactFx ) {
					fx.hitEntity( e.centerX-dir*4, footY, -dir );
				}
				destroy();
			}
		}

		// Walls
		if( !level.isValid(cx,cy) || level.hasCollision(cx,cy) )
			onBulletHitWall(
				(cx+0.5)*Const.GRID - Math.cos(ang)*Const.GRID*0.5,
				(cy+0.5)*Const.GRID - Math.sin(ang)*Const.GRID*0.5
			);
	}
}