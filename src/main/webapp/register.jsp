
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #eef2ff;
            margin: 0;
            padding: 40px 15px;
        }
        .card {
            background: white;
            max-width: 420px;
            margin: auto;
            padding: 28px;
            border-radius: 12px;
            box-shadow: 0 4px 15px #ccd0dd;
        }
        input, button {
            width: 100%;
            box-sizing: border-box;
            padding: 12px;
            margin: 9px 0;
        }
        button {
            background: #4f46e5;
            color: white;
            border: 0;
            cursor: pointer;
        }
        .error { color: #b91c1c; }
    </style>
</head>
<body>
<div class="card">
    <h2>Create Student Account</h2>
    <p>Start organizing your assignments.</p>

    <% if (request.getAttribute("error") != null) { %>
        <p class="error">${error}</p>
    <% } %>

    <form action="${pageContext.request.contextPath}/register"
          method="post">
        <label>Full Name</label>
        <input type="text" name="name" required maxlength="100">

        <label>Email</label>
        <input type="email" name="email" required maxlength="150">

        <label>Password (minimum 8 characters)</label>
        <input type="password" name="password"
               minlength="8" required>

        <button type="submit">Register</button>
    </form>

    <p>Already registered?
        <a href="${pageContext.request.contextPath}/login.jsp">
            Log in
        </a>
    </p>
</div>
</body>
</html>
>