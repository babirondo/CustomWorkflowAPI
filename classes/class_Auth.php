<?php

set_time_limit( 2 );
class Auth{
	function Auth( ){


		require("classes/class_db.php");


		$this->con = new db();

		$this->con->conecta();


	}

	function Autenticar(  $app, $jsonRAW){

            if (!$this->con->conectado){
                $data = array("data"=>
                    array(	"resultado" =>  "ERRO",
                                 "erro" => "nao conectado - ".$this->con->erro )
                );



                $app->render ('default.php',$data,500);
                return false;
            }

		$json = json_decode( $jsonRAW, true );
		IF ($json == NULL) {
			$data = array("data"=>

					array(	"resultado" =>  "ERRO",
							"erro" => "JSON zuado - $jsonRAW" )
			);


			$app->render ('default.php',$data,500);
			return false;
		}

		$sql = "SELECT * FROM usuarios WHERE login = '".$json["login"]."' and senha = '".$json[ "senha"]."'";
 
	 	$this->con->executa($sql);
 	 	if ( $this->con->nrw == 1 ){
 	 		$this->con->navega(null);
 	 		//autenticado

 	 		$data = array("data"=>
 	 				array(	"resultado" =>  "SUCESSO",
 	 						"email" => $this->con->dados["email"],
 	 						"id" => $this->con->dados["id"],
 	 						"nome" => $this->con->dados["nome"])
 	 		);
			$app->render ('default.php',$data,200);
 	 	}
	 	else {
	 		// nao encontrado
 	 		$data = array("data"=>
 	 				array(	"resultado" =>  "ERRO",
 	 						"erro" => "Usuário/Senha não encontrao")
 	 		);
 	 		$app->render ('default.php',$data,500);

	 	}

	}
}
