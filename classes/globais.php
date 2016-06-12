<?php
set_time_limit(2);
//error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Globais{
	function Globais( ){

            $this->SYS_DEPARA_CAMPOS["Tecnologias_do_teste"] = 12;
            $this->SYS_DEPARA_CAMPOS["Responsável"] = -1;
            $this->SYS_DEPARA_CAMPOS["bt_handover"] = "Salvar e Avancar >";

            $this->SYS_CAMPOS_ESPECIAIS["gestorselecao"] = "Bruno Siqueira - Gestor Seleção";

						$this->SYS_ADD_CAMPOS["entradanoposto"] = "wt_inicio";
						$this->SYS_ADD_CAMPOS["saidadoposto"] = "wt_fim";
            //$this->SYS_ADD_CAMPOS["temponoposto"] = "wt_inicio";
            $this->SYS_ADD_CAMPOS["usuarioassociado"] = "usuarioassociado";
            $this->SYS_ADD_CAMPOS["inicioprocesso"] = "p_inicio";
            $this->SYS_ADD_CAMPOS["atoresdoposto"] = "atoresdoposto";



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
