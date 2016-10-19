<?php
namespace raiz;
set_time_limit(2);
//error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Globais{
	function __construct( ){

		$usar = "windows";
		$usar = "mac";

		$this->ambiente = "dev";
	//$this->ambiente = "prod";

		if ($usar == "windows"){
				// windows
					$this->localhost = "127.0.0.1";
					$this->username = "bsiquei";
					$this->password = "rodr1gues";

		}
		else if ($usar == "mac"){
								// mac
					 $this->localhost = "localhost";
					 $this->username = "bsiquei";
					 $this->password = "rodr1gues";

		}

		if ($this->ambiente == "prod"){
			$this->db ="customworkflow_prod";

		}
		else if ($this->ambiente == "dev"){
			$this->db ="customworkflow";
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
