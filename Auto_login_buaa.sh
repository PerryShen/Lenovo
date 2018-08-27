#! /bin/bash

function do_login(){
    username=$1
    password=$2
    curl -X POST --data "action=login&ac_id=1&user_ip=&nas_ip=&user_mac=&save_me=1&ajax=1&username=$username&password=$password "  https://gw.buaa.edu.cn:801/include/auth_action.php -k
}

function do_logout(){
    username=$1
    curl -X POST --data "action=logout&ajax=1&username=$username" https://gw.buaa.edu.cn:802/include/auth_action.php -k  #登录之后重新打开认证界面，会有注销账号的按钮，这个按钮背后的脚本有网络POST命令
}

case "$1" in                                                                        
    login)
        shift 
        echo "connecting server at buaa.edu.cn:801/include/auth_action.php"
        do_login "$@"                                                               # "$@"表示所有参数列表
        [ $? -eq 0 ] && echo "Auto_login<$1><password>"                      # "$?"表示上一个程序之行完的返回值（数字值），返回为“0”时表示程序执行成功
        echo -e "\n"
        ;;
    logout)
	shift
        echo "connecting server at buaa.edu.cn:802/include/auth_action.php"
        do_logout "$@"
	[ $? -eq 0 ] && echo "Auto_logout<$1>"
	echo -e "\n"
        ;;
    version)
        echo "verion: 1.0.0"
        ;;
    help | *)
        echo " login|logout|version|help"
        ;;
esac


#keshengshen@163.com
#2018-8-27 10:29:03 done 
#Function: login and logout the university network authentication by a simple shell script.
