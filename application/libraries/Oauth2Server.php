<?php defined('BASEPATH') or exit('No direct script access allowed');
/**
 * @package     Oauth2Server
 *
 * @author      xiaocao
 * @link        http://homeway.me/
 * @copyright   Copyright(c) 2015
 * @version     15.6.24
 *
 * @author      Guilherme Mattioli
 * @copyright   Copyright(c) 2016
 * @version     16.9.27
 **/

class Oauth2Server extends CI_Controller
{
	private $storage = null;
	private $server = null;
	private $request = null;
	private $response = null;

	function __construct($config = array())
	{	parent::__construct();

		if (!$config)
		{	$this->config->load('database'); //database config
			$config = $this->config->item('db::conn');
			$config = $config['oauth'];
		}

		require_once(__DIR__.'/../third_party/Oauth2/src/OAuth2/Autoloader.php');	//oauth library

		OAuth2\Autoloader::register();
		$this->storage = new OAuth2\Storage\Pdo(array(
			'dsn' => $config["dsn"],
			'username' => $config["username"],
			'password' => $config["password"],
		));
		$this->server = new OAuth2\Server($this->storage, array('allow_implicit' => true));
		$this->request = OAuth2\Request::createFromGlobals();
		$this->response = new OAuth2\Response();
	}

	public function valid_client_secret_header()
	{	$client_id = $this->request->headers('CLIENT_ID');
		$client_secret = $this->request->headers('CLIENT_SECRET');

		if (!$client_id)
		{	$response = new OAuth2\Response(array(
				"error" => "invalid_request",
				"error_description" => "The client_id was not specified in the request"
			), 400);

			$response->send();
			die;
		}

		if (!$client_secret)
		{	$response = new OAuth2\Response(array(
				"error" => "invalid_request",
				"error_description" => "The client_secret was not specified in the request"
			), 400);

			$response->send();
			die;
		}

		$query = $this->db
		->where("client_id", $client_id)
		->where("client_secret", $client_secret)
		->limit(1)
		->get("oauth_clients");

		if ($query and is_object($query) and ($row = $query->row()))
		{	return true;
		}

		$response = new OAuth2\Response(array(
			"error" => "invalid_request",
			"error_description" => "The client_id and/or client_secret is not valid in the request"
		), 400);

		$response->send();
		die;
	}

	/**
	 * client_credentials, for more see: http://tools.ietf.org/html/rfc6749#section-4.3
	 * @link http://homeway.me/2015/06/29/build-oauth2-under-codeigniter/#Client_Credentials
	 */
	public function client_credentials(){
		$this->server->addGrantType(new OAuth2\GrantType\ClientCredentials($this->storage, array(
			"allow_credentials_in_request_body" => true
		)));
		$this->server->handleTokenRequest($this->request)->send();
	}

	/**
	 * password_credentials, for more see: http://tools.ietf.org/html/rfc6749#section-4.3
	 * @link http://homeway.me/2015/06/29/build-oauth2-under-codeigniter/#Resource_Owner_Password_Credentials
	 */
	public function password_credentials(){
		$users = array("user" => array("password" => 'pass', 'first_name' => 'homeway', 'last_name' => 'yao'));
		$storage = new OAuth2\Storage\Memory(array('user_credentials' => $users));
		$this->server->addGrantType(new OAuth2\GrantType\UserCredentials($storage));
		$this->server->handleTokenRequest($this->request)->send();
	}

	/**
	 * refresh_token, for more see: http://tools.ietf.org/html/rfc6749#page-74
	 */
	public function refresh_token(){
		$this->server->addGrantType(new OAuth2\GrantType\RefreshToken($this->storage, array(
			"always_issue_new_refresh_token" => true,
			"unset_refresh_token_after_use" => true,
			"refresh_token_lifetime" => 2419200,
		)));
		$this->server->handleTokenRequest($this->request)->send();
	}

	public function get_response()
	{	return $this->response;
	}

	/**
	 * limit scpoe here
	 * @param $scope = "node file userinfo"
	 */
	public function require_scope($scope=""){
		if (!$this->valid_scope($scope)) {
			$this->server->getResponse()->send();
			die;
		}
		return true;
	}

	public function valid_scope($scope='')
	{	return $this->server->verifyResourceRequest($this->request, $this->response, $scope);
	}

	public function check_client_id(){
		if (!$this->server->validateAuthorizeRequest($this->request, $this->response)) {
			$this->response->send();
			die;
		}
	}

	public function authorize($is_authorized){
		$this->server->addGrantType(new OAuth2\GrantType\AuthorizationCode($this->storage));
		$this->server->handleAuthorizeRequest($this->request, $this->response, $is_authorized);
		if ($is_authorized) {
			$code = substr($this->response->getHttpHeader('Location'), strpos($this->response->getHttpHeader('Location'), 'code=')+5, 40);
			// header("Location: ".$this->response->getHttpHeader('Location'));
			return $code;
		}
		$this->response->send();
		return false;
	}

	public function authorization_code(){
		$this->server->addGrantType(new OAuth2\GrantType\AuthorizationCode($this->storage));
		$this->server->handleTokenRequest($this->request)->send();
	}
}