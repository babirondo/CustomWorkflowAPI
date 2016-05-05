<?php
error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Postos{
	function Postos( ){
		
		require("classes/class_db.php");
		$this->con = new db();
		$this->con->conecta();

	}
	
	function getPostos($app, $idworkflow ){
	 
		$this->con->executa( "Select * from workflow_postos WHere id_workflow = $idworkflow  ");
		//$this->con->navega();
		
		$i=0;
		while ($this->con->navega(0)){
			$array["FETCH"][$i]["posto"]  = $this->con->dados["posto"];
			$array["FETCH"][$i]["idposto"]  = $this->con->dados["id"];
			$array["FETCH"][$i]["lista"]  = $this->con->dados["lista"];
			$array["FETCH"][$i]["form"]  = $this->con->dados["form"];
			$i++;
		}
		
		$array["resultado"] = "SUCESSO";

		$data =  	$array;
		
		$app->render ('default.php',$data,200);
				
		
	}

	function getCampos($app, $idworkflow , $idposto ){
	
		$this->con->executa( "Select * from postos_campo WHere idposto = $idposto  ");
		//$this->con->navega();
	
		$i=0;
		while ($this->con->navega(0)){
			$array["FETCH"][$i]["campo"]  = $this->con->dados["campo"];
			$array["FETCH"][$i]["idcampo"]  = $this->con->dados["id"];
			$i++;
		}
	
		$array["resultado"] = "SUCESSO";
	
		$data =  	$array;
	
		$app->render ('default.php',$data,200);
	
	
	}
	

	function getLista($app,   $idposto ){
	
		$this->con->executa( "select pc.campo, w.valor, p.id processo
								from processos p
									inner join workflow_dados w ON (w.idprocesso = p.id)
									inner join postos_campo pc ON (pc.id = w.idpostocampo)
								where w.idpostocampo IN ( SELECT idpostocampo FROM  postos_campo_lista WHERE idposto = $idposto  ) ");
		//$this->con->navega();
	
		$i=0;
		while ($this->con->navega(0)){
			$array["FETCH"][$this->con->dados["processo"]][$this->con->dados["campo"] ]   = $this->con->dados["valor"];

			$array["TITULO"][$this->con->dados["campo"]]   = $this->con->dados["campo"];
				
			$i++;
		}
	
		$array["resultado"] = "SUCESSO";
	
		$data =  	$array;
	
		$app->render ('default.php',$data,200);
	
	
	}
	
}