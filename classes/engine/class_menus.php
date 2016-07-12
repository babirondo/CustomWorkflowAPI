<?php
set_time_limit(2);
//error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Menus{
	function Menus( ){

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
			$this->con->executa( "Select * from menus where idpai = $idmenu", null, __LINE__);

			$i=0;
			while ($this->con->navega(0)){
				$array["FETCH"][$i]["menu"]  = $this->con->dados["menu"];
				$array["FETCH"][$i]["irpara"]  = $this->con->dados["irpara"];
				$array["FETCH"][$i]["tipodestino"]  = $this->con->dados["tipo_destino"];
				$array["FETCH"][$i]["idmenu"]  = $this->con->dados["id"];
				$i++;
			}

			$array["resultado"] = "SUCESSO";

			$data =  	$array;

			$app->render ('default.php',$data,200);


		}

	function getMenus($app ){

		$this->con->executa( "Select * from menus where idpai is null", null, __LINE__);

		$i=0;
		while ($this->con->navega(0)){
			$array["FETCH"][$i]["menu"]  = $this->con->dados["menu"];
			$array["FETCH"][$i]["irpara"]  = $this->con->dados["irpara"];
			$array["FETCH"][$i]["tipodestino"]  = $this->con->dados["tipo_destino"];
			$array["FETCH"][$i]["idmenu"]  = $this->con->dados["id"];
			$i++;
		}

		$array["resultado"] = "SUCESSO";

		$data =  	$array;

		$app->render ('default.php',$data,200);


	}

}
