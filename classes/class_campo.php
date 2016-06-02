<?php
error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Campos{
	function Campos( ){

		require_once("classes/class_db.php");
		require_once("classes/globais.php");
		$this->con = new db();
		$this->con->conecta();

                $this->globais = new Globais();

	}

	function BuscarValoresCampo ($valor_default_campo){

		switch ($valor_default_campo){
			case("{configuracoes.tecnologias}"):

					$this->con->executa( "select * from configuracoes.tecnologias");
					while ($this->con->navega(0)){
						$retorno[  $this->con->dados["id"]  ] =  $this->con->dados["tecnologia"] ;
					}
			break;
		}

		return  $retorno;
	}


	function getCampos(){

		$this->con->executa( "select id, campo from postos_campo");
		//$this->con->navega();

		$i=0;
		while ($this->con->navega(0)){
			$campos[ strtolower(trim($this->con->dados["id"])) ] = strtolower(trim($this->con->dados["campo"]));

			$i++;
		}
                $campos = $this->globais->ArrayMergeKeepKeys( $this->globais->SYS_ADD_CAMPOS, $campos);
                //$campos[ "entradanoposto" ] = "entradanoposto";
                    //$array["FETCH"] [$this->con->dados["idprocesso"]]["entradanoposto" ]   =  $this->con->dados["wt_inicio"] ;

		return $campos;

	}
}
