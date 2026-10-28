
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.studenttracker.model.Assignment" %>
<%@ page import="java.time.LocalDate" %>

<%
    if (session.getAttribute("studentId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Assignment> assignments =
        (List<Assignment>) request.getAttribute("assignments");

    if (assignments == null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }

    Integer totalValue = (Integer) request.getAttribute("total");
    Integer completedValue = (Integer) request.getAttribute("completed");
    Integer pendingValue = (Integer) request.getAttribute("pending");
    Integer overdueValue = (Integer) request.getAttribute("overdue");
    Integer progressValue = (Integer) request.getAttribute("progress");

    int total = totalValue == null ? assignments.size() : totalValue;
    int completed = completedValue == null ? 0 : completedValue;
    int pending = pendingValue == null ? 0 : pendingValue;
    int overdue = overdueValue == null ? 0 : overdueValue;
    int progress = progressValue == null ? 0 : progressValue;

    progress = Math.max(0, Math.min(100, progress));

    String search = (String) request.getAttribute("search");
    if (search == null) search = "";

    String context = request.getContextPath();

    String studentName = (String) session.getAttribute("studentName");
    if (studentName == null || studentName.trim().isEmpty()) {
        studentName = "Student";
    }

    String safeName = studentName.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");

    String safeSearch = search.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Study Space | StudyBloom</title>

<style>
:root {
    --ink: #40364b;
    --muted: #857a91;
    --purple: #8d79bd;
    --line: #eee8f3;
    --shadow: 0 12px 35px rgba(85,63,110,.08);
}

* {
    box-sizing: border-box;
}

html {
    scroll-behavior: smooth;
}

body {
    margin: 0;
    background: #fbf9fd;
    color: var(--ink);
    font-family: "Segoe UI", Arial, sans-serif;
    font-size: 15px;
    line-height: 1.5;
}

a {
    color: inherit;
    text-decoration: none;
}

button, input {
    font: inherit;
}

.app-layout {
    min-height: 100vh;
    display: flex;
}

/* SIDEBAR */

.sidebar {
    width: 245px;
    flex-shrink: 0;
    background: white;
    border-right: 1px solid var(--line);
    padding: 30px 20px;
    display: flex;
    flex-direction: column;
    gap: 9px;
}

.brand {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 25px;
    font-weight: 800;
    letter-spacing: -1px;
    margin: 0 0 42px 7px;
    color: #56466d;
}

.brand-icon {
    display: grid;
    place-items: center;
    width: 39px;
    height: 39px;
    border-radius: 14px;
    background: #f0e8ff;
    color: #8e76bb;
    font-size: 24px;
}

.brand-light {
    color: #b28dbd;
}

.nav-label, .eyebrow {
    font-size: 10px;
    letter-spacing: 1.8px;
    font-weight: 800;
    color: #a196ad;
    margin: 0 0 10px;
}

.nav-label {
    padding-left: 10px;
}

.nav-link {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 13px;
    border-radius: 12px;
    color: #80758c;
    font-weight: 600;
    transition: .2s;
}

.nav-link > span {
    width: 22px;
    text-align: center;
    font-size: 20px;
}

.nav-link:hover, .nav-link.active {
    background: #f2edfc;
    color: #7561a1;
}

.sidebar-note {
    margin-top: auto;
    background: linear-gradient(145deg,#fff0f5,#f4efff);
    padding: 20px 16px;
    border-radius: 18px;
    color: #665575;
}

.note-flower {
    font-size: 25px;
}

.sidebar-note h3 {
    font-size: 15px;
    margin: 9px 0 4px;
}

.sidebar-note p {
    font-size: 12px;
    line-height: 1.6;
    color: #8b7b95;
    margin: 0;
}

.logout-link {
    margin-top: 16px;
}

/* MAIN CONTENT */

.main-content {
    width: calc(100% - 245px);
    max-width: 1500px;
    margin: 0 auto;
    padding: 35px clamp(22px,4vw,60px) 25px;
}

.topbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 26px;
}

.topbar .eyebrow {
    margin-bottom: 6px;
}

.topbar h1 {
    font-size: 30px;
    letter-spacing: -.8px;
    margin: 0;
    font-weight: 750;
}

.topbar h1 span {
    color: #bc92cb;
}

.subtitle {
    color: #9b90a5;
    margin: 5px 0 0;
    font-size: 13px;
}

.profile-circle {
    width: 47px;
    height: 47px;
    display: grid;
    place-items: center;
    border-radius: 50%;
    background: #e9defa;
    color: #745c9d;
    font-size: 18px;
    font-weight: 800;
    border: 3px solid white;
    box-shadow: 0 0 0 1px #e8def3;
}

/* WELCOME BANNER */

.welcome-banner {
    display: flex;
    align-items: center;
    justify-content: space-between;
    min-height: 205px;
    padding: 30px 38px;
    border-radius: 23px;
    background: linear-gradient(112deg,#eee7ff,#fcecf5);
    overflow: hidden;
    margin-bottom: 25px;
}

.banner-tag {
    font-size: 10px;
    letter-spacing: 1.6px;
    font-weight: 800;
    color: #8a73ad;
}

.welcome-banner h2 {
    font-size: 28px;
    letter-spacing: -.7px;
    margin: 8px 0;
    color: #514360;
}

.welcome-banner p {
    color: #85758f;
    margin: 0 0 18px;
}

.banner-button {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 10px 17px;
    border: 0;
    border-radius: 10px;
    background: #8670b4;
    color: white;
    font-weight: 700;
    font-size: 12px;
    box-shadow: 0 6px 15px #b8a8d5;
    cursor: pointer;
}

.banner-button:hover {
    background: #725d9e;
}

.banner-art {
    font-size: 100px;
    opacity: .85;
    padding: 0 28px;
    transform: rotate(8deg);
}

/* STATISTICS */

.stats-grid {
    display: grid;
    grid-template-columns: repeat(4,minmax(0,1fr));
    gap: 17px;
    margin-bottom: 24px;
}

.stat-card {
    padding: 20px 21px;
    border-radius: 18px;
    border: 1px solid transparent;
    min-width: 0;
}

.lavender {
    background: #f0eaff;
    border-color: #e8defb;
}

.pink {
    background: #ffedf3;
    border-color: #fbe0ea;
}

.mint {
    background: #e7f7f0;
    border-color: #d9f0e5;
}

.peach {
    background: #fff0e6;
    border-color: #f8e4d6;
}

.stat-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    color: #766a84;
    font-size: 12px;
    font-weight: 650;
}

.stat-icon {
    display: grid;
    place-items: center;
    width: 31px;
    height: 31px;
    background: rgba(255,255,255,.7);
    border-radius: 10px;
    font-size: 17px;
}

.stat-number {
    font-size: 31px;
    line-height: 1.2;
    font-weight: 800;
    margin: 13px 0 4px;
    color: #4b3e59;
}

.stat-caption {
    font-size: 11px;
    color: #93859d;
    margin: 0;
}

/* PANELS */

.content-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
    margin-bottom: 24px;
}

.panel {
    background: white;
    border: 1px solid #f0eaf4;
    border-radius: 20px;
    padding: 25px;
    box-shadow: var(--shadow);
    min-width: 0;
}

.panel-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 23px;
}

