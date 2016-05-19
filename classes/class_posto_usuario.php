<?php
//error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Posto_Usuario{
	function Posto_Usuario( ){
		
		//require_once("classes/class_postos.php");
		//require_once("classes/class_campo.php");
		//require_once("classes/class_db.php");
		//require_once("classes/class_notificacoes.php");
		
		//$this->con = new db();
		//$this->con->conecta();		
	
		$this->workflow = new workflow();
	}
        
        function AssociarProcessonoPosto($app,  $jsonRAW, $idposto ){

            
       
            $this->workflow->SalvarnoBanco(  json_decode($jsonRAW, true), $idposto, "AssociarPosto", $app);
        }
	
        function DesassociarProcessonoPosto($app, $jsonRAW, $idposto ){
         // chamar o registrar   
            $array = $this->workflow->DesassociarRegistronoPosto( $jsonRAW, $idposto);
            
            $array["resultado"] = "SUCESSO";
            $data =  	$array;
            $app->render ('default.php',$data,200);

        }
       	
}