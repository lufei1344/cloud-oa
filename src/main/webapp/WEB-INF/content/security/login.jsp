<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录</title>
    <meta name="keywords" content="响应式后台">
    <meta name="description" content="现代技术">
    <link rel="shortcut icon" href="favicon.ico"> 
    <link href="${ctx}/scripts/hplus/css/bootstrap.min.css" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/animate.min.css" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/style.min.css" rel="stylesheet">
    
</head>

<body class="gray-bg">

    <div class="middle-box text-center loginscreen  animated fadeInDown">
        <div>
            <div>

                <h1 class="logo-name">H+</h1>

            </div>
            <h3>欢迎使用 H+</h3>
            <form class="m-t" role="form" action="${ctx }/login" method="post">
                <div class="form-group">
                    <input type="text" class="form-control" placeholder="用户名" id="username" name="username" value="admin" autocomplete="off">
                </div>
                <div class="form-group">
                    <input type="password" class="form-control" placeholder="密码" id="password" name="password" value="123456">
                </div>
                <div id="remember-me" class="pull-left">
					<input type="checkbox" name="remember" id="remember" /> <label
						id="remember-label" for="remember">记住我</label>
					<label>[admin/123456;snaker/123456;test/123456]</label>
				</div>
                <button type="submit" class="btn btn-primary block full-width m-b">登 录</button>
                <p class="text-muted text-center"> <a href="login.html#"><small>忘记密码了？</small></a> | <a href="register.html">注册一个新账号</a>
                </p>

            </form>
        </div>
    </div>
    <script src="${ctx}/scripts/hplus/js/jquery.min.js"></script>
    <script src="${ctx}/scripts/hplus/js/bootstrap.min.js"></script>
</body>
</html>
