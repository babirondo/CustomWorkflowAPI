<?php
namespace raiz;
error_reporting(E_ALL ^ E_DEPRECATED);

require_once("classes/class_db.php");

$con = new db();
$con->conecta();


/*

-- CHECK DE CONSISTENCIA PRA UPDATE
select tb.tecnologia -- tb.id de, tb.tecnologia, vw.id para, vw.tecnologia
from configuracoes."configuracoes.tecnologias3" tb,
	configuracoes.tecnologias vw
where UPPER(trim(tb.tecnologia)) = UPPER(trim(vw.tecnologia))
-- and vw.tecnologia = 'Perl'
 group by tb.tecnologia
 having COUNT(vw.id) > 1;

 --GERAR O DE PARA
 select  tb.id de, tb.tecnologia, vw.id para, vw.tecnologia
from configuracoes."configuracoes.tecnologias3" tb

	inner join configuracoes.tecnologias vw ON ( UPPER(trim(tb.tecnologia)) = UPPER(trim(vw.tecnologia))  )
 order by de

 */

$de[1] = 115;
$de[2] = 3;
$de[3] = 55;
$de[4] = 5;
$de[5] = 4;
$de[6] = 8;
$de[7] = 11;
$de[8] = 116;
$de[9] = 117;
$de[10] = 19;
$de[11] = 18;
$de[12] = 118;
$de[13] = 21;
$de[14] = 119;
$de[15] = 120;
$de[16] = 121;
$de[20] = 122;
$de[21] = 43;
$de[22] = 38;
$de[23] = 7;
$de[24] = 54;
$de[25] = 41;
$de[26] = 40;
$de[27] = 46;
$de[28] = 37;
$de[29] = 48;
$de[30] = 123;
$de[31] = 47;
$de[33] = 17;
$de[34] = 124;
$de[36] = 125;


  $sql = "select *
          from workflow_dados
          where idpostocampo IN ( 223)  ";
  $con->executa( $sql);

  while ($con->navega(0)){
      $valor_banco = $con->dados["valor"];

      $valor_quebrado = explode(",",$valor_banco);
      $alterarPara = null;
      foreach ($valor_quebrado as $valor){

          $alterarPara[] = $de[ $valor ];
      }

      $Lote_Alterar[$con->dados["id"] ][original] = $valor_banco;
      $Lote_Alterar[$con->dados["id"] ][alterado] = implode(",",$alterarPara);
  }

  foreach ($Lote_Alterar as $id => $valor){

    $sql = "UPDATE workflow_dados SET valor = '". $valor[alterado]."' /*". $valor[original]."*/ WHERE id = $id";
    echo "\n ".$sql;
  //  $con->executa( $sql);

  }
  echo "\n " ;
//var_dump($Lote_Alterar);
?>
