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
		
	//	echo "\n $idposto - ".$json[processo][valor];
		$id_pai = "null";
		 if ($idposto && $json[processo][valor] ) {
		 	$sql = "select tp.id
					from workflow_postos wp
					left  join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
					where wp.id  = $idposto";
		 //	echo "\n $sql";
		 	
			$this->con->executa($sql );
			$this->con->navega(0);
			$idtipoprocess_posto = 	$this->con->dados["id"];
		
		 	$sql = "select idtipoprocesso from processos where id = ".$json[processo][valor];
		 //	echo "\n $sql";
			$this->con->executa( $sql);
			$this->con->navega(0);
			$idtipoprocess_processo = 	$this->con->dados["idtipoprocesso"];
		
			//echo "\n $idtipoprocess_posto != $idtipoprocess_processo";
			
			if ( $idtipoprocess_posto != $idtipoprocess_processo){
				//$idprocesso =  $idtipoprocess_posto;//$json[processo][valor];
				
				$id_pai = $json[processo][valor];
				$json[processo][valor] = null;
			}
		 
				
		}
		
		
		
		if ( !$json[processo][valor]    )  {
 			 
 			$this->con->executa( "select tp.id idtipoprocesso
									from workflow_postos wp
										inner join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
									where wp.id = $idposto " );
 			$this->con->navega(0);
 			
 			$sql = "INSERT INTO  processos (idtipoprocesso, idpai, inicio)
										VALUES ( ".$this->con->dados["idtipoprocesso"]."   ,$id_pai, NOW() )
										RETURNING id ";
 			
 		//	echo "\n $sql";
			if (  $this->con->executa( $sql , 1 ) === false )
				$erro = 1;
			else{
				$idprocesso =  $this->con->dados["id"];		
			}
 		}
 				
		
				
 	    foreach ($json as $campo => $valor){
 	    	if ($campo == "processo") continue;
 	    	
 	    	if (!$this->con->executa( "INSERT INTO workflow_dados (idpostocampo, valor, idprocesso, registro) 
 	    						  VALUES ('$campo','$valor[valor]', $idprocesso, NOW()) "  ))
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