
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("studentId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Assignment | StudyBloom</title>

    <style>
        body {
            margin: 0;
            padding: 20px;
            min-height: 100vh;
            display: grid;
            place-items: center;
            background: linear-gradient(135deg, #f0e9ff, #fff0f5);
            font-family: "Segoe UI", Arial, sans-serif;
            color: #4c3d5d;
            box-sizing: border-box;
        }

        .card {
            width: 100%;
            max-width: 450px;
            padding: 30px;
            background: white;
            border-radius: 22px;
            box-shadow: 0 12px 35px #dcd0e8;
        }

        h1 {
            margin-bottom: 8px;
        }

        .subtitle {
            color: #93839f;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin: 16px 0 7px;
            font-size: 13px;
            font-weight: 600;
        }

        input, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #e5d9ef;
            border-radius: 10px;
            background: #fdfbff;
            box-sizing: border-box;
        }

        button, .back {
            display: block;
            width: 100%;
            padding: 13px;
            margin-top: 20px;
            border: 0;
            border-radius: 10px;
            text-align: center;
            text-decoration: none;
            font-weight: 700;
            box-sizing: border-box;
        }

        button {
            background: #8b73b8;
            color: white;
            cursor: pointer;
        }

        .back {
            margin-top: 10px;
            background: #f2ebfa;
            color: #765f96;
        }
    </style>
</head>

<body>
    <main class="card">
        <div style="font-size: 35px;">🌸</div>
        <h1>Add Assignment</h1>
        <p class="subtitle">Every little task is a step forward.</p>

        <form action="<%= request.getContextPath() %>/add-assignment"
              method="post">

            <label for="title">Assignment title</label>
            <input type="text" id="title" name="title"
                   maxlength="200" required
                   placeholder="e.g. Python practical">

            <label for="subject">Subject</label>
            <input type="text" id="subject" name="subject"
                   maxlength="100" required
                   placeholder="e.g. Python Programming">

            <label for="dueDate">Due date</label>
            <input type="date" id="dueDate" name="dueDate" required>

            <button type="submit">Save Assignment ♡</button>
        </form>

        <a class="back"
           href="<%= request.getContextPath() %>/dashboard">
            ← Back to Dashboard
        </a>
    </main>
</body>
</html>
