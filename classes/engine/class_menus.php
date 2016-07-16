<?php
namespace raiz;
set_time_limit(2);
//error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Menus{
	function __construct( ){

		require_once("classes/class_db.php");
		require_once("classes/globais.php");

		$this->con = new db();
		$this->con->conecta();

		$this->globais = new GLobais();

	}

		function getSubMenus($app , $idmenu, $jsonRAW){
			$json = json_decode( $jsonRAW, true );
			IF ($json == NULL) {
				$data = array("data"=>

						array(	"resultado" =>  "ERRO",
								"erro" => "JSON zuado - $jsonRAW" )
				);


				$app->render ('default.php',$data,500);
				return false;
			}
//var_dump($json);exit;
			$this->con->executa( "Select m.* , f.lista
														from menus m
															inner join eng_features f ON (f.id = m.irpara)
														where m.idpai = $idmenu", null, __LINE__);


			while ($this->con->navega(0)){
				$array["FETCH"][$this->con->dados["irpara"]]["menu"]  = $this->con->dados["menu"];
				$array["FETCH"][$this->con->dados["irpara"]]["irpara"]  = $this->con->dados["irpara"];
				$array["FETCH"][$this->con->dados["irpara"]]["tipodestino"]  = $this->con->dados["tipo_destino"];
				$array["FETCH"][$this->con->dados["irpara"]]["lista"]  = $this->con->dados["lista"];
				$array["FETCH"][$this->con->dados["irpara"]]["idmenu"]  = $this->con->dados["id"];

			}

			$array["resultado"] = "SUCESSO";

			$data =  	$array;

			$app->render ('default.php',$data,200);


		}

	function getMenus($app ){

		$this->con->executa( "Select m.*
													from menus m

													where m.idpai is null", null, __LINE__);


		while ($this->con->navega(0)){
			$array["FETCH"][$this->con->dados["id"]]["menu"]  = $this->con->dados["menu"];
			$array["FETCH"][$this->con->dados["id"]]["irpara"]  = $this->con->dados["irpara"];
			$array["FETCH"][$this->con->dados["id"]]["tipodestino"]  = $this->con->dados["tipodestino"];
			$array["FETCH"][$this->con->dados["id"]]["idmenu"]  = $this->con->dados["id"];

		}

		$array["resultado"] = "SUCESSO";

		$data =  	$array;

		$app->render ('default.php',$data,200);


	}

}
