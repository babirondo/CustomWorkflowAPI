<?php
error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Feed{
	function Feed( ){
		
		require("classes/class_db.php");
		$this->con = new db();
		$this->con->conecta();

	}
	
	function CarregarFeed($app ){
	 
		$this->con->executa( " select  *
								from \"FEED\" F
									LEFT JOIN \"JOGADOR\" J ON (J.\"ID_JOGADOR\" = F.\"ID_JOGADOR\")
									LEFT JOIN \"TIME_JOGADORES\" TJ ON (TJ.\"ID_JOGADOR\" = J.\"ID_JOGADOR\" )
									LEFT JOIN \"TIMES\" T ON (T.\"ID_TIME\" = TJ.\"ID_TIME\") ");
		//$this->con->navega();
		
		$array["resultado"] = "SUCESSO";
		
	//	$this->con->navega();
		$i=0;
		while ($this->con->navega()){
				$array["FEED"][$i]["NOME"]  = $this->con->dados["NOME"];
				$array["FEED"][$i]["TIME"]  = $this->con->dados["TIME"];
				$array["FEED"][$i]["FOTOJOGADOR"]  = $this->con->dados["FOTOJOGADOR"];
				$array["FEED"][$i]["NEW"]  = $this->con->dados["NEW"];
				$i++;
		}
	 
		$data = $array;
		
		$app->render ('default.php',$data,200);
				
		
	}
	
	
	
	function RegistrarFeed($app , $jsonRAW){
		 
		$json = json_decode( $jsonRAW, true );
		IF ($json == NULL) {
			$data = array("data"=>
						
					array(	"resultado" =>  "ERRO",
							"erro" => "JSON zuado - $jsonRAW" )
			);
				
				
			$app->render ('default.php',$data,200);
			return false;
		}
		//var_dump($json);
	
		//	curl -H 'Content-Type: application/json' -X PUT -d '{"IDJOGADOR":"2","MENSAGEM":"Editou seu cadastro"}' http://localhost/api/RegistrarFeed/
		/*
	
	
	
		*/
		$erro = 0;
	
		//dados cadastrais
		if (  $this->con->executa( "INSERT INTO \"FEED\" (\"ID_JOGADOR\", \"NEW\", \"PUBLICADO\")
									 VALUES ('".$json["idJogador"]   ."', '".$json["MENSAGEM"]   ."', NOW() )")  === false )
		{
			$data = array("data"=>
			
					array(	"resultado" =>  "ERRO  ",
							"erro" => "Nao foi possível salvar o feed" )
			);
		}
		else{
			$data = array("data"=>
					array(	"resultado" =>  "SUCESSO"
					)
			);
		}
			
		 
			$app->render ('default.php',$data,200);
	}
 
}