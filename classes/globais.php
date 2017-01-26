<?php
namespace raiz;
set_time_limit(2);
//error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Globais{
	function __construct( ){

		$this->sourcecode = "local"; //local ou prod
		$this->banco = "prod";//dev ou prod
		$this->environment = "mac"; //mac ou windows

		if ($this->sourcecode == "prod"){
		}
		else if ($this->sourcecode == "local"){
		}

		if ($this->banco == "prod"){
					$this->localhost = "127.0.0.1";
					$this->username = "bsiquei";
					$this->password = "rodr1gues";
					$this->db ="customworkflow_prod";
					$this->verbose=1;

		}
		else if ($this->banco == "dev"){
					 $this->localhost = "localhost";
					 $this->username = "bsiquei";
					 $this->password = "rodr1gues";
					 $this->db ="customworkflow";
					 $this->verbose=1;
		}


		$this->SYS_DEPARA_CAMPOS["SalvarAvaliadordoTeste"] = 229;

		$this->SYS_DEPARA_CAMPOS["postos_de_avaliacao"] = "309,310";

		$this->SYS_DEPARA_CAMPOS["ParecerTecnico1"] = "219";
		$this->SYS_DEPARA_CAMPOS["ParecerTecnico2"] = "221";

		$this->SYS_DEPARA_CAMPOS["Tecnologias_do_teste"] = 217;
		$this->SYS_DEPARA_CAMPOS["CV"] = "214";
		$this->SYS_DEPARA_CAMPOS["github"] = "215";
		$this->SYS_DEPARA_CAMPOS["ENTIDADE_FILHA_APONTA_PARA_CANDIDATO"] = "206";
		//$this->SYS_DEPARA_CAMPOS["Skills_mandatorias_vaga"] = 187;

		$this->SYS_DEPARA_CAMPOS["Tecnologias_candidato_domina"] = 223; // 223
		$this->SYS_DEPARA_CAMPOS["Tecnologias_vaga_pede"] = 203;
		$this->SYS_DEPARA_CAMPOS["Tecnologias_vaga_pede_opcional"] = 212;

    $this->SYS_DEPARA_CAMPOS["Responsavel"] = -1;
    $this->SYS_DEPARA_CAMPOS["bt_handover"] = "Salvar e Avancar >";

    $this->SYS_CAMPOS_ESPECIAIS["gestorselecao"] = "Bruno Siqueira - Gestor Seleção";

		$this->SYS_ADD_CAMPOS["entradanoposto"] = "wt_inicio";
		$this->SYS_ADD_CAMPOS["saidadoposto"] = "wt_fim";
    //$this->SYS_ADD_CAMPOS["temponoposto"] = "wt_inicio";
		$this->SYS_ADD_CAMPOS["usuarioassociado"] = "usuarioassociado";
		$this->SYS_ADD_CAMPOS["email_usuarioassociado"] = "email_usuarioassociado";
    $this->SYS_ADD_CAMPOS["inicioprocesso"] = "p_inicio";
    $this->SYS_ADD_CAMPOS["atoresdoposto"] = "atoresdoposto";

		$this->SYS_FEATURES_ADMIN["SOLICITAR_ACESSO"][CODIGO] = "solicitar-usuario";
		$this->SYS_FEATURES_ADMIN["SOLICITAR_ACESSO"][CAMPOS][idtipousuario] = 2;

		$this->SYS_FEATURES_ADMIN["USUARIOS"]["CRIAR"][CODIGO] = "admin-criar-usuario";
		$this->SYS_FEATURES_ADMIN["USUARIOS"]["CRIAR"][CAMPOS]["nome"] = "nome";
		$this->SYS_FEATURES_ADMIN["USUARIOS"]["CRIAR"][CAMPOS]["email"] = "email";
		$this->SYS_FEATURES_ADMIN["USUARIOS"]["CRIAR"][CAMPOS]["senha"] = "senha";
		$this->SYS_FEATURES_ADMIN["USUARIOS"]["CRIAR"][CAMPOS]["login"] = "login";

		$this->SYS_FEATURES_ADMIN["USUARIOS"]["ALTERAR"][CODIGO] = "admin-alterar-usuario";
		$this->SYS_FEATURES_ADMIN["USUARIOS"]["ALTERAR"][CAMPOS]["nome"] = "nome";
		$this->SYS_FEATURES_ADMIN["USUARIOS"]["ALTERAR"][CAMPOS]["email"] = "email";
		$this->SYS_FEATURES_ADMIN["USUARIOS"]["ALTERAR"][CAMPOS]["senha"] = "senha";
		//$this->SYS_FEATURES_ADMIN["USUARIOS"]["ALTERAR"][CAMPOS]["login"] = "login";



	}


	function getConfs($app   ){


			$array["sourcecode"] = $this->sourcecode;
			$array["banco"] =$this->banco ;
			$array["environment"] =$this->environment;
			$array["verbose"] =$this->verbose;

			$array["resultado"] = "SUCESSO";

			$data =  	$array;

			$app->render ('default.php',$data,200);
	}


	function Traduzir($texto_original)
	{

	//	echo "<BR> aa ".$texto_original;
		$texto_original = preg_replace_callback( '%{.*?}%i',

			    function($match) use ($valor) {
            //echo "<BR> trafuziu ".str_replace(array('{', '}'), '', strtolower(  $match[0] ) );
            return str_replace(array('{', '}'), '', strtolower(  $match[0] ) );
			    },
		$texto_original);

		return $texto_original;

	}

		 	Function ArrayMergeKeepKeys() {
				$arg_list = func_get_args();

				foreach((array)$arg_list as $arg){
					if (is_array ($arg) )
					{
						foreach((array)$arg as $K => $V){
								$Zoo[$K]=$V;
						}
					}
				}
				return $Zoo;
			}



}

?>
