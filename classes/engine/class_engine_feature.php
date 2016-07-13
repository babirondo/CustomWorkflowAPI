<?php
namespace raiz;
error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Engine_Feature{
	function __construct( ){

		require_once("classes/class_db.php");
		include_once("classes/globais.php");
		require_once("classes/class_campo.php");

		$this->con = new db();
		$this->con->conecta();


    $this->globais = new Globais();
		$this->campo = new Campos();

	}

        function UsuariosdoPosto($app, $idfeature  ){
            $array = $this->getUsuarios($idfeature);

            $array["resultado"] = "SUCESSO";

            $data =  	$array;

            $app->render ('default.php',$data,200);
        }

	function getUsuarios($idfeature  ){

            $sql = "select ua.idusuario, ua.idator, wp.id idfeature, u.nome
                    from usuario_atores ua
                            INNER JOIN workflow_postos wp ON (wp.idator = ua.idator)
                            INNER JOIN usuarios u ON (u.id = ua.idusuario)
                    where wp.id= $idfeature and u.admin is null ";
         //   echo "\n\n\n".$sql;
            $this->con->executa( $sql);

            while ($this->con->navega(0)){
                $array["USUARIOS_POSTO"]
                        [$this->con->dados["idfeature"]]
                        [$this->con->dados["idusuario"]]   = $this->con->dados["nome"];
            }

            return $array;
	}


	function getUsuariosbyTecnologia($idtecnologia  ){

            $sql = "select u.id
                    from usuarios u
                           inner join usuarios_avaliadores_tecnologias uat ON (uat.idusuario = u.id)
                    where uat.idtecnologia =$idtecnologia ";
           // echo $sql;
            $this->con->executa( $sql);

            while ($this->con->navega(0)){
                $array["USUARIO_TECNOLOGIA"] [$idtecnologia][]    = $this->con->dados["id"];
            }

            return $array;
	}


	function getPostos($app, $idworkflow , $jsonRAW){
		$json = json_decode( $jsonRAW, true );
		IF ($json == NULL) {
			$data = array("data"=>

					array(	"resultado" =>  "ERRO",
							"erro" => "JSON zuado - $jsonRAW" )
			);


			$app->render ('default.php',$data,500);
			return false;
		}
		$sql = "Select wp.*
            from workflow_postos wp
                  inner join workflow wk ON (wk.id = wp.id_workflow)
                  left join   usuario_atores ua ON (ua.idator = wp.idator)
                  left join usuarios u ON (u.id = ua.idusuario)
            WHere (wp.id_workflow = $idworkflow and wp.principal = 1) and (u.id = ".$json[idusuario]."  OR wp.idator is null)
            ORDER BY ordem_cronologica ";
	//echo $sql;exit;
		$this->con->executa( $sql);
		//$this->con->navega();

		$i=0;
		while ($this->con->navega(0)){
			$array["FETCH"][$i]["posto"]  = $this->con->dados["posto"];
			$array["FETCH"][$i]["idfeature"]  = $this->con->dados["id"];
			$array["FETCH"][$i]["lista"]  = $this->con->dados["lista"];



			$i++;
		}

		$array["resultado"] = "SUCESSO";

		$data =  	$array;

		$app->render ('default.php',$data,200);

	}

	function BuscarDadosProcesso($idprocesso , $idfeature,  $debug = null, $listar="Lista", $posto, $jsonfiltros = null)
	{
      // buscando dados -> indexado por idprocesso
      $array_dopai = $this->BuscarDadosdoFilhoePai($idfeature, $idprocesso, $debug, $listar, $posto, $jsonfiltros);

      return $array_dopai;
	}

	function LoadCampos(  $idfeature , $jsonRAW  ){
					$json = json_decode( $jsonRAW, true );
					IF ($json == NULL) {
						$data = array("data"=>

								array(	"resultado" =>  "ERRO",
										"erro" => "JSON zuado - $jsonRAW" )
						);


						$app->render ('default.php',$data,500);
						return false;
					}
            if ($idfeature>0)
            {
                //buscando dados do posto
                $sql ="SELECT * FROM eng_features WHERE id = $idfeature  ";
                $this->con->executa($sql);

                $p=0;
                while ($this->con->navega($p)){

                    $array["DADOS_POSTO"] [nomefeature]  = $this->con->dados["feature"];
                    $p++;
                }

                $this->con->executa( "Select * from eng_feature_campo WHere idfeature = $idfeature  ");

                while ($this->con->navega(0)){
		                $array["FETCH_CAMPO"][$this->con->dados["id"]] ["obrigatorio"]  = $this->con->dados["obrigatorio"];
		                $array["FETCH_CAMPO"][$this->con->dados["id"]] ["maxlenght"]  = $this->con->dados["maxlenght"];
		                $array["FETCH_CAMPO"][$this->con->dados["id"]] ["inputtype"]  = $this->con->dados["inputtype"];
		                $array["FETCH_CAMPO"][$this->con->dados["id"]] ["dica_preenchimento"]  = $this->con->dados["dica_preenchimento"];

		                if ($this->globais->Traduzir( $this->con->dados["valor_default"] ) == false )
		                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["valor_default"]  =  $this->con->dados["valor_default"];
		                else {
		                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["valor_default"]  =  $this->campo->BuscarValoresCampo($this->con->dados["valor_default"]);
		                }
		                $array["FETCH_CAMPO"][$this->con->dados["id"]] ["txtarea_cols"]  = $this->con->dados["txtarea_cols"];
		                $array["FETCH_CAMPO"][$this->con->dados["id"]] ["txtarea_rows"]  = $this->con->dados["txtarea_rows"];
		                $array["FETCH_CAMPO"][$this->con->dados["id"]] ["campo"]  = $this->con->dados["campo"];
		                $array["FETCH_CAMPO"][$this->con->dados["id"]] ["idcampo"]  = $this->con->dados["id"];
		        		}
            }

            // buscando os registros do posto, direcionado pelo idprocesso
            $array_dados = $this->BuscarDadosProcesso($json[processo][valor] , $idfeature, $debug, $listar, $posto, $jsonfiltros);

						if (is_array($array_dados) && is_array($array) ){
							$array_completo =  array_replace_recursive($array_dados, $array);
						}
						else if (is_array($array_dados)   ){
							$array_completo =  $array_dados;
						}
						else if (is_array($array)   ){
							$array_completo =  $array;
						}

            $array_completo["resultado"] = "SUCESSO";

            return $array_completo;

	}


  function LoadCamposbyProcesso(  $idprocesso  ){

      $array = $this->LoadCampos( null, $idprocesso, null, null, null );
      return $array;

	}

	function getCampos($app, $idfeature , $jsonRAW ){
		$data = $this->LoadCampos($idfeature , $jsonRAW );
		$app->render ('default.php',$data,200);
	}

	function BuscarDadosdoFilhoePai($idfeature, $idprocesso=null, $debug=null, $listar = "Lista", $posto, $jsonfiltros= null)
	{
			$sql = "select ed.id idenginedado, efc.id idfeaturecampo, ed.valor, ed.idprocesso
							from eng_feature_campo efc
								inner join engine_dados ed ON (ed.idfeature = efc.idfeature and ed.idfeaturecampo = efc.id)
							where efc.idfeature = $idfeature and ed.idprocesso=$idprocesso;
							";
      $this->con->executa( $sql, 0, __LINE__  );
      //echo "\n SQL GERADO";
      $i=0;

      while ($this->con->navega($i) ){
				$array["FETCH_CAMPO"][$this->con->dados["idfeaturecampo"]][  "valor"]  = $this->con->dados["valor"];
				$array["FETCH_CAMPO"][$this->con->dados["idfeaturecampo"]][  "idworkflowdado"]  = $this->con->dados["idenginedado"];

         	$i++;
      }


			return $array;
	}



	function getLista($app,   $idfeature , $jsonRAW){


    	$debug= 0;
		//$array = $this->BuscarDadosdoFilhoePai($idfeature, null, $debug, "Lista"); // xxx

	    $array = $this->LoadCampos(  $idfeature, null, null, $debug ,  "Lista" , $jsonRAW);
	                //  var_dump($array );

			$this->con->executa( "select *
	                          from posto_acao pa
	                                  inner join workflow_postos wp ON (wp.id = pa.goto)
	                          where pa.idfeature =  $idfeature    ");
		//$this->con->navega();
			$i=0;
			while ($this->con->navega(0)){
				$array["ACOES"]  [$this->con->dados["id"] ][acao]   = $this->con->dados["acao"];
				$array["ACOES"]  [$this->con->dados["id"] ][ir]   = $this->con->dados["goto"];
				$array["ACOES"]  [$this->con->dados["id"] ][lista]   = $this->con->dados["lista"];
				$array["ACOES"]  [$this->con->dados["id"] ][idworkflow]   = $this->con->dados["id_workflow"];

				$i++;
			}
	                //$array["ACOES"]  [$this->con->dados["idprocesso"] ][idworkflowdado]   = $this->con->dados["idworkflowdado"]; // L ou F


      switch ($array["DADOS_POSTO"][tipodesignacao])
      {
          case("AUTO-DIRECIONADO"):
          case("Assumir"):
	    			$array["ACOES"]  [$array["DADOS_POSTO"][tipodesignacao] ][acao]   = "Assumir"; // Nome do Link
	    			$array["ACOES"]  [$array["DADOS_POSTO"][tipodesignacao] ][ir]   = $idfeature; // proximo posto
	    			$array["ACOES"]  [$array["DADOS_POSTO"][tipodesignacao] ][lista]   = "L"; // L ou F
	    			$array["ACOES"]  [$array["DADOS_POSTO"][tipodesignacao] ][idworkflow]   = $array["DADOS_POSTO"][idworkflow];//$this->con->dados["id_workflow"];
	    			$array["ACOES"]  [$array["DADOS_POSTO"][tipodesignacao] ][assumir]   = 1;//$this->con->dados["id_workflow"];
          break;

          default:
		//$array["ACOES"]  [$array["DADOS_POSTO"][tipodesignacao] ][acao]   = $array["DADOS_POSTO"][tipodesignacao]; // Nome do Link
      }



		$array["resultado"] = "SUCESSO";

		$data =  	$array;

		$app->render ('default.php',$data,200);


	}

}
