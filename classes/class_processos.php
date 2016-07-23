<?php
namespace raiz;
error_reporting(E_ALL ^ E_DEPRECATED);

class Processos{

	function __construct( ){

    require_once("classes/class_db.php");
    require_once("classes/class_postos.php");

		$this->con = new db();
		$this->con->conecta();

    $this->postos = new Postos();

	}


	function VincularProcessos ($idprocesso, $candidato)
	{
		$sql = "UPDATE processos SET relacionadoa = $candidato where id = $idprocesso";
//		echo $sql;
    $this->con->executa( $sql);

		return true;
	}

	function CarregarDadosdoProcesso($idprocesso){
		$sql = "select proprio, filho, avo, bisavo, neto
            from arvore_processo
            where proprio =  $idprocesso  ";
    $this->con->executa( $sql);

    $this->con->navega(0);
    if ($this->con->dados["proprio"])
      $familia_processo[] = $this->con->dados["proprio"];
    if ($this->con->dados["filho"])
      $familia_processo[] = $this->con->dados["filho"];
    if ($this->con->dados["avo"])
      $familia_processo[] = $this->con->dados["avo"];
    if ($this->con->dados["bisavo"])
      $familia_processo[] = $this->con->dados["bisavo"];
    if ($this->con->dados["neto"])
      $familia_processo[] = $this->con->dados["neto"];


    $dados_processo = $this->postos->BuscarDadosdoFilhoePai(null, $idprocesso, null, "VidaProcesso", null);

/*
    $sql = "SELECT *
            FROM workflow_tramitacao wt
            WHERE wt.idprocesso IN (".implode(",",$familia_processo)." )   ORDER BY wt.inicio";
  //          echo  $sql;
    $this->con->executa( $sql);

    while ($this->con->navega(0)){
      $array["VIDA_PROCESSO"][$this->con->dados["idprocesso"]][$this->con->dados["id"]]["posto"] = $this->con->dados["idworkflowposto"];
      $array["VIDA_PROCESSO"][$this->con->dados["idprocesso"]][$this->con->dados["id"]]["inicio"] = $this->con->dados["inicio"];
      $array["VIDA_PROCESSO"][$this->con->dados["idprocesso"]][$this->con->dados["id"]]["fim"] = $this->con->dados["fim"];
      $array["VIDA_PROCESSO"][$this->con->dados["idprocesso"]][$this->con->dados["id"]]["id_usuario_associado"] = $this->con->dados["id_usuario_associado"];

    }
    $array = null;
		*/
		return $dados_processo;
	}


  function Vida_Processo($app, $idprocesso)
  {


    $array = $this->CarregarDadosdoProcesso($idprocesso);


    $array["resultado"] = "SUCESSO";

    $data =  	$array;

    $app->render ('default.php',$data,200);
  }

}
?>
