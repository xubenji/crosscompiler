<<<<<<< HEAD
# 一，远程服务器编写操作系统的环境搭建
# 搭建环境选用ubuntu18，gcc版本：7.5.0
# 请安装对应操作系统和gcc版本，否则会出现许多依赖问题
# ubuntu18.04 apt-get默认安装gcc-7.5.0，其他版本ubuntu就不一定了
  1，搭建交叉编译器  
    >: bash buildtools.sh  
    这个脚本一键编译安装交叉编译器gcc-8.1.1和gdb多架构版本  
    运行完脚本以后将编译好的二进制文件添加到环境变量。  
    打开环境变量文件  
    >: vim /etc/environment  
    将路径“/usr/local/cross-compiler/bin”保存到其他路径末尾，然后重启，保存好以后如下所示。  
    PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/cross-compiler/bin"  

  2，搭建支持raspi3的qemu  
    >:bash buildqemu.sh  
    这个脚本一键编译安装支持仿真树莓派3的qemu, 在模拟树莓派3的时候内存大小不能太大也不能太小（推荐128MB~512MB），否则会如下错误：  
    Unexpected error in visit_type_uintN() at /builddir/build/BUILD/qemu-3.0.0/qapi/qapi-visit-core.c:164:  
    qemu-system-aarch64: Parameter 'vcram-base' expects uint32_t  

# 二，搭建vs code+gdb+qemu远程调试
# 使用visual code远程调试内核的方式有两种
# 第一种是本地安装一个visual code客户端然后使用remote ssh插件连接到远程服务器
# 这个方法相对第二种比较简单，但是缺点是本地需要安装一个visual code和xshell，所以能够支持这样调试的设备有限

  1，在你本地的电脑安装配置remote ssh  
     在插件栏搜索安装remote ssh  
     点击右侧栏目中的小电视图标  
     然后点击齿轮的东西，搜索框中会弹出config配置文件
     点击config打开文件编辑如下内容：  
     Host （随便起个名字）  
     HostName （你服务器的ip地址）  
     User （登陆服务的用户名）  
     Port  (你连接的服务器的端口号，更改了ssh端口号的同学一定要记得填写）    
     IdentityFile (自动登录的ssh密匙文件，位置一般是.ssh/id_rsa, .ssh文件每个系统都不同一般是用户文件夹下，苹果的是"/Users/username/.ssh/id_rsa"）
     
  2，连接到远程主机
     并在远程主机上安装gdb  
     点击run->Add configurationd  
     将以下内容复制粘贴进配置文件（不要复制减号并注意删除原有配置）  

------------------------------------------------------------------------------------------------------------------------------  
  
{  
    // Use IntelliSense to learn about possible attributes.  
    // Hover to view descriptions of existing attributes.  
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387   
        "version": "0.2.0",  
        "configurations": [  
        {  
        "name": "GDB debug",  
        "type": "cppdbg",  
        "request": "launch",  
        "program": "${workspaceFolder}/kernel8.elf",  
        "args": [],  
        "stopAtEntry": true,  
        "cwd": "${workspaceFolder}",  
        "environment": [],  
        "externalConsole": false,  
        "MIMode": "gdb",  
        "targetArchitecture": "arm64",  
        //"preLaunchTask": "build",  
        "setupCommands":  
        [  
        {  
        "description": "Enable pretty-printing for gdb",  
        "text": "-enable-pretty-printing",  
        "ignoreFailures": true  
        }  
        ],    
        "miDebuggerPath": "/usr/bin/gdb-multiarch",  
        "miDebuggerServerAddress": "127.0.0.1:1234"  
        }  
        ]  
        }  
  
---------------------------------------------------------------------------------------------------------------------------------  
  
        其中preLaunchTask是在debugger之前执行的任务，我们现在用不到，所以将其注释掉。    
        保存好以后使用xshell连接虚拟主机，然后在工作文件夹输入make run(注意：这个指令每个makefile都不同，需要具体查看makefile才能知道）    
        然后点击run->start Debugging   
        然后就可以开始调试了（虚拟主机如果延迟很高，等待时间或许会很长）  


# 配置vs code online+网页访问ubuntu界面  
# 在很多设备上我们无法安装xshell和vscode，这个时候我们就需要使用浏览器编辑代码  
# 微软在2019年5月发布了vs code online，给出了在浏览器编辑代码的方案  
# 我们还需要配置一个可以访问ubuntu桌面的网页地址，以后我们只需要在网页输入地址就可以访问到ubuntu桌面了，这样就能直接在网页上看到qemu中的信息  
        1，配置使用地址访问ubuntu桌面  
        先在namecheap上买一个域名，域名地址可以自己随便选，普遍在2美金左右（喜欢其他的域名提供商可以选其他的，我选namecheap是因为它好配置）  
        再将域名指向你服务器的IP地址  
        然后运行OneClickDesktop_cn.sh  
        这个脚本会自动搭建桌面环境（记得在卖服务器的网址上把对应的端口开放，不然网页无法访问到）  
        2，配置vs code online   
           安装Docker  
           安装脚本：  
           官方源  
           curl -fsSL https://get.docker.com | bash  
           阿里云源  
           curl -fsSL https://get.docker.com | bash -s docker –mirror Aliyun  
           如果还有配置开机自启、配置Docker用户组、配置国内镜像源之类的更多需求，可见这篇文章：https://haoduck.com/239.html  

           部署code-server  
           命令说明：  
          -dit 后台、交互式终端  
          –name code-server 设置容器名为code-server，可以自行设置  
          –restart=always 容器总是重启(意外退出、重启服务器都会自动开启)  
          -p 8080:8080 映射容器的8080端口到宿主机8080端口，8443是https端口，但要配置SSL证书，这里就不说这个了  
          -v "$PWD:/home/coder/project" 当前目录($PWD)和容器的/home/coder/project配置数据持久化，可以自行设置前面的$PWD改为你想要的路径  
          -u "$(id -u)(id -g)" 设置容器用户  
          -e PASSWORD=’123456′ 设置密码为123456  

          docker run -dit –name code-server \  
          –restart=always \  
          -p 8080:8080 \  
          -v "$PWD:/home/coder/project" \  
          -u "$(id -u):$(id -g)" \  
          -e PASSWORD=’123456′ \  
          codercom/code-server:latest  
          运行完成，就可以通过IP:8080访问  

