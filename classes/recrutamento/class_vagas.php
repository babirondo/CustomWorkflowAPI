<?php
namespace raiz;
error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Vagas{

	function __construct( ){

		require_once("classes/class_db.php");
		$this->con = new db();
		$this->con->conecta();

		require_once("classes/globais.php");
    $this->globais = new Globais();

		require_once("classes/class_processos.php");
		$this->processo = new Processos();

		require_once("classes/class_campo.php");
		$this->campo = new Campos();

		require_once("classes/class_workflow.php");
		$this->workflow = new Workflow(  );

		require_once("classes/class_processos.php");
		$this->processos = new Processos(  );

		require_once("classes/class_postos.php");
		$this->postos = new Postos(  );


	}




	function CandidatosAplicadosAVaga ( $app, $idvaga, $jsonRAW  ){
		$json = json_decode( $jsonRAW, true );
		IF ($json == NULL) {
			$data = array("data"=>

					array(	"resultado" =>  "ERRO",
							"erro" => "JSON zuado - $jsonRAW" )
			);


			$app->render ('default.php',$data,500);
			return false;
		}
/*
		//ECHO "<PRE>";var_dump($json);

		$sql ="select * ,wc.id idcampo
					from postos_campo_lista pcl
						inner join workflow_campos wc ON (wc.id = pcl.idpostocampo)
						left join workflow_dados w ON (w.idpostocampo = wc.id)
					where pcl.idposto = ".$json[IDPOSTO]."
					and w.idprocesso IN (
									select id
									from processos
									where idpai = $idvaga  and relacionadoa is not null
					   )" ;
		//echo $sql;
		$this->con->executa($sql);

		while ($this->con->navega(0)){

			$array["FETCH"][$this->con->dados["idprocesso"] ][$this->con->dados["administrativo"]] = $this->campo->BuscarValoresCampo (  $this->con->dados["valor"] ,  $this->con->dados["idcampo"] );
			$array["TITULO"] [$this->con->dados["administrativo"]] = $this->con->dados["campo"];

		}

		$novo = $this->postos->AcoesdoPosto($json[IDPOSTO]);
		$array = $this->globais->ArrayMergeKeepKeys($array, $novo);



*/

	  $array = $this->postos->BuscarDadosdoFilhoePai($json[IDPOSTO], $idvaga, null, $listar = "Lista", null);

		//var_dump($array);

		$array["resultado"] = "SUCESSO";

		$data =  	$array;

		$app->render ('default.php',$data,200);
	}



	function ConsiderarCandidatosAVaga ( $app, $idvaga, $jsonRAW  ){
		$json = json_decode( $jsonRAW, true );
		IF ($json == NULL) {
			$data = array("data"=>

					array(	"resultado" =>  "ERRO",
							"erro" => "JSON zuado - $jsonRAW" )
			);


			$app->render ('default.php',$data,500);
			return false;
		}

		$json_base[processo][valor] =  $json["processo"];
		$json_base[processo][acao] = $this->globais->SYS_DEPARA_CAMPOS["bt_handover"];

		foreach ($json["candidatos_selecionados"] as $candidato){

			$json_base[206]["idpostocampo"]  = 206;
			$json_base[206]["valor"]  = $candidato;

			$json_base[205]["idpostocampo"]  = 205;
			$json_base[205]["valor"]  = $json["processo"];

			echo "\n  Salvando - vaga ".$json["processo"]." | candidato = ".$candidato;
			$idprocesso = $this->workflow->SalvarnoBanco(  $json_base , $json["idposto"], "Salvando", null);

			$this->processos->VincularProcessos($idprocesso, $candidato);


		}




		$array["resultado"] = "SUCESSO";
		$data =  	$array;
		$app->render ('default.php',$data,200);
	}


	function CandidatosDaVaga ($app , $idvaga  ){

		  $dadosProcesso = $this->processo->CarregarDadosdoProcesso( $idvaga);
			//FIXME: Array de retorno hard coded, fazer ficar dinamico


			//echo $dadosProcesso["212"];
			//echo "<pre>";var_dump($dadosProcesso);
			$array["DADOS_PROCESSO"]["PROCESSO"] = $idvaga;


			$array["DADOS_PROCESSO"]["TECNOLOGIAS_MANDATORIAS"] = $dadosProcesso["FETCH"][$idvaga][ $this->globais->SYS_DEPARA_CAMPOS["Tecnologias_vaga_pede"] ];
			$array["DADOS_PROCESSO"]["ID_TECNOLOGIAS_MANDATORIAS"] = $dadosProcesso["FETCH"][$idvaga][$this->globais->SYS_DEPARA_CAMPOS["Tecnologias_vaga_pede"]."-original"];
			$skills_desejadas = $array["DADOS_PROCESSO"]["ID_TECNOLOGIAS_MANDATORIAS"];

			// localiza candidatos que possuam as skills desejadas
			$sql =  "SELECT idprocesso
			FROM (
				select  regexp_split_to_array(w.valor, ',')  candidato ,  *

				from workflow_dados w
					inner join processos p ON (p.id = w.idprocesso and p.idtipoprocesso =2 )
					inner join workflow_campos wc ON (wc.id = w.idpostocampo and wc.administrativo = 'skills') ) massa
			where candidato && regexp_split_to_array('$skills_desejadas', ',')";
			//&& intersecao
			//@> contains
			//echo $sql;
			$this->con->executa($sql);

			while ($this->con->navega(0)){

				$array["CANDIDATOS"][$this->con->dados["idprocesso"] ] = $this->con->dados["idprocesso"];
			}


			$array["resultado"] = "SUCESSO";

			$data =  	$array;

			$app->render ('default.php',$data,200);
	}


		function ListarCandidatosDaVaga ( $app, $jsonRAW  ){
			$json = json_decode( $jsonRAW, true );
			IF ($json == NULL) {
				$data = array("data"=>

						array(	"resultado" =>  "ERRO",
								"erro" => "JSON zuado - $jsonRAW" )
				);


				$app->render ('default.php',$data,500);
				return false;
			}

			$dadosProcesso = $this->processo->CarregarDadosdoProcesso( $json[IDVAGA]);
			//FIXME: Array de retorno hard coded, fazer ficar dinamico
			$array["DADOS_PROCESSO"]["TECNOLOGIAS_MANDATORIAS"] = $dadosProcesso["FETCH"][$json[IDVAGA]][ $this->globais->SYS_DEPARA_CAMPOS["Tecnologias_vaga_pede"] ];
			$skills_desejadas = $dadosProcesso["FETCH"][$json[IDVAGA]][ $this->globais->SYS_DEPARA_CAMPOS["Tecnologias_vaga_pede"] ];
			//$array = null;

			//ECHO "<PRE>";var_dump($json);
			//ECHO "<PRE>";var_dump($array["FETCH"]);


			$sql ="select *,wc.id idcampo, ap.proprio idprocesso
						from arvore_processo ap
							inner join workflow_dados w ON ( w.idprocesso IN (ap.proprio, ap.avo, ap.filho, ap.bisavo , ap.neto) )
							INNER JOIN workflow_campos wc ON ( wc.id = w.idpostocampo)
							INNER JOIN postos_campo_lista pcl ON (pcl.idpostocampo = wc.id)

						where pcl.idposto = ".$json[IDPOSTO]." and ap.proprio IN (".implode("," ,$json[ "CANDIDATOS"] ).");";
			//echo $sql;
			$this->con->executa($sql);

			while ($this->con->navega(0)){

				$array["FETCH"][$this->con->dados["idprocesso"] ][$this->con->dados["idcampo"]] = $this->campo->BuscarValoresCampo (  $this->con->dados["valor"] ,  $this->con->dados["idcampo"] );
				$array["TITULO"] [$this->con->dados["idcampo"]]   = $this->con->dados["campo"];

				if ( $this->con->dados["idpostocampo"] ==  $this->globais->SYS_DEPARA_CAMPOS["Tecnologias_candidato_domina"]  )
				{
					// checa match de skills
					$retorno_match = $this->match($skills_desejadas, $array["FETCH"][$this->con->dados["idprocesso"] ][$this->con->dados["idcampo"]]  );
					$array["FETCH"][$this->con->dados["idprocesso"] ]["match"] = $retorno_match;
				}

			}
			$array["CONFIGURACOES"] [CV]   = $this->globais->SYS_DEPARA_CAMPOS["CV"];
			//ECHO "<PRE>";var_dump($array["FETCH"]);


			$array["resultado"] = "SUCESSO";

			$data =  	$array;

			$app->render ('default.php',$data,200);
		}


		function match ( $skills_vaga, $skills_candidato){

			//echo $skills_vaga;

				$skills_candidato = explode(", ",  $skills_candidato) ;
				$skills_vaga = explode(", ",  $skills_vaga) ;
				$tem = 0;


				foreach ($skills_vaga as $skill)
				{

						//echo "\n $skill, $skills_candidato";
					if ( in_array(   $skill, $skills_candidato) )
						$tem++;
				}

				return (($tem*100)/COUNT($skills_vaga));

		}

}
