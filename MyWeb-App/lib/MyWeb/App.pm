#!/usr/bin/perl
package MyWeb::App;

use Dancer ;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Request;
use POSIX;

our $VERSION = '0.1';

true;

set 'database'     => File::Spec->catfile(File::Spec->tmpdir(), 'test.db');
set 'session'      => 'Simple';
set 'template'     => 'template_toolkit';
set 'logger'       => 'console';
set 'log'          => 'debug';
set 'show_errors'  => 1;
set 'startup_info' => 1;
set 'warnings'     => 1;
set 'layout'       => 'main';
 
my $flash;
my $admin_name = 'admin' ;
my $admin_pass = 'kayacadmin' ;
 
sub set_flash {
    my $message = shift;

    $flash = $message;
}
 
sub get_flash {
 
    my $msg = $flash;
    $flash = "";

    return $msg;
}

sub process_text {
    my $t = shift;
    $t =~ s{(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])}{<a href=\"$1\" target=\"_blank\">$1</a>}ig;
    $t =~ s{(\b[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4})}{<a href=\"mailto:$1\">$1</a>}ig;
    return $t;
}

before_template sub {
    my $tokens = shift;

    $tokens->{'css_url'} = request->base . 'css/style.css';
    $tokens->{'login_url'} = uri_for('/login');
    $tokens->{'logout_url'} = uri_for('/logout');
    $tokens->{'blog_url'} = uri_for('/blog');
    $tokens->{'reg_url'} = uri_for('/reg');
    $tokens->{'add_url'} = uri_for('/add');
    $tokens->{'search_url'} = uri_for('/search'),
    $tokens->{'admin_url'} =  uri_for('/admin'),
    $tokens->{'user_url'} =  uri_for('/user'),

};


sub gen_randstr {
    my $length = shift;
    my @chars = ('a'..'z','A'..'Z','0'..'9','_');
    my $randstr;
    foreach (1..$length) {
    $randstr .= $chars[rand @chars];
    }
    return $randstr;
}

get '/' => sub {
    set 'layout'       => 'main';
    my $page = params->{page} || 1;
    my $from = ($page - 1) * 10;
    my $sql = "select id, uid, title , updated, TIME_TO_SEC(TIMEDIFF(CURRENT_TIMESTAMP, updated)) < 86400 as new from threads order by updated desc LIMIT ${from},10";
    my $sth = database->prepare($sql) or die database->errstr;
    $sth->execute or die $sth->errstr;
    my @entries = $sth->fetchall_arrayref({});
    #pager
    $sql = 'SELECT COUNT(*) FROM threads';
    $sth = database->prepare($sql) or die database->errstr;
    $sth->execute or die $sth->errstr;
    my $count = $sth->fetchrow_array;

    template 'show_entries.tt', {
       'msg' => get_flash(),
       'entries' => @entries,
       'page_now' => $page,
       'page_total' => ceil($count / 10)
};
#UPDATE threads SET updated = CURTIME   CURRENT_TIMESTAMP WHERE id=?
};


any ['get', 'post'] => '/reg' => sub {

    my $err;
    my $pass ;
    my $pass_again ;
    my $uname ;
    my $check_sql ;
    my $check_sth ;

    if ( request->method() eq "POST" ) {

       $uname = params->{'username'} ;
       $pass = params->{'password'} ;
       $pass_again = params->{'password2'} ;
       
       if(!($uname =~ /^[a-zA-Z0-9]+$/ && $pass =~ /^[\s\S]{6,}$/))
       {
          $err = "半角文字使ってください,パスワードが短いすぎる?" ;
       } else{
           $check_sql = "select id from users where name = "."'".$uname."'" ;
           $check_sth = database->prepare($check_sql) or die database->errstr;
           $check_sth->execute or die $check_sth->errstr;
           if ($check_sth->fetchrow_array){
                 $err = "独特の名前をどうぞ" ;
           } 
           elsif($pass ne $pass_again){
              $err = "パスワードが一致しません";
           }  else {
                     
               my $insert_user_sql = 'insert into users (name,pass) values(?,?)' ;
               my $sth = database->prepare($insert_user_sql) or die database->errstr;
	           $sth->execute(params->{'username'}, params->{'password'}) or die $sth->errstr;

               session vername => params->{'username'} ;
               session 'logged_in' => true;
               set_flash("いらっしゃい!".session('vername'));
               return redirect '/';
           }
       }


    }

# display login form
    template 'register.tt', {            
           'reg_url' => uri_for('/reg'),
	       'err' => $err,
    };

};	


any ['get', 'post'] => '/login' => sub {
    my $err;
    my $my_pass = '' ;
    my $user_err ;

    if ( request->method() eq "POST" ) {
           # process form input
          my $sql = "select pass from users where name = '".params->{'username'}."'";
          my $sth = database->prepare($sql) or die database->errstr;
          $sth->execute or die $sth->errstr;
          $my_pass = $sth->fetchrow_array ;
            #return "$my_pass" ;

          if(params->{'username'} eq $admin_name && params->{'password'} eq $admin_pass){
              session 'admin' => true ;
             # return  session 'admin' ;
          }
    #return  session 'admin' ;
          if(!$my_pass){
             $user_err = "会員がいません" ;
          }
          elsif(params->{'password'} ne $my_pass){
              $err = "パスワードが正しくありません";
          } 
          else {
                   session 'logged_in' => true;
                   session vername => params->{'username'} ;
                   set_flash('ログインした.');

                   return redirect '/';
          }
     
    }

    # display login form
    template 'login.tt', {
           'err' => $err,
           'user_err' => $user_err,
    };

};

get '/logout' => sub {
    session->destroy;
    set_flash('ログアウトした.');
    redirect '/';
};



get '/add' => sub {
     set 'layout'       => 'main';
     template 'add.tt', {
	'add_url' => uri_for("/add"),
     };

} ;


post '/add' =>sub {

    my $uid = 0 ;
    my $owner_name = 'guest' ;
    my $photo = ''  ;
    my $upload = upload('image'); 

    if ( session('logged_in')){
	    my $uid_sql = "select id from users where name = "."'".session('vername')."'" ;
	    my $uid_sth = database->prepare($uid_sql) or die database->errstr;
	    $uid_sth->execute or die $uid_sth->errstr;
        $uid = $uid_sth->fetchrow_array ;
    };

    if($upload && $upload->type =~ /^image/) {
        $photo = &gen_randstr(24).(substr($upload->filename, rindex($upload->filename, '.')));
        $upload->copy_to('public/uploads/'.$photo);
    }

    my $sql = 'insert into threads (uid, title,content,photo,updated) values (?,?,?,?,CURRENT_TIMESTAMP)';
    my $sth = database->prepare($sql) or die database->errstr;
    $sth->execute($uid,params->{'title'}, params->{'text'},$photo) or die $sth->errstr;

    params->{'text'} =~ s|<.+?>||g ;     
    params->{'text'} =~ s|\n|<br />|g;  

    template 'add.tt', {
	    'add_url' => uri_for("/add"),
    };
    redirect '/';

};

get '/blog/:id' => sub {

    set 'layout'       => 'main';
    my $err;
    my $myid = param('id');
    my $uid = 0 ;
    my $poster_name = 'guest' ;

    if ( session('logged_in')){
        $poster_name =  session('vername') ;
    };

    my $sql = "select * from threads where id = $myid";
    my $sth = database->prepare($sql) or die database->errstr;
    $sth->execute or die $sth->errstr;

    my $uid_sql = "select uid from threads where id = $myid";
    my $uid_sth = database->prepare($uid_sql) or die database->errstr;
    $uid_sth->execute or die $uid_sth->errstr;
    my $blog_uid = $uid_sth->fetchrow_array ;

    my $blog_sql = "select name from users where id = "."'".$blog_uid."'" ;
    my $blog_sth = database->prepare($blog_sql) or die database->errstr;
    $blog_sth->execute or die $blog_sth->errstr;
    my $blog_uname = $blog_sth->fetchrow_array ;

    my $post_sql = "select p.id, u.name, p.content, p.photo, p.datetime from posts p LEFT JOIN users u on u.id = p.uid where p.tid = $myid order by datetime ASC";
    my $post_sth = database->prepare($post_sql) or die database->errstr;
    $post_sth->execute or die $post_sth->errstr;

    my @blog_entries = $sth->fetchrow_hashref;
    my @post_entries = $post_sth->fetchall_arrayref({});

    $blog_entries[0]{content} = &process_text($blog_entries[0]{content});
    my $i = 0;
    while($_ = $post_entries[0][$i]) {
       $post_entries[0][$i]{content} = &process_text($post_entries[0][$i]{content});
       $i++;
    }

    template 'blog.tt', {
           'post_url' => uri_for("/blog/${myid}"),
           'blog_entries' => @blog_entries,
           'blog_owner' => $blog_uname ,
           'post_entries' => @post_entries,
           'err' => $err,
    };

};


post '/blog/:id' => sub {
    set 'layout'       => 'main';
    my $err;
    my $myid = param('id');
    my $uid = 0 ;
    my $poster_name = 'guest' ;
    my $photo = '' ;
    my $upload = upload('image'); 

    if($upload && $upload->type =~ /^image/) {
       $photo = &gen_randstr(24).(substr($upload->filename, rindex($upload->filename, '.')));
       $upload->copy_to('public/uploads/'.$photo);
    }

    if ( session('logged_in')){
        $poster_name =  session('vername') ;
	    my $uid_sql = "select id from users where name = "."'".session('vername')."'" ;
        
	    my $uid_sth = database->prepare($uid_sql) or die database->errstr;
	    $uid_sth->execute or die $uid_sth->errstr;
        $uid = $uid_sth->fetchrow_array ;
    };

    my $insert_sql = 'insert into posts (tid,uid,content,photo) values (?, ?,?,?)';
    my $insert_sth = database->prepare($insert_sql) or die database->errstr;
    $insert_sth->execute($myid,$uid,params->{'reply'},$photo) or die $insert_sth->errstr;

    params->{'reply'} =~ s|<.+?>||g ;     
    params->{'reply'} =~ s|\n|<br />|g;  


    my $current_sql = "update threads set updated = CURRENT_TIMESTAMP WHERE id= $myid" ;
    my $current_sth = database->prepare($current_sql) or die database->errstr;
    $current_sth->execute or die $current_sth->errstr;

    redirect "/blog/$myid";
};

get '/search' => sub {
    set 'layout'       => 'main';
    my $page = params->{page} || 1;
    my $from = ($page - 1) * 10;
    my $search_key = params->{'searchkey'} ;
    my $search_sql = "select *, TIME_TO_SEC(TIMEDIFF(CURRENT_TIMESTAMP, updated)) < 86400 as new from threads where content LIKE '%${search_key}%' OR title LIKE '%${search_key}%' ORDER BY updated DESC" ;
    my $search_sth = database->prepare($search_sql) or die database->errstr;
    $search_sth->execute() or die $search_sth->errstr;
    my @entries = $search_sth->fetchall_arrayref({});
    my $count = @entries;
    template 'search.tt', {
      'search_entries' => splice(@entries, $from, 10),
      'page_now' => $page,
      'page_total' => ceil($count / 10)
    };
} ;

get '/admin' => sub {
    my $sql = 'select id, uid, title , updated from threads order by updated desc';
    my $sth = database->prepare($sql) or die database->errstr;
    $sth->execute or die $sth->errstr;

    template 'admin.tt', {
           
           'entries' => $sth->fetchall_arrayref({}),
    };

} ;

post '/admin' => sub {
    my $tid = params->{'enid'} ;
    my $delete_sql = "delete from threads where id = $tid";
    my $delete_sth = database->prepare($delete_sql) or die database->errstr;
    $delete_sth->execute or die $delete_sth->errstr;

    my $sql = "delete from posts where tid = $tid";
    my $sth = database->prepare($sql) or die database->errstr;
    $sth->execute or die $sth->errstr;


    redirect "/admin";


} ;

get '/user' => sub {

    set 'layout'       => 'main';
    my $user = session('vername');

    my $user_sql = "select t.id , u.name, t.title ,t.updated from threads t LEFT JOIN users u on u.id = t.uid where u.name = "."'".$user."'" ;
    my $user_sth = database->prepare($user_sql) or die database->errstr;
    $user_sth->execute or die $user_sth->errstr;

    template 'user.tt', {
      'entries' => $user_sth->fetchall_arrayref({}),
     
    };

} ;

post '/user' => sub{
    my $tid = params->{'enid'} ;
    my $delete_sql = "delete from threads where id = $tid";
    #return $tid ;
    my $delete_sth = database->prepare($delete_sql) or die database->errstr;
    $delete_sth->execute or die $delete_sth->errstr;

    redirect "/user";

} ;

start;
