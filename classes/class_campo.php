<?php
namespace raiz;
error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Campos{
	function __construct( ){

		require_once("classes/class_db.php");
		require_once("classes/globais.php");
		$this->con = new db();
		$this->con->conecta();

		$this->globais = new Globais();

	}

	function BuscarValoresCampo ($valor_default_campo, $idcampo=""){
				if ($idcampo)
				{
    				switch ($idcampo){


								case( $this->globais->SYS_DEPARA_CAMPOS["Tecnologias_candidato_domina"] ):
								case( $this->globais->SYS_DEPARA_CAMPOS["Tecnologias_vaga_pede"] ):
								case( $this->globais->SYS_DEPARA_CAMPOS["Tecnologias_do_teste"] ):
								case( $this->globais->SYS_DEPARA_CAMPOS["Skills_mandatorias_vaga"] ):
                    $this->con->executa( "select * from configuracoes.tecnologias WHERE id IN ( $valor_default_campo ) ");
                    while ($this->con->navega(0)){
                        $retorno[  $this->con->dados["id"]  ] =  $this->con->dados["tecnologia"] ;
                    }
                    return implode(", ",$retorno);
                break;


								default:
										return $valor_default_campo;
            }
					}


            switch ($valor_default_campo){

							case("{usuarios_avaliadores_tecnologias}"):

									$this->con->executa( "select u.id, u.nome
																				from usuarios_avaliadores_tecnologias uat
																					inner join usuarios u ON (u.id = uat.idusuario)");
									while ($this->con->navega(0)){
											$retorno[  $this->con->dados["id"]  ] =  $this->con->dados["nome"] ;
									}
									return  $retorno;
							break;

							case("{configuracoes.tecnologias}"):

									$this->con->executa( "select * from configuracoes.tecnologias");
									while ($this->con->navega(0)){
											$retorno[  $this->con->dados["id"]  ] =  $this->con->dados["tecnologia"] ;
									}
									return  $retorno;
							break;

							case("{public.atores}"):

									$this->con->executa( "select * from public.atores " );
									while ($this->con->navega(0)){
											$retorno[  $this->con->dados["id"]  ] =  $this->con->dados["ator"] ;
									}
									return  $retorno;
							break;

							default:
								$retorno[0] = "Não Implementado ($valor_default_campo)";
							return $retorno;
            }


	}

	function PosSavenoCampo($campo, $valor, $json, $idposto)
	{
		$this->workflow = new Workflow();

			switch ($campo){
				case( $this->globais->SYS_DEPARA_CAMPOS["SalvarAvaliadordoTeste"] ):
 					//echo "\n Pós save especifico do $campo";
					//echo "\n idworkflowtramitacao: ". $json[processo][idworkflowtramitacao_original];

					$json[$this->globais->SYS_DEPARA_CAMPOS["Responsavel"]][valor] = $valor;
					$json[$this->globais->SYS_DEPARA_CAMPOS["Responsavel"]][idtramitacao] = $json[processo][idworkflowtramitacao_original];

					$this->workflow->AssociarRegistronoPosto($json,$idposto);
				break;
			}
	}


	function getCampos(){

//		$this->con->executa( "select id, campo from postos_campo");
		$this->con->executa( "select id, campo from workflow_campos");
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
