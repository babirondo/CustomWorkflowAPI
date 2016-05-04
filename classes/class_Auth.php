<?php
class Auth{
	function Auth( ){
		
		require("classes/class_db.php");
		$this->con = new db();
		$this->con->conecta();

	}
	
	function Autenticar($login, $senha, $app){
		
	 	
 
 	 	if ( $this->con->executa("SELECT * FROM \"JOGADOR\" WHERE \"EMAIL\" = '$login' and \"SENHA\" = '$senha'") ){
 	 		$this->con->navega();
 	 		//autenticado
 	 		
 	 		$data = array("data"=>
 	 				array(	"resultado" =>  "SUCESSO",
 	 						"email" => $this->con->dados["EMAIL"],
 	 						"nome" => $this->con->dados["NOME"])
 	 		); 	 	
 	 	}
	 	else {
	 		// nao encontrado
	 		$data = array("data"=>
	 						
	 				array(	"resultado" =>  "ERRO",
	 						"erro" => "Nao encontrado" )
	 		);	 		
	 	} 

		$app->render ('default.php',$data,200);
	}
}