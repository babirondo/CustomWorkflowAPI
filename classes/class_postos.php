<?php
error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Postos{
	function Postos( ){
		
		require("classes/class_db.php");
		$this->con = new db();
		$this->con->conecta();

	}
	
	function getPostos($app, $idworkflow ){
	 
		$this->con->executa( "Select * from workflow_postos WHere id_workflow = $idworkflow and principal = 1 ORDER BY ordem_cronologica ");
		//$this->con->navega();
		
		$i=0;
		while ($this->con->navega(0)){
			$array["FETCH"][$i]["posto"]  = $this->con->dados["posto"];
			$array["FETCH"][$i]["idposto"]  = $this->con->dados["id"];
			$array["FETCH"][$i]["lista"]  = $this->con->dados["lista"];
			$array["FETCH"][$i]["form"]  = $this->con->dados["form"];
			$i++;
		}
		
		$array["resultado"] = "SUCESSO";

		$data =  	$array;
		
		$app->render ('default.php',$data,200);
				
		
	}

	function getCampos($app, $idworkflow , $idposto, $idprocesso ){
		
		$this->con->executa( "Select * from workflow_postos WHere id = $idposto  ");
		$this->con->navega(0); 
			$array["DADOS_POSTO"] [starter]  = $this->con->dados["starter"];
		
		
		$this->con->executa( "Select * from postos_campo WHere idposto = $idposto  ");
		//$this->con->navega();
	 
		while ($this->con->navega(0)){
			$array["FETCH"][$this->con->dados["id"]] ["campo"]  = $this->con->dados["campo"];
			$array["FETCH"][$this->con->dados["id"]] ["idcampo"]  = $this->con->dados["id"];
//			$array["FETCH"][$i]["idcampo"]  = $this->con->dados["id"];
	
		}
 
		$this->con->executa( "Select wd.id idworkflowdado, wd.valor, pc.id
from postos_campo pc 
	inner join workflow_dados wd ON (wd.idpostocampo  =pc.id)
WHere pc.idposto = $idposto and wd.idprocesso = $idprocesso  ");
		//$this->con->navega();
		
		while ($this->con->navega(0)){
			$array["FETCH"][$this->con->dados["id"]]["valor"]  = $this->con->dados["valor"];
			$array["FETCH"][$this->con->dados["id"]]["idworkflowdado"]  = $this->con->dados["idworkflowdado"];
		}
		
		$array["resultado"] = "SUCESSO";
	
		$data =  	$array;
	
		$app->render ('default.php',$data,200);
	
	
	}
	

	function getLista($app,   $idposto ){
	
		
		// BUSCANDO DADOS DO PAI
		$sql = "
				SELECT pc.campo, w.valor, w.idprocesso, p.idpai
				FROM postos_campo_lista pcl
				INNER JOIN postos_campo pc ON (pc.id = pcl.idpostocampo)
				INNER JOIN workflow_postos wp ON (wp.id = pcl.idposto)
				INNER JOIN workflow_dados w ON (w.idpostocampo = pcl.idpostocampo )
				INNER JOIN processos p ON (p.id = w.idprocesso)
		
				WHERE pcl.idposto =   $idposto   ";
		$this->con->executa($sql );
		//echo $sql;
		//$this->con->navega();
		
		$i=0;
		while ($this->con->navega(0)){
			$pai[$this->con->dados["idprocesso"]][$this->con->dados["campo"] ]   = $this->con->dados["valor"];
		
			$array["TITULO"][$this->con->dados["campo"]]   = $this->con->dados["campo"];
		
			
			//echo " \n ".$this->con->dados["idprocesso"]." = ".$this->con->dados["campo"]."  = ". $this->con->dados["valor"];			
			$i++;
		}
				
		 
		
		 
		// BUSCANDO DADOS DO FILHO
		$sql = "
				SELECT pc.campo, w.valor, w.idprocesso, p.idpai, wt.id idworkflowtramitacao
				FROM postos_campo_lista pcl 
						INNER JOIN postos_campo pc ON (pc.id = pcl.idpostocampo)
						INNER JOIN workflow_postos wp ON (wp.id = pcl.idposto)
						INNER JOIN processos p ON (p.idtipoprocesso =  wp.idtipoprocesso)
						INNER JOIN workflow_dados w ON (w.idpostocampo = pcl.idpostocampo and p.id = w.idprocesso)
						INNER JOIN workflow_tramitacao wt ON (wt.idworkflowposto = pcl.idposto and wt.idprocesso = p.id and wt.fim is null)
						
				WHERE pcl.idposto =$idposto   ";
		$this->con->executa( $sql);
		//$this->con->navega();
	
		$i=0;
		while ($this->con->navega(0)){
			

			//$pai[$this->con->dados["idprocesso"]][$this->con->dados["campo"] ]   = $this->con->dados["valor"];
			


			$array["FETCH"][$this->con->dados["idprocesso"]][$this->con->dados["campo"] ]   = $this->con->dados["valor"];
			$array["FETCH"][$this->con->dados["idprocesso"]][idworkflowtramitacao ]   = $this->con->dados["idworkflowtramitacao"];
			
			if (is_array($pai[$this->con->dados["idpai"]]) )
			{
				$array["FETCH"][$this->con->dados["idprocesso"]] = array_merge($array["FETCH"][$this->con->dados["idprocesso"]] ,$pai[$this->con->dados["idpai"]]);
			}
				
			$array["TITULO"][$this->con->dados["campo"]]   = $this->con->dados["campo"];
				
			$i++;
		}
		 
	//	var_dump($array["FETCH"]);
		
		$this->con->executa( "select * 
								from posto_acao pa
									inner join workflow_postos wp ON (wp.id = pa.goto)
								where pa.idposto =  $idposto    ");
		//$this->con->navega();
		
		$i=0;
		while ($this->con->navega(0)){
			$array["ACOES"]  [$this->con->dados["id"] ][acao]   = $this->con->dados["acao"];
			$array["ACOES"]  [$this->con->dados["id"] ][ir]   = $this->con->dados["goto"];
			$array["ACOES"]  [$this->con->dados["id"] ][lista]   = $this->con->dados["lista"]; 
			$array["ACOES"]  [$this->con->dados["id"] ][idworkflow]   = $this->con->dados["id_workflow"];
				
			$i++;
		}
		 
		
		$array["resultado"] = "SUCESSO";
	
		$data =  	$array;
	
		$app->render ('default.php',$data,200);
	
	
	}
	
}