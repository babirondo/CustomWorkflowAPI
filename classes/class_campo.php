<?php
error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Campos{
	function Campos( ){
		
		require_once("classes/class_db.php");
		$this->con = new db();
		$this->con->conecta();

	}

	function getCampos(){
		
		$this->con->executa( "select id, campo from postos_campo");
		//$this->con->navega();
		
		$i=0;
		while ($this->con->navega(0)){
			$campos[ strtolower(trim($this->con->dados["id"])) ] = strtolower(trim($this->con->dados["campo"]));
			 
			$i++;
		}		
		return $campos;
		
	}	
}