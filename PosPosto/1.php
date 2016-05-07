<?php

$data = $this->LoadCampos($idposto, $idprocesso );

foreach ($data["FETCH"] as $linha){
				
		$jobdescription[] = $linha[campo] . " = " . $linha[valor] ;
}


$email_remetente = "bruno.siqueira@walmart.com";
$to      = "bruno.siqueira@walmart.com";
$subject = "[Walmart.com] Abertura de Vaga - Processo Seletivo #$idprocesso" ;
$message = 
"Olá,
Comunicamos de abertura de nova vaga, Processo Seletivo #$idprocesso.

Job Description:
".implode($jobdescription, "\n")."
		
Lembramos que: 
1 - Os candidatos que atenderem as exigências da vaga deverão executar o teste abaixo, em caráter eliminatório.
http://www. github.com. aihua/ teste blabla
		
2 - Toda a comunicação a respeito de um candidato deve preservar o número do Processo Seletivo.

3 - Somente serão considerados os candidatos com teste concluído e data de resposta de no máximo um mês a partir deste email.
		
Atenciosamente, 
Equipe de Contratação de Desenvolvedores
devcontrat@walmart.com ";

$headers = "MIME-Version: 1.1
		    Content-type: text/plain; charset=iso-8859-1
			From: $email_remetente
			Return-Path: $email_remetente
		    Reply-To: $email_remetente "; // Endereço (devidamente validado) que o seu usuário informou no contato


if (mail($to, $subject, $message, $headers))
	echo "Email enviado com sucesso";
else
	echo "Erro no envio de Email";
/*
  	*/

?>