.panel-heading .eyebrow {
    margin-bottom: 4px;
}

.panel h2, .assignment-heading h2 {
    font-size: 21px;
    letter-spacing: -.4px;
    margin: 0;
    color: #4b3e59;
}

.round-icon {
    width: 37px;
    height: 37px;
    border-radius: 13px;
    background: #f4effb;
    color: #9a82b9;
    display: grid;
    place-items: center;
    font-size: 22px;
}

.progress-number {
    display: flex;
    align-items: baseline;
    gap: 9px;
    margin-bottom: 14px;
}

.progress-number strong {
    font-size: 34px;
    color: #806bb0;
}

.progress-number span {
    font-size: 12px;
    color: #9c91a5;
}

.progress-track {
    height: 10px;
    background: #f0eaf7;
    border-radius: 20px;
    overflow: hidden;
}

.progress-fill {
    height: 100%;
    background: linear-gradient(90deg,#b9a3e7,#e9a8cb);
    border-radius: 20px;
    transition: width .3s;
}

.progress-caption {
    font-size: 12px;
    color: #93869c;
    margin: 11px 0 19px;
}

.mini-summary {
    display: flex;
    gap: 22px;
    flex-wrap: wrap;
    padding-top: 15px;
    border-top: 1px solid #f2edf5;
}

.mini-summary > div {
    display: flex;
    align-items: center;
    gap: 7px;
    font-size: 12px;
    color: #877b91;
}

.mini-summary strong {
    color: #564963;
}

.legend-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    display: inline-block;
}

.completed-dot {
    background: #b69cde;
}

.pending-dot {
    background: #e9b0cd;
}

