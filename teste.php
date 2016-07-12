<?php
namespace raiz;
error_reporting(E_ALL ^ E_DEPRECATED);

require_once("classes/class_db.php");

$con = new db();
$con->conecta();

?>
