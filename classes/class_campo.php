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

	function BuscarValoresCampo ($array, $idcampo=""){
				$valor_default_campo = $array["valor_default"];
				$idprocesso = $array["idprocesso"];

				if ($idcampo)
				{
    				switch ($idcampo){

								case( $this->globais->SYS_DEPARA_CAMPOS["ParecerTecnico1"] ):
								case( $this->globais->SYS_DEPARA_CAMPOS["ParecerTecnico2"] ):
										$idtramitacao = $array["idtramitacao"];

										$sql = "select wt.id_usuario_associado usuario_associado , u.nome usuario
														from workflow_tramitacao  wt
															LEFT JOIN usuarios u ON (u.id = wt.id_usuario_associado)
														WHERE wt.id = $idtramitacao";
										$this->con->executa($sql );
								//echo $sql;
										$this->con->navega(0);

										if ($this->con->dados["usuario"]){
											return  "Avaliador por: ".$this->con->dados["usuario"]."\n\n".$valor_default_campo ;
										}
										else{
											return  $valor_default_campo;
										}




								break;




								case( $this->globais->SYS_DEPARA_CAMPOS["Tecnologias_candidato_domina"] ):
								case( $this->globais->SYS_DEPARA_CAMPOS["Tecnologias_vaga_pede"] ):
								case( $this->globais->SYS_DEPARA_CAMPOS["Tecnologias_do_teste"] ):
								case( $this->globais->SYS_DEPARA_CAMPOS["Skills_mandatorias_vaga"] ):

										$sql = "select * from configuracoes.tecnologias WHERE id IN ( $valor_default_campo ) ";
                    $this->con->executa($sql );
//echo $sql;
										while ($this->con->navega(0)){
                        $retorno[  $this->con->dados["id"]  ] =  $this->con->dados["tecnologia"] ;
                    }
										if (is_array($retorno)){
													return implode(", ",$retorno);
										}
										else {
												return false;
										}
                break;


								default:
										return $valor_default_campo;
            }
					}


            switch ($valor_default_campo){

							case("{usuarios_avaliadores_tecnologias}"):


								$sql = "select wd.valor
												from arvore_processo ap
													inner join workflow_dados wd ON ( wd.idprocesso IN (ap.proprio, ap.avo, ap.filho, ap.bisavo ))
												where  proprio = $idprocesso and wd.idpostocampo = ". $this->globais->SYS_DEPARA_CAMPOS["Tecnologias_do_teste"];
									$this->con->executa( $sql );
									$this->con->navega(0);

									$tecnologias_do_teste =   $this->con->dados["valor"]  ;
									$sql = "select u.id, u.nome, (SELECT COUNT(*) FROM workflow_tramitacao WHERE id_usuario_associado = u.id and fim is null) as avaliando
																				from usuarios_avaliadores_tecnologias uat
																					inner join usuarios u ON (u.id = uat.idusuario)
																				where uat.idtecnologia IN (". $this->con->dados["valor"].") and u.email is not null
																				group by u.id, u.nome, avaliando ;";
									$this->con->executa( $sql );
									if ($this->con->nrw >0){
										while ($this->con->navega(0)){
												$retorno[  $this->con->dados["id"]  ] =  $this->con->dados["nome"] . " (Avaliando ".$this->con->dados["avaliando"]." testes)"  ;
										}

									}
									else{
											$retorno ["-1"] = "Nenhum avaliador disponível para esta tecnologia ($tecnologias_do_teste)";
									}
									return  $retorno;
							break;

							case("{configuracoes.tecnologias}"):

									$this->con->executa( "select * from configuracoes.tecnologias");
									while ($this->con->navega(0)){
											$retorno[  $this->con->dados["id"]  ] =  $this->con->dados["id"]."-".$this->con->dados["tecnologia"] ;
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
