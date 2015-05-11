package 
{
	import flash.display.MovieClip;	
	import flash.display.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.geom.*
	/**
	 * ...
	 * @author Erivan Franklin
	 */
	public class IATiro extends MovieClip 
	{
		static const ESTADO_INICIAR:int = 10;
		static const ESTADO_JUGAR:int = 20;
		static var estadoDeJuego:int = 0;
		static const enemigoVelocidadDeGiro:Number = 0.25;
		static const enemigoVelocidad:Point = new Point(0,0);
		static var enemigoAngulo:Number = 0.0;
		static var enemigoPosicion:Point = new Point(275,200);
		static var jugadorPosicion:Point;
		static var enemigo:mc_Enemigo;
		static var jugador:mc_jugador;
		static var enemigoRotacionEnRadianes:Number;
		
		public function IATiro() {
			
			enemigo = new mc_Enemigo();
			jugador = new mc_jugador();
			enemigo.x = enemigoPosicion.x;
			enemigo.y = enemigoPosicion.y;
			enemigo.rotation = 0;
			addEventListener(Event.ENTER_FRAME,cicloDelJuego);
			estadoDeJuego = ESTADO_INICIAR;			
			
		}		
		
		public function cicloDelJuego(e:Event):void
		{
			switch (estadoDeJuego)
			{
				case ESTADO_INICIAR :
					inicializarIA();
					break;
				case ESTADO_JUGAR :
					iniciaIA();
					break;
			}
		}
		public function inicializarIA():void
		{
			addChild(enemigo);
			addChild(jugador);
			jugador.startDrag(true,new Rectangle(0,0,550 - jugador.width,400 - jugador.height));
			estadoDeJuego = ESTADO_JUGAR;
		}
		public function iniciaIA():void
		{
			jugadorPosicion = new Point(jugador.x,jugador.y);// Posição personagen
			enemigoPosicion = new Point(enemigo.x,enemigo.y);// Seria minha posição do tiro
			enemigoRotacionEnRadianes = enemigo.rotation * Math.PI / 180;// Recebe a rotação do tiro 
			trace(enemigoRotacionEnRadianes);
			enemigoVelocidad.x = Math.cos(enemigoRotacionEnRadianes); // Velocidade em x de acordo com a rotação
			enemigoVelocidad.y = Math.sin(enemigoRotacionEnRadianes); // Velocidade em y de acordo com a rotação
			enemigo.x +=  enemigoVelocidad.x; // Tiro recebe a velocidade de cos de x
			enemigo.y +=  enemigoVelocidad.y; // Tiro recebe a velocidade de sen de y
			enemigo.rotation = ((buscarEntidad(enemigoPosicion, jugadorPosicion, enemigoRotacionEnRadianes, enemigoVelocidadDeGiro) * 180) / Math.PI);
			// Função pra rotacionar o inimigo 
			seSalio();
		}
		public function buscarEntidad(posicion:Point,buscaEsto:Point,anguloActual:Number,velocidadDeGiro:Number):Number
		{
			var puntoLocal:Point = buscaEsto.subtract(posicion);
			var anguloDeseado:Number = Math.atan2(puntoLocal.y,puntoLocal.x);
			var diferencia:Number = restringirAngulo((anguloDeseado - anguloActual));
			diferencia = restringirNumero(diferencia, -  velocidadDeGiro,velocidadDeGiro);
			return restringirAngulo((anguloActual + diferencia));
		}
		public function seSalio():void
		{
			if (enemigo.x < 0 || enemigo.x > 400)
			{
				enemigo.rotation = ((buscarEntidad(enemigoPosicion,jugadorPosicion,enemigoRotacionEnRadianes,enemigoVelocidadDeGiro) * 180) / Math.PI);
			}
			if (enemigo.y < 0 || enemigo.y > 550)
			{
				enemigo.rotation = ((buscarEntidad(enemigoPosicion,jugadorPosicion,enemigoRotacionEnRadianes,enemigoVelocidadDeGiro) * 180) / Math.PI);
			}
		}
		public function restringirNumero(numero:Number,bajo:Number,alto:Number):Number
		{
			return Math.max(bajo,Math.min(numero,alto));
		}
		public function restringirAngulo(radianes:Number):Number
		{
			while ((radianes <  -  Math.PI))
			{
				radianes +=  Math.PI * 2;
			}
			while ((radianes > Math.PI))
			{
				radianes -=  Math.PI * 2;
			}
			return radianes;
		}
	}	
}