.deadline-message {
    display: flex;
    align-items: flex-start;
    gap: 13px;
    padding: 17px;
    border-radius: 14px;
    margin: 8px 0 18px;
}

.deadline-message > span {
    font-size: 23px;
}

.deadline-message strong {
    font-size: 13px;
}

.deadline-message p {
    font-size: 12px;
    color: #8e8098;
    margin: 4px 0 0;
}

.deadline-message.alert {
    background: #fff0e9;
    color: #a66d56;
}

.deadline-message.calm {
    background: #f2edfc;
    color: #79659f;
}

.text-link {
    font-size: 12px;
    font-weight: 750;
    color: #8871b2;
}

/* ASSIGNMENT HEADING */

.assignment-heading {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    gap: 15px;
    flex-wrap: wrap;
    margin-bottom: 23px;
}

.assignment-heading .eyebrow {
    margin-bottom: 5px;
}

.assignment-tools {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
}

.search-form {
    display: flex;
    align-items: center;
    gap: 7px;
    padding: 5px;
    border: 1px solid #ece5f1;
    border-radius: 12px;
    background: #fdfcff;
    min-width: 260px;
}

.search-form > span {
    padding-left: 8px;
    color: #a194ae;
    font-size: 22px;
}

.search-form input {
    width: 100%;
    min-width: 80px;
    border: 0;
    outline: 0;
    background: transparent;
    padding: 8px 3px;
    color: var(--ink);
    font-size: 12px;
}

.search-form button {
    border: 0;
    border-radius: 8px;
    background: #8a75b5;
    color: white;
    font-size: 11px;
    font-weight: 700;
    padding: 9px 13px;
    cursor: pointer;
}

.search-form button:hover {
    background: #725d9e;
}

/* ASSIGNMENT TABLE */

.table-wrap {
    width: 100%;
    overflow-x: auto;
}

.assignment-table {
    width: 100%;
    border-collapse: collapse;
    text-align: left;
    white-space: nowrap;
}

.assignment-table th {
    padding: 13px 12px;
    background: #faf7fc;
    color: #a094ac;
    text-transform: uppercase;
    letter-spacing: 1px;
    font-size: 9px;
    font-weight: 800;
}

.assignment-table th:first-child {
    border-radius: 9px 0 0 9px;
}

.assignment-table th:last-child {
    border-radius: 0 9px 9px 0;
}

.assignment-table td {
    padding: 17px 12px;
    border-bottom: 1px solid #f2edf5;
    font-size: 12px;
    color: #746880;
}

.assignment-table tbody tr:last-child td {
    border-bottom: 0;
}

.assignment-table tbody tr:hover {
    background: #fdfbff;
}

.task-name {
    display: flex;
    align-items: center;
    gap: 10px;
    font-weight: 700;
    color: #564963;
}

.task-check {
    width: 22px;
    height: 22px;
    flex-shrink: 0;
    display: grid;
    place-items: center;
    border: 1px solid #e4dbe9;
    border-radius: 7px;
    color: #a79bb0;
    font-size: 13px;
}

.task-check.checked {
    background: #e6f6ed;
    border-color: #d6efdf;
    color: #5f9b7b;
}

.subject-chip {
    display: inline-block;
    background: #f2edfc;
    color: #8470aa;
    border-radius: 8px;
    padding: 5px 9px;
    font-size: 10px;
    font-weight: 700;
}

.date-text, .overdue-date {
    font-size: 12px;
}

.overdue-date {
    color: #d27b72;
    font-weight: 750;
}

.overdue-label {
    display: block;
    color: #d27b72;
    font-size: 9px;
    margin-top: 3px;
}

.status-badge {
    display: inline-block;
    border-radius: 20px;
    padding: 6px 10px;
    font-size: 10px;
    font-weight: 750;
}

.status-completed {
    background: #e5f6ed;
    color: #559476;
}

.status-pending {
    background: #fff2d9;
    color: #ad8a45;
}

.status-overdue {
    background: #ffebe8;
    color: #c8756d;
}

/* COMPLETE AND UNDO BUTTONS */

.complete-btn, .undo-btn {
    border: 0;
    border-radius: 8px;
    padding: 8px 11px;
    font-size: 11px;
    font-weight: 700;
    cursor: pointer;
    transition: .2s ease;
}

.complete-btn {
    background: #e5f6ed;
    color: #4d8b6c;
}

.complete-btn:hover {
    background: #d1efdf;
}

.undo-btn {
    background: #eee7ff;
    color: #765aa5;
}

