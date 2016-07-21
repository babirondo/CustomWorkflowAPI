<?php
namespace raiz;
error_reporting(E_ALL ^ E_DEPRECATED);

//require_Once("classes/globais.php");
require_Once("classes/class_workflow.php");
require_Once("classes/class_postos.php");
require_Once("classes/class_posto_usuario.php");
require_Once("classes/class_Auth.php");
require_Once("classes/class_relatorios.php");
require_Once("classes/class_processos.php");

require_Once("classes/engine/class_engine_feature.php");
require_Once("classes/engine/class_menus.php");
require_Once("classes/engine/class_engine.php");

require_Once("classes/recrutamento/class_vagas.php");

require 'vendor/autoload.php';
// tentando commitar pro github
 /// teste no atom

//instancie o objeto
$app = new \Slim\Slim( array(
    'debug' => true,
    'templates.path' => './templates'
) );
\Slim\Slim::registerAutoloader();


$app->post('/ListarCandidatos/', function (  ) use ($app)  {
  $cVagas = new Vagas(  );
	$cVagas->ListarCandidatosDaVaga($app,  $app->request->getBody());
}  );


$app->get('/Vaga/:idprocesso/Candidatos', function ( $idprocesso ) use ($app)  {
  $cVagas= new Vagas(  );
	$cVagas->CandidatosDaVaga($app, $idprocesso );
}  );


$app->get('/Engine/:idfeature', function ($idfeature) use ($app)  {
	$SubMenus = new Menus();
	$SubMenus->getMenu($app, $idfeature );
}  );


$app->post('/Engine/:idfeature/Lista', function ( $idfeature) use ($app)  {
  $Engine_Feature = new Engine_Feature(  );
	$Engine_Feature->getLista($app, $idfeature , $app->request->getBody());
}  );

$app->post('/Engine/Registrar/:idfeature', function (  $idfeature) use ($app)  {
	$Engine = new Engine(  );
	$Engine->Registrar($app, $app->request->getBody(), $idfeature );
}  );
$app->post('/Engine/:idfeature/Form', function ( $idfeature   ) use ($app)  {
	$Engine_Feature = new Engine_Feature(  );
	$Engine_Feature->getCampos($app, $idfeature ,  $app->request->getBody() );
}  );

$app->post('/Relatorios/', function (    ) use ($app)  {
	$Relatorios = new Relatorios(  );
	$Relatorios->extrair_dados($app,   $app->request->getBody());
}  );

$app->get('/getWorkflows/', function () use ($app)  {
	$Workflow = new Workflow();
	$Workflow->getWorkflows($app );
}  );

$app->get('/getMenus/', function () use ($app)  {
	$Menus = new Menus();
	$Menus->getMenus($app );
}  );

$app->post('/getSubMenus/:idmenu', function ($idmenu) use ($app)  {
	$SubMenus = new Menus();
	$SubMenus->getSubMenus($app, $idmenu, $app->request->getBody() );
}  );

$app->post('/:idworkflow/getPostos/', function ( $idworkflow ) use ($app)  {
	$Postos = new Postos(  );
	$Postos->getPostos($app, $idworkflow , $app->request->getBody() );
}  );

$app->get('/:idworkflow/:processo/getPosto/:idposto', function ( $idworkflow , $processo, $idposto ) use ($app)  {
	$Postos = new Postos(  );
	$Postos->getCampos($app, $idworkflow, $idposto , $processo);
}  );
$app->post('/:idworkflow/getPosto/Lista/:idposto', function ( $idworkflow , $idposto) use ($app)  {
	$Postos = new Postos(  );
	$Postos->getLista($app, $idposto , $app->request->getBody());
}  );

$app->post('/Registrar/:idworkflow/:idposto', function ( $idworkflow , $idposto) use ($app)  {
	$Workflow = new Workflow(  );
	$Workflow->Registrar($app, $app->request->getBody(), $idposto );
}  );

$app->post('/Autenticar/', function () use ($app)  {



	$Auth = new Auth();
	$Auth->Autenticar($app, $app->request->getBody() );
}  );

$app->post('/Posto/Associar/:idposto', function (  $idposto) use ($app)  {
	$Posto_Usuario = new Posto_Usuario(  );
	$Posto_Usuario->AssociarProcessonoPosto($app, $app->request->getBody(), $idposto );
}  );

$app->post('/Posto/Desassociar/:idposto', function (  $idposto) use ($app)  {
	$Posto_Usuario = new Posto_Usuario(  );
	$Posto_Usuario->DesassociarProcessonoPosto($app, $app->request->getBody(), $idposto );
}  );


$app->get('/Usuarios/Posto/:idposto', function (  $idposto) use ($app)  {
	$Postos = new Postos(  );
	$Postos->UsuariosdoPosto($app, $idposto );
}  );


$app->get('/VidaProcesso/:idprocesso', function (  $idprocesso) use ($app)  {
	$Processos = new Processos(  );
	$Processos->Vida_Processo($app, $idprocesso );
}  );


//rode a aplicação Slim
$app->run();
