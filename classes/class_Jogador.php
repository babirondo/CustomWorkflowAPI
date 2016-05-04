<?php
error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Jogador{
	function Jogador( ){
		
		require("classes/class_db.php");
		$this->con = new db();
		$this->con->conecta();

	}
	
	function CarregarDados($app, $idJogador){
	 
		$this->con->executa( " select  J.*, T.*
								from \"JOGADOR\" J
									LEFT JOIN \"TIME_JOGADORES\" TJ ON (TJ.\"ID_JOGADOR\" = J.\"ID_JOGADOR\")
									LEFT JOIN \"TIMES\" T ON (T.\"ID_TIME\" = TJ.\"ID_TIME\")		
								WHERE J.\"ID_JOGADOR\"= '".$idJogador."' and TJ.\"saida\" is null");
		$this->con->navega();
		
		$array["resultado"] = "SUCESSO";
		$array["Nome"] =  $this->con->dados["NOME"];
		$array["Num"] =   $this->con->dados["NUM"];
		$array["IDTime"] = $this->con->dados["ID_TIME"] ;
		$array["Time"] = $this->con->dados["TIME"] ;
		$array["Peso"] =  $this->con->dados["PESO"];
		$array["Altura"] =  $this->con->dados["ALTURA"];
		$array["fotoJogador"] =  $this->con->dados["FOTOJOGADOR"];
		
		// carregando posicoes do jogador
		$this->con->executa( " select  *
								from \"JOGADOR_POSICOES\" 
								WHERE \"ID_JOGADOR\"= '".$idJogador."'");
	//	$this->con->navega();
		$i=0;
		while ($this->con->navega(0)){
				$array["POSICOES_JOGADOR"][$i]["ID_POSICAO"]  = $this->con->dados["ID_POSICAO"];
			$i++;
		}
		//$array[] = $array2;		
		//$data =  	$array;
		

		// carregando posicoes do jogador NO TIME
		$this->con->executa( "select * 
from \"TIME_JOGADOR_POSICOES\" tjp
	left join \"TIME_JOGADORES\" tj ON (tj.\"ID_TIME_JOGADOR\"  = tjp.\"ID_TIME_JOGADOR\")
WHERE tj.\"ID_JOGADOR\" =   '".$idJogador."'");
		//	$this->con->navega();
		$i=0;
		while ($this->con->navega(0)){
			$array["POSICOES_JOGADOR_NO_TIME"][$i]["ID_POSICAO"]  = $this->con->dados["ID_POSICAO"];
			$i++;
		}
		//$array[] = $array2;
		$data =  	$array;
		
		
		
		$app->render ('default.php',$data,200);
				
		
	}
	
	function Alterar($app, $idJogador, $jsonRAW){
		GLOBAL $IDPosicao;
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
		
	//	curl -H 'Content-Type: application/json' -X PUT -d '{"TIMECornerSnake":"1","CornerDoritos":"0","Snake":"0","Num":"13","TIMEDoritos":"0","TIMECornerDoritos":"1","nomeJogador":"Bruno Siqueira","TIMESnake":"1","Coach":"0","CornerSnake":"0","Peso":"100","TIMECoach":"0","TIMEBackCenter":"0","BackCenter":"0","Altura":"1,78","Time":"3","Doritos":"0"}' http://localhost/api/Jogadores/2/
/*
 

  
	 							*/
		$erro = 0;

		//dados cadastrais
	 	if (  $this->con->executa( "UPDATE \"JOGADOR\" SET
	 							\"NOME\"= '".$json["nomeJogador"]   ."',
	 							\"PESO\"= '".$json["Peso"]   ."',
	 							\"ALTURA\"= '".$json["Altura"]   ."',
	 							\"NUM\"= '".$json["Num"]."',
	 							\"FOTOJOGADOR\"= '".$json["fotoJogador"]."'
	 						WHERE \"ID_JOGADOR\"  = '".$idJogador."' ") === false ) 
	 		$erro = 1;
	 						
	 		// relacionando jogador ao time
	 		$this->con->executa( "SELECT * FROM \"TIME_JOGADORES\" WHERE \"ID_JOGADOR\" = '".$idJogador."' and saida is null ");
	 		$this->con->navega();
 			if (!$this->con->dados["ID_TIME_JOGADOR"] && $json["Time"] > 0 ){
 				//INCLUIR NO TIME
 				if ($this->con->executa( "INSERT INTO \"TIME_JOGADORES\" (\"ID_JOGADOR\", \"ID_TIME\", \"entrada\") VALUES ('".$idJogador."', '".$json["Time"]."', NOW()); "  ) === FALSE)
 					$erro=4;
 			}
 			ELSE if ($this->con->dados["ID_TIME_JOGADOR"]>0 && $json["Time"] == 0){
 				//SAIU DO TIME
 				if ($this->con->executa( "UPDATE  \"TIME_JOGADORES\" SET \"saida\"= now() WHERE \"ID_TIME_JOGADOR\"='".$this->con->dados["ID_TIME_JOGADOR"]."'" ) === FALSE)
 					$erro=5;
 			}
 			
 			$this->con->executa( "SELECT * FROM \"TIME_JOGADORES\" WHERE \"ID_JOGADOR\" = '".$idJogador."' and saida is null ");
			$this->con->navega();
			$idTimeJogador = $this->con->dados["ID_TIME_JOGADOR"];	
 			
			if ( $idTimeJogador > 0)
			{
				// ajustando posicoes do jogador NO TIME
				foreach ($IDPosicao  as $key => $value){
						echo " \n checkando... $key $value --- ".$json[$key];
				
					$this->con->executa( "SELECT * FROM \"TIME_JOGADOR_POSICOES\" WHERE \"ID_POSICAO\" = '".$value."' AND \"ID_TIME_JOGADOR\" = '".$idTimeJogador."' ");
					$this->con->navega();
					if (!$this->con->dados["ID_TIME_JOGADOR_POSICAO"] && $json["TIME".$key] == 1){
						if ($this->con->executa( "INSERT INTO \"TIME_JOGADOR_POSICOES\" (\"ID_TIME_JOGADOR\", \"ID_POSICAO\") VALUES ('".$idTimeJogador."', '".$value."'); "  ) === FALSE)
							$erro=6;
					}
					ELSE if ($this->con->dados["ID_TIME_JOGADOR_POSICAO"]>0 && $json["TIME".$key] == 0){
						if ($this->con->executa( "delete from \"TIME_JOGADOR_POSICOES\" where \"ID_TIME_JOGADOR_POSICAO\"='".$this->con->dados["ID_TIME_JOGADOR_POSICAO"]."'" ) === FALSE)
							$erro=7;
					}
				
				}
				
			}
 			
 			
 		// ajustando posicoes DO JOGADOR
 		foreach ($IDPosicao  as $key => $value){
 		//	echo " \n checkando... $key $value --- ".$json[$key];

 			$this->con->executa( "SELECT * FROM \"JOGADOR_POSICOES\" WHERE \"ID_POSICAO\" = '".$value."' AND \"ID_JOGADOR\" = '".$idJogador."' ");
 			$this->con->navega();
 			if (!$this->con->dados["ID_POSICAO_JOGADOR"] && $json[$key] == 1){
 				if ($this->con->executa( "INSERT INTO \"JOGADOR_POSICOES\" (\"ID_JOGADOR\", \"ID_POSICAO\") VALUES ('".$idJogador."', '".$value."'); "  ) === FALSE)
 					$erro=2;
 			}
 			ELSE if ($this->con->dados["ID_POSICAO_JOGADOR"]>0 && $json[$key] == 0){
 				if ($this->con->executa( "delete from \"JOGADOR_POSICOES\" where \"ID_POSICAO_JOGADOR\"='".$this->con->dados["ID_POSICAO_JOGADOR"]."'" ) === FALSE)
 					$erro=3;
 			}
 			
 		}
 
 			
	 	if ($erro == 0){
 	 		//autenticado
 	 		
 	 		$data = array("data"=>
 	 				array(	"resultado" =>  "SUCESSO"
 	 						)
 	 		); 	 	
 	 	}
	 	else {
	 		// nao encontrado
	 		$data = array("data"=>
	 						
	 				array(	"resultado" =>  "ERRO #$erro",
	 						"erro" => "Nao encontrado" )
	 		);	 		
	 	} 

		$app->render ('default.php',$data,200);
	}
}