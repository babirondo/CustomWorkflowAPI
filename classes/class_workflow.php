<?php
error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

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
			$i++;
		}
		
		$array["resultado"] = "SUCESSO";

		$data =  	$array;
		
		$app->render ('default.php',$data,200);
				
		
	}
	
	 
}