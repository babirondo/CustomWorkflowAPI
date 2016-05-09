<?php
error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Postos{
	function Postos( ){
		
		require_once("classes/class_db.php");
		$this->con = new db();
		$this->con->conecta();

	}
	 
	
	function getPosto($idposto){
		 
		$this->con->executa( "Select *
								from workflow_postos wp 
								WHere wp.id = $idposto ");
		//$this->con->navega();
		
		$i=0;
		while ($this->con->navega(0)){
			$array["FETCH"][$i]["execucao_pos_posto"]  = $this->con->dados["execucao_pos_posto"];
			$i++;
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
								inner join   usuario_atores ua ON (ua.idator = wp.idator)
								inner join usuarios u ON (u.id = ua.idusuario)
							  WHere id_workflow = $idworkflow and principal = 1 and u.id = ".$json[idusuario]." 
							  ORDER BY ordem_cronologica ";

		$this->con->executa( $sql);
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
	
	function BuscarDadosdoPostodeumProcesso($idposto, $idprocesso, $array_estrutural=null, $debug = null)
	{
		 
		// buscando dados -> indexado por idprocesso 
		$array_dopai = $this->BuscarDadosdoFilhoePai($idposto, $idprocesso, $debug);

		/*
		/// TODO problema aqui
		// buscando dados -> indexado por id posto campo 
		$sql = "Select wd.id idworkflowdado, wd.valor, pc.id, wd.idprocesso
				from postos_campo pc
				inner join workflow_dados wd ON (wd.idpostocampo  =pc.id)
				WHere pc.idposto = $idposto and wd.idprocesso = $idprocesso  ";
		$this->con->executa( $sql);

		//$this->con->navega();
		
		while ($this->con->navega(0)){
			$array_dopai["FETCH"][$this->con->dados["idprocesso"] ][$this->con->dados["id"]]["valor"]  = $this->con->dados["valor"];
			$array_dopai["FETCH"][$this->con->dados["idprocesso"]][$this->con->dados["id"]]["idworkflowdado"]  = $this->con->dados["idworkflowdado"];
		}
		
		
		var_dump($array_dopai);
			*/
		//	var_dump($array_dopai);
//		if (is_array($array_dopai)){
			//echo " \n mergeou \n";
	//		$array_completo = array_merge( $array_dopai, $array_estrutural);
			//echo " \n vardump mergeado ($idposto) \n ";
			//var_dump($array);
		//}
		//else
			//$array_completo = $array_dopai;
		
		//	var_dump($array_completo);
			
		return $array_dopai;
	}
	
	
	function LoadCampos(  $idposto, $idprocesso, $posto="entrando", $debug=null ){
		// busca o email dos atores do posto
		$sql ="select u.email
				from workflow_postos wp 
					inner join atores  a ON (a.id = wp.idator)
					inner join usuario_atores ua ON (ua.idator = a.id)
					inner join usuarios u ON (u.id = ua.idusuario)
				where  wp.id = $idposto ";
		$this->con->executa($sql);
		
		$emails = null;
		while ($this->con->navega(0)){
			$emails[$this->con->dados["email"]]  = $this->con->dados["email"];
		}
		if (is_array($emails))
			$array["DADOS_POSTO"] [atores]  = implode(",",$emails);
		
		//buscando dados do posto
		$sql ="Select wp.*, nsp.de, nsp.para, nsp.titulo, nsp.corpo
								from workflow_postos  wp
									LEFT JOIN notificacoes_email nsp ON (nsp.id = wp.".(($posto=="entrando")?"notif_entrandoposto":"notif_saindoposto").")
								WHere wp.id = $idposto  ";
		$this->con->executa($sql);
		
		$this->con->navega(0);
		$array["DADOS_POSTO"] [starter]  = $this->con->dados["starter"];
		$array["DADOS_POSTO"] [de]  = $this->con->dados["de"];
		$array["DADOS_POSTO"] [para]  = $this->con->dados["para"];
		$array["DADOS_POSTO"] [titulo]  = $this->con->dados["titulo"];
		$array["DADOS_POSTO"] [corpo]  = $this->con->dados["corpo"];
		$array["DADOS_POSTO"] [avanca_processo]  = $this->con->dados["avanca_processo"];
		$array["DADOS_POSTO"] [notif_entrandoposto]  = $this->con->dados["notif_entrandoposto"];
		$array["DADOS_POSTO"] [notif_saindoposto]  = $this->con->dados["notif_saindoposto"];
		
		$this->con->executa( "Select * from postos_campo WHere idposto = $idposto  ");
		//$this->con->navega();
	
		while ($this->con->navega(0)){
			$array["FETCH_CAMPO"][$this->con->dados["id"]] ["campo"]  = $this->con->dados["campo"];
			$array["FETCH_CAMPO"][$this->con->dados["id"]] ["idcampo"]  = $this->con->dados["id"];
			//			$array["FETCH"][$i]["idcampo"]  = $this->con->dados["id"];
	
		}		
		
		
		
		// buscando os registros do posto, direcionado pelo idprocesso
		$array_dados = $this->BuscarDadosdoPostodeumProcesso($idposto, $idprocesso, $array, $debug);

		if (is_array($array_dados))
			$array_completo =  array_merge($array_dados, $array);
		else
			$array_completo = $array;
		
		$array_completo["resultado"] = "SUCESSO";

		return $array_completo;	
	
	}
	

	function getCampos($app, $idworkflow , $idposto, $idprocesso ){
		$data = $this->LoadCampos($idposto, $idprocesso );		
		$app->render ('default.php',$data,200);
	}
	
	function BuscarDadosdoFilhoePai($idposto, $idprocesso=null, $debug=null)
	{
	 
		// BUSCANDO DADOS DO PAI
		$sql = "
		SELECT pc.campo, w.valor, w.idprocesso, p.idpai
		FROM postos_campo_lista pcl
		INNER JOIN postos_campo pc ON (pc.id = pcl.idpostocampo)
		INNER JOIN workflow_postos wp ON (wp.id = pcl.idposto)
		LEFT JOIN workflow_dados w ON (w.idpostocampo = pcl.idpostocampo )
		LEFT JOIN processos p ON (p.id = w.idprocesso)
		
		WHERE wp.id  =   $idposto   ". (($idprocesso>0)?" and p.id = $idprocesso":"");
		$this->con->executa($sql );
		//echo "<PRE>$sql</pre>";
		//$this->con->navega();
		
		$i=0;
		while ($this->con->navega(0)){
			$pai[$this->con->dados["idprocesso"]][$this->con->dados["campo"] ]   = $this->con->dados["valor"];
		
			$array["TITULO"][$this->con->dados["campo"]]   = $this->con->dados["campo"];
		
				
			//echo " \n ".$this->con->dados["idprocesso"]." = ".$this->con->dados["campo"]."  = ". $this->con->dados["valor"];
			$i++;
		}
		
			
		//var_dump($pai);
			
		// BUSCANDO DADOS DO FILHO
		$sql = "
		SELECT pc.campo, w.valor, w.idprocesso, p.idpai, wt.id idworkflowtramitacao
		FROM postos_campo_lista pcl
		INNER JOIN postos_campo pc ON (pc.id = pcl.idpostocampo)
		INNER JOIN workflow_postos wp ON (wp.id = pcl.idposto)
		INNER JOIN processos p ON (p.idtipoprocesso =  wp.idtipoprocesso)
		INNER  JOIN workflow_dados w ON (w.idpostocampo = pcl.idpostocampo and p.id = w.idprocesso)
		INNER JOIN workflow_tramitacao wt ON (wt.idworkflowposto = pcl.idposto and wt.idprocesso = p.id and wt.fim is null)
		
		WHERE wp.id  =$idposto   ".(($idprocesso>0)?" and p.id = $idprocesso":"");
		$this->con->executa( $sql);

		//if ($debug==1) echo $sql;
		
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
		//var_dump($array);  
		
		return $array;
	}
	
	
	
	
	function getLista($app,   $idposto ){
	
		$array = $this->BuscarDadosdoFilhoePai($idposto);
		 
	//  var_dump($array );
		
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