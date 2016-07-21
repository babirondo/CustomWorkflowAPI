<?php
namespace raiz;
set_time_limit( 2 );
class UsuarioAtores{

	function __construct( ){

		require_once("classes/class_db.php");
		$this->con = new db();
		$this->con->conecta();

		require_once("classes/globais.php");
		$this->globais = new GLobais();

	}



	function Vincular($idusuario, $idatores)
	{
			foreach ($idatores as $idator){
				$sql = "INSERT INTO usuario_atores (idusuario, idator) values($idusuario, $idator)";
				$this->con->executa( $sql, 0, __LINE__  );
			}
			return true;
	}

}