.undo-btn:hover {
    background: #ded2fa;
}

.empty-state {
    text-align: center;
    padding: 43px 20px;
    color: #887b95;
}

.empty-state > span {
    font-size: 42px;
}

.empty-state h3 {
    margin: 10px 0 4px;
    color: #5d4e6b;
}

.empty-state p {
    margin: 0;
    font-size: 12px;
}

.table-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    border-top: 1px solid #f1ebf4;
    padding-top: 16px;
    margin-top: 5px;
    color: #a096ab;
    font-size: 11px;
}

.table-footer a {
    color: #8871b2;
    font-weight: 700;
}

.page-footer {
    text-align: center;
    padding: 24px 0 0;
    color: #aa9db4;
    font-size: 11px;
}

.page-footer span {
    color: #d69dc1;
}

/* RESPONSIVE DESIGN */

@media (max-width: 1050px) {
    .sidebar {
        width: 210px;
        padding: 25px 15px;
    }

    .main-content {
        width: calc(100% - 210px);
        padding: 28px 24px;
    }

    .stats-grid {
        grid-template-columns: repeat(2,minmax(0,1fr));
    }

    .content-grid {
        grid-template-columns: 1fr;
    }

    .search-form {
        width: 100%;
        max-width: 430px;
    }
}

@media (max-width: 700px) {
    .app-layout {
        display: block;
    }

    .sidebar {
        width: 100%;
        padding: 13px 16px;
        flex-direction: row;
        align-items: center;
        gap: 8px;
        border-right: 0;
        border-bottom: 1px solid var(--line);
        overflow-x: auto;
    }

    .brand {
        font-size: 19px;
        margin: 0 12px 0 0;
        white-space: nowrap;
    }

    .brand-icon {
        width: 32px;
        height: 32px;
    }

    .nav-label, .sidebar-note {
        display: none;
    }

    .nav-link {
        white-space: nowrap;
        padding: 9px 10px;
        font-size: 12px;
    }

    .nav-link > span {
        font-size: 16px;
        width: auto;
    }

    .logout-link {
        margin: 0 0 0 auto;
    }

    .main-content {
        width: 100%;
        padding: 23px 15px;
    }

    .topbar h1 {
        font-size: 25px;
    }

    .welcome-banner {
        padding: 25px 22px;
        min-height: 180px;
    }

    .welcome-banner h2 {
        font-size: 23px;
    }

    .banner-art {
        font-size: 60px;
        padding: 0 0 0 10px;
    }

    .stats-grid {
        gap: 10px;
    }

    .stat-card {
        padding: 15px;
    }

    .stat-number {
        font-size: 27px;
    }

    .panel {
        padding: 19px;
    }

    .assignment-heading h2 {
        font-size: 20px;
    }

    .assignment-tools {
        width: 100%;
    }

    .search-form {
        min-width: 0;
        flex: 1;
    }

    .table-footer {
        align-items: flex-start;
        flex-direction: column;
    }
}

@media (max-width: 420px) {
    .sidebar {
        gap: 3px;
    }

    .brand {
        margin-right: 5px;
        font-size: 17px;
    }

    .nav-link {
        padding: 8px;
        font-size: 11px;
    }

    .nav-link > span {
        display: none;
    }

    .banner-art {
        display: none;
    }

    .stats-grid {
        grid-template-columns: repeat(2,minmax(0,1fr));
    }

    .topbar h1 {
        font-size: 22px;
    }
}
</style>
</head>

