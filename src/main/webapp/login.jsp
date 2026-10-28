
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Login | StudyBloom</title>

    <style>
        :root {
            --purple: #8d79bd;
            --purple-dark: #715a9f;
            --pink: #e8a8c8;
            --text: #514360;
            --muted: #94869f;
            --border: #eee4f3;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            padding: 30px 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: "Segoe UI", Arial, sans-serif;
            color: var(--text);
            background:
                radial-gradient(circle at 10% 15%,
                    #f8ddeb 0, transparent 30%),
                radial-gradient(circle at 90% 85%,
                    #dff5eb 0, transparent 32%),
                linear-gradient(135deg, #eee7ff, #fff5f9 55%, #f0ebff);
            overflow-x: hidden;
            position: relative;
        }

        .decoration {
            position: fixed;
            pointer-events: none;
            user-select: none;
            opacity: 0.6;
            z-index: 0;
        }

        .flower-one {
            top: 7%;
            left: 8%;
            font-size: 65px;
            transform: rotate(-15deg);
        }

        .flower-two {
            right: 8%;
            bottom: 8%;
            font-size: 85px;
            transform: rotate(15deg);
        }

        .sparkle-one {
            top: 20%;
            right: 15%;
            font-size: 32px;
            color: #c19ad7;
        }

        .sparkle-two {
            left: 13%;
            bottom: 20%;
            font-size: 30px;
            color: #d99fc0;
        }

        .login-wrapper {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 440px;
        }

        .card {
            background: rgba(255, 255, 255, 0.91);
            padding: 38px;
            border: 1px solid rgba(255, 255, 255, 0.9);
            border-radius: 26px;
            box-shadow: 0 20px 60px rgba(100, 75, 125, 0.14);
            backdrop-filter: blur(12px);
        }

        .brand {
            text-align: center;
            margin-bottom: 25px;
        }

        .brand-icon {
            display: grid;
            place-items: center;
            width: 76px;
            height: 76px;
            margin: 0 auto 15px;
            border-radius: 25px;
            background: linear-gradient(135deg, #eee5ff, #ffe5f0);
            font-size: 40px;
            box-shadow: 0 8px 20px rgba(163, 131, 193, 0.15);
        }

        .brand-name {
            margin: 0;
            font-size: 29px;
            font-weight: 800;
            letter-spacing: -1px;
            color: #66517f;
        }

        .brand-name span {
            color: #c18ebd;
        }

        .tagline {
            margin: 9px 0 0;
            color: var(--muted);
            font-size: 13px;
            line-height: 1.6;
        }

        .welcome {
            margin: 28px 0 22px;
        }

        .welcome h2 {
            margin: 0 0 7px;
            font-size: 22px;
            letter-spacing: -0.4px;
        }

        .welcome p {
            margin: 0;
            color: var(--muted);
            font-size: 13px;
        }

        .message {
            padding: 12px 14px;
            margin: 0 0 18px;
            border-radius: 11px;
            font-size: 13px;
            line-height: 1.5;
        }

        .success {
            color: #397c5c;
            background: #e8f7ef;
            border: 1px solid #d5efdf;
        }

        .error {
            color: #a94d65;
            background: #fff0f3;
            border: 1px solid #f7d9e1;
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #665574;
            font-size: 13px;
            font-weight: 700;
        }

        input {
            display: block;
            width: 100%;
            padding: 13px 14px;
            border: 1px solid #e8ddec;
            border-radius: 12px;
            background: #fffafd;
            color: var(--text);
            font-family: inherit;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        input::placeholder {
            color: #b5a9bf;
        }

        input:focus {
            border-color: #aa91d1;
            box-shadow: 0 0 0 4px rgba(170, 145, 209, 0.14);
        }

        .login-button {
            display: block;
            width: 100%;
            margin-top: 25px;
            padding: 14px;
            border: none;
            border-radius: 12px;
            background: linear-gradient(100deg, #917bc2, #c18dbd);
            color: white;
            font-family: inherit;
            font-size: 14px;
            font-weight: 750;
            cursor: pointer;
            box-shadow: 0 8px 18px rgba(145, 123, 194, 0.25);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .login-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 11px 22px rgba(145, 123, 194, 0.32);
        }

        .login-button:active {
            transform: translateY(0);
        }

        .register-text {
            margin: 23px 0 0;
            text-align: center;
            color: var(--muted);
            font-size: 13px;
        }

        .register-text a {
            color: var(--purple-dark);
            font-weight: 750;
            text-decoration: none;
        }

        .register-text a:hover {
            color: #bd7eae;
            text-decoration: underline;
        }

        .footer {
            margin-top: 22px;
            text-align: center;
            color: #9d8dab;
            font-size: 11px;
        }

        .footer span {
            color: #d69bc0;
        }

        @media (max-width: 480px) {
            body {
                padding: 20px 14px;
            }

            .card {
                padding: 27px 22px;
                border-radius: 22px;
            }

            .brand-name {
                font-size: 26px;
            }

            .brand-icon {
                width: 67px;
                height: 67px;
                font-size: 35px;
            }

            .flower-one {
                top: 2%;
                left: 2%;
                font-size: 40px;
            }

            .flower-two {
                right: 2%;
                bottom: 2%;
                font-size: 48px;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after {
                scroll-behavior: auto !important;
                transition: none !important;
            }
        }
    </style>
</head>

<body>

    <span class="decoration flower-one" aria-hidden="true">🌸</span>
    <span class="decoration flower-two" aria-hidden="true">🌷</span>
    <span class="decoration sparkle-one" aria-hidden="true">✦</span>
    <span class="decoration sparkle-two" aria-hidden="true">✧</span>

    <main class="login-wrapper">

        <section class="card">

            <header class="brand">
                <div class="brand-icon" aria-hidden="true">✿</div>

                <h1 class="brand-name">
                    study<span>bloom</span>
                </h1>

                <p class="tagline">
                    Your little space to grow, learn and shine ✨
                </p>
            </header>

            <div class="welcome">
                <h2>Welcome back! 🌷</h2>
                <p>Log in to manage your assignments and deadlines.</p>
            </div>

            <% if ("1".equals(request.getParameter("registered"))) { %>
                <p class="message success" role="status">
                    Registration successful! Please log in.
                </p>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
                <p class="message error" role="alert">
                    ${error}
                </p>
            <% } %>

            <form action="${pageContext.request.contextPath}/login"
                  method="post">

                <div class="form-group">
                    <label for="email">Email address</label>

                    <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="Enter your email"
                        autocomplete="email"
                        required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>

                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Enter your password"
                        autocomplete="current-password"
                        required>
                </div>

                <button type="submit" class="login-button">
                    Log In &nbsp; →
                </button>

            </form>

            <p class="register-text">
                New student?
                <a href="${pageContext.request.contextPath}/register.jsp">
                    Create an account
                </a>
            </p>

        </section>

        <footer class="footer">
            Made with <span>♡</span> for your little wins
        </footer>

    </main>

</body>
</html>
