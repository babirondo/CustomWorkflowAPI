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

	function BuscarValoresCampo ($valor_default_campo, $globais_conf=""){

            switch ($globais_conf){
                case( $this->globais->SYS_DEPARA_CAMPOS["Tecnologias_do_teste"] ):

                    $this->con->executa( "select * from configuracoes.tecnologias WHERE id IN ( $valor_default_campo ) ");
                    while ($this->con->navega(0)){
                        $retorno[  $this->con->dados["id"]  ] =  $this->con->dados["tecnologia"] ;
                    }
                    return implode(",",$retorno);
                break;
            }


            switch ($valor_default_campo){
                case("{configuracoes.tecnologias}"):

                    $this->con->executa( "select * from configuracoes.tecnologias");
                    while ($this->con->navega(0)){
                        $retorno[  $this->con->dados["id"]  ] =  $this->con->dados["tecnologia"] ;
                    }
                    return  $retorno;
                break;
            }


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