<body>
<div class="app-layout">

    <aside class="sidebar">

        <a class="brand" href="<%= context %>/dashboard">
            <span class="brand-icon">✿</span>
            <span>study<span class="brand-light">bloom</span></span>
        </a>

        <p class="nav-label">WORKSPACE</p>

        <a class="nav-link active" href="<%= context %>/dashboard">
            <span>⌂</span> Dashboard
        </a>

        <a class="nav-link" href="#assignments">
            <span>▤</span> My assignments
        </a>

        <a class="nav-link" href="#progress">
            <span>◔</span> My progress
        </a>

        <div class="sidebar-note">
            <span class="note-flower">🌷</span>
            <h3>Little steps add up.</h3>
            <p>Keep going. You're doing better than you think.</p>
        </div>

        <a class="nav-link logout-link" href="<%= context %>/logout">
            <span>↪</span> Log out
        </a>

    </aside>

    <main class="main-content">

        <header class="topbar">
            <div>
                <p class="eyebrow">YOUR PERSONAL STUDY SPACE</p>
                <h1>Hey, <%= safeName %>! <span>✿</span></h1>
                <p class="subtitle">
                    A fresh little start, one task at a time.
                </p>
            </div>

            <div class="profile-circle">
                <%= safeName.substring(0,1).toUpperCase() %>
            </div>
        </header>

        <section class="welcome-banner">
            <div>
                <span class="banner-tag">YOUR STUDY CORNER</span>
                <h2>Make room for progress.</h2>
                <p>Every assignment you finish is a little win.</p>

                <a href="#assignments" class="banner-button">
                    View my tasks →
                </a>
            </div>

            <div class="banner-art" aria-hidden="true">🌸</div>
        </section>

        <!-- STATISTICS -->

        <section class="stats-grid">

            <article class="stat-card lavender">
                <div class="stat-top">
                    <span>Total assignments</span>
                    <span class="stat-icon">▤</span>
                </div>
                <p class="stat-number"><%= total %></p>
                <p class="stat-caption">Your complete task list</p>
            </article>

            <article class="stat-card pink">
                <div class="stat-top">
                    <span>Completed</span>
                    <span class="stat-icon">✓</span>
                </div>
                <p class="stat-number"><%= completed %></p>
                <p class="stat-caption">Look at you go!</p>
            </article>

            <article class="stat-card mint">
                <div class="stat-top">
                    <span>Pending</span>
                    <span class="stat-icon">◷</span>
                </div>
                <p class="stat-number"><%= pending %></p>
                <p class="stat-caption">Still on your list</p>
            </article>

            <article class="stat-card peach">
                <div class="stat-top">
                    <span>Overdue</span>
                    <span class="stat-icon">!</span>
                </div>
                <p class="stat-number"><%= overdue %></p>
                <p class="stat-caption">Tasks past their due date</p>
            </article>

        </section>

        <!-- PROGRESS AND DEADLINES -->

        <section class="content-grid">

            <article class="panel progress-panel" id="progress">

                <div class="panel-heading">
                    <div>
                        <p class="eyebrow">YOUR ACHIEVEMENTS</p>
                        <h2>My progress</h2>
                    </div>
                    <span class="round-icon">✧</span>
                </div>

                <div class="progress-number">
                    <strong><%= progress %>%</strong>
                    <span>completed</span>
                </div>

                <div class="progress-track">
                    <div class="progress-fill"
                         style="width: <%= progress %>%;">
                    </div>
                </div>

                <p class="progress-caption">
                    <%= completed %> out of <%= total %> assignments completed.
                </p>

                <div class="mini-summary">
                    <div>
                        <span class="legend-dot completed-dot"></span>
                        Completed <strong><%= completed %></strong>
                    </div>

                    <div>
                        <span class="legend-dot pending-dot"></span>
                        Pending <strong><%= pending %></strong>
                    </div>
                </div>

            </article>

            <article class="panel deadline-panel">

                <div class="panel-heading">
                    <div>
                        <p class="eyebrow">A LITTLE REMINDER</p>
                        <h2>Deadline watch</h2>
                    </div>
                    <span class="round-icon">♡</span>
                </div>

                <% if (overdue > 0) { %>

                    <div class="deadline-message alert">
                        <span>⚠</span>
                        <div>
                            <strong>You have overdue work.</strong>
                            <p><%= overdue %> assignment(s) need your attention.</p>
                        </div>
                    </div>

                <% } else if (pending > 0) { %>

                    <div class="deadline-message calm">
                        <span>🌷</span>
                        <div>
                            <strong>Keep your momentum.</strong>
                            <p>Check the dates below and plan your next step.</p>
                        </div>
                    </div>

                <% } else { %>

                    <div class="deadline-message calm">
                        <span>✨</span>
                        <div>
                            <strong>All caught up!</strong>
                            <p>Enjoy your progress and keep blooming.</p>
                        </div>
                    </div>

                <% } %>

                <a class="text-link" href="#assignments">
                    Check my assignments →
                </a>

            </article>

        </section>

        <!-- ASSIGNMENT LIST -->

        <section class="panel assignments-panel" id="assignments">

            <div class="assignment-heading">

                <div>
                    <p class="eyebrow">STAY ON TOP OF THINGS</p>
                    <h2>My assignments</h2>
                    <p class="subtitle">
                        Your tasks, all in one cozy place.
                    </p>
                </div>

                <div class="assignment-tools">

                    <a href="<%= context %>/add-assignment"
                       class="banner-button">
                        + Add Assignment
                    </a>

                    <form class="search-form"
                          action="<%= context %>/dashboard"
                          method="get">

                        <span>⌕</span>

                        <input type="search"
                               name="search"
                               value="<%= safeSearch %>"
                               placeholder="Search tasks or subjects..."
                               aria-label="Search assignments">

                        <button type="submit">Search</button>
                    </form>

                </div>
            </div>

            <% if (assignments.isEmpty()) { %>

                <div class="empty-state">
                    <span>🌼</span>

                    <h3><%= search.isEmpty()
                        ? "Your task list is waiting"
                        : "No matching assignments found" %></h3>

                    <p><%= search.isEmpty()
                        ? "Add an assignment to get your study space started."
                        : "Try another title, subject or status." %></p>
                </div>

            <% } else { %>

                <div class="table-wrap">

                    <table class="assignment-table">

                        <thead>
                            <tr>
                                <th>Assignment</th>
                                <th>Subject</th>
                                <th>Due date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>

                        <tbody>

                        <%
                            for (Assignment a : assignments) {

                                String status = a.getStatus() == null
                                    ? "Pending" : a.getStatus();

                                String title = a.getTitle() == null
                                    ? "Untitled" : a.getTitle();

                                String subject = a.getSubject() == null
                                    ? "General" : a.getSubject();

                                String safeTitle = title.replace("&", "&amp;")
                                    .replace("<", "&lt;")
                                    .replace(">", "&gt;")
                                    .replace("\"", "&quot;")
                                    .replace("'", "&#39;");

                                String safeSubject = subject.replace("&", "&amp;")
                                    .replace("<", "&lt;")
                                    .replace(">", "&gt;")
                                    .replace("\"", "&quot;")
                                    .replace("'", "&#39;");

                                boolean isCompleted =
                                    "Completed".equalsIgnoreCase(status);

                                boolean isOverdue = !isCompleted
                                    && a.getDueDate() != null
                                    && a.getDueDate().toLocalDate()
                                        .isBefore(LocalDate.now());

                                String displayedStatus = isCompleted
                                    ? "Completed"
                                    : (isOverdue ? "Overdue" : status);
                        %>

                            <tr>

                                <td>
                                    <div class="task-name">
                                        <span class="task-check <%= isCompleted
                                            ? "checked" : "" %>">
                                            <%= isCompleted ? "✓" : "○" %>
                                        </span>

                                        <span><%= safeTitle %></span>
                                    </div>
                                </td>

                                <td>
                                    <span class="subject-chip">
                                        <%= safeSubject %>
                                    </span>
                                </td>

                                <td>
                                    <span class="<%= isOverdue
                                        ? "overdue-date" : "date-text" %>">
                                        <%= a.getDueDate() == null
                                            ? "Not set"
                                            : a.getDueDate().toString() %>
                                    </span>

                                    <% if (isOverdue) { %>
                                        <small class="overdue-label">
                                            Overdue
                                        </small>
                                    <% } %>
                                </td>

                                <td>
                                    <span class="status-badge <%= isCompleted
                                        ? "status-completed"
                                        : (isOverdue
                                            ? "status-overdue"
                                            : "status-pending") %>">
                                        <%= displayedStatus %>
                                    </span>
                                </td>

                                <!-- COMPLETE / UNDO ACTION -->

                                <td>
                                    <form action="<%= context %>/complete-assignment"
                                          method="post">

                                        <input type="hidden"
                                               name="assignmentId"
                                               value="<%= a.getAssignmentId() %>">

                                        <% if (isCompleted) { %>

                                            <input type="hidden"
                                                   name="status"
                                                   value="Pending">

                                            <button type="submit"
                                                    class="undo-btn">
                                                ↶ Undo
                                            </button>

                                        <% } else { %>

                                            <input type="hidden"
                                                   name="status"
                                                   value="Completed">

                                            <button type="submit"
                                                    class="complete-btn">
                                                ✓ Complete
                                            </button>

                                        <% } %>

                                    </form>
                                </td>

                            </tr>

                        <% } %>

                        </tbody>

                    </table>

                </div>

            <% } %>

            <div class="table-footer">

                <span>
                    Showing <%= assignments.size() %> matching assignment(s)
                </span>

                <% if (!search.isEmpty()) { %>
                    <a href="<%= context %>/dashboard">Clear search ×</a>
                <% } %>

            </div>

        </section>

        <footer class="page-footer">
            Made for your little wins <span>♡</span>
        </footer>

    </main>

</div>
</body>
</html>
