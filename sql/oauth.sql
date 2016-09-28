/*
SQLyog Ultimate v10.42 
MySQL - 5.5.35 : Database - weizhan
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`oauth` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `oauth`;

--
-- Table structure for table `oauth_access_tokens`
--

DROP TABLE IF EXISTS `oauth_access_tokens`;

CREATE TABLE IF NOT EXISTS `oauth_access_tokens` (
  `access_token` varchar(40) NOT NULL COMMENT 'Acesso ao recursos de access_token',
  `client_id` varchar(80) NOT NULL COMMENT 'Developers AppId',
  `user_id` varchar(255) DEFAULT NULL COMMENT 'Developers do ID do usuário',
  `expires` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data Hora certificada date("Y-m-d H:i:s")',
  `scope` varchar(2000) DEFAULT NULL COMMENT 'contêiner de permissões',
  PRIMARY KEY (`access_token`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `oauth_authorization_codes`
--

DROP TABLE IF EXISTS `oauth_authorization_codes`;

CREATE TABLE IF NOT EXISTS `oauth_authorization_codes` (
  `authorization_code` varchar(40) NOT NULL COMMENT 'Adquirido através do código de autorização, usado para obter o access_token',
  `client_id` varchar(80) NOT NULL COMMENT 'Developers AppId',
  `user_id` varchar(255) DEFAULT NULL COMMENT 'Developers do ID do usuário',
  `redirect_uri` varchar(2000) DEFAULT NULL COMMENT 'Após autenticação redireciona para url',
  `expires` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data Hora certificada date("Y-m-d H:i:s")',
  `scope` varchar(2000) DEFAULT NULL COMMENT 'contêiner de permissões',
  PRIMARY KEY (`authorization_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `oauth_clients`
--

DROP TABLE IF EXISTS `oauth_clients`;

CREATE TABLE IF NOT EXISTS `oauth_clients` (
  `client_id` varchar(80) NOT NULL COMMENT 'Developers AppId',
  `client_secret` varchar(80) NOT NULL COMMENT 'Developers AppSecret',
  `redirect_uri` varchar(2000) NOT NULL COMMENT 'Após autenticação redireciona para url',
  `grant_types` varchar(80) DEFAULT NULL COMMENT 'Modo de autenticação: client_credentials, password, refresh_token, authorization_code, authorization_access_token',
  `scope` varchar(100) DEFAULT NULL COMMENT 'contêiner de permissões',
  `user_id` varchar(80) DEFAULT NULL COMMENT 'Developers do ID do usuário',
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `oauth_clients` (`client_id`, `client_secret`, `redirect_uri`, `grant_types`, `scope`, `user_id`) VALUES
('testclient', 'testpass', 'http://google.com/', 'client_credentials password authorization_code refresh_token', 'file node userinfo cloud', 'mycli');

--
-- Table structure for table `oauth_jwt`
--

DROP TABLE IF EXISTS `oauth_jwt`;

CREATE TABLE IF NOT EXISTS `oauth_jwt` (
  `client_id` varchar(80) NOT NULL COMMENT 'Developers do ID do usuário',
  `subject` varchar(80) DEFAULT NULL,
  `public_key` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `oauth_refresh_tokens`
--

DROP TABLE IF EXISTS `oauth_refresh_tokens`;

CREATE TABLE IF NOT EXISTS `oauth_refresh_tokens` (
  `refresh_token` varchar(40) NOT NULL COMMENT 'Token de atualização do access_token',
  `client_id` varchar(80) NOT NULL COMMENT 'Developers AppId',
  `user_id` varchar(255) DEFAULT NULL COMMENT 'Developers do ID do usuário',
  `expires` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data Hora certificada date("Y-m-d H:i:s")',
  `scope` varchar(2000) DEFAULT NULL COMMENT 'contêiner de permissões',
  PRIMARY KEY (`refresh_token`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `oauth_scopes`
--

DROP TABLE IF EXISTS `oauth_scopes`;

CREATE TABLE IF NOT EXISTS `oauth_scopes` (
  `scope` text  COMMENT 'nome do contêiner',
  `is_default` tinyint(1) DEFAULT NULL COMMENT 'Se é padrão: 1 => Sim, 0 => Não'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `oauth_scopes` (`scope`, `is_default`) VALUES
('userinfo', 1),
('file', 0),
('node', 0),
('cloud', 0),
('share', 0);

--
-- Table structure for table `oauth_users`
--

DROP TABLE IF EXISTS `oauth_users`;

CREATE TABLE IF NOT EXISTS `oauth_users` (
  `username` varchar(255) NOT NULL COMMENT 'Nome de autenticação de username do usuário quando utilizado interno',
  `password` varchar(2000) DEFAULT NULL COMMENT 'Nome de autenticação de password do usuário quando utilizado interno',
  `first_name` varchar(255) DEFAULT NULL COMMENT 'Ao usar interno',
  `last_name` varchar(255) DEFAULT NULL COMMENT 'Ao usar interno',
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- INSERT INTO `oauth_users` (`username`, `password`, `first_name`, `last_name`) VALUES
-- ('user', 'pass', 'xiaocao', 'grasses'),
-- ('username', 'password', 'xiaocao', 'grasses');





