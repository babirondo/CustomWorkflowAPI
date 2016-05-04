<?php
error_reporting(E_ALL ^ E_DEPRECATED);
 

//adt for windows 64 http://dl.google.com/android/adt/adt-bundle-windows-x86_64-20140702.zip
// commit feito pelo mac
require_Once("classes/globais.php");
require_Once("classes/class_workflow.php");

require 'vendor/autoload.php';
// tentando commitar pro github 
 
//instancie o objeto
$app = new \Slim\Slim( array(
    'debug' => true,
    'templates.path' => './templates'
) );
\Slim\Slim::registerAutoloader();
 
//defina a rota

$app->get('/getWorkflows/', function () use ($app)  {
	$Workflow = new Workflow();
	$Workflow->getWorkflows($app );
}  ); 
 
//rode a aplicação Slim 
$app->run();
