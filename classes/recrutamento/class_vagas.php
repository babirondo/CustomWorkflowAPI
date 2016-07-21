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

	}



	function CandidatosDaVaga ($app , $idvaga  ){

		  $dadosProcesso = $this->processo->CarregarDadosdoProcesso( $idvaga);
			//FIXME: Array de retorno hard coded, fazer ficar dinamico


			//echo $dadosProcesso["212"];
			//echo "<pre>";var_dump($dadosProcesso);
			$array["DADOS_PROCESSO"]["PROCESSO"] = $idvaga;


			$array["DADOS_PROCESSO"]["TECNOLOGIAS_MANDATORIAS"] = $dadosProcesso["FETCH"][$idvaga][ $this->globais->SYS_DEPARA_CAMPOS["Tecnologias_candidato_domina"] ];
			$array["DADOS_PROCESSO"]["ID_TECNOLOGIAS_MANDATORIAS"] = $dadosProcesso["FETCH"][$idvaga][$this->globais->SYS_DEPARA_CAMPOS["Tecnologias_candidato_domina"]."-original"];
			$skills_desejadas = $array["DADOS_PROCESSO"]["ID_TECNOLOGIAS_MANDATORIAS"];

			// localiza candidatos que possuam as skills desejadas
			$sql =  "SELECT idprocesso
			FROM (
				select  regexp_split_to_array(w.valor, ',')  candidato ,  *

				from workflow_dados w
					inner join processos p ON (p.id = w.idprocesso and p.idtipoprocesso =2 )
					inner join workflow_campos wc ON (wc.id = w.idpostocampo and wc.administrativo = 'skills') ) massa
			where candidato @> regexp_split_to_array('$skills_desejadas', ',')";
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

			//ECHO "<PRE>";var_dump($json);

			$sql ="select * ,wc.id idcampo
						from postos_campo_lista pcl
							inner join workflow_campos wc ON (wc.id = pcl.idpostocampo)
							left join workflow_dados w ON (w.idpostocampo = wc.id)
						where pcl.idposto = ".$json[IDPOSTO]." and w.idprocesso IN (".implode("," ,$json[ "CANDIDATOS"] ).");";
			//echo $sql;
			$this->con->executa($sql);

			while ($this->con->navega(0)){

				$array["FETCH"][$this->con->dados["idprocesso"] ][$this->con->dados["administrativo"]] = $this->campo->BuscarValoresCampo (  $this->con->dados["valor"] ,  $this->con->dados["idcampo"] );

			}



			$array["resultado"] = "SUCESSO";

			$data =  	$array;

			$app->render ('default.php',$data,200);
		}


}
