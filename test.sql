-- MySQL dump 10.13  Distrib 5.5.27, for osx10.6 (i386)
--
-- Host: localhost    Database: test
-- ------------------------------------------------------
-- Server version	5.5.27

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tid` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `content` text NOT NULL,
  `photo` varchar(50) NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tid` (`tid`)
) ENGINE=MyISAM AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (45,19,0,'asdasdasda','p1XIDbl35HHCOLqNyCVsOmP5.JPG','2012-08-18 12:35:54'),(46,1,0,'afafa@aaa.com','','2012-08-18 14:16:51'),(47,36,36,'おもしろい．兴味がある !','','2012-08-18 17:48:26'),(48,12,0,'again?','','2012-08-18 17:52:38'),(49,35,0,'おもしろい．\r\n<div>\r\n兴味がある !','','2012-08-18 18:10:46'),(50,35,0,'おもしろい．\r\n<div>\r\n兴味がある !!!!','','2012-08-18 18:19:53');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `threads`
--

DROP TABLE IF EXISTS `threads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `threads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `photo` varchar(50) NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `updated` (`updated`)
) ENGINE=MyISAM AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `threads`
--

LOCK TABLES `threads` WRITE;
/*!40000 ALTER TABLE `threads` DISABLE KEYS */;
INSERT INTO `threads` VALUES (32,35,'面白法人カヤック×日本広告制作協会によるワークショップを実施','朝日新聞社が主催する「朝日地球環境フォーラム」の分科会のひとつとして、\r\n10月16日（火）に面白法人カヤック×日本広告制作協会（OAC）による「未来をつくるワークショップ」を実施します。\r\n当日は代表 柳澤大輔、意匠部 林真由美、企画部 玉田雄以が参加し、\r\nみなさんのアイデアづくりをサポートします。\r\n\r\nご興味のある方は、ぜひご参加ください！\r\nhttp://www.kayac.com/news/2012/08/oac','','2012-08-18 17:35:40','2012-08-18 17:35:40'),(38,35,'Liziyueの掲示板','Liziyueの掲示板','','2012-08-18 18:30:35','2012-08-18 18:30:35'),(34,0,'大量簡単写真交換アプリ「写真袋」がさらに便利に！PC専用「写真袋アップローダー」登場','株式会社カヤック（本社：神奈川県鎌倉市、代表取締役CEO：柳澤大輔、以下「カヤック」）は、IDとパスワードの登録が不要、合言葉だけで大量に写真の交換ができるアプリ「写真袋」から、PC専用の「写真袋アップローダー」をリリースいたしました。iPhoneアプリ「写真袋」を利用するユーザーは、スマートフォンからだけでなく、PCからも写真を共有することが可能になります。また、iPhoneアプリ、Androidアプリをアップデートし、新機能を追加したことを発表いたします。\r\n\r\n【「写真袋アップローダー」について】\r\n「写真袋アップローダー」は、デジタルカメラで撮影してPCに取り込んだたくさんの写真を簡単にPCからアップロードし、iPhone、Andoridアプリ「写真袋」を使用する複数の人と共有することができるサービスです。結婚式の二次会、キャンプや音楽フェスなど多くの人が集まるイベントや、旅行、子どもの記念日などのシチュエーションでデジタルカメラでたくさんの写真を撮影したときや、過去に撮影してパソコンに保存してある写真を共有したいときの利用を想定します。\r\n','','2012-08-18 17:38:59','2012-08-18 17:38:59'),(19,0,'aaa','aaaaa','hkYLiJm0zMDwxIyClSxtgqqr.JPG','2012-08-18 12:28:55','2012-08-18 12:35:56'),(11,0,'qiguai','zenmebujianle','','2012-08-14 12:01:39','2012-08-14 12:01:39'),(12,0,'again','','','2012-08-14 12:12:37','2012-08-18 17:52:38'),(13,0,'more again','','','2012-08-14 12:14:20','2012-08-14 12:14:20'),(33,36,'「2012年度 東京企画構想学舎」にカヤックが登場！','オレンジ･アンド･パートナーズ代表 小山薫堂氏が学長を務めるコミュニケーション・スクール「東京企画構想学舎」。\r\nそのカリキュラムのひとつ、「企画12社セミナー」の第5回目、9月13日（木）にカヤックが登場します。\r\n弊社代表 柳澤大輔も参加予定です。\r\nご興味のある方は、ぜひご参加ください。\r\nhttp://www.kayac.com/news/2012/07/kikaku_yana','','2012-08-18 17:38:00','2012-08-18 17:38:00'),(35,0,'神代がアプリ開発の極意を語っています！','8月2日（木）に発売された日経コンピュータの、「スマホアプリ　開発の最適解」という特集の中で、\r\n手早くアプリを開発するために「とにかく動くものを作るのが重要」とHTMLファイ部神代友行が語っています。\r\nスマホやタブレットの開発したいけど、これまでのシステム開発の常識では通用しないと思われていた方はぜひ、ご覧ください！','','2012-08-18 17:39:34','2012-08-18 18:19:53'),(36,0,'女子高生と自称二枚目執事が、鎌倉を声で案内する「もえナビ」リリース！','株式会社カヤック（本社：神奈川県鎌倉市、代表取締役：柳澤大輔）は、スマホにダウンロードするだけで簡単に使える音声ガイドアプリ『もえナビ』シリーズをApp Storeにてリリースいたしました。『もえナビ』は、カヤックが運営する50万人以上の声優が集う音声コミュニティサイト「koebu」の協力のもと、オリジナルのガイド文を声優が読み上げる音声ガイドアプリです。6月4日にリリースするのは、カヤックが本社を置く鎌倉の街を案内する観光ガイド。鎌倉に詳しい女子高生キャラクターが案内する「もえナビ-鎌倉女子高生-」と、自称二枚目執事が案内する「もえナビ-鎌倉執事-」の2バージョンを同時リリースいたします（※1）。\r\nhttp://www.kayac.com/news/2012/06/moenavi','','2012-08-18 17:40:30','2012-08-18 17:48:26'),(40,0,'ゲーム','画像','_9zrijVdklVxCIPuCYdDrTEb.png','2012-08-19 03:28:07','2012-08-19 03:28:07');
/*!40000 ALTER TABLE `threads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `pass` varchar(50) NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (35,'admin','kayacadmin','2012-08-18 17:09:14'),(36,'liziyue','liziyue','2012-08-18 17:13:34');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-08-19 11:29:01
