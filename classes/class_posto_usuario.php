<?php
namespace raiz;
//error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Posto_Usuario{
	function __construct( ){

		//require_once("classes/class_postos.php");
		//require_once("classes/class_campo.php");
		//require_once("classes/class_db.php");
		//require_once("classes/class_notificacoes.php");

		//$this->con = new db();
		//$this->con->conecta();

		$this->workflow = new workflow();
	}

        function AssociarProcessonoPosto($app,  $jsonRAW, $idposto ){
//id_usuario_associado

            $array = $this->workflow->AssociarRegistronoPosto( $jsonRAW, $idposto);
        }

        function DesassociarProcessonoPosto($app, $jsonRAW, $idposto ){
         // chamar o registrar
            $array = $this->workflow->DesassociarRegistronoPosto( $jsonRAW, $idposto);

            $array["resultado"] = "SUCESSO";
            $data =  	$array;
            $app->render ('default.php',$data,200);

        }

}
