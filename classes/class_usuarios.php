<?php
namespace raiz;
set_time_limit( 2 );
class Usuarios{

	function __construct( ){

		require_once("classes/class_db.php");
		$this->con = new db();
		$this->con->conecta();

		require_once("classes/globais.php");
		$this->globais = new GLobais();

		require_once("classes/class_usuario_atores.php");
		$this->UsuarioAtores = new UsuarioAtores();

	}



		function AlterarUsuario($jsonRAW)
		{
			$json = json_decode( $jsonRAW, true );
			IF ($json == NULL) {
				$data = array("data"=>

						array(	"resultado" =>  "ERRO",
								"erro" => "JSON zuado - $jsonRAW" )
				);
				return false;
			}

			foreach ($this->globais->SYS_FEATURES_ADMIN["USUARIOS"]["ALTERAR"][CAMPOS] as $idx_tentativa => $tentativa)
			{
					$changes[] =  $idx_tentativa. " = " . "'".$json[ $idx_tentativa ]."'";

			}

			$sql = "UPDATE usuarios SET ".implode(" , ",$changes)." WHERE id = ".  $json["chave_primaria"];
			//echo "\n".$sql;
			$this->con->executa( $sql , 0 , __LINE__);

			return true;
		}



	function CriarUsuario($preenchidoRAW)
	{

		$json = json_decode( $preenchidoRAW, true );
		IF ($json == NULL) {
			$data = array("data"=>

					array(	"resultado" =>  "ERRO",
							"erro" => "JSON zuado - $jsonRAW" )
			);
			return false;
		}

		foreach ($this->globais->SYS_FEATURES_ADMIN["USUARIOS"]["CRIAR"][CAMPOS] as $idx_tentativa => $tentativa)
		{
				$campos[] =  $idx_tentativa;
				$valores[] = "'".$json[ $idx_tentativa ]."'";
		}

		$sql = "INSERT INTO usuarios (id, ".implode(",",$campos).") VALUES (".  $json["chave_primaria"]."  , ".implode(",",$valores)." )
						RETURNING id       ";
//  echo "\n".$sql." \n";
		if (  $this->con->executa( $sql , 1 , __LINE__) === false )
			return false;
		else{
			if ($json["chave_primaria"] == $this->con->dados["id"]){
				// relacionar tipos de usuario ao usuario recem criado

					if ( $this->UsuarioAtores->vincular($this->con->dados["id"], explode(",",$json["tipousuario"]) ) )
						return true;
					else {
						return false;
					}
			}
			else {
				return false;
			}

		}

		return false;
	}

}
