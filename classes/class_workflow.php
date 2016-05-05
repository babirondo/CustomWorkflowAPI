<?php
//error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Workflow{
	function Workflow( ){
		
		require("classes/class_db.php");
		$this->con = new db();
		$this->con->conecta();

	}
	
	function getWorkflows($app ){
	 
		$this->con->executa( "Select * from workflow");
		//$this->con->navega();
		
		$i=0;
		while ($this->con->navega(0)){
			$array["FETCH"][$i]["workflow"]  = $this->con->dados["workflow"];
			$array["FETCH"][$i]["idworkflow"]  = $this->con->dados["id"];
			$array["FETCH"][$i]["postoinicial"]  = $this->con->dados["posto_inicial"];
			$i++;
		}
		
		$array["resultado"] = "SUCESSO";

		$data =  	$array;
		
		$app->render ('default.php',$data,200);
				
		
	}
	
 	function Registrar($app , $jsonRAW, $idposto){
 		$json = json_decode( $jsonRAW, true );
 		IF ($json == NULL) {
			$data = array("data"=>
	
					array(	"resultado" =>  "ERRO",
							"erro" => "JSON zuado - $jsonRAW" )
			);
	
	
			$app->render ('default.php',$data,500);
			return false;
		}	
		$erro = 0;
 		
		if (  $this->con->executa( "INSERT INTO  processos (numprocesso, idpai)
									VALUES ('zzz',null)
									RETURNING id ", 1 ) === false )
			$erro = 1;
		else{
			$idprocesso =  $this->con->dados["id"];		
		}

 	    foreach ($json as $campo => $valor){
 	    	if (!$this->con->executa( "INSERT INTO workflow_dados (idpostocampo, valor, idprocesso) 
 	    						  VALUES ('$campo','$valor[valor]', $idprocesso) "  ))
 	    		$erro++;
 	    }
		
		
		if ($erro == 0){
			//autenticado
				
			$data = array("data"=>
					array(	"resultado" =>  "SUCESSO",
							"IDPROCESSO" => $idprocesso
					)
			);
		}
		else {
			// nao encontrado
			$data = array("data"=>
		
					array(	"resultado" =>  "ERRO #$erro",
							"erro" => "Nao encontrado" )
			);
		}
		
		$app->render ('default.php',$data,200);		
		
	
	
	}
	
	 
	
}